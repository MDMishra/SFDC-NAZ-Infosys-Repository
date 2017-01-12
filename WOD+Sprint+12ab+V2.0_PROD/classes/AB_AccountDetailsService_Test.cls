/* code coverage for AB_M360,AB_AccountDetailsService , AB_TaskDetailService,AB_UpdateContactservice and AB_ContactDetailService*/
@isTest
public class AB_AccountDetailsService_Test {
    
    static string usr;
    public static string strJSONBody;
    public static string strTskJSONBody;
    static string usrNmbr = [select WSLRNbrRouteNbr__c from user where id =: UserInfo.getUserId()].WSLRNbrRouteNbr__c;
    static string usrWsalerNmbr = [select Wholesaler_Number__c from user where id =: UserInfo.getUserId()].Wholesaler_Number__c;
    
    public static Task createTask(Date d,String status,ID accIdIs){
        Task taskIs = new Task();
        taskIs.WhatId = accIdIs;
        taskIs.OwnerId= userInfo.getUserId();
        taskIs.Subject = 'Other';
        taskIs.priority= 'High';
        taskIs.status = status;
        taskIs.description = 'Test';
        taskIs.ActivityDate=d;
        insert taskIs;
        return taskIs;
        }
    public static Task createTask2(Date d,String status,ID accIdIs){
        Task taskIs = new Task();
        //taskIs.WhatId = accIdIs;
        //taskIs.OwnerId= userInfo.getUserId();
        taskIs.Subject = 'other';
        taskIs.priority= 'Normal';
        taskIs.status = status;
        //taskIs.description = '';
        //taskIs.ActivityDate=d;
        insert taskIs;
        return taskIs;
        }
    
