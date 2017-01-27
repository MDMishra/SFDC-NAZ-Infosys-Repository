/*Author: Bharat*/
/*Description: To save New task records created in ios.*/
/*Created date: 27/9/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_CreateNewTaskService/*')
   global with sharing class AB_CreateNewTaskService{
     @HttpPost //Method name
      global static ResponseWrapper AB_CreateNewTaskService(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        
        string JSONString = '';
        
        if(!test.isRunningTest()){
            JSONString = request.requestBody.toString();// Holds the request body
            system.debug('######'+Limits.getHeapSize());
        }
        else{           
            JSONString = AB_CreateNewTaskService_Test.JSONString;
        }
        
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        
        try{     
            TaskWrapper deserializedRequest = 
              (TaskWrapper)JSON.deserializeStrict(JSONString, TaskWrapper.class);//To deserialze request body.
            task tsk = new task();
            if(deserializedRequest.subject != null)
                tsk.Subject = deserializedRequest.subject;
            else
                tsk.Subject = 'No Subject';
            if(deserializedRequest.AssignedTo != null)
                tsk.Ownerid = deserializedRequest.AssignedTo;
            if(deserializedRequest.Accountid != null && deserializedRequest.Accountid != '')            
                tsk.Whatid = deserializedRequest.Accountid;
            if(deserializedRequest.DueDate != null)
                tsk.ActivityDate = date.valueOf(deserializedRequest.DueDate);
            if(deserializedRequest.Priority != null)
                tsk.Priority = deserializedRequest.Priority;
            
            if(deserializedRequest.Category != null)
                tsk.Category__c = deserializedRequest.Category;
            if(deserializedRequest.Description != null)
                tsk.Description = deserializedRequest.Description;
            insert tsk; 
            strReturn = 'Success.';
            isSuccessRes = 1;
            
        }
        catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
        
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
      public class TaskWrapper {
          
          string Subject;
          string DueDate;
          string AssignedTo;
          string Accountid;
          string Priority;
          string Category;
          string Description;
                        
          public TaskWrapper(string Subject,string DueDate,string AssignedTo,string Accountid,string Priority,string Category,string Description)
          {
              this.Subject= Subject;
              this.DueDate= DueDate;
              this.AssignedTo= AssignedTo;
              this.Accountid= Accountid; 
              this.Priority= Priority;
              this.Category= Category; 
              this.Description= Description;               
          }
      }
   }