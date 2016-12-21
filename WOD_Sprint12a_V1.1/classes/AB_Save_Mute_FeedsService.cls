/*Author: Bharat*/
/*Description: Sending Muted feedIds of logied in user to the External system.*/
/*Created date: 06/10/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_Save_Mute_FeedsService/*')
   global with sharing class AB_Save_Mute_FeedsService{
       
     @HttpPost //Method name
     //Sending Muted Feedids of loged in user to the External system.
      global static ResponseWrapper AB_Save_Mute_FeedsService(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('request.requestBody=='+request.requestBody.toString());
        string strJSONBody='';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
        }
        else{
            
            strJSONBody = AB_Save_Mute_FeedsService_Test.strJSONBody;
            //strJSONBody = '{\"UserName\":\"rajesh.kurumati@nuvemconsulting.com\",\"FeedItemId\":\"appshark@2\",\"MuteValue\":\"true\"}';
            
        }
        string strReturn=''; //Holds the return message
        Integer isSuccessRes; //Holds the success status '1' or '0'
        list<user> lstUsers = new list<user>();
        string strUserName = '';
        string strPassword = '';
        string strFeedId = '';
        string strMuteValue = '';
        list<string> MutedFeeds = new list<string>();
        
        try{     
            UserWrapper deserializedUsr = (UserWrapper)JSON.deserializeStrict(strJSONBody, UserWrapper.class);//To get request body.
            
                strUserName = deserializedUsr.UserName;
                //strPassword = deserializedUsr.Password;
                strFeedId = deserializedUsr.FeedItemId; 
                strMuteValue = deserializedUsr.MuteValue; 
                                        
                        
            //TODO: Mute feedItem id update to User object
            string  strMutedList = '';
             lstUsers = [select id,muteFeeds__c from user where username =: strUserName];
            if(lstUsers != null && lstUsers.size()>0)
            {
                if(lstUsers[0].muteFeeds__c != null && lstUsers[0].muteFeeds__c != '')
                    strMutedList  = lstUsers[0].muteFeeds__c; 
                If (strMuteValue  == 'true')
                      strMutedList   = strMutedList + strFeedId + ',';
                else
                     strMutedList  = strMutedList.replace(strFeedId+ ',','' );  
                 lstUsers[0].muteFeeds__c   =strMutedList ;     
                 Update lstUsers; 
                 strReturn = 'Success.';
                 isSuccessRes = 1;   
            }
            else
            {
                 strReturn = 'Sorry, No user found';
                isSuccessRes = 0;
            }
                  
            //END: Mute feedItem id update to User object
            
        }
        catch(exception e) {strReturn = 'Sorry,Something went wrong.';system.debug('e.getMessage()=='+e.getMessage()); isSuccessRes = 0;}
                
                
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        system.debug('obj=='+obj);
        return obj; 
      }
      //Wrapper class to serialize response
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}
          //public list<string> MutedFeeds{get;set;}         
          public ResponseWrapper(integer isSuccess,String Message)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
              //this.MutedFeeds= MutedFeeds;
          }
      }
      
      // Wrapper class to deserialize Request body details.
    public class UserWrapper {
          string UserName;//LogedIn User
          //string Password;
          string FeedItemId;
          string MuteValue;       
          public UserWrapper(string strUname,string strFId,string strMValue)//string strPword ,
          {
              this.UserName = strUname; 
              //this.Password = strPword;
              this.FeedItemId = strFId;  
              this.MuteValue = strMValue;                      
          }
      }
      
       global class deserializeResponse {
        //public String id;
        public String access_token;
    }
   }