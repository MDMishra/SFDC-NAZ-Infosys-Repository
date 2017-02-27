//Author: Bharat
  //Description: To store today date in user when he ends the day from IOS
  //Created date: Feb 22/2016
  //Modification History: 

@RestResource(urlMapping='/AB_EndDayDate_Service/*')
    global with sharing class AB_EndDayDate_Service{
        
        @HttpPost //Method name
        //Check for User Authentication based on UserName and Password from external system 
        global static ResponseWrapper AB_EndDayDate_Service(string username,boolean isLogout){
            
            String strStatusMsg = '';//Holds the status message
            Integer isSuccessRes;//Holds the success response '1' or '0'
            list<user> LogedinUser = new list<user>();
            try{       
                LogedinUser = [select id,M360_EndDayDate__c,Temp_Route__c from user where username =: username];
                if(LogedinUser != null){
                    if(isLogout == true){
                        LogedinUser[0].Temp_Route__c = '';
                    }
                    else{
                        LogedinUser[0].M360_EndDayDate__c = system.today();
                        LogedinUser[0].Temp_Route__c = '';
                    }
                    update LogedinUser[0];
                    strStatusMsg = 'Success.';
                    isSuccessRes = 1;
                }
            }
            catch(exception e) {strStatusMsg = AB_M360.EventLog(e);isSuccessRes = 0;}
            //system.debug('isSuccessRes=='+isSuccessRes);
            ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strStatusMsg);//Initialising the object for wrapper class. This object returns response to the external system.
            system.debug('obj=='+obj);
             
            return obj;      
        }
        //Wrapper class to serialize response
        global class ResponseWrapper
        {
            public integer isSuccess {get;set;}//Holds success or failure status.
            public String Message {get;set;}//Status message to be sent as response             
            public ResponseWrapper(integer isSuccess,String Message)
            {
                this.isSuccess =isSuccess;
                this.Message = Message;
            }
        }
        
    }