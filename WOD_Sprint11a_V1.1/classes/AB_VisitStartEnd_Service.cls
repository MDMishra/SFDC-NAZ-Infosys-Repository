/*Author: Bharat*/
/*Description: To send Response to the external IOS system about visit start and end status.*/
/*Created date: 31/8/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_VisitStartEnd_Service/*')
   global with sharing class AB_VisitStartEnd_Service{
     @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper AB_VisitStartEnd_Service(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        
        string JSONString = '';
        if(!test.isRunningTest()){
            JSONString = request.requestBody.toString();// Holds the request body
        }
        else{
            
            AB_VisitStartEnd_Service_Test testAB = new  AB_VisitStartEnd_Service_Test();
            string str = AB_VisitStartEnd_Service_Test.Uname;
            string strAid = AB_VisitStartEnd_Service_Test.AId;
            string strEndLat = AB_VisitStartEnd_Service_Test.EndGeoLatitude;
            string strEndLong = AB_VisitStartEnd_Service_Test.EndGeoLongitude;
            string strStrtLat = AB_VisitStartEnd_Service_Test.StartGeoLatitude;
            string strStrtLong = AB_VisitStartEnd_Service_Test.StartGeoLongitude;
            boolean visitProgress = AB_VisitStartEnd_Service_Test.isVisitInprogress;
            //system.debug(visitProgress);  
            //system.debug(strStrtLat);
            //system.debug(strStrtLong );         
            boolean StartOutOfRange = AB_VisitStartEnd_Service_Test.isStartOutOfRange;
            //system.debug(StartOutOfRange);
            boolean EndOutOfRange = AB_VisitStartEnd_Service_Test.isEndOutOfRange;
            string Reasons = AB_VisitStartEnd_Service_Test.Reason;
            boolean VisitCompleted = AB_VisitStartEnd_Service_Test.isVisitCompleted;
            string StrtdateTime = AB_VisitStartEnd_Service_Test.StartdateAndTime;
            string EnddateTime = AB_VisitStartEnd_Service_Test.EnddateAndTime;
            //system.debug('str=='+str);
            //strJSONBody = '{\"AccountId\":\"001f000000pKybg\"}';
            JSONString = '{\"AccountId\":\"'+strAid+'\",'+'\"UserName\":\"'+str+'\",'+'\"EndGeoLatitude\":\"'+strEndLat+'\",'+'\"EndGeoLongitude\":\"'+strEndLong+'\",';
            JSONString = JSONString+'\"StartGeoLatitude\":\"'+strStrtLat+'\",'+'\"StartGeoLongitude\":\"'+strStrtLong+'\",'+'\"StartdateAndTime\":\"'+StrtdateTime+'\",'+'\"EnddateAndTime\":\"'+EnddateTime+'\",';
            JSONString = JSONString+'\"isVisitInprogress\":'+visitProgress+',';
            JSONString = JSONString+'\"isStartOutOfRange\":'+StartOutOfRange+','+'\"isEndOutOfRange\":'+EndOutOfRange+',';
            //JSONString = JSONString+'\"StartdateAndTime\":\"'+StrtdateTime+'\",'+'\"EnddateAndTime\":\"'+EnddateTime+'\"}';
            JSONString = JSONString+'\"Reason\":\"'+Reasons+'\",'+'\"isVisitCompleted\":'+VisitCompleted+'}';
        }
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        list<Event> objEvent = new list<event>();
        user objUsr;
        try{     
            VisitDetailsWrapper deserializedRequest = 
              (VisitDetailsWrapper)JSON.deserializeStrict(JSONString, VisitDetailsWrapper.class);//To deserialze request body.
            //system.debug('deserializedRequest=='+deserializedRequest);
            //system.debug(deserializedRequest.StartGeoLatitude+'======'+deserializedRequest.StartGeoLongitude+'====='+deserializedRequest.EndGeoLatitude+'======'+deserializedRequest.EndGeoLongitude);
            if(deserializedRequest.isVisitInprogress == true && (deserializedRequest.StartGeoLatitude == '' || deserializedRequest.StartGeoLongitude == ''))
                system.debug('Not found Geolocation on Start visit.');
            if(deserializedRequest.isVisitCompleted == true && (deserializedRequest.EndGeoLatitude == '' || deserializedRequest.EndGeoLongitude == ''))
                system.debug('Not found Geolocation on End visit.');
            //Query the event object.
            if(deserializedRequest.AccountId != null && deserializedRequest.UserName != null)
                objEvent= [select id from event where createddate = TODAY and accountid =: deserializedRequest.AccountId and Owner.UserName =: deserializedRequest.UserName limit 1];// query to check the whether the event exists or not.
            //system.debug('objEvent=='+objEvent); 
            if(deserializedRequest.UserName != null)
                objUsr = [select id from user where username =: deserializedRequest.UserName limit 1];
            //system.debug('objUsr =='+objUsr); 
                       
            //To get start datetime gmt value
            DateTime Startdt;
            //2016-10-03 19:08:41
            
            //06/08/2013 07:23:22
            if(deserializedRequest.StartdateAndTime != ''){
            String myDate = deserializedRequest.StartdateAndTime;
            String stringDate1 = myDate.substring(0,4) + '-' + 
                                myDate.substring(5,7) + '-' +
                                myDate.substring(8,10) + ' ' +
                                myDate.substring(11,19);
            Startdt = datetime.valueOf(stringDate1);
            }
            //To get enddatetime gmt value
            DateTime Enddt;
            if(deserializedRequest.EnddateAndTime != ''){
            String myDate2 = deserializedRequest.EnddateAndTime;
            String stringDate2 = myDate2.substring(0,4) + '-' + 
                                myDate2.substring(5,7) + '-' +
                                myDate2.substring(8,10) + ' ' +
                                myDate2.substring(11,19);
            Enddt = datetime.valueOf(stringDate2);
            //System.debug(String.valueOfGmt(Enddt));
            }
            
            if(!objEvent.isEmpty()){ //if the event exists. End visit call         
                system.debug('Update');
                if(deserializedRequest.StartGeoLatitude != '')
                    objEvent[0].Start_Geo_Location__Latitude__s = decimal.valueOf(deserializedRequest.StartGeoLatitude);
                if(deserializedRequest.StartGeoLongitude != '')
                    objEvent[0].Start_Geo_Location__Longitude__s = decimal.valueOf(deserializedRequest.StartGeoLongitude);
                if(deserializedRequest.EndGeoLatitude != '')
                    objEvent[0].End_Geo_Location__Latitude__s = decimal.valueOf(deserializedRequest.EndGeoLatitude);
                if(deserializedRequest.EndGeoLongitude != '')
                    objEvent[0].End_Geo_Location__Longitude__s = decimal.valueOf(deserializedRequest.EndGeoLongitude);
                if(deserializedRequest.StartdateAndTime != '')
                    objEvent[0].StartDateTime = Startdt;
                    //objEvent[0].StartDateTime = DateTime.valueOf(deserializedRequest.StartdateAndTime);
                if(deserializedRequest.EnddateAndTime != '')
                    objEvent[0].EndDateTime = Enddt;
                    //objEvent[0].EndDateTime = DateTime.valueOf(deserializedRequest.EnddateAndTime);
               // if(deserializedRequest.AccountId != null)
                   // objEvent.accountid = deserializedRequest.AccountId;
                if(objUsr != null)
                    objEvent[0].ownerid = objUsr.id;
                if(deserializedRequest.isVisitInprogress != null)
                    objEvent[0].Visit_in_Progress__c = deserializedRequest.isVisitInprogress;
                if(deserializedRequest.isStartOutOfRange != null && deserializedRequest.isVisitCompleted == false)
                    objEvent[0].Out_of_Range_on_Start__c = deserializedRequest.isStartOutOfRange;
                if(deserializedRequest.isEndOutOfRange != null)
                    objEvent[0].Out_of_Range_on_End__c = deserializedRequest.isEndOutOfRange;
                if(deserializedRequest.Reason != null && deserializedRequest.isVisitInprogress == true)               
                    objEvent[0].Out_of_Range_Reason__c = deserializedRequest.Reason;
                if(deserializedRequest.isVisitCompleted != null)
                    objEvent[0].Visit_Completed__c = deserializedRequest.isVisitCompleted;
                strReturn='Success.'; 
                isSuccessRes = 1;  
                update objEvent;                                
            } 
            
            else{ // if the user not exists. Start visit call
                
                system.debug('NotUpdate');
                event obj = new event();
                obj.subject = 'POC Visit - '+string.valueOf(deserializedRequest.StartdateAndTime);
                
                if(deserializedRequest.StartdateAndTime != ''){
                    string strDate = string.valueOf(deserializedRequest.StartdateAndTime);
             
                    obj.ActivityDateTime =Startdt;
                }
                obj.DurationInMinutes = 30;//Required field in event to insert a record.
                
                if(deserializedRequest.StartGeoLatitude != '')
                    obj.Start_Geo_Location__Latitude__s = decimal.valueOf(deserializedRequest.StartGeoLatitude);
                if(deserializedRequest.StartGeoLongitude != '')
                    obj.Start_Geo_Location__Longitude__s = decimal.valueOf(deserializedRequest.StartGeoLongitude);
                if(deserializedRequest.EndGeoLatitude != '')
                    obj.End_Geo_Location__Latitude__s = decimal.valueOf(deserializedRequest.EndGeoLatitude);
                if(deserializedRequest.EndGeoLongitude != '')
                    obj.End_Geo_Location__Longitude__s = decimal.valueOf(deserializedRequest.EndGeoLongitude);
                if(deserializedRequest.StartdateAndTime != '')
                    obj.StartDateTime = Startdt;
                    //obj.StartDateTime = DateTime.valueOf(deserializedRequest.StartdateAndTime);
                if(deserializedRequest.EnddateAndTime != '')
                    obj.EndDateTime = Enddt;
                    //obj.EndDateTime = DateTime.valueOf(deserializedRequest.EnddateAndTime);
                if(deserializedRequest.AccountId != null)
                    obj.Whatid = deserializedRequest.AccountId;
                if(objUsr != null)
                    obj.ownerid = objUsr.id;
                if(deserializedRequest.isVisitInprogress != null)
                    obj.Visit_in_Progress__c = deserializedRequest.isVisitInprogress;
                if(deserializedRequest.isStartOutOfRange != null)
                    obj.Out_of_Range_on_Start__c = deserializedRequest.isStartOutOfRange;
                if(deserializedRequest.isEndOutOfRange != null)
                    obj.Out_of_Range_on_End__c = deserializedRequest.isEndOutOfRange;
                if(deserializedRequest.Reason != null)               
                    obj.Out_of_Range_Reason__c = deserializedRequest.Reason;
                if(deserializedRequest.isVisitCompleted != null)
                    obj.Visit_Completed__c = deserializedRequest.isVisitCompleted;
                //obj.Out_of_Range_Options__c = 'option 2';
                insert obj;
                strReturn='Success.'; 
                isSuccessRes = 1;
            }
        }
        catch(exception e) {strReturn = 'Sorry, Something went wrong.';system.debug('e.getMessage()=='+e.getMessage());isSuccessRes = 0;}
                
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        return obj; 
      }
      //Wrapper class to serialize response
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}         
          public ResponseWrapper(integer isSuccess,String Message)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
          }
      }
      // Wrapper class to deserialize user details.     
      public class VisitDetailsWrapper {
          string StartGeoLatitude;//event.Start_Geo_Location__c
          string StartGeoLongitude; //event.Start_Geo_Location__c
          string EndGeoLatitude;//event.End_Geo_Location__c
          string EndGeoLongitude;//event.End_Geo_Location__c
          string StartdateAndTime; //event.StartDateTime
          string EnddateAndTime;//event.EndDateTime
          string AccountId;//event.accountid
          string UserName;//event.ownerid
          boolean isVisitInprogress;//event.Visit_in_Progress__c
          boolean isStartOutOfRange;//event.Out_of_Range_on_Start__c
          boolean isEndOutOfRange;//event.Out_of_Range_on_End__c
          string Reason;//event.Out_of_Range_Reason__c
          boolean isVisitCompleted;//event.Visit_Completed__c      
          public VisitDetailsWrapper(string StartGeoLatitude,string StartGeoLongitude,string EndGeoLatitude,string EndGeoLongitude,string StartdateAndTime,string EnddateAndTime,string AccountId,string UserName,boolean isVisitInprogress,boolean isStartOutOfRange,boolean isEndOutOfRange,string Reason,boolean isVisitCompleted)
          {
              this.StartGeoLatitude= StartGeoLatitude; 
              this.StartGeoLongitude= StartGeoLongitude; 
              this.EndGeoLatitude= EndGeoLatitude;
              this.EndGeoLongitude= EndGeoLongitude;
              this.StartdateAndTime= StartdateAndTime;
              this.EnddateAndTime= EnddateAndTime;
              this.AccountId= AccountId; 
              this.UserName= UserName; 
              this.isVisitInprogress= isVisitInprogress;
              this.isStartOutOfRange= isStartOutOfRange;
              this.isEndOutOfRange= isEndOutOfRange;
              this.Reason= Reason;   
              this.isVisitCompleted= isVisitCompleted;                   
          }
      }
   }