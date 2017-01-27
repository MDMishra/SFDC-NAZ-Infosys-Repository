/*Author: Bharat*/
/*Description: To save user selected dashboards in user detail from M360 app.*/
/*Created date: 23/01/2016*/
/*Test class: AB_UserDashboards_Service_Test*/
/*Modification History: */

@RestResource(urlMapping='/AB_UserDashboards_Service/*')
global with sharing class AB_UserDashboards_Service{
    
    @HttpPost //Method name
     
    global static ResponseWrapper AB_UserDashboards_Service(string username,boolean order)
    {
       
        string strReturn = '';//holds message to return
        integer isSuccessRes;//holds is true or false success response
        try{ 
        
            //Start:getting logedin user recortd-----------------------------
            if(username != null){
                //query to get user where user is logedin user
                list<user> logedinUsr = [select id,Ordering_interface__c from user where username =: username];
                 if(logedinUsr != null && !logedinUsr.isEmpty()){
                    logedinUsr[0].Ordering_interface__c = order;
                }
                update logedinUsr[0];
            }
            //End:getting logedin user recortd-------------------------------
           
            strReturn = 'Success';
            isSuccessRes = 1;                   
        }
        catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn);
        return obj;
    }
        
    //Wrapper class to serialize response
    global class ResponseWrapper
    {
        public integer isSuccess {get;set;}//Holds the success status 0 or 1
        public String Message {get;set;}//Holds the return message
        public ResponseWrapper(integer isSuccess,String Message)//integer PriorityTasksCount,integer NoPriorityTasksCount,integer TodayTasksCount,integer OverDueTasksCount
        {
            this.isSuccess =isSuccess;
            this.Message = Message;
        }
    }   
}