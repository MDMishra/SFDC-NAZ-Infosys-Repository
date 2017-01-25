/*Author: Bharat*/
/*Description: To Update User Notes(ContentNotes) records .*/
/*Created date: 27/9/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_UserNotesUpdateService/*')
   global with sharing class AB_UserNotesUpdateService{
     @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper AB_UserNotesUpdateService(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        
        string JSONString = '';
        
        if(!test.isRunningTest()){
            JSONString = request.requestBody.toString();// Holds the request body
            system.debug('######'+Limits.getHeapSize());
        }
        else{
            
            JSONString = AB_UserNotesUpdateService_Test.JSONString;
        }
        
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        list<Note> objNote;
        try{     
            UserNotesWrapper deserializedRequest = 
              (UserNotesWrapper)JSON.deserializeStrict(JSONString, UserNotesWrapper.class);//To deserialze request body.
            
            if(deserializedRequest.id != null && deserializedRequest.id != ''){
                objNote = [select id,title,body,parentid,lastmodifiedby.id,createdby.id from Note where id =: deserializedRequest.id limit 1];
                //system.debug('objNote =='+objNote); 
                if(deserializedRequest.isDelete != null && deserializedRequest.isDelete == true){
                    if(objNote != null && objNote.size() != 0){
                        delete objNote;
                        strReturn='Note deleted successfully.'; 
                        isSuccessRes = 1;
                    }
                }
                else{
                    if(objNote != null && objNote.size() != 0){
                        Note obj = new Note();
                        obj = objNote[0];
                        obj.title = deserializedRequest.Title;
                        obj.body = deserializedRequest.Content;
                        //obj.lastmodifiedby.id = deserializedRequest.userId;
                         
                        update obj;
                        strReturn='Note updated successfully.'; 
                        isSuccessRes = 1;
                    }
                }
            }
            else{
                Note objCNote = new Note();
                objCNote.title = deserializedRequest.Title;
                objCNote.parentid = deserializedRequest.accountId;
                //String body = deserializedRequest.Content;
                //objCNote.Content = Blob.valueOf(body.escapeHTML4());
                objCNote.body = deserializedRequest.Content;
                //objCNote.createdbyid = '005f00000029fc3';
                insert objCNote;
                strReturn='Note created successfully.'; 
                isSuccessRes = 1;
            }             
            
            
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
      public class UserNotesWrapper {
          
          string Title;
          
          string Content;
          string id;
          boolean isDelete;
          string accountId;
          //string userId;
                        
          public UserNotesWrapper(string Title,string Content,string id,boolean isDelete,string accountId)
          {
              this.Title = Title;
              
              this.Content = Content;
              this.id = id; 
              this.isDelete = isDelete;       
              this.accountId = accountId; 
              //this.userId = userId;    
          }
      }
   }