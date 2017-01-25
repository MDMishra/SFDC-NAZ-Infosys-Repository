/*Author: Bharat*/
/*Description: send details of todays completed visits to IOS system 
/*Created date: 17/1/2017*/
/*Modification history: */

@RestResource(urlMapping='/AB_EndDay_Service/*')
    global with sharing class AB_EndDay_Service{
        
        @HttpPost //Method name
        //Check for User Authentication based on UserName and Password from external system 
        global static ResponseWrapper AB_EndDay_Service(string username){
            
            String strStatusMsg = '';//Holds the status message
            Integer isSuccessRes;//Holds the success response '1' or '0'
            list<ActivitiesWrapper> lstWrap = new list<ActivitiesWrapper>();
            try{       
                
                if(username != null)
                    strStatusMsg = 'Success';
                    isSuccessRes = 1;
                    list<event> objEvent = [select id,account.name,ownerid,whatid,StartDateTime,EndDateTime from event where StartDateTime = today and EndDateTime = today and Owner.UserName =: username];// query to check the whether the event exists or not.
                    for(event evt : objEvent){
                        ActivitiesWrapper objWrap = new ActivitiesWrapper();
                        objWrap.AccountName = evt.account.name;
                        objWrap.StartTime = evt.StartDateTime.format('h:mm a');
                        objWrap.EndTime = evt.EndDateTime.format('h:mm a');
                        lstWrap.add(objWrap);
                    }
                
            }
             catch(exception e) {strStatusMsg = AB_M360.EventLog(e);isSuccessRes = 0;}
            //system.debug('isSuccessRes=='+isSuccessRes);
            ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strStatusMsg , lstWrap);//Initialising the object for wrapper class. This object returns response to the external system.
            system.debug('obj=='+obj);
             
            return obj;      
        }
        //Wrapper class to serialize response
        global class ResponseWrapper
        {
            public integer isSuccess {get;set;}//Holds success or failure status.
            public String Message {get;set;}//Status message to be sent as response             
            public list<ActivitiesWrapper> listActivities {get;set;}    
            public ResponseWrapper(integer isSuccess,String Message,list<ActivitiesWrapper> listActivities)
            {
                this.isSuccess =isSuccess;
                this.Message = Message;
                this.listActivities = listActivities;
            }
        }
        public class ActivitiesWrapper
        {
            public String AccountName {get;set;}//user.fullPhotoUrl
            public String StartTime {get;set;}//user.fullname
            public String EndTime {get;set;}//Event created date
          
        }
        
    }