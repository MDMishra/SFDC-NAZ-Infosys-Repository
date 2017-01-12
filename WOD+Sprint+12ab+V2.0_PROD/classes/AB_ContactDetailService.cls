/*Author: Bharat*/
/*Description: Sending all conatcts of an account to IOS system.*/
/*Created date: 28/12/2016*/
/*Test class: AB_AccountDetailsService_Test*/
/*Modification History: */

@RestResource(urlMapping='/AB_ContactDetailService/*')
global with sharing class AB_ContactDetailService{
    
    @HttpPost //Method name
     // Sending Account Details and its key decision maker contact details to the External system.
     
    global static ResponseWrapper AB_ContactDetailService(string accountid)
    {
        
        string strReturn = '';//holds message to return
        integer isSuccessRes;//holds is true or false success response
        list<AB_AccountDetailsService2.ContactDetailWrapper> listContactWrap = new list<AB_AccountDetailsService2.ContactDetailWrapper>();//holds list of contacts  data
        try{ 
        
        //Start:getting all contacts of the account-----------------------------
        if(accountid != null){
            //query to get all contacts for accountid
            list<Contact> lstCons = [select id,accountid,Office_Hours__c,Delivery_Hours__c,name,firstname,lastname,phone,mobilephone,email,title from contact where accountid =: accountid]; 
            system.debug('lstCons=='+lstCons);
            if(lstCons != null && !lstCons.isEmpty()){
                for(contact objCon : lstCons){
                    AB_AccountDetailsService2.ContactDetailWrapper objConWrap = new AB_AccountDetailsService2.ContactDetailWrapper();
                    objConWrap = AB_AccountDetailsService2.PrepareContactData(objCon);//preparing contact data
                    
                    listContactWrap.add(objConWrap);
                }
            }
        }
        //End:getting all contacts of the account-------------------------------
       
        strReturn = 'Success';
        isSuccessRes = 1;                   
        }
         catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,listContactWrap);
        return obj;
    }
        
    //Wrapper class to serialize response
    global class ResponseWrapper
    {
        public integer isSuccess {get;set;}//Holds the success status 0 or 1
        public String Message {get;set;}//Holds the return message
        public list<AB_AccountDetailsService2.ContactDetailWrapper> ContactList{get;set;}//holds contacts 
        public ResponseWrapper(integer isSuccess,String Message,list<AB_AccountDetailsService2.ContactDetailWrapper> ContactList)//integer PriorityTasksCount,integer NoPriorityTasksCount,integer TodayTasksCount,integer OverDueTasksCount
        {
            this.isSuccess =isSuccess;
            this.Message = Message;
            this.ContactList = ContactList;
            
        }
    }
    
}