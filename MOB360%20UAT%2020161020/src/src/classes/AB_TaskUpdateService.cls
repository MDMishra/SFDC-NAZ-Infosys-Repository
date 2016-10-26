/*Author: Appshark*/
/*Description: To Update Task records .*/
/*Created date: 28/9/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_TaskUpdateService/*')
   global with sharing class AB_TaskUpdateService{
     @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper AB_TaskUpdateService(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        
        string JSONString = '';
        if(!test.isRunningTest()){
            JSONString = request.requestBody.toString();// Holds the request body
            system.debug('######'+Limits.getHeapSize());
        }
        else{
            AB_TaskUpdateService_Test objTest = new AB_TaskUpdateService_Test();
            if(AB_TaskUpdateService_Test.TaskId != null && AB_TaskUpdateService_Test.TaskId !=''){
                string TaskId = AB_TaskUpdateService_Test.TaskId;
                JSONString = '{\"id\":\"'+TaskId+'\",\"Status\":\"In Progress\"}';
            }
        }
        
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        try{     
            UserNotesWrapper deserializedRequest = 
              (UserNotesWrapper)JSON.deserializeStrict(JSONString, UserNotesWrapper.class);//To deserialze request body.
            Task objTaskToUpdate = new Task();
            if(deserializedRequest.id != null && deserializedRequest.id != ''){
                objTaskToUpdate = [select id,status from task where id =: deserializedRequest.id];   
                objTaskToUpdate.status = deserializedRequest.Status;
                update objTaskToUpdate;
                strReturn = 'Record Updated Successfully.';
                isSuccessRes = 1;
            }
        }
        catch(exception e) {
                strReturn = 'Sorry, Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                System.debug('Exception e '+e.getLineNumber());
                isSuccessRes = 0;
        }
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        //system.debug('obj=='+obj);
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
      public class UserNotesWrapper {
                   
          string status;
          string id;                      
          public UserNotesWrapper(string status,string id)
          {             
              this.Status= Status;
              this.id = id;                           
          }
      }
   }