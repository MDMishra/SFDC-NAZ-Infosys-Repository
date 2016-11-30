/*Author: Bharat*/
/*Description: Sending Account Details and its key decision maker contact details to the External system.*/
/*Created date: 29/8/2016*/
/*Modification History:30/9/2016*/
/*---------------------14/11/2016 Removed code related to Chatterfeeds data collection*/

@RestResource(urlMapping='/AB_AccountDetailsService/*')
global with sharing class AB_AccountDetailsService{
    
    @HttpPost //Method name
     // Sending Account Details and its key decision maker contact details to the External system.
     
    global static ResponseWrapper AB_AccountDetails_Service()
    {
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
         set<id> setid = new set<id>();
        string strJSONBody = '';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
            //system.debug('strJSONBody=='+strJSONBody);
        }
        else{
             AB_AccountDetails_Service_Test testAB = new  AB_AccountDetails_Service_Test();
             if(AB_AccountDetails_Service_Test.Uname != null && AB_AccountDetails_Service_Test.Uname != ''){
                 string str =  AB_AccountDetails_Service_Test.Uname;
                  
                 //system.debug('str=='+str);
                 if(AB_AccountDetails_Service_Test.AccId != null && AB_AccountDetails_Service_Test.AccId != '')
                 {
                     string strAId = AB_AccountDetails_Service_Test.AccId;
                     strJSONBody = '{\"username\":\"'+str+'\",\"accountid\":\"'+strAId+'\"}';
                 }
                 else
                 {
                     //strJSONBody = '{\"AccountId\":\"001f000000pKybg\"}';
                     strJSONBody = '{\"username\":\"'+str+'\"}';
                 }
             }
        }
        list<AccountTargetWrapper> deserializedSapScores = new list<AccountTargetWrapper>();//Sap Score Wrapper getting values for other class
        list<ProductImagesWrapper> deserializedProducts = new list<ProductImagesWrapper>();//Sap Score product images Wrapper getting values for other class
        string strReturn=''; //Holds the return message to be sent as response
        Integer isSuccessRes; //Holds success status '0' or '1'
        string HighPriorityCount ='';//Holds Count of priority messages
        integer GreenAccountsCount=0;//Holds Green Sap Color Accounts count
        integer YellowAccountsCount=0;//Holds Yellow Sap Color Accounts count
        integer RedAccountsCount=0;//Holds Red Sap Color Accounts count
        integer CertifiedAccounts=0;//Holds Green Sap Color Accounts count
        integer NonCertifiedAccounts=0;//Holds Green Sap Color Accounts count
        integer PriorityWholesalerTasks=0;//Holds Non Green Sap Color Accounts count
        integer NoPriorityWholesalerTasks =0;
        integer WlslrTodayTasksCount =0;
        integer WlslrOverDueTasksCount =0;
        string lowPriorityCount ='';//Holds count of no priority messages
        string WholesalerAccountId='';//Holds Wholesaler Account id
        string WholesalerAccountName='';//Holds Wholesaler Account name
        list<Account> listAccounts = new list<Account>();//initializing list of accounts
        list<account> ListOrderedAccounts = new list<account>();//Ordered accounts order by Route_Schedule__c.sequence__c
        list<string> aids = new list<string>();//list of poc Account ids
        list<string> SAPids = new list<string>();
        map<id,account> mapAcc = new map<id,account>();//Accountid and account records
        map<id,list<contact>> mapCon = new map<id,list<contact>>();//Accountid and contact records
        map<id,list<event>> mapEve = new map<id,list<event>>();//Accountid and event records
        map<id,list<Task>> mapAssignedTasks = new map<id,list<Task>>();
        list<string> PickListValues = new list<string>();//event.Out_of_Range_Reason__c picklist values
        list<string> lstTaskStatusOptions = new list<string>();//holds Task status picklist field options
        list<string> lstTaskCategoryOptions = new list<string>();//holds Task category picklist field options
        list<string> lstTaskPriorityOptions = new list<string>();//holds Task priority picklist field options
        list<string> lstCasePriorityOptions = new list<string>();//holds case priority picklist field options
        List<listWrapper> lstRecords = new List<listWrapper>();//Initializing Wrapper object list
        list<AssignedTasksWrapper> listWhlsalrAsgndTsks = new list<AssignedTasksWrapper>();
        string dataloaderDate = '';
        string strMailId = '';
                
        try{     
            UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
            list<user> logedinUser = new list<user>();
            if(deserializedUser.username != null && deserializedUser.username != ''){   
                logedinUser = [select id, Wholesaler_Number__c,WSLRNbrRouteNbr__c,Email from user where username =: deserializedUser.username limit 1];//To get wholesaler Number of loged in user
            }
            list<Route_Schedule__c> RouteList = new list<Route_Schedule__c>();//Holds Route List order by Sequence__c
            list<RouteCust__c> RouteCustList = new list<RouteCust__c>();//Holds RouteCust list
            if(logedinUser != null && logedinUser.size() != 0){ 
                RouteList = [select id,name,SeqNbr__c,Route__r.WSLRNbrRouteNbr__c, Account__r.name,Account__c from Route_Schedule__c where StopDate__c = today and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c order by SeqNbr__c];//'005f00000029fc3'                
                //query to get accounts related to RouteCust__c where WSLRNbrRouteNbr__c = logedinuser.WSLRNbrRouteNbr__c
                RouteCustList = [select id,WSLRNbrRouteNbr__c,Account__r.name,Account__c,Account__r.SAP_Color__c from RouteCust__c where WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c];
            }
                        
            if(RouteList != null && RouteList.size()!=0){
               
                for(Route_Schedule__c c:RouteList){
                    aids.add(c.Account__c);
                    
                }                
            }
            //to get accounts related to RouteCust__c
            if(RouteCustList != null && RouteCustList.size()!=0){
               
                for(RouteCust__c c:RouteCustList){                
                        SAPids.add(c.Account__c);
                        if(c.Account__r.SAP_Color__c != '' && c.Account__r.SAP_Color__c == 'Green')
                            CertifiedAccounts++;
                        if(c.Account__r.SAP_Color__c != '' && c.Account__r.SAP_Color__c == 'Red')
                            NonCertifiedAccounts++;
                                                   
                }
            }
            
            list<string> WholesalerAccIds = new list<string>();
            
            list<Account> WholesalerAccountList = new list<Account>();
            list<task> listWholesalerTasks = new list<task>();//Initialise list of tasks assigned to logedin user and Wholesaler account
            if(logedinUser != null && logedinUser.size() != 0) 
                //To get Wholesaler record   
                WholesalerAccountList = [select id,name, WSLR_NBR_US__c from account where WSLR_NBR_US__c =: logedinUser[0].Wholesaler_Number__c and recordtype.name = 'Wholesaler' limit 1];
                if(WholesalerAccountList != null && WholesalerAccountList.size() != 0){
                WholesalerAccountId = WholesalerAccountList[0].id;//Assigning wholesaler account id
                WholesalerAccountName = WholesalerAccountList[0].name;
                for(Account acc: WholesalerAccountList){
                    WholesalerAccIds.add(acc.id);                   
                }
                strMailId = logedinUser[0].Email;
            }  
            
            //Wholesaler tasks Data Preperation for logedin user starts=======================================================================
            
            //Query to get list of tasks for today
            list<task> listWSTask = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate = today and Ownerid =: logedinUser[0].id and status != 'Completed' order by priority desc];//whatid =: WholesalerAccountList[0].id
            WlslrTodayTasksCount = listWSTask.size();//Holds Todays tasks count
            //Query to get list of tasks not for today
            list<task> listWSTask2 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate != today and Ownerid =: logedinUser[0].id and status != 'Completed' order by activitydate desc];
            listWSTask.addAll(listWSTask2);
            //query to get tasks which are completed
            list<task> listWSTask3 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where Ownerid =: logedinUser[0].id and status = 'Completed' order by activitydate desc];
            listWSTask.addAll(listWSTask3);
                
            if(listWSTask != null && listWSTask.size() != 0){
                for(task objTsk: listWSTask){
                    if(objTsk.ActivityDate < date.today() && objTsk.Status != 'Completed')
                        WlslrOverDueTasksCount++;                   
                    if(objTsk.ActivityDate == date.today() && objTsk.Priority == 'High')
                        PriorityWholesalerTasks++;
                    if(objTsk.ActivityDate == date.today() && objTsk.Priority != 'High')
                        NoPriorityWholesalerTasks++;
                    AssignedTasksWrapper objTskWrap = new AssignedTasksWrapper();
                    objTskWrap = PrepareTaskData(objTsk);
                    listWhlsalrAsgndTsks.add(objTskWrap);
                }
            
            }
           
            //Wholesaler tasks Data Preperation for logedin user finish=======================================================================
            
            //Sap Score Wrapper construction=========================================================================================
            string strSapScoreJson = '';    
            ABS_SapScore newClass = new ABS_SapScore();// initiating ABS_SapScore class(external class). Which holds data of sap scores
            list<string> accIds = new list<string>();
            string strWholesalerId = '';
            
            if(WholesalerAccIds != null && WholesalerAccIds.size() != 0)
                strWholesalerId = WholesalerAccIds[0];
            accIds.add(strWholesalerId);//Passing Wholesaler account id
            if(SAPids != null)
                accIds.addAll(SAPids);//Passing Poc Account ids
            
            /*Sap score class calling and assingning return response to a string*/  
            if(accIds != null && !accIds.isEmpty())              
                strSapScoreJson = newClass.sapScore(accIds);
            
            list<AccountTargetWrapper> lstSapScores2 = new list<AccountTargetWrapper>();
            string[] strJsonList = strSapScoreJson.split('##Json#####');
            deserializedSapScores = (list<AccountTargetWrapper>)JSON.deserializeStrict(strJsonList[0], list<AccountTargetWrapper>.class);            
            deserializedProducts = (list<ProductImagesWrapper>)JSON.deserializeStrict(strJsonList[1], list<ProductImagesWrapper>.class);
            //system.debug('deserializedProducts =='+deserializedProducts );
            //Sap Score Wrapper construction Finish=========================================================================================            
            
            if(aids==null && aids.size()==0){
            //system.debug(aids);
                strReturn = 'Sorry, There are no records to display.';
                isSuccessRes = 0;
            }
            else{
              
                //Accounts, Contact, Event Wrappers construction==============================================================================
                 //Query to get list of accounts and its Key Decision maker(contact)
                listAccounts = [select id, Name ,SAP_Color__c, BillingCity ,BillingState,BillingPostalcode,BillingCountry,BillingStreet,Out_of_Range_Distance_for_POCs_Meters__c,Location__Latitude__s,Location__Longitude__s,Out_of_Range_Options_for_POCS__c,Wholesaler__c,Wholesaler__r.Out_of_Range_Options_for_POCS__c,Wholesaler__r.Out_of_Range_Distance_for_POCs_Meters__c,Size__c,Trade_Program_NM__c, (select id,Accountid,name,Title,email,Phone,MobilePhone,Office_Hours__c,Delivery_Hours__c from contacts where lboc_Key_Decision_Maker__c = true limit 1),(select id,whatid,Visit_in_Progress__c,Visit_Completed__c from Events where createddate = TODAY and owner.username =: deserializedUser.username limit 1),(select id,Subject, Ownerid, owner.name,Priority, whatid, account.name, status,ActivityDate from tasks where Owner.Username =: deserializedUser.username order by ActivityDate,priority desc) from account where id in: aids];
                list<task> listPocTask = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate = today and whatid in: aids and status != 'Completed' order by priority desc];// Ownerid =: logedinUser[0].id and
                //integer POCTodayTasks = listPocTask.size();//Holds Today tasks count fot poc accounts
                //query to get tasks which completed not today
                list<task> listPocTask2 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where activitydate != today and whatid in: aids and status != 'Completed' order by activitydate desc];// and Ownerid =: logedinUser[0].id
                listPocTask.addAll(listPocTask2);
                //query to get completed tasks of all due dates
                list<task> listPocTask3 = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where whatid in: aids and status = 'Completed' order by activitydate desc];// and Ownerid =: logedinUser[0].id
                listPocTask.addAll(listPocTask3);                
                
                for(task obj: listPocTask){
                    if(mapAssignedTasks.get(obj.whatid) == null){
                            list<task> lstTsk = new list<task>();
                            lstTsk.add(obj);
                            mapAssignedTasks.put(obj.whatid,lstTsk);
                             
                    }
                    else{
                        list<task> lstTsk = new list<task>();
                        lstTsk.addAll(mapAssignedTasks.get(obj.whatid));
                        lstTsk.add(obj);
                        mapAssignedTasks.put(obj.whatid,lstTsk); 
                    }
                }
                system.debug('listAccounts.size()====='+listAccounts.size());
                if(listAccounts != null && listAccounts.size() != 0){
                    for(account objAcnt:listAccounts){
                        mapAcc.put(objAcnt.id,objAcnt);
                        if(objAcnt.contacts!=null && objAcnt.contacts.size()!=0){
                            mapCon.put(objAcnt.id,objAcnt.contacts);
                        }
                        if(objAcnt.events!=null && objAcnt.events.size()!=0)
                            mapEve.put(objAcnt.id,objAcnt.events);
                        
                    }
                }
                if(RouteList != null && RouteList.size() != null){
                    for(Route_Schedule__c obj:RouteList){
                         if(mapAcc.get(obj.Account__c)!=null)
                             ListOrderedAccounts.add(mapAcc.get(obj.Account__c));   
                    }
                }
                if(ListOrderedAccounts != null && ListOrderedAccounts.size() != null){
                    for(account objA:ListOrderedAccounts){
                        if(objA.SAP_Color__c != null && objA.SAP_Color__c == 'Green'){
                            GreenAccountsCount++;
                        }
                        if(objA.SAP_Color__c != null && objA.SAP_Color__c == 'Yellow'){
                            YellowAccountsCount++;
                        }
                        if(objA.SAP_Color__c != null && objA.SAP_Color__c == 'Red'){
                            RedAccountsCount++;
                        }
                        listWrapper objWrap = new listWrapper();
                        objWrap.AccountRecord = PrepareAccountData(objA);
                        if(mapCon.get(objA.id)!=null){
                            for(contact objC:mapCon.get(objA.id)){                        
                                objWrap.ContactRecord= PrepareContactData(objC);
                            }
                        }
                        if(mapEve.get(objA.id)!=null){
                            for(event objE:mapEve.get(objA.id)){                       
                                //if(objEveWrap!=null)
                                objWrap.EventRecord = PrepareEventData(objE);
                            }
                        }
                        //Assigned tasks to the logedin user for each account
                        AssignedTasksWrapper objAssignedTaskWrap = new AssignedTasksWrapper();
        
                        integer HighPriorTasks =0;
                        integer NoPriorTasks =0;
                        integer POCTodayTasks =0;
                        integer POCOverDueTasks = 0;
                        if(mapAssignedTasks.get(objA.id) != null){
                            
                            for(Task objTsk: mapAssignedTasks.get(objA.id)){
                                if(objTsk.ActivityDate < date.today() && objTsk.status != 'Completed')
                                    POCOverDueTasks++;
                                if(objTsk.ActivityDate == date.today() && objTsk.status != 'Completed')
                                    POCTodayTasks++;
                                if(objTsk.ActivityDate == date.today() && objTsk.Priority == 'High')
                                    HighPriorTasks++;
                                    
                                if(objTsk.ActivityDate == date.today() && objTsk.Priority != 'High')
                                    NoPriorTasks++;
                                                                     
                                objAssignedTaskWrap = PrepareTaskData(objTsk);
                                if(objAssignedTaskWrap != null){
                                    if(objWrap.listAssignedTasks != null)
                                        objWrap.listAssignedTasks.add(objAssignedTaskWrap);
                                    else{
                                        objWrap.listAssignedTasks = new list<AssignedTasksWrapper>();
                                        objWrap.listAssignedTasks.add(objAssignedTaskWrap);
                                        }
                                }
                            }
                            
                        }
                        objWrap.PriorityAssignedTasks = HighPriorTasks;
                        objWrap.NoPriorityAssignedTasks = NoPriorTasks;
                        objWrap.POCTodayTasksCount = POCTodayTasks;
                        objWrap.POCOverDueTasksCount = POCOverDueTasks;
                        lstRecords.add(objWrap);                    
                    }
                }
                
                strReturn = 'Success. Account Records are queried successfully.';
                isSuccessRes = 1;
            }
            
            //to get values of event.Out_of_Range_Reason__c picklist field start.==========================================================     
            Schema.DescribeFieldResult fieldResult =
            event.Out_of_Range_Reason__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
            if(ple != null){
            for( Schema.PicklistEntry f : ple)
                {
                  PickListValues.add(string.valueOf(f.getLabel()));
                   system.debug(f.getLabel());
                }
            }      
            system.debug(PickListValues);
            //to get values of event.Out_of_Range_Reason__c picklist field finish.==========================================================
            
            
            //to get values of task.Status picklist field start.==========================================================     
            Schema.DescribeFieldResult StatusfieldResult =
            task.status.getDescribe();
            List<Schema.PicklistEntry> plev = StatusfieldResult.getPicklistValues();
                
            if(plev != null){
            for( Schema.PicklistEntry f : plev)
                {
                  lstTaskStatusOptions.add(string.valueOf(f.getLabel()));
                   system.debug(f.getLabel());
                }
            }      
            system.debug(lstTaskStatusOptions);
            //to get values of task.Status picklist field finish.==========================================================
            
            //to get values of task.Category__c picklist field start.==========================================================     
            Schema.DescribeFieldResult CategoryfieldResult =
            task.Category__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = CategoryfieldResult.getPicklistValues();
                
            if(ple2 != null){
            for( Schema.PicklistEntry f : ple2)
                {
                  lstTaskCategoryOptions.add(string.valueOf(f.getLabel()));
                   system.debug(f.getLabel());
                }
            }      
            system.debug(lstTaskCategoryOptions);
            //to get values of task.Category__c picklist field finish.======================
            
            //to get values of task.Priority picklist field start.==========================================================     
            Schema.DescribeFieldResult PriorityfieldResult =
            task.Priority.getDescribe();
            List<Schema.PicklistEntry> ple3 = PriorityfieldResult.getPicklistValues();
                
            if(ple3 != null){
            for( Schema.PicklistEntry f : ple3)
                {
                  lstTaskPriorityOptions.add(string.valueOf(f.getLabel()));
                   system.debug(f.getLabel());
                }
            }      
            system.debug(lstTaskPriorityOptions);
            //to get values of task.Priority picklist field finish.======================
            
            //Start: to get values of ONTAP__Case_Force__c.ONTAP__Priority__c picklist field start.==========================================================     
            Schema.DescribeFieldResult CasePriorityfieldResult =
            ONTAP__Case_Force__c.ONTAP__Priority__c.getDescribe();
            List<Schema.PicklistEntry> ple4 = CasePriorityfieldResult.getPicklistValues();
                
            if(ple4 != null){
            for( Schema.PicklistEntry f : ple4)
                {
                  lstCasePriorityOptions.add(string.valueOf(f.getLabel()));
                   system.debug(f.getLabel());
                }
            }      
            system.debug(lstCasePriorityOptions);
            //Stop: to get values of ONTAP__Case_Force__c.ONTAP__Priority__c picklist field finish.======================
            
            
            
            //start:last modified date of sap details
            US_Account_Target_Program__c dataloader=[Select LastModifiedDate from US_Account_Target_Program__c order By LastModifiedDate DESC Limit 1];
            if(dataloader != null)
            {
                string str = dataloader.LastModifiedDate.format('MM/dd/yyyy HH:mm', 
                 'America/New_York')+' EST';
                dataloaderDate = str;
            }
            //end:last modified date
            
            
                        
        }
        catch(exception e) {strReturn = 'Sorry,Something went wrong.';system.debug('e.getMessage()=='+e.getMessage());System.debug('Exception e '+e.getLineNumber());isSuccessRes = 0;}
         
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,strMailId,WholesalerAccountId,WholesalerAccountName, lstRecords,PickListValues,deserializedSapScores,deserializedProducts,GreenAccountsCount,YellowAccountsCount,RedAccountsCount,CertifiedAccounts,NonCertifiedAccounts,listWhlsalrAsgndTsks,lstTaskStatusOptions,lstTaskCategoryOptions,lstTaskPriorityOptions,lstCasePriorityOptions,PriorityWholesalerTasks,NoPriorityWholesalerTasks,WlslrTodayTasksCount,WlslrOverDueTasksCount,dataloaderDate);//Initialising the object for wrapper class. This object can be returned as response to the external system.//ListWholesalerChat,ListTaskFeeds,ListWholeComnt
        return obj;
        
    }
    
    /*
        Description : If Account field data is null , we are assigning to empty string
    */
    public static AccountDetailWrapper PrepareAccountData(account objA){
        AccountDetailWrapper objAccWrap = new AccountDetailWrapper();
        if(objA.id!=null){
            objAccWrap.id = objA.id;
        }
        
        if(objA.Name!=null){
            objAccWrap.Name = objA.Name;
        }
        
        if(objA.BillingCity!=null){
            objAccWrap.ShippingCity = objA.BillingCity;
        }
        else{
            objAccWrap.ShippingCity = '';
        }
        if(objA.BillingState!=null){
            objAccWrap.ShippingState = objA.BillingState;
        }
        else{
            objAccWrap.ShippingState = '';
        }
        if(objA.BillingPostalcode!=null){
            objAccWrap.ShippingPostalcode = objA.BillingPostalcode;
        }
        else{
            objAccWrap.ShippingPostalcode = '';
        }
        if(objA.BillingCountry!=null){
            objAccWrap.ShippingCountry = objA.BillingCountry;
        }
        else{
            objAccWrap.ShippingCountry = '';
        }
        //Shippingstreet concatenation starts
        string strStreet = '';
        string street='';
        if(objA.BillingStreet!='' && objA.BillingStreet!=null){
            strStreet = objA.BillingStreet;
            String[] streetA;                        
            if(strStreet.contains('\r\n')){
               streetA = strStreet.split('[\r\n]');
               for(string s:streetA){
                   street = street +' '+ s;
               }
               objAccWrap.ShippingStreet = street;
            }
            else{
                objAccWrap.ShippingStreet = objA.BillingStreet;
            }                       
        }
        else{
            objAccWrap.ShippingStreet= '';
        }                    
        //Shippingstreet concatenation ends
        
        if(objA.Location__Latitude__s !=null){
            objAccWrap.LocationLatitude = string.valueOf(objA.Location__Latitude__s);
        }
        else{
            objAccWrap.LocationLatitude = '';
        }
        if(objA.Location__Longitude__s !=null){
            objAccWrap.LocationLongitude = string.valueOf(objA.Location__Longitude__s);
        }
        else{
            objAccWrap.LocationLongitude = '';
        }
        if(objA.Size__c != null && objA.Size__c != ''){
            if(objA.Size__c == 'B1'||objA.Size__c == 'B2'||objA.Size__c == 'BP'){
                objAccWrap.Size = 'B';
            }
            else{
                objAccWrap.Size = objA.Size__c;
            }
        }
        else{
             objAccWrap.Size = '';
        }
        if(objA.Trade_Program_NM__c != null && objA.Trade_Program_NM__c != ''){
            if(objA.Trade_Program_NM__c == 'MACRO' || objA.Trade_Program_NM__c == 'Macro Pkg Liquor' || objA.Trade_Program_NM__c=='Macro C-Store' || objA.Trade_Program_NM__c=='Macro 3D'){//Size__c,Trade_Program_NM__c
                objAccWrap.TradeProgramNM = 'Macro';
            }
            else
                objAccWrap.TradeProgramNM = objA.Trade_Program_NM__c;
        }
        else{
            objAccWrap.TradeProgramNM = '';
        }
        
        if(objA.Wholesaler__c!=null){
            system.debug('objA.Name=='+objA.Name);
            if(objA.Wholesaler__r.Out_of_Range_Distance_for_POCs_Meters__c!=null)
                objAccWrap.OutOfRangeDistanceForPOCsMeters = string.valueOf(objA.Wholesaler__r.Out_of_Range_Distance_for_POCs_Meters__c);
            else
                objAccWrap.OutOfRangeDistanceForPOCsMeters = '';
            if(objA.Wholesaler__r.Out_of_Range_Options_for_POCS__c !=null)
                objAccWrap.OutOfRangeOptionsForPOCS = objA.Wholesaler__r.Out_of_Range_Options_for_POCS__c;
            else
                objAccWrap.OutOfRangeOptionsForPOCS = '';
        }
        else{
            if(objA.Out_of_Range_Distance_for_POCs_Meters__c!=null)
                objAccWrap.OutOfRangeDistanceForPOCsMeters = string.valueOf(objA.Out_of_Range_Distance_for_POCs_Meters__c);
            else
                objAccWrap.OutOfRangeDistanceForPOCsMeters = '';
            if(objA.Out_of_Range_Options_for_POCS__c != null)
                objAccWrap.OutOfRangeOptionsForPOCS = objA.Out_of_Range_Options_for_POCS__c;
            else
                objAccWrap.OutOfRangeOptionsForPOCS = '';
        }
        if(objA.SAP_Color__c != null){
            objAccWrap.SAPColor = objA.SAP_Color__c;
        }
        else
            objAccWrap.SAPColor = '';
        return objAccWrap;
    }
    public static ContactDetailWrapper PrepareContactData(contact objC){
        ContactDetailWrapper objConWrap = new ContactDetailWrapper();
        if(objC.id!=null){
            objConWrap.id = objC.id;
        }
        
        if(objC.Accountid!=null){
            objConWrap.Accountid = objC.Accountid;
        }
        
        if(objC.name!=null && objC.name!=''){
            objConWrap.name = objC.name;
        }
        
        if(objC.Title!=null && objC.Title!='')
            objConWrap.Title = objC.Title;
        else
            objConWrap.Title = '';
        if(objC.email!=null && objC.email!='')
            objConWrap.email = objC.email;
        else
            objConWrap.email = '';  
        if(objC.Phone!=null && objC.Phone!='')
            objConWrap.Phone = objC.Phone;
        else
            objConWrap.Phone = '';
        if(objC.MobilePhone!=null && objC.MobilePhone!='')
            objConWrap.MobilePhone = objC.MobilePhone;
        else
            objConWrap.MobilePhone = '';
        if(objC.Office_Hours__c!=null && objC.Office_Hours__c!='')
            objConWrap.OfficeHours = objC.Office_Hours__c;
        else
            objConWrap.OfficeHours = '';
        if(objC.Delivery_Hours__c!=null && objC.Delivery_Hours__c!='')
            objConWrap.DeliveryHours = objC.Delivery_Hours__c;
        else
            objConWrap.DeliveryHours = '';
        return objConWrap;
    }
    public static EventDetailWrapper PrepareEventData(Event objE){
        EventDetailWrapper objEveWrap = new EventDetailWrapper();
        if(objE.Visit_in_Progress__c!=null)
            objEveWrap.VisitinProgress = objE.Visit_in_Progress__c;
        
        if(objE.Visit_Completed__c !=null)
            objEveWrap.VisitCompleted = objE.Visit_Completed__c; 
        //if(objE.id !=null)
            objEveWrap.id = objE.id; 
        /*else
            objEveWrap.id = '';*/
        if(objE.Whatid !=null)
            objEveWrap.Accountid = objE.Whatid; 
        else
            objEveWrap.Accountid = '';     
        return objEveWrap;
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
        public string UserMailId{get;set;}//holds user mailid
        public string WholesalerAccountId {get;set;}//Holds Wholesaler accountid
        public string WholesalerAccountName {get;set;}//Holds Wholesaler account name
        public list<listWrapper> lstRecords {get;set;}                
        public list<string> lstReasonValues {get;set;} //event.Out_of_Range_Reason__c picklist values
        public list<AccountTargetWrapper> deserializedSapScores{get;set;}
        public list<ProductImagesWrapper> deserializedProducts{get;set;}
        public integer GreenAccountscount {get;set;}//Holds Sap Color Green count
        public integer YellowAccountscount {get;set;}//Holds Sap Color Yellow count
        public integer RedAccountscount {get;set;}//Holds Sap Color Red Count
        public integer CertifiedAccounts {get;set;}//holds green accounts count
        public integer NonCertifiedAccounts {get;set;}//holds non green accounts count
        public list<AssignedTasksWrapper> WholesalerTasks {get;set;}//holds Task records where whatid is Wholesaler account and assignedto loggedin user.
        public list<string> TaskStatusOptions {get;set;}//holds task's Status fields options
        public list<string> TaskCategoryOptions {get;set;}
        public list<string> TaskPriorityOptions {get;set;}
        public list<string> CasePriorityOptions {get;set;}
        public integer PriorityWholesalerTasks{get;set;}
        public integer NoPriorityWholesalerTasks{get;set;}
        public integer WlslrTodayTasksCount{get;set;}
        public integer WlslrOverDueTasksCount{get;set;}
        public string dataloaderDate{get;set;}
        
        public ResponseWrapper(integer isSuccess,String Message,string UserMailId,string WholesalerAccountId,string WholesalerAccountName,list<listWrapper> lstWrap,list<string> lstPicks,list<AccountTargetWrapper> deserializedSapScores,list<ProductImagesWrapper> deserializedProducts,integer GreenAccountscount,integer YellowAccountscount,integer RedAccountscount,integer CertifiedAccounts,integer NonCertifiedAccounts,list<AssignedTasksWrapper> WholesalerTasks,list<string> TaskStatusOptions,list<string> TaskCategoryOptions,list<string> TaskPriorityOptions,list<string> CasePriorityOptions,integer PriorityWholesalerTasks,integer NoPriorityWholesalerTasks,integer WlslrTodayTasksCount,integer WlslrOverDueTasksCount,string dataloaderDate)//list<WholesalerChatWrapper> ListWholesalerChat,list<WholesalerTaskWrapper> ListTaskFeeds,list<WholesalerCommentWrapper> ListWholeComnt
        {
            this.isSuccess =isSuccess;
            this.Message = Message;
            this.UserMailId = UserMailId;
            this.WholesalerAccountId = WholesalerAccountId;
            this.WholesalerAccountName = WholesalerAccountName;
            this.lstRecords = lstWrap;
            this.lstReasonValues = lstPicks;
            this.deserializedSapScores = deserializedSapScores;
            this.deserializedProducts = deserializedProducts;
            this.GreenAccountscount = GreenAccountscount;
            this.YellowAccountscount = YellowAccountscount;
            this.RedAccountscount = RedAccountscount;
            this.CertifiedAccounts = CertifiedAccounts;
            this.NonCertifiedAccounts = NonCertifiedAccounts;
            this.WholesalerTasks = WholesalerTasks;
            this.TaskStatusOptions = TaskStatusOptions;
            this.TaskCategoryOptions = TaskCategoryOptions;
            this.TaskPriorityOptions = TaskPriorityOptions;
            this.CasePriorityOptions = CasePriorityOptions;
            this.PriorityWholesalerTasks = PriorityWholesalerTasks;
            this.NoPriorityWholesalerTasks = NoPriorityWholesalerTasks;
            this.WlslrTodayTasksCount = WlslrTodayTasksCount;
            this.WlslrOverDueTasksCount = WlslrOverDueTasksCount;
            this.dataloaderDate = dataloaderDate;
            
        }
    }
    //Wrapper class to club all AccountFields,ContactFields, EventFields
    public class listWrapper
    {
        public AccountDetailWrapper AccountRecord;
        public ContactDetailWrapper ContactRecord;
        public EventDetailWrapper EventRecord;
        public list<AssignedTasksWrapper> listAssignedTasks;
        public integer PriorityAssignedTasks;
        public integer NoPriorityAssignedTasks;
        public integer POCTodayTasksCount;
        public integer POCOverDueTasksCount;
    }
    // Wrapper class to deserialize user details of account fields.     
    public class AccountDetailWrapper 
    {
        string id;
        string Name;
        string ShippingCity; 
        string ShippingState;
        string ShippingPostalcode;
        string ShippingCountry;
        string ShippingStreet;
        string OutOfRangeDistanceForPOCsMeters;
        string LocationLatitude;
        string LocationLongitude;
        string Size;
        string TradeProgramNM;
        string OutOfRangeOptionsForPOCS;
        string SAPColor;
    }
    // Wrapper class to deserialize user details of contact fields.     
    public class ContactDetailWrapper 
    {
        string id;
        string Accountid;
        string name;
        string Title; 
        string email;
        string Phone;
        string MobilePhone; 
        string OfficeHours;
        string DeliveryHours;
    }   
    // Wrapper class to deserialize user details of Event fields.     
    public class EventDetailWrapper 
    {
        string id;
        string Accountid;
        boolean VisitinProgress;
        boolean VisitCompleted;    
    }
            
    //wrapper class for task feeds
    public class WholesalerTaskWrapper
    {
        string subject;
        string whoid;
        string whatid;
        string ActivityDate;
        string CreatedByName;
        string CreatedByPhotoUrl;
        boolean isHighPriority;
        
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
    // Sap score wrapper class.
    public class AccountTargetWrapper
    {
       string id {get;set;}
       string Core {get;set;}
       string HighEnd {get;set;}
       string FMB {get;set;}
       string colorCore{get;set;}
       string colorHighEnd{get;set;}
       string colorFmb{get;set;}
       string pgmCore{get;set;}
       string pgmHighEnd{get;set;}
       string pgmFmb{get;set;}
       string AccountName{get;set;}
       string PremiseFlag{get;set;}
       string Channel{get;set;}
       string SAPChannel{get;set;}
       string SAPColor{get;set;}
       
       public AccountTargetWrapper(string id,string Core,string HighEnd,string FMB,string colorCore,string colorHighEnd,string colorFmb,string pgmCore,string pgmHighEnd,string pgmFmb,string AccountName,string PremiseFlag,string Channel,string SAPChannel,string SAPColor)//,list<US_Account_Target__c> usTargetRecords
       {
           this.id= id;
           this.Core= Core;
           this.HighEnd= HighEnd;
           this.FMB= FMB;
           this.colorCore= colorCore;
           this.colorHighEnd= colorHighEnd;
           this.colorFmb= colorFmb;
           this.pgmCore= pgmCore;
           this.pgmHighEnd= pgmHighEnd;
           this.pgmFmb= pgmFmb;
           this.AccountName = AccountName;
           this.PremiseFlag= PremiseFlag;
           this.Channel= Channel;
           this.SAPChannel= SAPChannel;
           this.SAPColor= SAPColor;          
       }
    }
    //Wrapper class for Products and their images
    public class ProductImagesWrapper 
       {
           string ProductImage{get;set;}
           string ProductName{get;set;}
           string BrandCategory{get;set;}
           string ColorCode{get;set;}
           string Accountid{get;set;}
           string BrandPackage{get;set;}
           public ProductImagesWrapper(string ProductImage,string ProductName,string BrandCategory,string ColorCode,string Accountid,string BrandPackage)
           {
               this.ProductImage = ProductImage;
               this.ProductName = ProductName;
               this.BrandCategory = BrandCategory;
               this.ColorCode = ColorCode;
               this.Accountid = Accountid;
               this.BrandPackage = BrandPackage;
           }
       }
    // Wrapper class to deserialize user details.
    public class UserDetailsWrapper 
    {
        string username; //holds the logedin username   
        string accountid;    
        public UserDetailsWrapper(string u,string accountid)
        {
            this.username = u;  
            this.accountid = accountid;                       
        }
    }
    
}