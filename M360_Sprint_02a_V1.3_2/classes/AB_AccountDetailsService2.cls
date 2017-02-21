/*Author: Bharat*/
/*Description: Sending Account Details and its key decision maker contact details to the External system.*/
/*Created date: 29/8/2016*/
/*Modification History:18/11/2016*/

/*---------------------14/11/2016 Removed code related to Chatterfeeds data collection*/
/*---------------------3/1/2017 Change requirement on assortment data dashboard*/

@RestResource(urlMapping='/AB_AccountDetailsService2/*')
global with sharing class AB_AccountDetailsService2{
    
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
             
            strJSONBody = AB_AccountDetailsService_Test.strJSONBody;   
             
        }
        map<id,list<Task>> mapAssignedTasks = new map<id,list<Task>>();
        list<AccountTargetWrapper> deserializedSapScores = new list<AccountTargetWrapper>();//Sap Score Wrapper getting values for other class
        list<ProductImagesWrapper> deserializedProducts = new list<ProductImagesWrapper>();//Sap Score product images Wrapper getting values for other class
        string strReturn=''; //Holds the return message to be sent as response
        Integer isSuccessRes; //Holds success status '0' or '1'
        integer GreenAccountsCount=0;//Holds Green Sap Color Accounts count
        integer YellowAccountsCount=0;//Holds Yellow Sap Color Accounts count
        integer RedAccountsCount=0;//Holds Red Sap Color Accounts count
        
        string WholesalerAccountId='';//Holds Wholesaler Account id
        string WholesalerAccountName='';//Holds Wholesaler Account name
        list<Account> listAccounts = new list<Account>();//initializing list of accounts
        list<account> ListOrderedAccounts = new list<account>();//Ordered accounts order by Route_Schedule__c.sequence__c
        list<string> aids = new list<string>();//list of poc Account ids
        
        list<string> AssrtmntIds = new list<string>();//list of poc Account ids from route_cust to get data regards assortment status dashboard
        list<string> SAPids = new list<string>();
        map<id,account> mapAcc = new map<id,account>();//Accountid and account records
        map<id,list<contact>> mapCon = new map<id,list<contact>>();//Accountid and contact records
        map<id,list<event>> mapEve = new map<id,list<event>>();//Accountid and event records
        map<id,list<US_Account_Target_Program__c>> mapAccTgtPgms = new map<id,list<US_Account_Target_Program__c>>();//holds assortmeny status dashboard data
        list<string> PickListValues = new list<string>();//event.Out_of_Range_Reason__c picklist values
        list<string> lstTaskStatusOptions = new list<string>();//holds Task status picklist field options
        list<string> lstTaskCategoryOptions = new list<string>();//holds Task category picklist field options
        list<string> lstTaskPriorityOptions = new list<string>();//holds Task priority picklist field options
        list<string> lstCasePriorityOptions = new list<string>();//holds case priority picklist field options
        List<listWrapper> lstRecords = new List<listWrapper>();//Initializing Wrapper object list
        string dataloaderDate = '';
        string strMailId = '';
        string strRouteNumber = '';
        string strEmployeeNmbr = '';
        integer WlslrOverDueTasksCount =0;
        integer PriorityWholesalerTasks =0;
        integer NoPriorityWholesalerTasks=0;
        integer WlslrTodayTasksCount=0;
        string userId='';
        integer CertifiedAccounts=0;//Holds Green Sap Color Accounts count
        integer NonCertifiedAccounts=0;//Holds Green Sap Color Accounts count
        integer levelOneRedCores = 0;
            integer levelOneGreenCores = 0;
            integer levelTwoRedHEs = 0;
            integer levelTwoGreenHEs = 0;
            integer levelTwoRedFMBs = 0;
            integer levelTwoGreenFMBs = 0;
            integer levelTwoRedCores = 0;
            integer levelTwoGreenCores = 0;
        AssrtmntDshbrdWrapper objAsrtmntWrap = new AssrtmntDshbrdWrapper();
        boolean level2 = false;
                
        try{     
            UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
            list<user> logedinUser = new list<user>();
            string strTempRoute = '';
            if(deserializedUser.username != null && deserializedUser.username != ''){   
                logedinUser = [select id,Temp_Route__c,Employee_Number_US__c, Wholesaler_Number__c,WSLRNbrRouteNbr__c,Email from user where username =: deserializedUser.username limit 1];//To get wholesaler Number of loged in user
                if(logedinUser != null && !logedinUser.isEmpty()){
                    userId = logedinUser[0].id;
                    if(logedinUser[0].Temp_Route__c != null && logedinUser[0].Temp_Route__c != ''){
                        list<string> listStrTemp = logedinUser[0].Temp_Route__c.split('-=-');
                        system.debug(date.valueOf(listStrTemp[1]));
                        if(date.valueOf(listStrTemp[1]) == system.today())
                            strTempRoute = listStrTemp[0];
                        else{
                            logedinUser[0].Temp_Route__c = null;
                            update logedinUser[0];
                        }
                    }
                    
                }    
            }
            //system.debug(strTempRoute );
            list<Route__c> newRoute = new list<Route__c>();
            if(deserializedUser.Route != null && deserializedUser.Route != ''){   
                newRoute= [select id,RouteNbr__c,WSLRNbrRouteNbr__c from Route__c where id = :deserializedUser.Route and WSLRNbrRouteNbr__c != null];
                logedinUser[0].Temp_Route__c = deserializedUser.Route + '-=-' + system.today();
                update logedinUser[0];
            }
            else if(strTempRoute != ''){
                newRoute= [select id,RouteNbr__c,WSLRNbrRouteNbr__c from Route__c where id = :strTempRoute and WSLRNbrRouteNbr__c != null];
            }
            //system.debug(newRoute);
            list<Route_Schedule__c> RouteList = new list<Route_Schedule__c>();//Holds Route List order by Sequence__c
            list<RouteCust__c> RouteCustList = new list<RouteCust__c>();//Holds RouteCust list
            if(logedinUser != null && logedinUser.size() != 0){ 
                if(logedinUser[0].Employee_Number_US__c != null)
                    strEmployeeNmbr = logedinUser[0].Employee_Number_US__c;
                if(logedinUser[0].Wholesaler_Number__c != null && logedinUser[0].WSLRNbrRouteNbr__c != null)
                    strRouteNumber = logedinUser[0].WSLRNbrRouteNbr__c.replace(logedinUser[0].Wholesaler_Number__c,'' ); 
                //To get todays route accounts(Stop_Date == today)
                if(deserializedUser.AccountsNeeded != null && deserializedUser.AccountsNeeded == 'Todays'){
                    if(newRoute != null && !newRoute.isEmpty()){
                        RouteList = [select id,name,SeqNbr__c,Route__r.WSLRNbrRouteNbr__c, Account__r.name,Account__c from Route_Schedule__c where StopDate__c = today and Route__c = :newRoute[0].id order by SeqNbr__c];
                        if(newRoute[0].RouteNbr__c != null)
                            strRouteNumber = newRoute[0].RouteNbr__c;     
                    }
                    else if(logedinUser[0].WSLRNbrRouteNbr__c != null)
                        RouteList = [select id,name,SeqNbr__c,Route__r.WSLRNbrRouteNbr__c, Account__r.name,Account__c from Route_Schedule__c where StopDate__c = today and Route__r.WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c order by SeqNbr__c];//'005f00000029fc3'                
                }
                //system.debug('newRoute =='+newRoute );
                //query to get accounts related to RouteCust__c where WSLRNbrRouteNbr__c = logedinuser.WSLRNbrRouteNbr__c
                if(newRoute != null && !newRoute.isEmpty()){
                    RouteCustList = [select id,WSLRNbrRouteNbr__c,Account__r.name,Account__c,Account__r.SAP_Color__c from RouteCust__c where WSLRNbrRouteNbr__c =: newRoute[0].WSLRNbrRouteNbr__c];
                    //system.debug('RouteCustList.size()========'+RouteCustList.size());
                }
                else if(logedinUser[0].WSLRNbrRouteNbr__c != null){
                    RouteCustList = [select id,WSLRNbrRouteNbr__c,Account__r.name,Account__c,Account__r.SAP_Color__c from RouteCust__c where WSLRNbrRouteNbr__c =: logedinUser[0].WSLRNbrRouteNbr__c];
                    //system.debug('Route');
                }
            }
            //system.debug('RouteCustList=='+RouteCustList);            
            if(deserializedUser.AccountsNeeded != null && deserializedUser.AccountsNeeded == 'Todays'){
                if(RouteList != null && RouteList.size()!=0){
                   
                    for(Route_Schedule__c c:RouteList){
                        aids.add(c.Account__c);
                        
                    }                
                }
            }
            
            if(RouteCustList != null && RouteCustList.size()!=0){
               
                for(RouteCust__c c : RouteCustList){
                    if(deserializedUser.AccountsNeeded != null && deserializedUser.AccountsNeeded == 'All'){
                        aids.add(c.Account__c);
                    }
                    AssrtmntIds.add(c.Account__c);
                }                
            }
            
            //----------------Assortment status dashboard--------------------
            
            list<US_Account_Target_Program__c> lstAccTgtPgms = new list<US_Account_Target_Program__c>();
            //if(aids != null && !aids.isEmpty()){
            if(AssrtmntIds != null && !AssrtmntIds.isEmpty()){
                lstAccTgtPgms = [select id, Account__c,Account__r.SAP_Channel__c, Brand_Category__c,Achieved_Targets__c,Program_Target_Level__c from US_Account_Target_Program__c where Account__c in: AssrtmntIds];
                
                
                ABS_SapScore newClass = new ABS_SapScore();
                if(lstAccTgtPgms != null && !lstAccTgtPgms.isEmpty()){
                  for(US_Account_Target_Program__c objTgt : lstAccTgtPgms){
                    if(objTgt.Brand_Category__c == 'FMB' || objTgt.Brand_Category__c == 'HE'){
                        level2 = true;
                      }
                  }
                  for(US_Account_Target_Program__c obj : lstAccTgtPgms){
                    if(level2 == true){
                      if(obj.Achieved_Targets__c != null && obj.Program_Target_Level__c != null)
                          {
                            if(obj.Brand_Category__c != null && obj.Brand_Category__c == 'CORE'){
                              string strcolor = newClass.accountColor(integer.valueOf(obj.Achieved_Targets__c),integer.valueOf(obj.Program_Target_Level__c));
                                      if(strcolor == 'Redcircle')
                                          levelTwoRedCores++;
                                      if(strcolor == 'Greencircle')
                                          levelTwoGreenCores++;
                            }
                            if(obj.Brand_Category__c != null && obj.Brand_Category__c == 'FMB'){
                              string strcolor = newClass.accountColor(integer.valueOf(obj.Achieved_Targets__c),integer.valueOf(obj.Program_Target_Level__c));
                                      if(strcolor == 'Redcircle')
                                          levelTwoRedFMBs++;
                                      if(strcolor == 'Greencircle')
                                          levelTwoGreenFMBs++;
                            }
                            if(obj.Brand_Category__c != null && obj.Brand_Category__c == 'HE'){
                              string strcolor = newClass.accountColor(integer.valueOf(obj.Achieved_Targets__c),integer.valueOf(obj.Program_Target_Level__c));
                                      if(strcolor == 'Redcircle')
                                          levelTwoRedHEs++;
                                      if(strcolor == 'Greencircle')
                                          levelTwoGreenHEs++;
                            }
                          }
                    }
                    else{
                      if(obj.Achieved_Targets__c != null && obj.Program_Target_Level__c != null)
                          {
                            if(obj.Brand_Category__c != null && obj.Brand_Category__c == 'CORE'){
                              string strcolor = newClass.accountColor(integer.valueOf(obj.Achieved_Targets__c),integer.valueOf(obj.Program_Target_Level__c));
                                  if(strcolor == 'Redcircle')
                                      levelOneRedCores++;
                                  if(strcolor == 'Greencircle')
                                      levelOneGreenCores++;
                            }   
                                   
                          }
                      
                    }
                  }
                }
                
                objAsrtmntWrap.levelTwoGreenFMBs = levelTwoGreenFMBs;               
                objAsrtmntWrap.levelTwoRedFMBs = levelTwoRedFMBs;
                objAsrtmntWrap.levelTwoRedHEs = levelTwoRedHEs;
                objAsrtmntWrap.levelTwoGreenHEs = levelTwoGreenHEs;
                objAsrtmntWrap.levelTwoGreenCores = levelTwoGreenCores;
                objAsrtmntWrap.levelTwoRedCores = levelTwoRedCores;
                objAsrtmntWrap.levelOneRedCores = levelOneRedCores;
                objAsrtmntWrap.levelOneGreenCores = levelOneGreenCores;
                objAsrtmntWrap.isLevel2 = level2;
            }
            
            //----------------Assortment status dashboard--------------------
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
            //system.debug('SAPids=='+SAPids);
            list<string> WholesalerAccIds = new list<string>();
            
            list<Account> WholesalerAccountList = new list<Account>();
            list<task> listWholesalerTasks = new list<task>();//Initialise list of tasks assigned to logedin user and Wholesaler account
            if(logedinUser != null && logedinUser.size() != 0){ 
                //To get Wholesaler record   
                if(logedinUser[0].Wholesaler_Number__c != null)
                    WholesalerAccountList = [select id,name, WSLR_NBR_US__c from account where WSLR_NBR_US__c =: logedinUser[0].Wholesaler_Number__c and recordtype.name = 'Wholesaler' limit 1];
                if(WholesalerAccountList != null && WholesalerAccountList.size() != 0){
                    WholesalerAccountId = WholesalerAccountList[0].id;//Assigning wholesaler account id
                    WholesalerAccountName = WholesalerAccountList[0].name;
                    for(Account acc: WholesalerAccountList){
                        WholesalerAccIds.add(acc.id);                   
                    }
                }
                if(logedinUser[0].Email != null)
                    strMailId = logedinUser[0].Email;
            }  
            
            
           
            
            //Sap Score Wrapper construction=========================================================================================
            if(deserializedUser.AccountsNeeded != null && deserializedUser.AccountsNeeded == 'Todays'){
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
                if(strSapScoreJson != ''){
                    string[] strJsonList = strSapScoreJson.split('##Json#####');
                
                    deserializedSapScores = (list<AccountTargetWrapper>)JSON.deserializeStrict(strJsonList[0], list<AccountTargetWrapper>.class);            
                    deserializedProducts = (list<ProductImagesWrapper>)JSON.deserializeStrict(strJsonList[1], list<ProductImagesWrapper>.class);
                
                }
                //system.debug('deserializedProducts =='+deserializedProducts );
            }
            //Sap Score Wrapper construction Finish=========================================================================================            
            
            if(aids==null && aids.size()==0){
            //system.debug(aids);
                strReturn = 'Sorry, There are no records to display.';
                isSuccessRes = 0;
            }
            else{
              system.debug('yes');
                //Accounts, Contact, Event Wrappers construction==============================================================================
                 //Query to get list of accounts and its Key Decision maker(contact)
                listAccounts = [select id,SAP_Channel__c,Wholesaler__r.WSLR_NBR_US__c,WSLR_NBR_US__c,WSLR_ASGND_CUST_NBR_US__c, Name ,SAP_Color__c, BillingCity ,BillingState,BillingPostalcode,RTL_SEG_NM_US__c,BillingCountry,BillingStreet,Out_of_Range_Distance_for_POCs_Meters__c,Location__Latitude__s,Location__Longitude__s,Out_of_Range_Options_for_POCS__c,Wholesaler__c,Wholesaler__r.Out_of_Range_Options_for_POCS__c,Wholesaler__r.Out_of_Range_Distance_for_POCs_Meters__c,Size__c,Trade_Program_NM__c, (select id,Accountid,Account.Delivery_Hours_and_Days__c,Account.Office_Hours_and_Days__c,name,firstname,lastname,Title,email,Phone,MobilePhone from contacts where ONTAP__Decision_Maker__c = true limit 1),(select id,whatid,Visit_in_Progress__c,Visit_Completed__c from Events where createddate = TODAY and owner.username =: deserializedUser.username) from account where id in: aids order by name];
                //system.debug('listAccounts.size()====='+listAccounts.size());
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
                set<id> setIds = new set<id>();
                if(deserializedUser.AccountsNeeded != null && deserializedUser.AccountsNeeded == 'All'){
                    if(listAccounts != null && !listAccounts.isEmpty()){
                        ListOrderedAccounts = listAccounts;
                        for(account objA : listAccounts){
                            setIds.add(objA.id);
                        }
                    }
                }
                
                else{
                    
                    if(RouteList != null && RouteList.size() != null){
                        for(Route_Schedule__c obj:RouteList){
                             if(mapAcc.get(obj.Account__c)!=null){
                                 if(!setIds.contains(obj.Account__c))
                                     ListOrderedAccounts.add(mapAcc.get(obj.Account__c));  
                                 setIds.add(obj.Account__c); 
                             }
                        }
                    }
                }
                list<task> listPocTask = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where whatid in: setIds];
                if(listPocTask != null && !listPocTask.isEmpty()){
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
                }
                
                /*Start: wholesaler tasks count data*/
                 //Wholesaler tasks Data Preperation for logedin user starts=======================================================================
            
                //Query to get list of tasks for today
                list<task> listWSTask = [select id,Subject,Category__c , Ownerid, owner.name,Priority, whatid, account.name,Description, status,ActivityDate from task where Ownerid =: logedinUser[0].id order by priority desc];//whatid =: WholesalerAccountList[0].id
                //WlslrTodayTasksCount = listWSTask.size();//Holds Todays tasks count
                                    
                if(listWSTask != null && listWSTask.size() != 0){
                    for(task objTsk: listWSTask){
                        if(objTsk.ActivityDate < date.today() && objTsk.Status != 'Completed')
                            WlslrOverDueTasksCount++;                   
                        if(objTsk.ActivityDate == date.today() && objTsk.Priority == 'High')
                            PriorityWholesalerTasks++;
                        if(objTsk.ActivityDate == date.today() && objTsk.Priority != 'High')
                            NoPriorityWholesalerTasks++;
                        if(objTsk.ActivityDate == date.today() && objTsk.Status != 'Completed')
                            WlslrTodayTasksCount++;

                        
                    }
                
                }
           
            //Wholesaler tasks Data Preperation for logedin user finish=======================================================================
                /*end: wholesaler tasks count data*/
                if(ListOrderedAccounts != null && ListOrderedAccounts.size() != null){
                    for(account objA:ListOrderedAccounts){
                        /*Task count data start*/
                        integer HighPriorTasks =0;
                        integer NoPriorTasks =0;
                        integer POCTodayTasks =0;
                        integer POCOverDueTasks = 0;
                        system.debug('yes');
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
                            }
                        }
                        listWrapper objWrap = new listWrapper();
                        objWrap.PriorityPOCTasks = HighPriorTasks;
                        objWrap.NoPriorityPOCTasks = NoPriorTasks;
                        objWrap.POCTodayTasksCount = POCTodayTasks;
                        objWrap.POCOverDueTasksCount = POCOverDueTasks;
                        /*end task count data*/
                        
                        if(objA.SAP_Color__c != null && objA.SAP_Color__c == 'Green'){
                            GreenAccountsCount++;
                        }
                        
                        if(objA.SAP_Color__c != null && objA.SAP_Color__c == 'Red'){
                            RedAccountsCount++;
                        }
                        
                        objWrap.AccountRecord = PrepareAccountData(objA);
                        if(mapCon.get(objA.id)!=null){
                            for(contact objC:mapCon.get(objA.id)){                        
                                objWrap.ContactRecord= PrepareContactData(objC);
                            }
                        }
                        if(mapEve.get(objA.id)!=null){
                            boolean isRevisit;
                            event RevisitEvt = new event();
                            event CompletedEvt = new event();
                            for(event objE:mapEve.get(objA.id)){                       
                                //checking if any of the event is not completed
                                if(objE.Visit_Completed__c == false){
                                    isRevisit = true;
                                    RevisitEvt = objE;
                                }
                                else
                                    CompletedEvt = objE;
                                
                                //objWrap.EventRecord = PrepareEventData(objE);
                            }
                            
                            if(isRevisit == true){//checking if there is any record with Visit_completed__c = false
                                objWrap.EventRecord = PrepareEventData(RevisitEvt);
                            }
                            else//preparing data for latest event if there is no event with Visit_completed__c = false
                                objWrap.EventRecord = PrepareEventData( CompletedEvt);
                        }
                        
                        lstRecords.add(objWrap);                    
                    }
                }
                
                strReturn = 'Success. Account Records are queried successfully.';
                isSuccessRes = 1;
            }
            
            if(deserializedUser.AccountsNeeded != null && deserializedUser.AccountsNeeded == 'Todays'){
                //to get values of event.Out_of_Range_Reason__c picklist field start.==========================================================     
                
                PickListValues = AB_M360.getPickListLabels(event.Out_of_Range_Reason__c);     
                system.debug(PickListValues);
                                
                //to get values of task.Status picklist field start.==========================================================     
                
                lstTaskStatusOptions = AB_M360.getPickListLabels(task.status);    
                system.debug(lstTaskStatusOptions);
                
                //to get values of task.Category__c picklist field start.==========================================================     
                
                lstTaskCategoryOptions = AB_M360.getPickListLabels(task.Category__c);   
                system.debug(lstTaskCategoryOptions);
                
                //to get values of task.Priority picklist field start.==========================================================     
                  
                lstTaskPriorityOptions = AB_M360.getPickListLabels(task.Priority);   
                system.debug(lstTaskPriorityOptions);
                
                //Start: to get values of ONTAP__Case_Force__c.ONTAP__Priority__c picklist field start.==========================================================     
                lstCasePriorityOptions.add('High');  
                lstCasePriorityOptions.add('Low');     
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
                        
        }
        catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,strMailId,WholesalerAccountId,WholesalerAccountName, lstRecords,PickListValues,deserializedSapScores,deserializedProducts,GreenAccountsCount,YellowAccountsCount,RedAccountsCount,objAsrtmntWrap,lstTaskStatusOptions,lstTaskCategoryOptions,lstTaskPriorityOptions,lstCasePriorityOptions,dataloaderDate,strRouteNumber,WlslrOverDueTasksCount,PriorityWholesalerTasks,NoPriorityWholesalerTasks,WlslrTodayTasksCount,userId,strEmployeeNmbr);//Initialising the object for wrapper class. This object can be returned as response to the external system.//ListWholesalerChat,ListTaskFeeds,ListWholeComnt
        return obj;
        
    }
    
    /*
        Description : If Account field data is null , we are assigning to empty string
    */
    public static AccountDetailWrapper PrepareAccountData(account objA){
        AccountDetailWrapper objAccWrap = new AccountDetailWrapper();
        if(objA.id!=null)
            objAccWrap.id = objA.id;
        
        if(objA.Name!=null)
            objAccWrap.Name = objA.Name;
        
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
            //system.debug('objA.Name=='+objA.Name);
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
        if(objA.SAP_Channel__c != null){
            objAccWrap.POCChannel = objA.SAP_Channel__c;
        }
        else
            objAccWrap.POCChannel = '';
            
        
        if(objA.WSLR_NBR_US__c != null){
            objAccWrap.WSalerNumber = objA.Wholesaler__r.WSLR_NBR_US__c;
        }
        else
            objAccWrap.WSalerNumber = '';
        if(objA.WSLR_ASGND_CUST_NBR_US__c != null){
            objAccWrap.CustomerId = objA.WSLR_ASGND_CUST_NBR_US__c;
        }
        else
            objAccWrap.CustomerId = ''; 
        
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
        if(objC.firstname!=null && objC.firstname!=''){
            objConWrap.firstname = objC.firstname;
        }
        if(objC.lastname!=null && objC.lastname!=''){
            objConWrap.lastname = objC.lastname;
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
        if(objC.Account.Office_Hours_and_Days__c !=null && objC.Account.Office_Hours_and_Days__c !='')
            objConWrap.OfficeHours = objC.Account.Office_Hours_and_Days__c;
        else
            objConWrap.OfficeHours = '';
        if(objC.Account.Delivery_Hours_and_Days__c!=null && objC.Account.Delivery_Hours_and_Days__c!='')
            objConWrap.DeliveryHours = objC.Account.Delivery_Hours_and_Days__c;
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
        
        if(objE.Whatid !=null)
            objEveWrap.Accountid = objE.Whatid; 
        else
            objEveWrap.Accountid = '';     
        return objEveWrap;
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
        public AssrtmntDshbrdWrapper AssortmentColors {get;set;}
        
        
        
        public list<string> TaskStatusOptions {get;set;}//holds task's Status fields options
        public list<string> TaskCategoryOptions {get;set;}
        public list<string> TaskPriorityOptions {get;set;}
        public list<string> CasePriorityOptions {get;set;}
        public string dataloaderDate{get;set;}
        public string strRouteNumber{get;set;}
        public integer WlslrOverDueTasksCount{get;set;}
        public integer PriorityWholesalerTasks {get;set;}
        public integer NoPriorityWholesalerTasks{get;set;}
        public integer WlslrTodayTasksCount{get;set;}
        public string userId{get;set;}
        public string EmployeeId{get;set;}
        
        
        public ResponseWrapper(integer isSuccess,String Message,string UserMailId,string WholesalerAccountId,string WholesalerAccountName,list<listWrapper> lstWrap,list<string> lstPicks,list<AccountTargetWrapper> deserializedSapScores,list<ProductImagesWrapper> deserializedProducts,integer GreenAccountscount,integer YellowAccountscount,integer RedAccountscount,AssrtmntDshbrdWrapper AssortmentColors,list<string> TaskStatusOptions,list<string> TaskCategoryOptions,list<string> TaskPriorityOptions,list<string> CasePriorityOptions,string dataloaderDate,string strRouteNumber,integer WlslrOverDueTasksCount ,integer PriorityWholesalerTasks,integer NoPriorityWholesalerTasks,integer WlslrTodayTasksCount,string userId,string EmployeeId)//list<WholesalerChatWrapper> ListWholesalerChat,list<WholesalerTaskWrapper> ListTaskFeeds,list<WholesalerCommentWrapper> ListWholeComnt
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
            this.AssortmentColors = AssortmentColors;
            
            
            
            
            this.TaskStatusOptions = TaskStatusOptions;
            this.TaskCategoryOptions = TaskCategoryOptions;
            this.TaskPriorityOptions = TaskPriorityOptions;
            this.CasePriorityOptions = CasePriorityOptions;
            this.dataloaderDate = dataloaderDate;
            this.strRouteNumber = strRouteNumber;
            this.WlslrOverDueTasksCount  = WlslrOverDueTasksCount ;
            this.PriorityWholesalerTasks  = PriorityWholesalerTasks ;
            this.NoPriorityWholesalerTasks = NoPriorityWholesalerTasks;
            this.WlslrTodayTasksCount = WlslrTodayTasksCount;
            this.userId = userId;
            this.EmployeeId = EmployeeId;
        }
    }
    //Wrapper class to club all AccountFields,ContactFields, EventFields
    public class listWrapper
    {
        public AccountDetailWrapper AccountRecord;
        public ContactDetailWrapper ContactRecord;
        public EventDetailWrapper EventRecord;
        public integer PriorityPOCTasks;
        public integer NoPriorityPOCTasks;
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
        string POCChannel;
        string WSalerNumber;
        string CustomerId;
    }
    // Wrapper class to deserialize user details of contact fields.     
    public class ContactDetailWrapper 
    {
        string id ='';
        string Accountid ='';
        string name ='';
        string Title =''; 
        string email ='';
        string Phone ='';
        string MobilePhone =''; 
        string OfficeHours ='';
        string DeliveryHours ='';
        string firstname = '';
        string lastname = '';
    }   
    // Wrapper class to deserialize user details of Event fields.     
    public class EventDetailWrapper 
    {
        string id;
        string Accountid;
        boolean VisitinProgress;
        boolean VisitCompleted;    
    }   
    
    public class AssrtmntDshbrdWrapper
    {
        integer levelOneRedCores = 0;//holds green core accounts count
        integer levelOneGreenCores = 0;//holds non green core accounts count
        integer levelTwoRedHEs = 0;//holds red he accounts count
        integer levelTwoGreenHEs = 0;//holds green he accounts count
        integer levelTwoRedFMBs = 0;//holds red fmb accounts count
        integer levelTwoGreenFMBs = 0;//holds fmb core accounts count
        integer levelTwoRedCores = 0;//holds other red core accounts count
        integer levelTwoGreenCores = 0;//holds other green core accounts count
        boolean isLevel2;    
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
        string AccountsNeeded;  
        string Route;  
        public UserDetailsWrapper(string u,string AccountsNeeded,string Route)
        {
            this.username = u;  
            this.AccountsNeeded = AccountsNeeded;  
            this.Route = Route;                   
        }
    }
    
}