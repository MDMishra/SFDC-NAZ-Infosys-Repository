/*Author: Bharat*/
/*Description: Sending Muted feedIds of logied in user to the External system.*/
/*Created date: 06/10/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_MutedFeedsService/*')
   global with sharing class AB_MutedFeedsService{
       
     @HttpPost //Method name
     //Sending Muted Feedids of loged in user to the External system.
      global static ResponseWrapper AB_MutedFeedsService(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        string strJSONBody='';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
        }
        else{
            AB_MutedFeedsService_Test testAB = new AB_MutedFeedsService_Test();
             string str = AB_MutedFeedsService_Test.Uname;
            //system.debug('str=='+str);
            //strJSONBody = '{\"AccountId\":\"001f000000pKybg\"}';
            strJSONBody = '{\"UserName\":\"'+str+'\"}';
        }
        string strReturn=''; //Holds the return message
        Integer isSuccessRes; //Holds the success status '1' or '0'
        list<user> lstUsers = new list<user>();
        string strUserName = '';
        list<string> MutedFeeds = new list<string>();
        
        try{     
            UserWrapper deserializedUsr = (UserWrapper)JSON.deserializeStrict(strJSONBody, UserWrapper.class);//To get request body.
            //system.debug('deserializedUsr.UserName=='+deserializedUsr.UserName);
            if(deserializedUsr.UserName != null)
                strUserName = deserializedUsr.UserName;
            
            //Query to get AccountTeamMembers
            if(strUserName != '')
                lstUsers = [select id,muteFeeds__c from user where username =: strUserName];
            
            if(lstUsers.size()==0){
                strReturn = 'Sorry, There are records to display.';
                isSuccessRes = 0;
            }
            else{
                strReturn = 'Success.';
                isSuccessRes = 1;
                if(lstUsers[0].muteFeeds__c != null && lstUsers[0].muteFeeds__c != ''){
                    string str = lstUsers[0].muteFeeds__c;
                    if(str != ''){
                    	if(str.contains(',')){
                        	MutedFeeds = str.split(',');
                    	}
                    	else
                    		MutedFeeds.add(lstUsers[0].muteFeeds__c);
                    }
                }
            }
        }
        catch(exception e) {
                strReturn = 'Sorry,Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                
                isSuccessRes = 0;
        }
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn, MutedFeeds);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        system.debug('obj=='+obj);
        return obj; 
      }
      //Wrapper class to serialize response
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}
          public list<string> MutedFeeds{get;set;}         
          public ResponseWrapper(integer isSuccess,String Message,list<string> MutedFeeds)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
              this.MutedFeeds= MutedFeeds;
          }
      }
      
      // Wrapper class to deserialize Request body details.
      public class UserWrapper {
          string UserName;//LogedIn User       
          public UserWrapper(string str)
          {
              this.UserName = str;                         
          }
      }
   }