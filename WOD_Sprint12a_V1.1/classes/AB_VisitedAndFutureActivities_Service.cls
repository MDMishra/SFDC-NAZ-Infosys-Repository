/*Author: Bharat*/
/*Description: To send Response to the external IOS system about all events(Activities) which are visited for accounts and future activities*/
/*Created date: 07/11/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_VisitedAndFutureActivities_Service/*')
   global with sharing class AB_VisitedAndFutureActivities_Service{
     @HttpPost //Method name
     //To send Response to the external IOS system about visited Account events and future activities.
      global static ResponseWrapper AB_VisitedAndFutureActivities_Service(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        
        string JSONString = '';
        if(!test.isRunningTest()){
            JSONString = request.requestBody.toString();// Holds the request body
        }
        else
        {
            if(AB_VisitedAndFutureActivities_Test.accId != null && AB_VisitedAndFutureActivities_Test.accId != '')
                 {
                     string strAId = AB_VisitedAndFutureActivities_Test.accId;
                     JSONString = '{\"AccountId\":\"'+strAId+'\"}';
                 }
           
        }
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        list<Event> objEvent = new list<event>();
        list<user> listPastUsr = new list<user>();//holds users of past activities
        list<user> listFutureUsr = new list<user>();//holds users of Future activities
        list<id> ListUsrId = new list<id>();
        List<ActivitiesWrapper> lstPastRecords = new List<ActivitiesWrapper>();//Initializing Wrapper object list.
        List<ActivitiesWrapper> lstFutureRecords = new List<ActivitiesWrapper>();//Initializing Wrapper object list.
        map<id,string> mapUserPics= new map<id,string>();//holds id of owner and fullphotourl
        //map<string,list<user>> mapRouteUser = new map<string,list<user>>();//holds wholesaler RouteNumber and related user
        string RequestedAccId = '';//holds Accountid of request
        list<Route_Schedule__c> ListRouteSchedules = new list<Route_Schedule__c>();
        set<string> setRouteNmbers = new set<string>();//holds WholesalerRoutenumbers of Route__c to map with users
        try{
            RequestWrapper deserializedRequest = 
              (RequestWrapper)JSON.deserializeStrict(JSONString, RequestWrapper.class);//To deserialze request body.
              
            if(deserializedRequest.AccountId != null){
                RequestedAccId = deserializedRequest.AccountId;
                objEvent= [select id,createddate,ownerid,owner.name,subject from event where accountid =: RequestedAccId and subject like '%POC VISIT%' order by createddate desc];// query to get events where whatid = request.accountid.(Past events)
                ListRouteSchedules = [select stopdate__c, Route__r.WSLRNbrRouteNbr__c from Route_Schedule__c where Account__c =: RequestedAccId and stopdate__c > TODAY and Route__r.WSLRNbrRouteNbr__c != null order by stopdate__c asc];//query to get future activities owners from routeschedule
            }
            //Start:Past Activities Details
            if(objEvent != null && objEvent.size() != 0){
                for(event obj : objEvent){
                    if(obj.ownerid != null)
                        ListUsrId.add(obj.ownerid);
                }
                if(ListUsrId != null && ListUsrId.size() != 0)
                    listPastUsr = [select name,id,fullphotourl from user where id in: ListUsrId];        
            }
            for(user objU : listPastUsr){
                if(mapUserPics.get(objU.id) == null)
                    mapUserPics.put(objU.id,objU.fullphotourl);
            }
            for(event obj:objEvent){
                ActivitiesWrapper objActWrap = new ActivitiesWrapper();
                if(mapUserPics.get(obj.ownerid) != null)
                    objActWrap.PhotoUrl = mapUserPics.get(obj.ownerid);
                objActWrap.Name = obj.owner.name;
                
                //objActWrap.CreatedDate = string.valueOf(obj.createddate);
                objActWrap.CreatedDate = PrepareDate(string.valueOf(obj.createddate.month()), string.valueOf(obj.createddate.day()));
                lstPastRecords.add(objActWrap);
            }
            //Stop:Past Activities details
            
            //Start: Future Activities Details
            if(ListRouteSchedules != null && ListRouteSchedules.size() != 0){
                for(Route_Schedule__c objRte : ListRouteSchedules){
                    if(objRte.Route__r.WSLRNbrRouteNbr__c != null && objRte.stopdate__c != null && objRte.stopdate__c >= system.today())// 
                        setRouteNmbers.add(objRte.Route__r.WSLRNbrRouteNbr__c);
                }
                if(setRouteNmbers != null && setRouteNmbers.size() != 0){
                    listFutureUsr = [select id,name,fullphotourl,WSLRNbrRouteNbr__c from user where WSLRNbrRouteNbr__c in: setRouteNmbers];
                    
                    
                }
                
                for(Route_Schedule__c objRute : ListRouteSchedules){
                    
                            if(listFutureUsr != null && !listFutureUsr.isEmpty())
                            {
                                for(user usr : listFutureUsr)
                                {
                                    if(usr.WSLRNbrRouteNbr__c == objRute.Route__r.WSLRNbrRouteNbr__c)
                                    {
                                        ActivitiesWrapper objFutureActWrap = new ActivitiesWrapper();
                                        objFutureActWrap.PhotoUrl = usr.fullphotourl;
                                        objFutureActWrap.Name = usr.name;
                                        if(objRute.stopdate__c != null)
                                            objFutureActWrap.CreatedDate = 
                                            PrepareDate(string.valueOf(objRute.stopdate__c.month()), string.valueOf(objRute.stopdate__c.day()));
                                        else
                                            objFutureActWrap.CreatedDate = '';
                                        lstFutureRecords.add(objFutureActWrap);
                                    }
                                }
                            }
                    
                }
            }
            //Stop: Future Activities Details
            strReturn = 'Success.';
            isSuccessRes = 1;
        }
          catch(exception e) {strReturn = 'Sorry, Something went wrong.'+e.getMessage();system.debug('e.getMessage()=='+e.getMessage()+e.getlinenumber());system.debug('e.getMessage()=='+e.getlinenumber());isSuccessRes = 0;}
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,lstPastRecords,lstFutureRecords);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        //system.debug('obj=='+obj);
        return obj; 
        
        
    }
    public static string PrepareDate(string dtMonth,string dtDay){
        string strDate = '';
        if(dtMonth == '01' || dtMonth == '1')
            strDate = 'January '+dtDay;
        if(dtMonth == '02' || dtMonth =='2')
            strDate = 'February '+dtDay;
        if(dtMonth == '03' || dtMonth == '3')
            strDate = 'March '+dtDay;
        if(dtMonth == '04' || dtMonth == '4')
            strDate = 'April '+dtDay;
        if(dtMonth == '05' || dtMonth == '5')
            strDate = 'May '+dtDay;
        if(dtMonth == '06' || dtMonth == '6')
            strDate = 'June '+dtDay;
        if(dtMonth == '07' || dtMonth == '7')
            strDate = 'July '+dtDay;
        if(dtMonth == '08' || dtMonth == '8')
            strDate = 'August '+dtDay;
        if(dtMonth == '09' || dtMonth == '9')
            strDate = 'September '+dtDay;
        if(dtMonth == '10')
            strDate = 'October '+dtDay;
        if(dtMonth == '11')
            strDate = 'November '+dtDay;
        if(dtMonth == '12')
            strDate = 'December '+dtDay;
        return strDate;
    }
    //Wrapper class to serialize response
    global class ResponseWrapper
    {
      public integer isSuccess {get;set;}//Holds success response
      public String Message {get;set;} //holds success message
      public list<ActivitiesWrapper> ActivitiesPastDetails {get;set;}   //holds events related to the account  
      public list<ActivitiesWrapper> ActivitiesFutureDetails {get;set;}//holds future events to be created(data retrieving according to the conditions from route schedule object)
      public ResponseWrapper(integer isSuccess,String Message,list<ActivitiesWrapper> ActivitiesPastDetails,list<ActivitiesWrapper> ActivitiesFutureDetails)
      {
          this.isSuccess =isSuccess;
          this.Message = Message;
          this.ActivitiesPastDetails = ActivitiesPastDetails;
          this.ActivitiesFutureDetails = ActivitiesFutureDetails;
      }
    }
     //Wrapper class to store list Visited Activities details.
      public class ActivitiesWrapper
      {
          public String PhotoUrl {get;set;}//user.fullPhotoUrl
          public String Name {get;set;}//user.fullname
          public String CreatedDate {get;set;}//Event created date
          
      }
    //Wrapper class to deserialize request
    public class RequestWrapper
    {
      public string AccountId {get;set;}
      public RequestWrapper(string AccountId)
      {
          this.AccountId = AccountId;
      }
    }
}