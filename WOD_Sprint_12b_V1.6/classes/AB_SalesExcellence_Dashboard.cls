/*Author: Bharat*/
/*Description: Sending SalesExcellence_Dashboard Details to the External system.*/
/*Created date: 7/12/2016*/
/*Modification History:*/

@RestResource(urlMapping='/AB_SalesExcellence_Dashboard/*')
global with sharing class AB_SalesExcellence_Dashboard {
    
    @HttpPost //Method name
    
    global static ResponseWrapper AB_SalesExcellence_Dashboard()
    {
        
        list<string> aids = new list<string>();//list of poc Account ids
        set<id> schIds = new set<id>();
        decimal TargetVisits= 0;//holds target visits to be made by sales rep
        //double CompletedVisits = 0;//holds visits completed by sales rep
        decimal StrikeRate = 0;//holds percentage of strike rate 
        decimal RouteAdherence = 0;//holds percentage of route adherence
        decimal TimeToSell = 0;//holds total time taken to complte all visits by sales rep
        string StrTimeToSell='';//holds time to sell in hh:min format
        decimal PocsCount=0;//holds count of poc accounts in the route
        decimal Tapwisers=0;//holds count of tapwiser accounts
        decimal Tapwiser = 0;// holds percentage of tapwisers
        map<id,boolean> mapTapwisers =new map<id,boolean>();
        list<AccountWrapper> lstAccWrap = new list<AccountWrapper>();
        string strReturn=''; //Holds the return message to be sent as response
        Integer isSuccessRes; //Holds success status '0' or '1'
        decimal TargetStrikeRate = 0;
        decimal TargetRouteAdherence = 0;
        decimal TargetTapwiser= 0;
        
        //Get Callout Request
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        string strJSONBody = '';
        
        
        if(!test.isRunningTest()){          
            strJSONBody = request.requestBody.toString();// Holds the request body
            
//AB_DevSettings.debug('strJSONBody==',strJSONBody);

        }else{
             
             strJSONBody = AB_SalesExcellence_Dashboard_Test.strJSONBody;
        }
        
        try{     
            UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
            list<user> logedinUser = new list<user>();
            if(deserializedUser.username != null && deserializedUser.username != ''){   
                logedinUser = [select id,username, Wholesaler_Number__c,WSLRNbrRouteNbr__c,Email from user where username =: deserializedUser.username limit 1];//To get wholesaler Number of loged in user
                
            }
            //system.debug('logedinUser=='+logedinUser);
            integer ScheduledCount=0;
            decimal VisitsCount=0;
            decimal TimeSpent=0.0;
            //list<Route_Schedule__c> RouteList = new list<Route_Schedule__c>();//Holds Route List order by Sequence__c
            list<Route_Schedule__c> MonthsRouteList = new list<Route_Schedule__c>();
            if(logedinUser[0].WSLRNbrRouteNbr__c != null){
                //this query is for Sales excellence data up to todate
                //RouteList = [select id,name,Route__r.WSLRNbrRouteNbr__c, Account__r.name,Account__r.Tapwiser__c,Account__c,Visits_Count__c,Scheduled_Count__c,Time_Spent__c,Route__r.Tapwiser_Adherence__c,Route__r.Strike_Rate_Adherence__c,Route__r.Call_Route_Adherence__c from Route_Schedule__c where StopDate__c <= TODAY and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c and Route__r.WSLRNbrRouteNbr__c != null];//'005f00000029fc3': logedinUser[0].WSLRNbrRouteNbr__c
                //this query is for timespent data
                if(deserializedUser.startDate == null && deserializedUser.endDate == null)      
                    MonthsRouteList = [select id,name,RouteNbr__c,Route__r.WSLRNbrRouteNbr__c,Route__r.Call_Route_Adherence__c,Route__r.Strike_Rate_Adherence__c,Route__r.Tapwiser_Adherence__c, Account__r.name,Account__r.Tapwiser__c,Account__c,Visits_Count__c,Scheduled_Count__c,Time_Spent__c from Route_Schedule__c where StopDate__c = THIS_MONTH and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c and Route__r.WSLRNbrRouteNbr__c != null];
                else
                    MonthsRouteList = [select id,name,RouteNbr__c,Route__r.WSLRNbrRouteNbr__c,Route__r.Call_Route_Adherence__c,Route__r.Strike_Rate_Adherence__c,Route__r.Tapwiser_Adherence__c, Account__r.name,Account__r.Tapwiser__c,Account__c,Visits_Count__c,Scheduled_Count__c,Time_Spent__c from Route_Schedule__c where StopDate__c >=: date.valueOf(deserializedUser.startDate) and StopDate__c <=: date.valueOf(deserializedUser.endDate) and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c and Route__r.WSLRNbrRouteNbr__c != null];
            }
            
             
            /*time spent should be calculate for this month*/
            /*And Account sales data for this month*/
            string RouteNmbr = '';
            map<id,list<Route_Schedule__c >> mapRSchedules = new map<id,list<Route_Schedule__c >>();
            if(MonthsRouteList != null && MonthsRouteList.size()!=0){   
                TargetVisits = MonthsRouteList.size();    
                RouteNmbr = MonthsRouteList[0].RouteNbr__c;           
                for(Route_Schedule__c c:MonthsRouteList){
                    
                    if(c.Account__c != null){
                        schIds.add(c.id);//holds RouteSchedules for this month ids
                        aids.add(c.Account__c); //holds accounts on the route 
                        if(mapTapwisers.get(c.Account__c) == null)
                            mapTapwisers.put(c.Account__c,c.Account__r.Tapwiser__c); 
                        if(c.Scheduled_Count__c != null)  
                            ScheduledCount +=integer.valueOf(c.Scheduled_Count__c); 
                        if(c.Visits_Count__c != null)
                            VisitsCount += integer.valueOf(c.Visits_Count__c); 
                            
                        if(c.Time_Spent__c != null)
                            TimeSpent += c.Time_Spent__c;//counting total time spent in the month
                
                    
            //start: map construction to calculate sales excellence data for each account(dashboard level 2)                      
                        if(mapRSchedules.get(c.Account__c) == null){
                            list<Route_Schedule__c> lstRSchedules = new list<Route_Schedule__c>();
                            lstRSchedules.add(c);
                            mapRSchedules.put(c.Account__c,lstRSchedules);
                        }
                        else{
                            list<Route_Schedule__c> lstRSchedules = new list<Route_Schedule__c>();
                            lstRSchedules.addAll(mapRSchedules.get(c.Account__c));
                            lstRSchedules.add(c);
                            mapRSchedules.put(c.Account__c,lstRSchedules);
                        }
             //End: Map construction
                    }
                }
                if(MonthsRouteList[0].Route__r.Strike_Rate_Adherence__c != null)
                    TargetStrikeRate = MonthsRouteList[0].Route__r.Strike_Rate_Adherence__c;
                if(MonthsRouteList[0].Route__r.Call_Route_Adherence__c != null)
                    TargetRouteAdherence = MonthsRouteList[0].Route__r.Call_Route_Adherence__c;
                if(MonthsRouteList[0].Route__r.Tapwiser_Adherence__c != null)
                    TargetTapwiser = MonthsRouteList[0].Route__r.Tapwiser_Adherence__c;
            }
            PocsCount = mapTapwisers.size(); //counting total poc accounts          
            //system.debug('PocsCount=='+PocsCount);
            //system.debug(mapRSchedules.size());
            list<ONTAP__Order__c> lstVisitOrders = new list<ONTAP__Order__c>();
            decimal orderedVisits = 0;//holds count of ordered visits(getting count from Visit_Orders__c)
            
            if(aids != null){
                if(deserializedUser.startDate == null && deserializedUser.endDate == null)
                {
                   lstVisitOrders = [select RAS_RouteNbr__c,RAS_SubmitDateTime__c,ONTAP__OrderAccount__c from ONTAP__Order__c where RAS_RouteNbr__c =: RouteNmbr and RAS_SubmitDateTime__c = THIS_MONTH and ONTAP__OrderAccount__r.id in :aids];
                   //lstVisitOrders = [select RAS_RouteNbr__c,RAS_SubmitDateTime__c,ONTAP__OrderAccount__c from ONTAP__Order__c limit 10];
                }
                else{                
                    lstVisitOrders = [select RAS_RouteNbr__c,RAS_SubmitDateTime__c,ONTAP__OrderAccount__c from ONTAP__Order__c where RAS_RouteNbr__c =: RouteNmbr and  DAY_ONLY(RAS_SubmitDateTime__c) >=: date.valueOf(deserializedUser.startDate) and DAY_ONLY(RAS_SubmitDateTime__c) <=: date.valueOf(deserializedUser.endDate) and ONTAP__OrderAccount__r.id in :aids];
                }
            }
            //system.debug('lstVisitOrders.size()=='+lstVisitOrders.size());
            //system.debug('MonthsRouteList.size()=='+MonthsRouteList.size());
            //system.debug('RouteNmbr=='+RouteNmbr);
            map<id,list<ONTAP__Order__c>> mapVOrdres = new map<id,list<ONTAP__Order__c>>();
            if(lstVisitOrders != null && !lstVisitOrders.isEmpty()){
                orderedVisits = lstVisitOrders.size();//counting all orderd visits in tha route
                for(ONTAP__Order__c objVst : lstVisitOrders){
                    //orderedVisits += objVst.Count__c;
                    
             //start: map construction to calculate strike Rate data for each account(dashboard level 2)                      
                        if(mapVOrdres.get(objVst.ONTAP__OrderAccount__c) == null){
                            list<ONTAP__Order__c> lstVOrders = new list<ONTAP__Order__c>();
                            lstVOrders.add(objVst);
                            mapVOrdres.put(objVst.ONTAP__OrderAccount__c,lstVOrders);
                        }
                        else{
                            list<ONTAP__Order__c> lstVOrders = new list<ONTAP__Order__c>();
                            lstVOrders.addAll(mapVOrdres.get(objVst.ONTAP__OrderAccount__c));
                            lstVOrders.add(objVst);
                            mapVOrdres.put(objVst.ONTAP__OrderAccount__c,lstVOrders);
                        }
             //End: Map construction
                    
                }
            }
            //START: Tapwiser account counting
            //system.debug('mapTapwisers=='+mapTapwisers.size());
            if(mapTapwisers != null && !mapTapwisers.isempty()){
                for(id keyid : mapTapwisers.keyset()){
                    if(mapTapwisers.get(keyid) == true)
                        Tapwisers++;
                }
            }
            //END: Tapwiser account counting
            
            string DecValue = '';
            if(Tapwisers != 0 && PocsCount != 0){
                
                Tapwiser = (Tapwisers/PocsCount*100).setScale(2);
            }
            
            if(orderedVisits != 0 && TargetVisits != 0){
                //TargetVisits = 1;
                StrikeRate = (orderedVisits/TargetVisits*100).setScale(2);
            }
            if(VisitsCount != 0 && ScheduledCount != 0){
                
                RouteAdherence = (VisitsCount/ScheduledCount*100).setScale(2);
            }
                
            TimeToSell = TimeSpent/integer.valueOf(date.today().day());//toatal time spent in this month divided by no.of days in this month
            Decimal decMinutes = (TimeToSell - math.floor(TimeToSell)) * 60;
            StrTimeToSell = math.floor(TimeToSell)+'hr '+Integer.valueOf(decMinutes)+'min';// Conversion of decimal in to time hh:min format
            
                       
            if(mapRSchedules != null && !mapRSchedules.isEmpty()){
                
                for(id keyId : mapRSchedules.keyset()){
                    lstAccWrap.addAll(PrepareDashboardData(keyId,mapRSchedules, mapVOrdres)); 
                                  
                }               
            }
            
            /*End: Account wise sales excellence data preperation*/
            
            strReturn = 'Success';
            isSuccessRes = 1;
            
        }
        catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
                    
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,StrikeRate,RouteAdherence,StrTimeToSell,TimeToSell,Tapwiser,TargetStrikeRate,TargetRouteAdherence,TargetTapwiser,lstAccWrap);//Initialising the object for wrapper class. This object can be returned as response to the external system.
            return obj;
    }
    /*START: Sales excellence for each account data preperation*/
    public static list<AccountWrapper> PrepareDashboardData(id keyId,map<id,list<Route_Schedule__c>> mapRSchedules,map<id,list<ONTAP__Order__c>> mapVOrdres){
        string DecValue = '';
        list<AccountWrapper> lstAcctWrap = new list<AccountWrapper>();
        decimal sCount = 0;             
        AccountWrapper objAccWrap = new AccountWrapper();
        if(mapRSchedules.get(keyId) != null && !mapRSchedules.get(keyId).isEmpty()){
            
            decimal vCount = 0;
            
            for(Route_Schedule__c objRteSche : mapRSchedules.get(keyId)){
                
                if(objRteSche.Visits_Count__c != null)
                  vCount += objRteSche.Visits_Count__c;
                if(objRteSche.Scheduled_Count__c != null)
                  sCount += objRteSche.Scheduled_Count__c; 
                //system.debug('objRteSche.Account__r.name=='+objRteSche.Account__r.name);
                objAccWrap.AccName = objRteSche.Account__r.name; 
                objAccWrap.AccTapwiser = objRteSche.Account__r.Tapwiser__c;
            }
            
            
            //objAccWrap.AccRouteAdherence = vCount/sCount*100;
            if(vCount != 0 && sCount != 0){
                
                objAccWrap.AccRouteAdherence = (vCount/sCount*100).setScale(2);
            }
          
        } 
        if(mapVOrdres.get(keyId) != null && !mapVOrdres.get(keyId).isEmpty()){
            decimal ordrCount = 0;
            for(ONTAP__Order__c objVOrdr : mapVOrdres.get(keyId)){
                
                //if(objVOrdr.Count__c != null)
                   ordrCount += 1;
            }
            if(ordrCount != 0 && sCount != 0){
                
                objAccWrap.AccStrikeRate = (ordrCount/sCount*100).setScale(2);
            }
        }
        objAccWrap.id = keyId;
        lstAcctWrap.add(objAccWrap);     
        return lstAcctWrap;
    }
           
    /*END: Sales excellence for each account data preperation*/
        
    //Wrapper class to serialize response
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}  
          public decimal StrikeRate {get;set;}  
          public decimal RouteAdherence {get;set;}
          public string StrTimeToSell {get;set;}
          public decimal TimeToSell {get;set;} 
          public decimal Tapwiser{get;set;} 
          public decimal TargetStrikeRate{get;set;}
          public decimal TargetRouteAdherence {get;set;}
          public decimal TargetTapwiser {get;set;}   
          public list<AccountWrapper> AccSalesExcellence {get;set;}
          public ResponseWrapper(integer isSuccess,String Message,decimal StrikeRate,decimal RouteAdherence,string StrTimeToSell,decimal TimeToSell,decimal Tapwiser,decimal TargetStrikeRate,decimal TargetRouteAdherence,decimal TargetTapwiser,list<AccountWrapper> AccSalesExcellence)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
              this.StrikeRate = StrikeRate;
              this.RouteAdherence = RouteAdherence;
              this.StrTimeToSell = StrTimeToSell;
              this.TimeToSell = TimeToSell;
              this.Tapwiser =Tapwiser;
              this.TargetStrikeRate= TargetStrikeRate;
              this.TargetRouteAdherence = TargetRouteAdherence;
              this.TargetTapwiser= TargetTapwiser;
              this.AccSalesExcellence = AccSalesExcellence;
          }
      }
    public class AccountWrapper 
    {
        decimal AccRouteAdherence=0;
        decimal AccStrikeRate =0;
        string id='';
        string AccName='';
        boolean AccTapwiser;
    }
     
    public class UserDetailsWrapper 
    {
        string username; //holds the logedin username 
        string startDate;//holds start date to get data from route schedule
        string endDate;  //holds end date to get data from route schedule
        public UserDetailsWrapper(string u,string sd,string ed)
        {
            this.username = u;  
            this.startDate = sd;
            this.endDate = ed;
        }
    }
    
    
}