    static testMethod void UnitTest2() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User usr1 = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '10500'
             );
             insert usr1;
             
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       objAc.billingCity = 'Hyderabad';
       objAc.billingstreet = 'ttt\r\nHyderabad';
       objAc.billingCountry = 'Hyderabad';
       objAc.billingPostalCode = '500459';
       objAc.Trade_Program_NM__c = 'MACRO';
       objAc.INDUS_VOL_CLASS_CD_US__c  = '11';
       objAc.WSLR_NBR_US__c = '54554';
       objAc.WSLR_ASGND_CUST_NBR_US__c = '434343';
       //objAc.Wholesaler__c = objAcWhole.id;
       insert objAc;
       
       Date d2= System.today()-1;
       String status2='Completed';
       
       strTskJSONBody = '{\"userid\":\"'+userinfo.getuserid()+'\",\"accountid\":\"'+usr1.id+'\",\"accountType\":\"'+'Wholesalerrr'+'\"}';
       AB_AccountDetailsService2.AB_AccountDetails_Service();
       AB_TaskDetailService.UserDetailsWrapper objUserDets = new AB_TaskDetailService.UserDetailsWrapper('AccId','usr','POCp');
    }
    static testMethod void UnitTest3() {
       Recordtype WholesalerRType = [select id ,name from recordtype where sobjecttype = 'account' and name ='Wholesaler'];
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       User u = [select WSLRNbrRouteNbr__c,Wholesaler_Number__c from user where id =: UserInfo.getUserId()];
       account objAcWhole = new account();
       objAcWhole.name = 'Test Account';       
       objAcWhole.recordtypeid = WholesalerRType.id;
       objAcWhole.WSLR_NBR_US__c = u.Wholesaler_Number__c;
       insert objAcWhole;
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       //objAc.billingCity = '';
       objAc.billingstate = 'THyderabad';
       //objAc.billingCountry = 'Hyderabad';
       //objAc.billingPostalCode = '500459';
       objAc.Trade_Program_NM__c = 'MACRO';
       //objAc.Wholesaler__c = objAcWhole.id;
       objAc.INDUS_VOL_CLASS_CD_US__c = '20';
       insert objAc;
       objAc.WSLR_NBR_US__c = '54554';
       objAc.WSLR_ASGND_CUST_NBR_US__c = '434343';
       strTskJSONBody = '{\"userid\":\"'+userinfo.getuserid()+'\",\"accountid\":\"'+objAc.id+'\",\"accountType\":\"'+'POC'+'\"}';  
        
       usr = UserInfo.getUserId();
       strJSONBody = '{\"username\":\"'+UserInfo.getUserName()+'\",\"AccountsNeeded\":\"'+'Todays'+'\"}';
       
       Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = usrNmbr;
       insert objRte;
       
       Route_Schedule__c route = new Route_Schedule__c();
       route.Route__c = objRte.id;
       route.SeqNbr__c = 1;
       route.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route.StopDate__c = System.today();
      // route.Sales_Rep__c = usr;
       insert route;
             
         contact objCon = new contact();
         objCon.AccountId = objAc.id;
         objCon.LastName = 'Test Con';
         //objCon.Title = 'Test Title';
         //objCon.email = 'test@test.com';
         objCon.Phone = '8787878787';
         //objCon.Office_Hours__c = '8AM-4PM';
         objCon.ONTAP__Decision_Maker__c = true;
         insert objCon;
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=objAc.id;
         e.CurrencyIsoCode = 'USD';
         //e.StartDateTime = system.now();
         e.OwnerId=UserInfo.getUserId();
         e.DurationInMinutes=60;
         e.activitydatetime=system.now();
        // e.createddate = system.today();
         e.Type = 'Email';
         e.Description = 'string'; //string
         insert e;
         system.debug('event=='+e);
       
      // select Visit_in_Progress__c,Visit_Completed__c from Events where createddate = TODAY and owner.username
       event objEve  =  new event();
       objEve.subject = 'Test Event';
       objEve.Visit_in_Progress__c = true;
       objEve.Visit_Completed__c = false;
       objEve.OwnerId = UserInfo.getUserId();
       objEve.Whatid = objAcWhole.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 30;
       //objEve.createddate = system.today();
       insert objEve;
       
       Date d= System.today();
       String status='In Progress';       
       Id accIdIs = objAcWhole.id;
       Task task = createTask(d,status,accIdIs);
       
       Date d1= System.today()-1;
       String status1='In Progress';       
       Id accId1 = objAcWhole.id;
       Task task1 = createTask(d1,status1,accId1);
       
       Date d2= System.today()-1;
       String status2='Completed';
       Id accId2 = objAcWhole.id;
       Task task2 = createTask(d2,status2,accId2);
       
       Date d3= System.today();
       String status3='In Progress';       
       Id accId3 = objAc.id;
       Task task3 = createTask(d3,status3,accId3);
       
       Date d4= System.today()-1;
       String status4='In Progress';              
       Id accId4 = objAc.id;
       Task task4 = createTask(d4,status4,accId4);
       
       Task task6 = createTask2(d4,status4,accId4);
       
       Date d5= System.today()-1;
       String status5='Completed';
       Id accId5 = objAc.id;
       Task task5 = createTask(d5,status5,accId5);
       
                     
       AB_AccountDetailsService2 objClass = new AB_AccountDetailsService2();
       AB_AccountDetailsService2.AB_AccountDetails_Service();
       AB_AccountDetailsService2.PrepareEventData(e);
              
       AB_AccountDetailsService2.UserDetailsWrapper UserWrap = new AB_AccountDetailsService2.UserDetailsWrapper(UserInfo.getUserName(),'Todays');  //Covering inner/wrapper class
       AB_AccountDetailsService2.AccountTargetWrapper actTargetw = new AB_AccountDetailsService2.AccountTargetWrapper('123','CORE','HighEnd','FMB','colorCore','colorHighEnd','colorFmb','pgmCore','pgmHighEnd','pgmFmb','AccountName','PremiseFlag','Channel','On Premise','SAPColor');
       AB_AccountDetailsService2.ProductImagesWrapper pImageW = new AB_AccountDetailsService2.ProductImagesWrapper('ProductImage','ProductName','BrandCategory','ColorCode','Accountid','BrandPackage');
       //AB_TaskDetailService objTaskClass = new AB_TaskDetailService();
        AB_TaskDetailService.AB_TaskDetail_Service();
        AB_TaskDetailService.UserDetailsWrapper objUserDets = new AB_TaskDetailService.UserDetailsWrapper(objAc.id,usr,'POC');
        AB_UpdateContactservice.AB_UpdateContactservice('Testing','TestCon','email@mail.com','title','MobilePhone','Phone',objAc.id);
    }
    /* method to cover AB_AccountRoutecust trigger and AB_Taskdetailservice*/
    static testMethod void UnitTestCust() {
        Recordtype WholesalerRType = [select id ,name from recordtype where sobjecttype = 'account' and name ='Wholesaler'];
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAcWhole = new account();
       objAcWhole.name = 'Test Account';       
       objAcWhole.recordtypeid = WholesalerRType.id;
       objAcWhole.WSLR_NBR_US__c = usrNmbr;
       insert objAcWhole;
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       objAc.billingCity = 'Hyderabad';
       objAc.billingstreet = 'ttt\r\nHyderabad';
       objAc.billingCountry = 'Hyderabad';
       objAc.billingPostalCode = '500459';
       objAc.Trade_Program_NM__c = 'MACRO';
       objAc.RTL_SEG_NM_US__c = 'PACKAGE LIQUOR';
       objAc.Wholesaler__c = objAcWhole.id;
       objAc.WSLR_NBR_US__c = '54554';
       objAc.WSLR_ASGND_CUST_NBR_US__c = '434343';
       insert objAc; 
       
              
       strTskJSONBody = '{\"userid\":\"'+userinfo.getuserid()+'\",\"accountid\":\"'+objAc.id+'\",\"accountType\":\"'+'Wholesaler'+'\"}';
       usr = UserInfo.getUserId();
       strJSONBody = '{\"username\":\"'+UserInfo.getUserName()+'\",\"AccountsNeeded\":\"'+'All'+'\"}';       
       Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = usrNmbr;
       
       insert objRte;
       
       Route__c objRte2 = new Route__c();
       objRte2.WSLRNbrRouteNbr__c = usrNmbr;
       
       insert objRte2;
       
       RouteCust__c objCust = new RouteCust__c();
       objCust.Route__c = objRte.id;
       objCust.Account__c = objAc.id;
       objCust.WSLRNbrRouteNbr__c = usrNmbr;
       insert objCust;
       
       RouteCust__c objCust2 = new RouteCust__c();
       objCust2.Route__c = objRte2.id;
       objCust.Account__c = objAcWhole.id;
       objCust2.WSLRNbrRouteNbr__c = usrNmbr;
       insert objCust2;
       
       Route_Schedule__c route = new Route_Schedule__c();
       route.Route__c = objRte.id;
       route.SeqNbr__c = 1;
       route.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route.StopDate__c = System.today();
      // route.Sales_Rep__c = usr;
       insert route;
             
         contact objCon = new contact();
         objCon.AccountId = objAc.id;
         objCon.LastName = 'TestCon';
         objCon.firstname = 'Testing';
         objCon.Title = 'Test Title';
         objCon.email = 'test@test.com';
         objCon.Phone = '8787878787';
         objCon.Office_Hours__c = '8AM-4PM';
         objCon.ONTAP__Decision_Maker__c= true;
         objCon.Delivery_Hours__c = '8AM-4PM';
         objCon.MobilePhone = '8585858585';
         insert objCon;
         
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=objAc.id;
         e.CurrencyIsoCode = 'USD';
         //e.StartDateTime = system.now();
         e.OwnerId=UserInfo.getUserId();
         e.DurationInMinutes=60;
         e.activitydatetime=system.now();
         //e.createddate = system.today();
         e.Type = 'Email';
         e.Description = 'string'; //string
         insert e;
         system.debug('event=='+e);
       
       event objEve  =  new event();
       objEve.subject = 'Test Event';
       objEve.Visit_in_Progress__c = true;
       objEve.Visit_Completed__c = false;
       objEve.OwnerId = UserInfo.getUserId();
       objEve.Whatid = objAc.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 30;
       //objEve.createddate = system.today();
       insert objEve;
       
       US_Account_Target_Program__c objAcTrgt6 = new US_Account_Target_Program__c();
        objAcTrgt6.Account__c=objAc.id;
        objAcTrgt6.Brand_Category__c = 'FMB';
        
        insert objAcTrgt6;
        US_Account_Target_Program__c objAcTrg6 = new US_Account_Target_Program__c();
        objAcTrg6.Account__c=objAc.id;
        objAcTrg6.Brand_Category__c = 'FMB';
        insert objAcTrg6;
        
        US_Account_Target_Program__c objAcTrgt = new US_Account_Target_Program__c();
        objAcTrgt.Account__c=objAc.id;
        objAcTrgt.Brand_Category__c = 'CORE';
        
        insert objAcTrgt;
        
        US_Account_Target_Program__c objAcTrg = new US_Account_Target_Program__c();
        objAcTrg.Account__c=objAc.id;
        objAcTrg.Brand_Category__c = 'CORE';
        
        insert objAcTrg;
        objAcTrg.Brand_Category__c = 'High End';
        update objAcTrg;
        
      
       
       Date d= System.today();
       String status='In Progress';       
       Id accIdIs = objAcWhole.id;
       Task task = createTask(d,status,accIdIs);
       
       Date d1= System.today()-1;
       String status1='In Progress';       
       Id accId1 = objAcWhole.id;
       Task task1 = createTask(d1,status1,accId1);
       
       Date d2= System.today()-1;
       String status2='Completed';
       Id accId2 = objAcWhole.id;
       Task task2 = createTask(d2,status2,accId2);
       
       Date d3= System.today();
       String status3='In Progress';       
       Id accId3 = objAc.id;
       Task task3 = createTask(d3,status3,accId3);
       
       Date d4= System.today()-1;
       String status4='In Progress';  
             
       Id accId4 = objAc.id;
       Task task4 = createTask(d4,status4,accId4);
       
       Date d5= System.today()-1;
       String status5='Completed';
       Id accId5 = objAc.id;
       Task task5 = createTask(d5,status5,accId5);
       Task task6 = createTask2(d5,status5,accId5);
          
       AB_AccountDetailsService2.AB_AccountDetails_Service();
       AB_AccountDetailsService2.PrepareEventData(e);
              
       AB_AccountDetailsService2.UserDetailsWrapper UserWrap = new AB_AccountDetailsService2.UserDetailsWrapper(UserInfo.getUserName(),'All');  //Covering inner/wrapper class
       AB_AccountDetailsService2.AccountTargetWrapper actTargetw = new AB_AccountDetailsService2.AccountTargetWrapper('123','Core','HighEnd','FMB','colorCore','colorHighEnd','colorFmb','pgmCore','pgmHighEnd','pgmFmb','AccountName','PremiseFlag','Channel','SAPChannel','SAPColor');
       AB_AccountDetailsService2.ProductImagesWrapper pImageW = new AB_AccountDetailsService2.ProductImagesWrapper('ProductImage','ProductName','BrandCategory','ColorCode','Accountid','BrandPackage');
       AB_TaskDetailService.AB_TaskDetail_Service();
       AB_TaskDetailService.UserDetailsWrapper objUserDets = new AB_TaskDetailService.UserDetailsWrapper(objAc.id,usr,'POC');
       AB_ContactDetailService.AB_ContactDetailService(objAc.id);
       AB_UpdateContactservice.AB_UpdateContactservice('Testing','TestCon','test@test.com','title','MobilePhone','Phone',objAc.id);
       AB_M360.getPickListValues(Account.Industry);
       AB_M360.getPickListselectOptions(Account.Industry);
       AB_M360.WriteLog=true;
       AB_M360.debug('test','test');
        
    }      
    
}