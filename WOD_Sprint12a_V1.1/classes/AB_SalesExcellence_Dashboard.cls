/*Author: Bharat*/
/*Description: Sending SalesExcellence_Dashboard Details to the External system.*/
/*Created date: 7/12/2016*/
/*Modification History:*/

@RestResource(urlMapping='/AB_SalesExcellence_Dashboard/*')
global with sharing class AB_SalesExcellence_Dashboard {
    @HttpPost //Method name
    global static ResponseWrapper AB_SalesExcellence_Dashboard()
    {
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        string strJSONBody = '';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
            //system.debug('strJSONBody=='+strJSONBody);
        }
        
        else{
             string str = '';
             if(AB_SalesExcellence_Dashboard_Test.Uname != null && AB_SalesExcellence_Dashboard_Test.Uname != ''){
                str =  AB_SalesExcellence_Dashboard_Test.Uname;
             }     
                 //system.debug('str=='+str);
                            
                 strJSONBody = '{\"username\":\"'+str+'\"}';
                 
             
        }
        list<string> aids = new list<string>();//list of poc Account ids
        integer TargetVisits= 0;
        double CompletedVisits = 0;
        decimal StrikeRate;
        decimal RouteAdherence;
        decimal TimeToSell;
        string StrTimeToSell='';
        integer PocsCount=0;
        integer Tapwisers=0;
        decimal Tapwiser;
        map<id,boolean> mapTapwisers =new map<id,boolean>();
        string strReturn=''; //Holds the return message to be sent as response
        Integer isSuccessRes; //Holds success status '0' or '1'
        try{     
            UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
            list<user> logedinUser = new list<user>();
            if(deserializedUser.username != null && deserializedUser.username != ''){   
                logedinUser = [select id,username, Wholesaler_Number__c,WSLRNbrRouteNbr__c,Email from user where username =: deserializedUser.username limit 1];//To get wholesaler Number of loged in user
                
            }
            system.debug('logedinUser=='+logedinUser);
            integer ScheduledCount=0;
            decimal VisitsCount=0;
            decimal TimeSpent=0.0;
            list<Route_Schedule__c> RouteList = new list<Route_Schedule__c>();//Holds Route List order by Sequence__c
            list<Route_Schedule__c> MonthsRouteList = new list<Route_Schedule__c>();
            if(logedinUser[0].WSLRNbrRouteNbr__c != null){
                RouteList = [select id,name,Route__r.WSLRNbrRouteNbr__c, Account__r.name,Account__r.Tapwiser__c,Account__c,Visits_Count__c,Scheduled_Count__c,Time_Spent__c from Route_Schedule__c where StopDate__c <= TODAY and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c and Route__r.WSLRNbrRouteNbr__c != null];//'005f00000029fc3': logedinUser[0].WSLRNbrRouteNbr__c
                MonthsRouteList = [select id,name,Route__r.WSLRNbrRouteNbr__c, Account__r.name,Account__r.Tapwiser__c,Account__c,Visits_Count__c,Scheduled_Count__c,Time_Spent__c from Route_Schedule__c where StopDate__c = THIS_MONTH and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c and Route__r.WSLRNbrRouteNbr__c != null];
            }
            system.debug('RouteList=='+RouteList.size());
            TargetVisits = RouteList.size();    
            if(RouteList != null && RouteList.size()!=0){              
                for(Route_Schedule__c c:RouteList){
                    if(c.Account__c != null){
                        aids.add(c.Account__c);  
                        if(mapTapwisers.get(c.Account__c) == null)
                            mapTapwisers.put(c.Account__c,c.Account__r.Tapwiser__c); 
                        if(c.Scheduled_Count__c != null)  
                            ScheduledCount +=integer.valueOf(c.Scheduled_Count__c); 
                        if(c.Visits_Count__c != null)
                            VisitsCount += integer.valueOf(c.Visits_Count__c); 
                        
                    }              
                } 
                               
            }
            PocsCount = mapTapwisers.size(); //counting total poc accounts          
            system.debug('PocsCount=='+PocsCount);
            
            //START: Time spent per visit 
            /*time spent should be calculate for this month*/
            if(MonthsRouteList != null && MonthsRouteList.size()!=0){              
                for(Route_Schedule__c c:MonthsRouteList){
                    if(c.Account__c != null){
                        if(c.Time_Spent__c != null)
                            TimeSpent += c.Time_Spent__c;//counting total time spent in the month
                    }
                }
            }
            //End: Time spent per visit
            
            
            //START: Tapwiser account counting
            if(mapTapwisers != null && !mapTapwisers.isempty()){
                for(id keyid : mapTapwisers.keyset()){
                    if(mapTapwisers.get(keyid) == true)
                        Tapwisers++;
                }
            }
            //END: Tapwiser account counting
            
            Tapwiser = Tapwisers/PocsCount*100;
            system.debug('Tapwisers=='+Tapwisers);
            system.debug('VisitsCount=='+VisitsCount);
            system.debug('ScheduledCount=='+ScheduledCount);
            system.debug('TimeSpent=='+TimeSpent);
            system.debug('RouteList=='+RouteList);
            list<event> eventlist = new list<event>();
            //eventlist = [select id,Out_of_Range_on_Start__c,Out_of_Range_on_End__c,Visit_Completed__c,EndDateTime from event where Whatid in: aids and Visit_Completed__c = true and Out_of_Range_on_Start__c = false and Out_of_Range_on_End__c = false];
            Date startOfMonth = Date.today().toStartOfMonth();
            Date startOfNextMonth = startOfMonth.addMonths(1);
            eventlist = [select id,Out_of_Range_on_Start__c,Out_of_Range_on_End__c,Visit_Completed__c,EndDateTime,whatid from event where Visit_Completed__c = true and Out_of_Range_on_Start__c = false and Out_of_Range_on_End__c = false and EndDateTime >= :startOfMonth and EndDateTime < :startOfNextMonth and EndDateTime != null and whatid in: aids];
            system.debug('eventlist=='+eventlist);
            CompletedVisits = eventlist.size();           
            StrikeRate = CompletedVisits/TargetVisits*100;
            if(string.valueof(StrikeRate).contains('.'))
                StrikeRate = StrikeRate.round();
            RouteAdherence = VisitsCount/ScheduledCount*100;
            
            string DecValue='';
            if(RouteAdherence.scale()>1){
                DecValue = string.valueof(RouteAdherence.setscale(2)).substringAfter('.');
            }
            else 
                DecValue = string.valueof(RouteAdherence).substringAfter('.');
            if(string.valueof(RouteAdherence).contains('.'))
                RouteAdherence = decimal.valueOf(string.valueof(RouteAdherence).substringBefore('.')+'.'+DecValue);
            
            TimeToSell = TimeSpent/integer.valueOf(date.today().day());//toatal time spent in this month divided by no.of days in this month
            
            //********************This piece of code is to convert decimal hours in to minutes
            string str1 = '';
            string str2 = '';
            if(string.valueof(TimeToSell).contains('.'))
                str1 = string.valueof(decimal.valueOf('.'+string.valueof(TimeToSell).substringAfter('.'))*60);
            if(str1.contains('.'))
                str1 = str1.substringBefore('.');           
            system.debug(str1);
            if(string.valueof(TimeToSell).contains('.'))
                str2 = string.valueof(TimeToSell).substringBefore('.');
            system.debug(str2);
            TimeToSell = decimal.valueOf(str2+'.'+str1);
            
            system.debug('TimeToSell=='+TimeToSell);
            string minutes;
            if(TimeToSell.scale()>1){
                minutes = string.valueof(TimeToSell.setscale(2)).substringAfter('.');
            }
            else 
                minutes = string.valueof(TimeToSell).substringAfter('.');
            if(string.valueof(TimeToSell).contains('.'))
                //TimeToSell = decimal.valueOf(string.valueof(TimeToSell).substringBefore('.')+'.'+string.valueof(TimeToSell).substringAfter('.').substring(0,2));string.valueof(TimeToSell).substringAfter('.').substring(0,2)
                StrTimeToSell = string.valueof(TimeToSell).substringBefore('.')+'hr '+minutes+'min';
            strReturn = 'Success';
            isSuccessRes = 1;
            
        }
        catch(exception e) {strReturn = 'Sorry, Something went wrong.'+e.getMessage()+e.getlinenumber();system.debug('e.getMessage()=='+e.getMessage()+e.getlinenumber());isSuccessRes = 0;}
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,StrikeRate,RouteAdherence,StrTimeToSell,TimeToSell,Tapwiser,80,100,40);//Initialising the object for wrapper class. This object can be returned as response to the external system.
            return obj;
    }
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
          public ResponseWrapper(integer isSuccess,String Message,decimal StrikeRate,decimal RouteAdherence,string StrTimeToSell,decimal TimeToSell,decimal Tapwiser,decimal TargetStrikeRate,decimal TargetRouteAdherence,decimal TargetTapwiser)
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
          }
      }
    public class UserDetailsWrapper 
    {
        string username; //holds the logedin username   
        //string AccountsNeeded;    
        public UserDetailsWrapper(string u)
        {
            this.username = u;  
            //this.AccountsNeeded = AccountsNeeded;                     
        }
    }
    
    
}