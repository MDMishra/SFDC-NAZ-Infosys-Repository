/*Author: Bharat*/
/*Description: Sending Users and Accounts related data of the logedin user and wholesaler account to the External system.
               These data used in Mobile app in task creation as user lookup and account lookup.*/
/*Created date: 7/10/2016*/
/*Modification History: 20/10/2016*/

@RestResource(urlMapping='/AB_UsersAndAccountsDetailsService/*')
global with sharing class AB_UsersAndAccountsDetailsService{
    
    @HttpPost //Method name
     
    global static ResponseWrapper AB_UsersAndAccountsDetailsService()
    {
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        string strJSONBody = '';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
        }
        else{
             AB_UsersAndAccountsDetailsService_Test testAB = new  AB_UsersAndAccountsDetailsService_Test();
             if(AB_UsersAndAccountsDetailsService_Test.Uname != null && AB_UsersAndAccountsDetailsService_Test.Uname != ''){
                 string str =  AB_UsersAndAccountsDetailsService_Test.Uname;
                 if(AB_UsersAndAccountsDetailsService_Test.AccId != null && AB_UsersAndAccountsDetailsService_Test.AccId != '')
                 {
                     string strAId = AB_UsersAndAccountsDetailsService_Test.AccId;
                     strJSONBody = '{\"username\":\"'+str+'\",\"accountid\":\"'+strAId+'\"}';
                 }
                 else
                 {
                     strJSONBody = '{\"username\":\"'+str+'\"}';
                 }
             }
        }
        list<AccListWrapper> listAccWrap = new list<AccListWrapper>();
        list<UserListWrapper> listUsrWrap = new list<UserListWrapper>();        
        integer isSuccess = 0;
        string Message = '';
        string strAccountId = '';
        try{
            UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
            if(deserializedUser.accountid != null)
                strAccountId = deserializedUser.accountid;
            list<user> logedinUser = new list<user>();
            if(deserializedUser.username != null && deserializedUser.username != ''){   
                logedinUser = [select id,name,UserName, Wholesaler_Number__c,WSLRNbrRouteNbr__c from user where username =: deserializedUser.username limit 1];//To get wholesaler Number of loged in user
            }
            list<Route_Schedule__c> RouteList = new list<Route_Schedule__c>();//Holds all accounts in route list
            list<user> WholesalerUsersList = new list<user>();
            if(logedinUser != null && logedinUser.size() != 0){
                //Query that holds all accounts in users route(to prepare account list)
                if(logedinUser[0].WSLRNbrRouteNbr__c != '' && logedinUser[0].WSLRNbrRouteNbr__c != null)
                    RouteList = [select Account__r.name,Account__c from Route_Schedule__c where Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c];
                //Query holds wholesaler account(to prepare user list)
                WholesalerUsersList = [select id,name,UserName from user where Wholesaler_Number__c =: logedinUser[0].Wholesaler_Number__c and IsActive = True order by name];
            }
            
            list<AccountTeamMember> LstPOCAccountUsers1 = new list<AccountTeamMember>();//holds usres related to the account
            list<account> acc = new list<account>();
            map<id,string> mapTeam = new map<id,string>();
            if(strAccountId != '' && strAccountId != null){// && strAccountId != WholesalerAccountList[0].id
                //query to get all team members of the POC account(to prepare user list)
                LstPOCAccountUsers1 = [select user.id,user.name, user.username from AccountTeamMember where AccountId=:strAccountId and user.IsActive=true order by user.name];
                
            }
            //start: Users data preperation
            if(LstPOCAccountUsers1 != null && LstPOCAccountUsers1.size() != 0 && strAccountId != ''){
                //if deserializedUser.accountid is not empty(data prep for POC account)
               for(AccountTeamMember objATM : LstPOCAccountUsers1){
                    if(mapTeam.get(objATM.user.id) == null)
                        mapTeam.put(objATM.user.id,objATM.user.UserName);
                    UserListWrapper objUWrap = new UserListWrapper();
                    objUWrap.Userid = objATM.user.id;
                    objUWrap.UserName = objATM.user.UserName;
                    objUWrap.Name = objATM.user.Name;
                    listUsrWrap.add(objUWrap);
                } 
            }
            
            else{
                //if deserializedUser.accountid is empty(data preperation for wholesaler account)
                if(WholesalerUsersList != null && WholesalerUsersList.size() != 0 && strAccountId == ''){ 
                    for(user objATM : WholesalerUsersList){
                        UserListWrapper objUWrap = new UserListWrapper();
                        objUWrap.Userid = objATM.id;
                        objUWrap.UserName = objATM.UserName;
                        objUWrap.Name = objATM.Name;
                        listUsrWrap.add(objUWrap);
                    }
                }
            }
            
            //End: Users data preperation
            
            //start: Account list preperation
            set<id> setAid = new set<id>();//holds all accountids in users route list
            if(RouteList != null && RouteList.size() != 0){
                for(Route_Schedule__c objRoute : RouteList){
                    if(objRoute.Account__c != null)
                        setAid.add(objRoute.Account__c);
                }
            }
            List<account> ListFinalAccounts = new List<account>();
            if(setAid != null){
                ListFinalAccounts = [select id, name from account where id in:setAid];
            }
            //End: Account list Preperation
            
            //start: Accounts data preperation
            if(ListFinalAccounts != null && ListFinalAccounts.size() != 0){
                for(Account objAcc : ListFinalAccounts){
                    AccListWrapper objAccWrap = new AccListWrapper();
                    if(objAcc.id != null)
                        objAccWrap.Accountid = objAcc.id;
                    else
                        objAccWrap.Accountid = '';
                    if(objAcc.name != null && objAcc.name != '')
                        objAccWrap.AccountName = objAcc.name;
                    else
                        objAccWrap.AccountName = '';
                    listAccWrap.add(objAccWrap);
                }
            }
            //End: Accounts data preperation
            //system.debug('listUsrWrap=='+listUsrWrap);    
            isSuccess = 1;
            Message = 'Success.';
        }
        catch(exception e) {Message = 'Sorry, Something went wrong.';system.debug('e.getMessage()=='+e.getMessage());System.debug('Exception e '+e.getLineNumber());isSuccess = 0;}
                
        ResponseWrapper obj = new ResponseWrapper(listUsrWrap,listAccWrap,isSuccess,Message);
        return obj;
    }
    
    global class ResponseWrapper
    {
        public list<UserListWrapper> listUsers{get;set;}
        public list<AccListWrapper> listAccounts{get;set;}
        public integer isSuccess{get;set;}
        public string Message{get;set;}
        public ResponseWrapper(list<UserListWrapper> listUsers,list<AccListWrapper> listAccounts,integer isSuccess,string Message)
        {
            this.listUsers = listUsers;
            this.listAccounts = listAccounts;
            this.isSuccess = isSuccess;
            this.Message = Message;
        }
    }
    //Wrapper class for User notes on feeditem objectName=ContentNotes
    public class UserListWrapper
    {
        string Userid;        
        string UserName;
        string Name;        
    }
    //Wrapper class holds account information
    public class AccListWrapper
    {
        string Accountid;              
        string AccountName;        
    }
    // Wrapper class to deserialize user details.
    public class UserDetailsWrapper 
    {
        string username; //holds the logedin username   
        string accountid;    
        public UserDetailsWrapper(string u,string aid)
        {
            this.username = u;  
            this.accountid = aid;                       
        }
    }
 }