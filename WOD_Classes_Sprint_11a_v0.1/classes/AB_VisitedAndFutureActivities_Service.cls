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
        map<string,user> mapRouteUser = new map<string,user>();//holds wholesaler RouteNumber and related user
        string RequestedAccId = '';//holds Accountid of request
        list<Route_Schedule__c> ListRouteSchedules = new list<Route_Schedule__c>();
        set<string> setRouteNmbers = new set<string>();//holds WholesalerRoutenumbers of Route__c to map with users
        try{
            RequestWrapper deserializedRequest = 
              (RequestWrapper)JSON.deserializeStrict(JSONString, RequestWrapper.class);//To deserialze request body.
              
            if(deserializedRequest.AccountId != null){
                RequestedAccId = deserializedRequest.AccountId;
                objEvent= [select id,createddate,ownerid,owner.name from event where accountid =: RequestedAccId order by createddate desc];// query to get events where whatid = request.accountid.(Past events)
                ListRouteSchedules = [select stopdate__c, Route__r.WSLRNbrRouteNbr__c from Route_Schedule__c where Account__c =: RequestedAccId order by stopdate__c asc];//query to get future activities owners from routeschedule
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
                
                objActWrap.CreatedDate = string.valueOf(obj.createddate);
                lstPastRecords.add(objActWrap);
            }
            //Stop:Past Activities details
            
            //Start: Future Activities Details
            if(ListRouteSchedules != null && ListRouteSchedules.size() != 0){
                for(Route_Schedule__c objRte : ListRouteSchedules){
                    if(objRte.Route__r.WSLRNbrRouteNbr__c != null)
                        setRouteNmbers.add(objRte.Route__r.WSLRNbrRouteNbr__c);
                }
                if(setRouteNmbers != null && setRouteNmbers.size() != 0){
                    listFutureUsr = [select id,name,fullphotourl,WSLRNbrRouteNbr__c from user where WSLRNbrRouteNbr__c in: setRouteNmbers];
                    if(listFutureUsr != null && listFutureUsr.size() != 0){
                        for(user objUsr : listFutureUsr){
                            if(mapRouteUser.get(objUsr.WSLRNbrRouteNbr__c) == null)
                                mapRouteUser.put(objUsr.WSLRNbrRouteNbr__c,objUsr);
                        }
                    }
                    
                }
                for(Route_Schedule__c objRute : ListRouteSchedules){
                    ActivitiesWrapper objFutureActWrap = new ActivitiesWrapper();
                    if(objRute.Route__r.WSLRNbrRouteNbr__c != null){
                        if(mapRouteUser.get(objRute.Route__r.WSLRNbrRouteNbr__c) != null){
                            objFutureActWrap.PhotoUrl = mapRouteUser.get(objRute.Route__r.WSLRNbrRouteNbr__c).fullphotourl;
                            objFutureActWrap.Name = mapRouteUser.get(objRute.Route__r.WSLRNbrRouteNbr__c).name;
                            if(objRute.stopdate__c != null)
                                objFutureActWrap.CreatedDate = string.valueOf(objRute.stopdate__c);
                            else
                                objFutureActWrap.CreatedDate = '';
                            lstFutureRecords.add(objFutureActWrap);
                        }
                        
                    }
                }
            }
            //Stop: Future Activities Details
            strReturn = 'Success.';
            isSuccessRes = 1;
        }
        catch(exception e) {
                strReturn = 'Sorry, Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                isSuccessRes = 0;
        }
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,lstPastRecords,lstFutureRecords);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        //system.debug('obj=='+obj);
        return obj; 
        
        
    }
    //Wrapper class to serialize response
    global class ResponseWrapper
    {
      public integer isSuccess {get;set;}
      public String Message {get;set;} 
      public list<ActivitiesWrapper> ActivitiesPastDetails {get;set;}     
      public list<ActivitiesWrapper> ActivitiesFutureDetails {get;set;}
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