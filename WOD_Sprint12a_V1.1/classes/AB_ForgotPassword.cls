/*Author: Bharat*/
/*Description: Check for User Existance based on UserName from external system .
               Send Email to the users Email to reset password.
/*Created date: 23/8/2016*/
/*Modification History: */

@RestResource(urlMapping='/ForgotPassword/*')
   global with sharing class AB_ForgotPassword{
     @HttpPost //Method name
      global static ResponseWrapper AB_ForgotPassword(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        
        string JSONString = '';
        if(!test.isRunningTest()){
            JSONString = request.requestBody.toString();// Holds the request body
        }
        else{
            AB_ForgotPassword_Test testAB = new AB_ForgotPassword_Test();
            string strUsr = '';
            strUsr = AB_ForgotPassword_Test.Uname;                
            system.debug('strUsr=='+strUsr);               
            JSONString = '{\"username\":\"'+strUsr+'\"}';
        }
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        try{     
            UserDetailsWrapper deserializedUser = 
              (UserDetailsWrapper)JSON.deserializeStrict(JSONString, UserDetailsWrapper.class);//To deserialze request body.
            //system.debug('deserializedUser.uName=='+deserializedUser.username);
            
            //Query the user object to get the record having the user name in request body.
            list<user> u= new list<user>();
            u = [select id,UserName from user where UserName =: deserializedUser.username];// query to check the whether the user exists or not.
            //system.debug('u.size()=='+u.size());            
            if(u.size()!=0)
            { //if the user exists               
                id uId;
                uId=u[0].id;
                system.resetPassword(uId, true);
                strReturn='Success-Mail has been sent to your email.'; 
                if(strReturn != '')
                {
                isSuccessRes = 1; 
                }
            } 
            else
            { // if the user not exists
                integer i;
                strReturn='Error. Please check the username.'; 
                if(strReturn != '')
                {
                isSuccessRes = 0;
                }
            }
        }
          catch(exception e) {strReturn = 'Sorry, Something went wrong. Please check the Username.';system.debug('e.getMessage()=='+e.getMessage());isSuccessRes = 0;}
     
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
      public class UserDetailsWrapper {
          string username;       
          public UserDetailsWrapper(string strUsr)
          {
              this.username = strUsr;                         
          }
      }
   }