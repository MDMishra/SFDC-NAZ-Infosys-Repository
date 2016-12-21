/*Author: Bharat*/
/*Description: Check for User Authentication based on UserName and Password from external system 
/*Created date: 23/8/2016*/
/*Modification history: */

@RestResource(urlMapping='/UserAuthentication/*')
    global with sharing class AB_UserAuthentication{
        
        @HttpPost //Method name
        //Check for User Authentication based on UserName and Password from external system 
        global static ResponseWrapper AB_UserAuthentication(){
            RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
            //system.debug('Name=='+request.requestBody.toString());
            
            string strJSONBody = '';
            if(!test.isRunningTest()){
                strJSONBody = request.requestBody.toString();
            }
            else{
                AB_UserAuthentication_Test testAB = new AB_UserAuthentication_Test();
                string strUsr = AB_UserAuthentication_Test.Uname;
                
                system.debug('strUsr=='+strUsr);
                strJSONBody = '{\"username\":\"'+strUsr+'\"}';//,'+'\"password\":\"'+strPwd+'\"
            }
            System.debug('strJSONBody::'+strJSONBody);
            String strStatusMsg = '';//Holds the status message
            //string imageEncoded ='';//Holds the encoded image string
            Integer isSuccessRes;//Holds the success response '1' or '0'
            string profileImageUrl = '';//Holds the User Profile pic url.
            string userFullName = '';//Holds the user name
            try{       
                UserDetailsWrapper deserializedUser = 
                (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//getting request body
                System.debug('deserializedUser::'+deserializedUser);
                
                //strStatusMsg = AB_UserVerification.checkUserCredentials(deserializedUser.username,deserializedUser.password);// To know the provided username and password are matched or not.                       
                                                
                //Query user to get PhotoUrl and FullName
                list<user> objUser = [select name,FullPhotoUrl,IsProfilePhotoActive from User where username =: deserializedUser.username limit 1];
                if(objUser != null && objUser.size() != 0){
                    profileImageUrl=objUser[0].FullPhotoUrl; 
                    userFullName = objUser[0].name; 
                    strStatusMsg = 'Success';
                }
                else
                    strStatusMsg = 'Sorry. There is no user found';
                system.debug(profileImageUrl);
                /*blob b = Blob.valueOf(profileImageUrl);//to encode the PhotoUrl.
                system.debug(EncodingUtil.base64Encode(b));
                imageEncoded = EncodingUtil.base64Encode(b);*/
                                           
                if(strStatusMsg == 'Success'){
                    isSuccessRes = 1;
                }
                else{
                    isSuccessRes = 0;
                }
            }
            catch(exception e) {strStatusMsg = 'Something went wrong.';isSuccessRes = 0;System.debug('exception::'+e.getMessage());}
                
            //system.debug('isSuccessRes=='+isSuccessRes);
            ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strStatusMsg , profileImageUrl, userFullName);//Initialising the object for wrapper class. This object can be returned as response to the external system.
            system.debug('obj=='+obj);
             
            return obj;      
        }
        //Wrapper class to serialize response
        global class ResponseWrapper
        {
            public integer isSuccess {get;set;}//Holds success or failure status.
            public String Message {get;set;}//Status message to be sent as response 
            public String PhotoUrl {get;set;}//user.FullPhotoUrl  
            public string FullName {get;set;}//user.fullname     
            public ResponseWrapper(integer isSuccess,String Message,string PhotoUrl,string FullName)
            {
                this.isSuccess =isSuccess;
                this.Message = Message;
                this.PhotoUrl = PhotoUrl;
                this.FullName = FullName;
            }
        }
        // Wrapper class to deserialize user details.
        public class UserDetailsWrapper 
        {
            public string username;
            //public string password;
        }
    }