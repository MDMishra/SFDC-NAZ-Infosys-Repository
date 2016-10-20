/*Author: Appshark*/
/*Description: Sending Account Details and its key decision maker contact details to the External system.*/
/*Created date: 29/8/2016*/
/*Modification History:30/9/2016 */

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
            system.debug('strJSONBody=='+strJSONBody);
        }
        else{
             AB_AccountDetails_Service_Test testAB = new  AB_AccountDetails_Service_Test();
             if(AB_AccountDetails_Service_Test.Uname != null && AB_AccountDetails_Service_Test.Uname != ''){
                 string str =  AB_AccountDetails_Service_Test.Uname;
                  
                 system.debug('str=='+str);
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
        string HighPriorityCount;//Holds Count of priority messages
        integer GreenAccountsCount=0;//Holds Green Sap Color Accounts count
        integer YellowAccountsCount=0;//Holds Yellow Sap Color Accounts count
        integer RedAccountsCount=0;//Holds Red Sap Color Accounts count
        integer PriorityWholesalerTasks=0;
        integer NoPriorityWholesalerTasks =0;
        integer WlslrTodayTasksCount =0;
        integer WlslrOverDueTasksCount =0;
        string lowPriorityCount;//Holds count of no priority messages
        string WholesalerAccountId;//Holds Wholesaler Account id
        string WholesalerAccountName;//Holds Wholesaler Account name
        list<Account> listAccounts = new list<Account>();//initializing list of accounts
        list<account> ListOrderedAccounts = new list<account>();//Ordered accounts order by Route_Schedule__c.sequence__c
        list<string> aids = new list<string>();//list of poc Account ids
        map<id,account> mapAcc = new map<id,account>();//Accountid and account records
        map<id,list<contact>> mapCon = new map<id,list<contact>>();//Accountid and contact records
        map<id,list<event>> mapEve = new map<id,list<event>>();//Accountid and event records
        map<id,list<Task>> mapAssignedTasks = new map<id,list<Task>>();
        list<FeedItem> listFeedItem = new list<FeedItem>();//initializing list of feedItem
        list<string> PickListValues = new list<string>();//event.Out_of_Range_Reason__c picklist values
        list<string> lstTaskStatusOptions = new list<string>();//Task
        list<string> lstTaskCategoryOptions = new list<string>();
        list<string> lstTaskPriorityOptions = new list<string>();
        List<listWrapper> lstRecords = new List<listWrapper>();//Initializing Wrapper object list
        list<listChatWrapper> ListChatRecords = new list<listChatWrapper>();//holds High priority feed items on the top of list and no priority feed items at last
        list<listChatWrapper> ListChatPriorityRecs = new list<listChatWrapper>();//holds High pririty feed items 
        list<listChatWrapper> ListChatNoPriorityRecs = new list<listChatWrapper>();//holds no priority feed items
        list<listChatWrapper> ListCommentRecs = new list<listChatWrapper>();//holds coment records
        list<UserNotesWrapper> listUserNotes = new list<UserNotesWrapper>();
        list<AssignedTasksWrapper> listWhlsalrAsgndTsks = new list<AssignedTasksWrapper>();
                
        try{     
            UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
            system.debug('deserializedUser.uName=='+deserializedUser.username);
            list<user> logedinUser = new list<user>();
            //list<Task> ListTasks = new list<Task>();
            if(deserializedUser.username != null && deserializedUser.username != ''){   
                logedinUser = [select id, Wholesaler_Number__c,WSLRNbrRouteNbr__c from user where username =: deserializedUser.username limit 1];//To get wholesaler Number of loged in user
                //ListTasks = [select id,Ownerid,owner.name,whatid,account.name,status from task where whatid != null and owner.username =: deserializedUser.username];
            }
            list<Route_Schedule__c> RouteList = new list<Route_Schedule__c>();//Holds Route List order by Sequence__c
            list<ContentNote> listContentNotes = new list<ContentNote>();
            if(logedinUser != null && logedinUser.size() != 0){ 
               // RouteList = [select id,name,Sequence__c, Account__r.name,Account__c from Route_Schedule__c where Schedule_Date__c = today and Sales_Rep__c =: logedinUser[0].id order by Sequence__c]; Old approach to get route list
                RouteList = [select id,name,SeqNbr__c,Route__r.WSLRNbrRouteNbr__c, Account__r.name,Account__c from Route_Schedule__c where StopDate__c = today and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c order by SeqNbr__c];//'005f00000029fc3'                
                listContentNotes = [select id, title,CreatedDate,TextPreview,ownerid,createdbyid from contentnote where createdbyid =: logedinUser[0].id];
            }
            //list<contentdocument> lstCon = [select id,parentid from contentdocument];
            //system.debug('lstCon=='+lstCon);
            
            if(RouteList != null && RouteList.size()!=0){
               
                for(Route_Schedule__c c:RouteList){
                    //if(!setid.Contains(c.Account__c)){
                        //setid.add(c.Account__c);
                        aids.add(c.Account__c);
                    //}
                     
                }
                system.debug('aids.size()=='+aids.size());
                system.debug('setid.size()=='+setid.size());
            }
            
            //Wholesaler chatterfeed details start 
            list<string> WholesalerAccIds = new list<string>();
            
            list<Account> WholesalerAccountList = new list<Account>();
            list<task> listWholesalerTasks = new list<task>();//Initialise list of tasks assigned to logedin user and Wholesaler account
            if(logedinUser != null && logedinUser.size() != 0) 
                //To get Wholesaler record   
                WholesalerAccountList = [select id,name, WSLR_NBR_US__c from account where WSLR_NBR_US__c =: logedinUser[0].Wholesaler_Number__c and recordtype.name = 'Wholesaler' limit 1];
                if(WholesalerAccountList != null && WholesalerAccountList.size() != 0){
                WholesalerAccountId = WholesalerAccountList[0].id;//Assigning wholesaler account id
                WholesalerAccountName = WholesalerAccountList[0].name;
                //Query to get Tasks assigned to Logedin user and whatid is wholesaler id
                //listWholesalerTasks = [select id,subject,Description, owner.name, whatid, account.name, status,ActivityDate,Priority,Ownerid from task where Owner.Username =: deserializedUser.username and whatid =: WholesalerAccountList[0].id order by ActivityDate asc];
                for(Account acc: WholesalerAccountList){
                    WholesalerAccIds.add(acc.id);                   
                }
            }  
            
            //Wholesaler tasks Data Preperation for logedin user starts=======================================================================
            /*Old Approach
            if(listWholesalerTasks != null && listWholesalerTasks.size() != 0){
                for(task objTsk: listWholesalerTasks){
                    if(objTsk.ActivityDate == date.today() && objTsk.Priority == 'High')
                        PriorityWholesalerTasks++;
                    if(objTsk.ActivityDate == date.today() && objTsk.Priority != 'High')
                        NoPriorityWholesalerTasks++;
                    AssignedTasksWrapper objTskWrap = new AssignedTasksWrapper();
                    objTskWrap = PrepareTaskData(objTsk);
                    listWhlsalrAsgndTsks.add(objTskWrap);
                }
            
            }*/
            //new approach
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
            
            if(aids==null && aids.size()==0){
            system.debug(aids);
                strReturn = 'Sorry, There are no records to display.';
                isSuccessRes = 0;
            }
            else{
            
                //Sap Score Wrapper construction=========================================================================================
                
                ABS_SapScore newClass = new ABS_SapScore();// initiating ABS_SapScore class(external class). Which holds data of sap scores
                list<string> accIds = new list<string>();
                string strWholesalerId = '';
                
                if(WholesalerAccIds != null && WholesalerAccIds.size() != 0)
                    strWholesalerId = WholesalerAccIds[0];
                accIds.add(strWholesalerId);//Passing Wholesaler account id
                accIds.addAll(aids);//Passing Poc Account ids
                
                /*Sap score class calling and assingning return response to a string*/                
                string strSapScoreJson = newClass.sapScore(accIds);
                
                list<AccountTargetWrapper> lstSapScores2 = new list<AccountTargetWrapper>();
                system.debug('accIds=='+accIds);
                system.debug('strSapScoreJson=='+strSapScoreJson);
                string[] strJsonList = strSapScoreJson.split('##Json#####');
                deserializedSapScores = (list<AccountTargetWrapper>)JSON.deserializeStrict(strJsonList[0], list<AccountTargetWrapper>.class);
                system.debug('deserializedSapScores=='+deserializedSapScores);
                
                deserializedProducts = (list<ProductImagesWrapper>)JSON.deserializeStrict(strJsonList[1], list<ProductImagesWrapper>.class);
                system.debug('deserializedProducts =='+deserializedProducts );
                //Sap Score Wrapper construction Finish=========================================================================================
               
                
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
                system.debug('listAccounts====='+listAccounts);
                if(listAccounts != null && listAccounts.size() != 0){
                    for(account objAcnt:listAccounts){
                        system.debug(objAcnt.name);
                        system.debug(objAcnt.contacts);
                        system.debug(objAcnt.Events);
                        mapAcc.put(objAcnt.id,objAcnt);
                        if(objAcnt.contacts!=null && objAcnt.contacts.size()!=0){
                            system.debug('objAcnt.events=='+objAcnt.events);
                            system.debug('objAcnt.contacts=='+objAcnt.contacts);
                            mapCon.put(objAcnt.id,objAcnt.contacts);
                        }
                        if(objAcnt.events!=null && objAcnt.events.size()!=0)
                            mapEve.put(objAcnt.id,objAcnt.events);
                        /*if(mapAssignedTasks.get(objAcnt.id) == null && objAcnt.Tasks!=null && objAcnt.Tasks.size()!=0){
                            
                            mapAssignedTasks.put(objAcnt.id,objAcnt.Tasks);
                             
                        }*/
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
                
            if(plev != null){
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
                
            if(plev != null){
            for( Schema.PicklistEntry f : ple3)
                {
                  lstTaskPriorityOptions.add(string.valueOf(f.getLabel()));
                   system.debug(f.getLabel());
                }
            }      
            system.debug(lstTaskPriorityOptions);
            //to get values of task.Priority picklist field finish.======================
            
            //ContentNotes Data Preperation starts==========================================================================================
            
            if(listContentNotes != null){
                system.debug('listContentNotes=='+listContentNotes);
                for(contentnote objNote : listContentNotes){
                    UserNotesWrapper objUsrNteWrap = new UserNotesWrapper();
                    objUsrNteWrap = PrepareNoteData(objNote);
                    listUserNotes.add(objUsrNteWrap);
                }
            }
            //ContentNotes Data Preperation ends==========================================================================================
            
            system.debug('WholesalerAccIds=='+WholesalerAccIds); 
            if(deserializedUser.accountid != null && deserializedUser.accountid != '') 
                listFeedItem = [SELECT id,parentid,CreatedDate,createdById, CreatedBy.Name, Body,CommentCount,likecount,LinkUrl,Type,Title,RelatedRecordId,HasContent,ContentType,ContentSize, (SELECT feeditemid,CommentBody, CreatedDate, CreatedBy.Name FROM FeedComments ORDER BY CreatedDate asc),(SELECT feeditemid, CreatedDate, CreatedBy.Name FROM FeedLikes ORDER BY CreatedDate asc) FROM FeedItem where type != 'TrackedChange' and parentid =: deserializedUser.accountid order by CreatedDate desc];            
            else{
                if(WholesalerAccIds != null)    
                    listFeedItem = [SELECT id,parentid,CreatedDate,createdById, CreatedBy.Name, Body,CommentCount,likecount,LinkUrl,Type,Title,RelatedRecordId,HasContent,ContentType,ContentSize, (SELECT feeditemid,CommentBody, CreatedDate, CreatedBy.Name FROM FeedComments ORDER BY CreatedDate asc),(SELECT feeditemid, CreatedDate, CreatedBy.Name FROM FeedLikes ORDER BY CreatedDate asc) FROM FeedItem where type != 'TrackedChange' and parentid in : WholesalerAccIds order by CreatedDate desc];            
            }
            //map<id,list<FeedComment>> mapFeedComments = new map<id,list<FeedComment>>();//holds feed id and list of feed comments
            map<id,string> mapFeedUserPhoto = new map<id,string>();//holds feed.createdbyId and user fullphotourl
            //map<id,string> mapContentFileData = new map<id,string>();//holds == not in use
            map<id,string> mapContentFileUrl = new map<id,string>();//holds Contentent version id and url of the contentPost
            map<id,ContentVersion> mapContentVersion = new map<id,ContentVersion>();//holds contentversion data
            map<id,task> mapTaskFeeds = new map<id,task>();// holds feedid and list of tasks
            set<id> uId = new set<id>();
            set<id> RelRecId = new set<id>();//Holds Content Version ids
            set<id> setTaskIds = new set<id>();
            
            
            //blob bodyBlob1;
            system.debug('listFeedItem=='+listFeedItem);
            if(listFeedItem != null && listFeedItem.size() != 0){
                for(FeedItem objFeed:listFeedItem){
                    //system.debug('objFeed.contentdata=='+EncodingUtil.base64Encode(objFeed.contentdata));
                    //system.debug('objFeed.contentdata=='+objFeed.contentdata);
                    if(objFeed.createdById!=null)
                        uId.add(objFeed.createdById);
                    if(objFeed.RelatedRecordId!=null)
                        RelRecId.add(objFeed.RelatedRecordId); 
                    string strId = objFeed.parentid;
                    if(objFeed.parentid != null && strId.startsWithIgnoreCase('00T')){
                        //system.debug('objFeed.parentid=='+objFeed.parentid);
                        //mapTaskFeeds.put(objFeed.parentid);
                        setTaskIds.add(objFeed.parentid); 
                    //system.debug('objFeed.body()=='+objFeed.body());
                    if(objFeed.FeedComments !=null && objFeed.FeedComments.size()!=0){
                        for(FeedComment objComnt : objFeed.FeedComments){
                            if(objComnt.CreatedById!=null){
                                uId.add(objComnt.CreatedById);
                            }
                        }   
                    }
                    if(objFeed.FeedLikes !=null && objFeed.FeedLikes.size()!=0){
                        for(FeedLike objLike : objFeed.FeedLikes){
                            if(objLike.CreatedById!=null){
                                uId.add(objLike.CreatedById);
                            }
                        }   
                    }
                    
                    }
                }
            }
            system.debug('setTaskIds=='+setTaskIds);
            list<task> listFeedTasks = new list<task>();
            if(setTaskIds!=null)
                listFeedTasks = [select id,subject,whoid,whatid,activitydate,status from task where id in:setTaskIds];
            for(task objT:listFeedTasks){
                mapTaskFeeds.put(objT.id,objT);
            }
            list<user> ListuserUrls = new list<user>();
            if(uId != null)
                ListuserUrls = [select id, fullphotourl from user where id in:uId];
            if(ListuserUrls != null && ListuserUrls.size() != 0){
                for(user u:ListuserUrls){
                    if(u.fullphotourl != null)
                        mapFeedUserPhoto.put(u.id,u.fullphotourl);
                        //system.debug('mapFeedUserPhoto='+mapFeedUserPhoto);
                }
            }
            system.debug('RelRecId=='+RelRecId);
            list<contentversion> ListContentFileUrls = new list<contentversion>();//Content versions of feed items
            list<ContentDistribution> listContentDistribution = new list<ContentDistribution>();// this list contains url of the content files and images of feeditem
            if(RelRecId != null){
                ListContentFileUrls = [select id, VersionData,FileExtension,contentdocumentid,versionnumber,TextPreview from contentversion where id in:RelRecId];
                listContentDistribution = [select id, DistributionPublicUrl, contentversionid from ContentDistribution where contentversionid in:RelRecId];
            }
            system.debug('listContentDistribution=='+listContentDistribution);
            if(listContentDistribution != null && listContentDistribution.size() != 0){
                for(ContentDistribution objDistr:listContentDistribution){
                    //system.debug('objDistr.DistributionPublicUrl=='+objDistr.DistributionPublicUrl);
                    if(objDistr.contentversionid != null && objDistr.DistributionPublicUrl != null){
                        mapContentFileUrl.put(objDistr.contentversionid,objDistr.DistributionPublicUrl);
                    }
                }
            }
            //system.debug('mapContentFileUrl=='+mapContentFileUrl);
            //system.debug('ListContentFileUrls=='+ListContentFileUrls);
            if(ListContentFileUrls != null && ListContentFileUrls.size() != null){
                for(contentversion file:ListContentFileUrls){
                    system.debug('file.TextPreview=='+file.TextPreview);
                    if(file.versiondata != null)                         
                        mapContentVersion.put(file.id,file);                  
                }
            }
            
            //system.debug('listFeedItem =='+listFeedItem.size() );
            integer PriorityCount = 0;
            integer NoPriorityCount = 0;
            //integer i = 0;//to know size of contestpost feeds
            string strJsonMute;
            integer ii = 0;//holds count of http callouts
            if(listFeedItem != null && listFeedItem.size() != 0){
                for(FeedItem objFeed:listFeedItem){
                    
                    listChatWrapper objChatWrap = new listChatWrapper();
                    listChatWrapper objChatWrapPriority = new listChatWrapper();
                    listChatWrapper objChatWrapNoPriority = new listChatWrapper();
                    WholesalerChatWrapper objWchatWrap = new WholesalerChatWrapper();//Wrapper instance for wholesaleChatter                
                    
                    //strJsonMute = isFeedMuted(objFeed.Id);
                    /*string strJsonMute2 = '';
                    if(ii<100){
                        ii++; //increments when http callout happened
                        if(!test.isRunningTest()){
                            strJsonMute2 = isFeedMutedsss(objFeed.Id);//method that results whether the feed is muted or not
                            isMuteResponseWrapper muteResponse = (isMuteResponseWrapper )JSON.deserializeStrict(strJsonMute2, isMuteResponseWrapper.class);//deserializing mute response
                            objWchatWrap.isMute=muteResponse.isMutedByMe;
                        }             
                        else{*/
                            objWchatWrap.isMute= 'true';                            
                        //}
                        
                    //}
                    System.debug(objFeed);
                    if(objFeed.type != null && (objFeed.type == 'TextPost' || objFeed.type == 'LinkPost' ||  objFeed.type == 'ContentPost'))
                    {
                        if(objFeed.id!=null)
                            objWchatWrap.id = string.valueOf(objFeed.id);
                        else
                            objWchatWrap.id = '';          
                        if(objFeed.CreatedDate!=null)
                            objWchatWrap.CreatedDate = string.valueOf(objFeed.CreatedDate);
                        else
                            objWchatWrap.CreatedDate = '';
                        if(objFeed.CreatedBy.Name!=null)
                            objWchatWrap.CreatedByName = objFeed.CreatedBy.Name;
                        else
                            objWchatWrap.CreatedByName = '';
                        if(objFeed.Body!=null)
                            objWchatWrap.Body = objFeed.Body;
                        else
                            objWchatWrap.Body= '';
                        if(objFeed.createdById!=null){
                            if(mapFeedUserPhoto.get(objFeed.createdById) != null)
                                objWchatWrap.CreatedByPhotoUrl = mapFeedUserPhoto.get(objFeed.createdById);
                        }
                        else
                            objWchatWrap.CreatedByPhotoUrl = '';
                        if(objFeed.linkurl!=null){
                            objWchatWrap.linkUrl = objFeed.linkurl;
                        }
                        else
                            objWchatWrap.linkUrl = '';  
                        if(objFeed.type!=null){//types: TrackedChange,TextPost,CreateRecordEvent,ContentPost,LinkPost
                            objWchatWrap.FeeditemType = objFeed.type;
                        }
                        else
                            objWchatWrap.FeeditemType = ''; 
                        if(objFeed.title!=null){
                            objWchatWrap.FileTitle = objFeed.title;
                        }
                        else
                            objWchatWrap.FileTitle = '';
                        if(objFeed.likeCount!=null){
                            objWchatWrap.likeCount= string.valueOf(objFeed.likeCount);
                        }
                        else
                            objWchatWrap.likeCount= '';
                        if(objFeed.commentCount!=null){
                            objWchatWrap.commentCount= string.valueOf(objFeed.commentCount);
                        }
                        else
                            objWchatWrap.commentCount= '';
                        if(objFeed.RelatedRecordId!=null){
                            
                            if(mapContentFileUrl.get(objFeed.RelatedRecordId) != null) {
                                //system.debug('URL is*****=='+mapContentFileUrl.get(objFeed.RelatedRecordId));
                                objWchatWrap.ContentFile = mapContentFileUrl.get(objFeed.RelatedRecordId);
                            }
                            if(mapContentVersion.get(objFeed.RelatedRecordId) != null && mapContentVersion.get(objFeed.RelatedRecordId).ContentDocumentId != null)
                            {
                                //system.debug('objFeed.id========================================'+objFeed.id);
                                string strURL = 'https://naz--nazsapapp1.cs16.my.salesforce.com/services/data/v37.0/connect/files/'+mapContentVersion.get(objFeed.RelatedRecordId).ContentDocumentId+'/content?versionNumber='+mapContentVersion.get(objFeed.RelatedRecordId).versionNumber;
                                objWchatWrap.ContentFile = strURL;
                            }
                            else
                                objWchatWrap.ContentFile = 'No Content'; 
                        }
                        else{
                            //objWchatWrap.FileExtension = '';
                            objWchatWrap.ContentFile = 'No Content'; 
                        }
                        
                        objWchatWrap.isImage = false;
                        if(objFeed.ContentType!=null){
                            objWchatWrap.FileExtension = objFeed.ContentType;
                            if(objFeed.ContentType!=null && objFeed.ContentType.toLowerCase().contains('image')){
                                //system.debug('Heree is image+++++++++++++++');
                                objWchatWrap.isImage = true;                                  
                            }
                            else{
                                objWchatWrap.isImage = false;
                            }
                        }
                        else{                            
                            objWchatWrap.FileExtension = '';
                        }
                        if(objWchatWrap.body.toLowerCase().contains('#priority'))
                        {
                            objWchatWrap.isHighPriority = true;
                            //system.debug('objWchatWrap.body====**##'+objWchatWrap.body);
                            objChatWrapPriority.FeedItemRecord = objWchatWrap;                       
                            PriorityCount++;                        
                        }
                        else{
                            objWchatWrap.isHighPriority = false;
                            objChatWrapNoPriority.FeedItemRecord = objWchatWrap;
                            NoPriorityCount++;                        
                        }
                                          
                    }
                    if(objFeed.type != null && objFeed.type == 'CreateRecordEvent'){
                        WholesalerTaskWrapper objTaskWrap = new WholesalerTaskWrapper();
                        //system.debug('objFeed.type=='+objFeed.type);
                        system.debug('objFeed.body=='+objFeed.body);
                        string strTask = objFeed.parentid;
                        if(objFeed.parentid != null && strTask.startsWithIgnoreCase('00T')){
                            if(mapTaskFeeds.get(objFeed.parentId) != null)
                            {
                                if(mapTaskFeeds.get(objFeed.parentId).subject != null)
                                    objTaskWrap.subject = mapTaskFeeds.get(objFeed.parentId).subject;
                                else
                                    objTaskWrap.subject = '';
                                if(mapTaskFeeds.get(objFeed.parentId).whoid != null)
                                    objTaskWrap.whoid = mapTaskFeeds.get(objFeed.parentId).whoid;
                                else
                                    objTaskWrap.whoid = '';
                                if(mapTaskFeeds.get(objFeed.parentId).whatid != null)
                                    objTaskWrap.whatid = mapTaskFeeds.get(objFeed.parentId).whatid;
                                else
                                    objTaskWrap.whatid = '';
                                if(mapTaskFeeds.get(objFeed.parentId).ActivityDate!= null)
                                    objTaskWrap.ActivityDate = string.valueOf(mapTaskFeeds.get(objFeed.parentId).ActivityDate);
                                else
                                    objTaskWrap.ActivityDate = '';                            
                            }
                            if(objFeed.createdById!=null){
                                if(mapFeedUserPhoto.get(objFeed.createdById) != null)
                                    objTaskWrap.CreatedByPhotoUrl = mapFeedUserPhoto.get(objFeed.createdById);
                            }
                            else
                                objTaskWrap.CreatedByPhotoUrl = '';
                            if(objFeed.CreatedBy.Name!=null)
                                objTaskWrap.CreatedByName = objFeed.CreatedBy.Name;
                            else
                                objTaskWrap.CreatedByName = '';
                                
                            if(objWchatWrap.body!=null && objWchatWrap.body.toLowerCase().contains('#priority'))
                            {
                                objTaskWrap.isHighPriority = true;
                                //system.debug('objWchatWrap.body====**##'+objWchatWrap.body);
                                objChatWrapPriority.TaskFeedRecord = objTaskWrap;
                                PriorityCount++;                          
                            }
                            else{
                                objTaskWrap.isHighPriority = false;
                                objChatWrapNoPriority.TaskFeedRecord = objTaskWrap;
                                NoPriorityCount++;                           
                            }
                            //objChatWrap.TaskFeedRecord = objTaskWrap;
                            //ListTaskFeeds.add(objTaskWrap);
                            //system.debug('ListTaskFeeds=='+ListTaskFeeds);
                        }
                        
                    }
                    if(objFeed.CommentCount!=0){
                        system.debug('objFeed.feedComments=='+objFeed.feedComments.size());
                        for(FeedComment objComment : objFeed.feedComments){
                            WholesalerCommentWrapper objWComntWrap = new WholesalerCommentWrapper();//Wrapper instance for wholesaleChatter Comment
                            if(objComment.feeditemid != null)
                                objWComntWrap.FeedItemId = objComment.feeditemid;
                            else
                                 objWComntWrap.FeedItemId = '';    
                            if(objComment.commentBody != null)
                                objWComntWrap.CommentBody = objComment.commentBody;
                            else
                                 objWComntWrap.CommentBody = ''; 
                            if(objComment.CreatedById != null){
                                if(mapFeedUserPhoto.get(objComment.createdById)!=null)
                                    objWComntWrap.CreatedByUserPhotoUrl = mapFeedUserPhoto.get(objComment.createdById);
                            }        
                            else
                                 objWComntWrap.CreatedByUserPhotoUrl = ''; 
                            if(objComment.CreatedBy.name != null)
                                objWComntWrap.CommentCreatedByName= objComment.CreatedBy.name;
                            else
                                 objWComntWrap.CommentCreatedByName= '';
                            if(objComment.CreatedDate != null)
                                objWComntWrap.CommentCreatedDate= string.valueOf(objComment.CreatedDate);
                            else
                                 objWComntWrap.CommentCreatedDate= '';
                            //ListWholeComnt.add(objWComntWrap);CommentCreatedByName
                            
                            if(objChatWrapNoPriority.CommentRecords !=null)
                               objChatWrapNoPriority.CommentRecords.add(objWComntWrap);
                            else{
                               objChatWrapNoPriority.CommentRecords = new list<WholesalerCommentWrapper>();
                               objChatWrapNoPriority.CommentRecords.add(objWComntWrap);
                            }
                            if(objChatWrapPriority.CommentRecords !=null)
                               objChatWrapPriority.CommentRecords.add(objWComntWrap);
                            else{
                               objChatWrapPriority.CommentRecords = new list<WholesalerCommentWrapper>();
                               objChatWrapPriority.CommentRecords.add(objWComntWrap);
                            }
                        }
                    }
                    if(objFeed.LikeCount!=0){
                        system.debug('objFeed.feedLikes=='+objFeed.feedLikes.size());
                        for(FeedLike objLikes : objFeed.feedLikes){
                            WholesalerLikeWrapper objWLikeWrap = new WholesalerLikeWrapper();//Wrapper instance for wholesaleChatter Like
                            if(objLikes.feeditemid != null)
                                objWLikeWrap.FeedItemId = objLikes.feeditemid;
                            else
                                 objWLikeWrap.FeedItemId = ''; 
                            if(objLikes.CreatedBy.name != null)
                                objWLikeWrap.LikeCreatedByName = objLikes.CreatedBy.name;
                            else
                                 objWLikeWrap.LikeCreatedByName = '';   
                            
                            if(objLikes.CreatedById != null){
                                if(mapFeedUserPhoto.get(objLikes.createdById)!=null)
                                    objWLikeWrap.CreatedByUserPhotoUrl = mapFeedUserPhoto.get(objLikes.createdById);
                            }    
                            else
                                 objWLikeWrap.CreatedByUserPhotoUrl = ''; 
                            //ListWholeComnt.add(objWComntWrap);
                            
                            if(objChatWrapNoPriority.LikeRecords !=null)
                               objChatWrapNoPriority.LikeRecords.add(objWLikeWrap);
                            else{
                               objChatWrapNoPriority.LikeRecords = new list<WholesalerLikeWrapper>();
                               objChatWrapNoPriority.LikeRecords.add(objWLikeWrap);
                            }
                            if(objChatWrapPriority.LikeRecords !=null)
                               objChatWrapPriority.LikeRecords.add(objWLikeWrap);
                            else{
                               objChatWrapPriority.LikeRecords = new list<WholesalerLikeWrapper>();
                               objChatWrapPriority.LikeRecords.add(objWLikeWrap);
                            }
                        }
                    }
                    //ListChatRecords.add(objChatWrap);
                    if(objChatWrapPriority.FeedItemRecord != null || objChatWrapPriority.TaskFeedRecord != null)
                        //system.debug('objChatWrapPriority =='+objChatWrapPriority);
                        ListChatPriorityRecs.add(objChatWrapPriority);
                    if(objChatWrapNoPriority.FeedItemRecord != null || objChatWrapNoPriority.TaskFeedRecord != null)
                        ListChatNoPriorityRecs.add(objChatWrapNoPriority);
                    
                    HighPriorityCount=string.valueOf(PriorityCount); 
                    lowPriorityCount = string.valueOf(NoPriorityCount);
                    //isHighPriority = HighPriority;
               
                }
            }
            //system.debug('ListCommentRecs=='+ListCommentRecs.size());
            //system.debug('ListChatPriorityRecs=='+ListChatPriorityRecs.size());
            //system.debug('ListChatNoPriorityRecs=='+ListChatNoPriorityRecs.size());
            ListChatRecords.addAll(ListChatPriorityRecs);
            ListChatRecords.addAll(ListChatNoPriorityRecs);
            
            system.debug('ListChatRecords=='+ListChatRecords.size());
            
        }
        catch(exception e) {
            strReturn = 'Sorry,Something went wrong.';
            system.debug('e.getMessage()=='+e.getMessage());
            System.debug('Exception e '+e.getLineNumber());
            
            isSuccessRes = 0;
        }
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,WholesalerAccountId,WholesalerAccountName,HighPriorityCount,lowPriorityCount, lstRecords,PickListValues,ListChatRecords,deserializedSapScores,deserializedProducts,listUserNotes,GreenAccountsCount,YellowAccountsCount,RedAccountsCount,listWhlsalrAsgndTsks,lstTaskStatusOptions,lstTaskCategoryOptions,lstTaskPriorityOptions,PriorityWholesalerTasks,NoPriorityWholesalerTasks,WlslrTodayTasksCount,WlslrOverDueTasksCount);//Initialising the object for wrapper class. This object can be returned as response to the external system.//ListWholesalerChat,ListTaskFeeds,ListWholeComnt
        system.debug('Limits.getHeapSize()=='+Limits.getHeapSize());
        system.debug('Limits.getLimitHeapSize()=='+Limits.getLimitHeapSize());
        system.debug('obj=='+obj);
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
        else{
            objAccWrap.id = '';
        }
        if(objA.Name!=null){
            objAccWrap.Name = objA.Name;
        }
        else{
            objAccWrap.Name = '';
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
            //system.debug('strStreet =='+strStreet );
            String[] streetA;                        
            if(strStreet.contains('\r\n')){
               streetA = strStreet.split('[\r\n]');
               //system.debug('streetA=='+streetA);
               for(string s:streetA){
                   street = street +' '+ s;
               }
               //system.debug('street=='+street);
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
        
        if(objA.Location__Latitude__s !=null){//objA.Test_Location__Latitude__s
            objAccWrap.LocationLatitude = string.valueOf(objA.Location__Latitude__s);
        }
        else{
            objAccWrap.LocationLatitude = '';
        }
        if(objA.Location__Longitude__s !=null){//objA.Test_Location__Longitude__s
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
            //system.debug('objA.Out_of_Range_Distance_for_POCs_Meters__c=='+objA.Out_of_Range_Distance_for_POCs_Meters__c);
            //system.debug('test==objA.Wholesaler__r.Out_of_Range_Options_for_POCS__c='+objA.Wholesaler__r.Out_of_Range_Options_for_POCS__c);
            if(objA.Wholesaler__r.Out_of_Range_Distance_for_POCs_Meters__c!=null)
                objAccWrap.OutOfRangeDistanceForPOCsMeters = string.valueOf(objA.Wholesaler__r.Out_of_Range_Distance_for_POCs_Meters__c);
            else
                objAccWrap.OutOfRangeDistanceForPOCsMeters = '';
            if(objA.Wholesaler__r.Out_of_Range_Options_for_POCS__c !=null)
                objAccWrap.OutOfRangeOptionsForPOCS = objA.Wholesaler__r.Out_of_Range_Options_for_POCS__c;
            else
                objAccWrap.OutOfRangeOptionsForPOCS = '';
            //system.debug(objA.Out_of_Range_Distance_for_POCs_Meters__c);
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
        else
            objConWrap.id= '';
        if(objC.Accountid!=null){
            objConWrap.Accountid = objC.Accountid;
        }
        else
            objConWrap.Accountid = '';
        if(objC.name!=null && objC.name!=''){
            objConWrap.name = objC.name;
        }
        else
            objConWrap.name = '';
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
        if(objE.id !=null)
            objEveWrap.id = objE.id; 
        else
            objEveWrap.id = '';
        if(objE.Whatid !=null)
            objEveWrap.Accountid = objE.Whatid; 
        else
            objEveWrap.Accountid = '';     
        return objEveWrap;
    }
    /*Description: if User note fields value is null, We are assigning to empty string*/
    public static UserNotesWrapper PrepareNoteData(contentnote objNote){
        UserNotesWrapper objNoteWrap = new UserNotesWrapper();
        if(objNote.id !=null)
            objNoteWrap.id = objNote.id; 
        else
            objNoteWrap.id = '';
        if(objNote.Title !=null)
            objNoteWrap.Title = objNote.Title; 
        else
            objNoteWrap.Title = ''; 
        if(objNote.TextPreview !=null)
            objNoteWrap.TextPreview = objNote.TextPreview; 
        else
            objNoteWrap.TextPreview = '';
        if(objNote.CreatedDate !=null)
            objNoteWrap.CreatedDate= string.valueOf(objNote.CreatedDate); 
        else
            objNoteWrap.CreatedDate= ''; 
        return objNoteWrap;
    }
    
     /*Description: Task data preperation*/
    public static AssignedTasksWrapper PrepareTaskData(Task objTsk)
    {
        AssignedTasksWrapper objTsjWrp = new AssignedTasksWrapper();
        if(objTsk.Status != null)
            objTsjWrp.Status = objTsk.Status;
        else
            objTsjWrp.Status = '';
        if(objTsk.ActivityDate != null){
            objTsjWrp.ActivityDate  = string.ValueOf(objTsk.ActivityDate).replace('-','/');
             /*DateTime dT = objTsk.ActivityDate;
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            objTsjWrp.ActivityDate= string.valueOf(myDate);*/
        }
        else
            objTsjWrp.ActivityDate  = '';
        if(objTsk.id != null)
            objTsjWrp.id = objTsk.id;
        else
            objTsjWrp.id = '';
        if(objTsk.whatid != null)
            objTsjWrp.Accountid = objTsk.whatid;
        else
            objTsjWrp.Accountid = '';
        if(objTsk.Account.name != null)
            objTsjWrp.AccountName = objTsk.Account.name;
        else
            objTsjWrp.AccountName = '';
        if(objTsk.Subject != null)
            objTsjWrp.Subject = objTsk.Subject;
        else
            objTsjWrp.Subject = '';
        if(objTsk.Priority != null)
            objTsjWrp.Priority = objTsk.Priority;
        else
            objTsjWrp.Priority = '';
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
    
    
    global class deserializeResponse {
        //public String id;
        public String access_token;
    }
    //Wrapper class to serialize response
    global class ResponseWrapper
    {
        public integer isSuccess {get;set;}//Holds the success status 0 or 1
        public String Message {get;set;}//Holds the return message
        public string WholesalerAccountId {get;set;}//Holds Wholesaler accountid
        public string WholesalerAccountName {get;set;}//Holds Wholesaler account name
        public list<listWrapper> lstRecords {get;set;}
                
        public string HighPrioritycount {get;set;}//Holds Priority messages count
        public string lowPriorityCount;
        //public boolean isHighPriority;
        public list<string> lstReasonValues {get;set;} //event.Out_of_Range_Reason__c picklist values
        public list<listChatWrapper> ListChatRecords{get;set;}
        public list<AccountTargetWrapper> deserializedSapScores{get;set;}
        public list<ProductImagesWrapper> deserializedProducts{get;set;}
        public list<UserNotesWrapper> listUserNotes{get;set;}
        public integer GreenAccountscount {get;set;}//Holds Sap Color Green count
        public integer YellowAccountscount {get;set;}//Holds Sap Color Yellow count
        public integer RedAccountscount {get;set;}//Holds Sap Color Red Count
        public list<AssignedTasksWrapper> WholesalerTasks {get;set;}//holds Task records where whatid is Wholesaler account and assignedto loggedin user.
        public list<string> TaskStatusOptions {get;set;}//holds task's Status fields options
        public list<string> TaskCategoryOptions {get;set;}
        public list<string> TaskPriorityOptions {get;set;}
        public integer PriorityWholesalerTasks{get;set;}
        public integer NoPriorityWholesalerTasks{get;set;}
        public integer WlslrTodayTasksCount{get;set;}
        public integer WlslrOverDueTasksCount{get;set;}
        //public list<WholesalerChatWrapper> ListWholesalerChat{get;set;}
        //public list<WholesalerTaskWrapper> ListTaskFeeds{get;set;}
        //public list<WholesalerCommentWrapper> ListWholeComnt{get;set;}
        public ResponseWrapper(integer isSuccess,String Message,string WholesalerAccountId,string WholesalerAccountName,string HighPrioritycount,string lowPriorityCount,list<listWrapper> lstWrap,list<string> lstPicks,list<listChatWrapper> ListChatRecords,list<AccountTargetWrapper> deserializedSapScores,list<ProductImagesWrapper> deserializedProducts,list<UserNotesWrapper> listUserNotes,integer GreenAccountscount,integer YellowAccountscount,integer RedAccountscount,list<AssignedTasksWrapper> WholesalerTasks,list<string> TaskStatusOptions,list<string> TaskCategoryOptions,list<string> TaskPriorityOptions,integer PriorityWholesalerTasks,integer NoPriorityWholesalerTasks,integer WlslrTodayTasksCount,integer WlslrOverDueTasksCount)//list<WholesalerChatWrapper> ListWholesalerChat,list<WholesalerTaskWrapper> ListTaskFeeds,list<WholesalerCommentWrapper> ListWholeComnt
        {
            this.isSuccess =isSuccess;
            this.Message = Message;
            this.WholesalerAccountId = WholesalerAccountId;
            this.WholesalerAccountName = WholesalerAccountName;
            this.lstRecords = lstWrap;
            this.HighPrioritycount = HighPrioritycount;
            this.lowPriorityCount = lowPriorityCount;
            //this.isHighPriority = isHighPriority;
            this.lstReasonValues = lstPicks;
            this.ListChatRecords = ListChatRecords;
            this.deserializedSapScores = deserializedSapScores;
            this.deserializedProducts = deserializedProducts;
            this.listUserNotes = listUserNotes;
            this.GreenAccountscount = GreenAccountscount;
            this.YellowAccountscount = YellowAccountscount;
            this.RedAccountscount = RedAccountscount;
            this.WholesalerTasks = WholesalerTasks;
            this.TaskStatusOptions = TaskStatusOptions;
            this.TaskCategoryOptions = TaskCategoryOptions;
            this.TaskPriorityOptions = TaskPriorityOptions;
            this.PriorityWholesalerTasks = PriorityWholesalerTasks;
            this.NoPriorityWholesalerTasks = NoPriorityWholesalerTasks;
            this.WlslrTodayTasksCount = WlslrTodayTasksCount;
            this.WlslrOverDueTasksCount = WlslrOverDueTasksCount;
            //this.ListWholesalerChat = ListWholesalerChat;
            //this.ListTaskFeeds = ListTaskFeeds;
            //this.ListWholeComnt = ListWholeComnt;
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
    public class listChatWrapper
    {
        public WholesalerChatWrapper FeedItemRecord;
        public list<WholesalerCommentWrapper> CommentRecords;
        public list<WholesalerLikeWrapper> LikeRecords;
        public WholesalerTaskWrapper TaskFeedRecord;
               
    }
    
    //Wrapper for WholesalerChatter
    public class WholesalerChatWrapper 
    {
        string id;
        string CreatedByName;
        string CreatedDate;
        string Body;  
        //string CommentBody;
        //string FeedItemId;
        //string CommentCreatedDate;
        //string CommentCreatedByName;
        string CreatedByPhotoUrl;
        string linkUrl;
        string FeeditemType;
        string FileTitle;
        string ContentFile;//Contentversion.contentdata
        string FileExtension; 
        string likeCount;
        string commentCount;
        boolean isHighPriority;
        boolean isImage;
        string isMute;
    }
    public class WholesalerCommentWrapper
    {
        string CommentBody;
        string FeedItemId;
        string CommentCreatedDate;
        string CommentCreatedByName;
        string CreatedByUserPhotoUrl;
    }
    public class WholesalerLikeWrapper
    {
        string FeedItemId;
        string LikeCreatedByName;
        string CreatedByUserPhotoUrl;
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
    //Wrapper class for User notes on feeditem objectName=ContentNotes
    public class UserNotesWrapper
    {
        string id;        
        string Title;
        string TextPreview;
        string CreatedDate;
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
       boolean isCore {get;set;}
       boolean isALNR {get;set;}
       string id {get;set;}
       string Core {get;set;}
       string HighEnd {get;set;}
       string FMB {get;set;}
       string ALNR{get;set;}
       string colorCore{get;set;}
       string colorHighEnd{get;set;}
       string colorFmb{get;set;}
       string colorALNR{get;set;}
       string pgmCore{get;set;}
       string pgmHighEnd{get;set;}
       string pgmFmb{get;set;}
       string pgmALNR{get;set;}
       string AccountName{get;set;}
       string PremiseFlag{get;set;}
       string Channel{get;set;}
       string SAPColor{get;set;}
       //list<US_Account_Target__c> usTargetRecords{get;set;}//US_Account_Target__c
       
       public AccountTargetWrapper(boolean isCore,boolean isALNR,string id,string Core,string HighEnd,string FMB,string ALNR,string colorCore,string colorHighEnd,string colorFmb,string colorALNR,string pgmCore,string pgmHighEnd,string pgmFmb,string pgmALNR,string AccountName,string PremiseFlag,string Channel,string SAPColor)//,list<US_Account_Target__c> usTargetRecords
       {
           this.isCore = isCore;
           this.isALNR= isALNR;
           this.id= id;
           this.Core= Core;
           this.HighEnd= HighEnd;
           this.FMB= FMB;
           this.ALNR= ALNR;
           this.colorCore= colorCore;
           this.colorHighEnd= colorHighEnd;
           this.colorFmb= colorFmb;
           this.colorALNR= colorALNR;
           this.pgmCore= pgmCore;
           this.pgmHighEnd= pgmHighEnd;
           this.pgmFmb= pgmFmb;
           this.pgmALNR= pgmALNR;
           this.AccountName = AccountName;
           this.PremiseFlag= PremiseFlag;
           this.Channel= Channel;
           this.SAPColor= SAPColor;
           //this.usTargetRecords= usTargetRecords;
           
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
    //Wrapper to deserialize mute Response
    public class isMuteResponseWrapper 
    {
        string isMutedByMe; //holds the IsMute Value   
           
        public isMuteResponseWrapper(string mute)
        {
            this.isMutedByMe = mute;  
                                  
        }
    }
}