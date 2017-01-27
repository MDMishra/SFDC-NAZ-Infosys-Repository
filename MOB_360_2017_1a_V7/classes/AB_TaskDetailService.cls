/*Author: Bharat*/
/*Description: Sending all Assigned tasks for account of loggedin user to IOS system.*/
/*Created date: 17/11/2016*/
/*Test class: AB_AccountDetailsService_Test*/
/*Modification History: 12/26/2016 -- added code to get data of list of contacts assigned to the account */

@RestResource(urlMapping='/AB_TaskDetailService/*')
global with sharing class AB_TaskDetailService{
    
    @HttpPost //Method name
     // Sending Account Details and its key decision maker contact details to the External system.
     
    global static ResponseWrapper AB_TaskDetail_Service()
    {
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
         set<id> setid = new set<id>();
        string strTskJSONBody = '';
        if(!test.isRunningTest()){
            strTskJSONBody = request.requestBody.toString();// Holds the request body
            //system.debug('strJSONBody=='+strJSONBody);
        }
        else{
            
             strTskJSONBody = AB_AccountDetailsService_Test.strTskJSONBody;
            
        }
        
        integer PriorityTasksCount =0;//Holds Non Green Sap Color Accounts count
        integer NoPriorityTasksCount =0;
        integer TodayTasksCount =0;
        integer OverDueTasksCount =0;
        list<AssignedTasksWrapper> listAsgndTsks = new list<AssignedTasksWrapper>();
        string strReturn = '';
        integer isSuccessRes;
        
        try{
        UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strTskJSONBody, UserDetailsWrapper.class);//To get request body.
        string strAccountId = deserializedUser.accountid;
        string strUid = deserializedUser.userid;
        string strAccountType = deserializedUser.accountType;
        
        list<task> listPocTask = new list<task>();
        list<task> listPocTask2 = new list<task>();
        list<task> listPocTask3 = new list<task>();
        
        
        
        if(deserializedUser.accountType != null && deserializedUser.accountType == 'POC'){
        //collection of Poc account tasks
        
             listPocTask = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate = today and whatid =: strAccountId and status != 'Completed' order by priority desc];// Ownerid =: logedinUser[0].id and
            //query to get tasks which completed not today
            listPocTask2 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate != today and whatid =: strAccountId and status != 'Completed' order by activitydate desc];// and Ownerid =: logedinUser[0].id
            listPocTask.addAll(listPocTask2);
            //query to get completed tasks of all due dates
            listPocTask3 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where whatid =: strAccountId and status = 'Completed' order by activitydate desc];// and Ownerid =: logedinUser[0].id
            listPocTask.addAll(listPocTask3); 
        } 
        if(deserializedUser.accountType != null && deserializedUser.accountType == 'Wholesaler'){
        //Collection of wholesaler tasks
        
            listPocTask = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate = today and Ownerid =: strUid and status != 'Completed' order by priority desc];//whatid =: WholesalerAccountList[0].id
            //Query to get list of tasks not for today
            listPocTask2 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate != today and Ownerid =: strUid and status != 'Completed' order by activitydate desc];
            listPocTask.addAll(listPocTask2);
            //query to get tasks which are completed
            listPocTask3 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where Ownerid =: strUid and status = 'Completed' order by activitydate desc];
            listPocTask.addAll(listPocTask3);

        }              
        
        AssignedTasksWrapper objAssignedTaskWrap = new AssignedTasksWrapper();
        for(task objTsk: listPocTask){                                
            objAssignedTaskWrap = PrepareTaskData(objTsk);
            if(objAssignedTaskWrap != null){
                listAsgndTsks.add(objAssignedTaskWrap);
            }
        }
        
        
        strReturn = 'Success';
        isSuccessRes = 1;                   
        }
         catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
         
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,listAsgndTsks);
        return obj;
    }
     /*Description: Task data preperation*/
    public static AssignedTasksWrapper PrepareTaskData(Task objTsk)
    {
        AssignedTasksWrapper objTsjWrp = new AssignedTasksWrapper();
        //if(objTsk.Status != null)
            objTsjWrp.Status = objTsk.Status;
        //else
            //objTsjWrp.Status = '';
        if(objTsk.ActivityDate != null){
            objTsjWrp.ActivityDate  = string.ValueOf(objTsk.ActivityDate).replace('-','/');
             
        }
        else
            objTsjWrp.ActivityDate  = '';
        if(objTsk.id != null)
            objTsjWrp.id = objTsk.id;
        
        if(objTsk.whatid != null)
            objTsjWrp.Accountid = objTsk.whatid;
        else
            objTsjWrp.Accountid = '';
        if(objTsk.Account.name != null)
            objTsjWrp.AccountName = objTsk.Account.name;
        else
            objTsjWrp.AccountName = '';
//if(objTsk.Subject != null)
            objTsjWrp.Subject = objTsk.Subject;
        //else
            //objTsjWrp.Subject = '';
        //if(objTsk.Priority != null)
            objTsjWrp.Priority = objTsk.Priority;
        //else
            //objTsjWrp.Priority = '';
        if(objTsk.Owner.name != null)
            objTsjWrp.AssignedTo = objTsk.Owner.name;
        else
            objTsjWrp.AssignedTo = '';
        if(objTsk.Description != null)
            objTsjWrp.Description = objTsk.Description;
        else
            objTsjWrp.Description = '';
        if(objTsk.Category__c != null)
            objTsjWrp.Category = objTsk.Category__c;
        else
            objTsjWrp.Category = '';
        return objTsjWrp;
    }
     //Wrapper class to serialize response
    global class ResponseWrapper
    {
        public integer isSuccess {get;set;}//Holds the success status 0 or 1
        public String Message {get;set;}//Holds the return message
        public list<AssignedTasksWrapper> AssignedTasksList {get;set;}//holds Task records where whatid is Wholesaler account and assignedto loggedin user.
        public ResponseWrapper(integer isSuccess,String Message,list<AssignedTasksWrapper> WholesalerTasks)//integer PriorityTasksCount,integer NoPriorityTasksCount,integer TodayTasksCount,integer OverDueTasksCount
        {
            this.isSuccess =isSuccess;
            this.Message = Message;
            this.AssignedTasksList = WholesalerTasks;
            
        }
    }
    //Tasks assigned to loggedin user Wrapper class
    public class AssignedTasksWrapper
    {
        string Status;
        string Accountid;
        string AccountName;
        string ActivityDate;
        string id;
        string Subject;
        string AssignedTo;
        string Priority;
        string Description;
        string Category;
    }
    
    // Wrapper class to deserialize user details.
    public class UserDetailsWrapper 
    {
        string userid; //holds the logedin username   
        string accountid; 
        string accountType;   
        public UserDetailsWrapper(string accountid,string u,string accountType)//,string accountid
        {
            this.userid = u;  
            this.accountid = accountid;  
            this.accountType = accountType;                    
        }
    }
}