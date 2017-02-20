/*Author: Bharat*/
/*Descrption: To remove Temp Route value on user*/
/*test class: AB_AccountDetailsService_Test*/

@RestResource(urlMapping='/AB_RemoveTempRoute/*')
    global with sharing class AB_RemoveTempRoute{
        
        @HttpPost //Method name
         
        global static ResponseWrapper AB_RemoveTempRoute(string username){
            if(username != null){
                list<user> Logedinuser = [select id,Temp_Route__c from user where username = :username];
                if(Logedinuser != null && !Logedinuser.isEmpty()){
                    if(Logedinuser[0].Temp_Route__c != null)
                        Logedinuser[0].Temp_Route__c = null;
                    update Logedinuser[0];
                }
            }
            ResponseWrapper obj = new ResponseWrapper('Success');
            return obj;
        }
        global class ResponseWrapper
        {
            public String Message {get;set;}//Status message to be sent as response 
            public ResponseWrapper(String Message)
            {
                this.Message = Message;
            }
        }
    }