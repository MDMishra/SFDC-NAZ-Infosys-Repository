@isTest
public class AB_AccountDetails_Service_Test {
    @TestVisible public static string Uname;
    @TestVisible public static string AccId;
    static string usr;
    static string usrNmbr = [select WSLRNbrRouteNbr__c from user where id =: UserInfo.getUserId()].WSLRNbrRouteNbr__c;
    
    static testMethod void UnitTest1() {
       Recordtype WholesalerRType = [select id ,name from recordtype where sobjecttype = 'account' and name ='Wholesaler'];
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAcWhole = new account();
       objAcWhole.name = 'Test Account';       
       objAcWhole.recordtypeid = WholesalerRType.id;
       objAcWhole.WSLR_NBR_US__c = '10500';
       insert objAcWhole;
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       objAc.billingCity = 'Hyderabad';
       objAc.billingstreet = 'ttt\r\nHyderabad';
       objAc.billingCountry = 'Hyderabad';
       objAc.billingPostalCode = '500459';
       objAc.Trade_Program_NM__c = 'MACRO';
       objAc.Wholesaler__c = objAcWhole.id;
       insert objAc;
       AccId = objAc.id;
       
            
       
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
        /*usr = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '123',
             WSLRNbrRouteNbr__c = '93411D0103'
             );
             insert usr;
             Uname = usr.Username;*/
       usr = UserInfo.getUserId();
             Uname = UserInfo.getUserName();
       system.debug('Uname==test'+Uname);
       
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
         objCon.Title = 'Test Title';
         objCon.email = 'test@test.com';
         objCon.Phone = '8787878787';
         objCon.Office_Hours__c = '8AM-4PM';
         objCon.lboc_Key_Decision_Maker__c = true;
         insert objCon;
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=objAc.id;
         e.CurrencyIsoCode = 'USD';
         //e.StartDateTime = system.now();
         e.OwnerId=UserInfo.getUserId();
         e.DurationInMinutes=60;
         e.activitydatetime=system.now();
         e.createddate = system.today();
         e.Type = 'Email';
         e.Description = 'string'; //string
         insert e;
         system.debug('event=='+e);
       //select name,Title,email,Phone,MobilePhone,Office_Hours__c,Delivery_Hours__c from contacts where lboc_Key_Decision_Maker__c = true
       
      // select Visit_in_Progress__c,Visit_Completed__c from Events where createddate = TODAY and owner.username
       event objEve  =  new event();
       objEve.subject = 'Test Event';
       objEve.Visit_in_Progress__c = true;
       objEve.Visit_Completed__c = false;
       objEve.OwnerId = UserInfo.getUserId();
       objEve.Whatid = objAc.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 30;
       objEve.createddate = system.today();
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
       
       Date d5= System.today()-1;
       String status5='Completed';
       Id accId5 = objAc.id;
       Task task5 = createTask(d5,status5,accId5);
       
       FeedItem post1 = new FeedItem();
       post1.body = '[Welcome to test Knowledge]';
       post1.type = 'CreateRecordEvent';
       Post1.parentid = task5.id;       
       insert post1;
       
        FeedLike fl2 = new FeedLike();
       fl2.FeedItemId = post1.id;
       insert fl2;
       
       FeedComment fc2 = new FeedComment();
       fc2.CommentBody = 'test comment';
       fc2.FeedItemId = post1.id;
       insert fc2;
               
       FeedItem post2 = new FeedItem();
       post2.body = '[Welcome to test Knowledge]';
       post2.type = 'TextPost';
       Post2.parentid = objAcWhole.id;       
       insert post2;
       
       FeedItem post3 = new FeedItem();
       post3.body = '[Welcome to test Knowledge]';
       post3.type = 'LinkPost';
       Post3.parentid = task5.id;       
       insert post3;  
       
       FeedItem post4 = new FeedItem();
       post4.body = '[Welcome to test Knowledge]';
       post4.type = 'TextPost';
       Post4.parentid = objAc.id;       
       insert post4;
       
       FeedLike fl = new FeedLike();
       fl.FeedItemId = post4.id;
       insert fl;
       
       FeedComment fc = new FeedComment();
       fc.CommentBody = 'test comment';
       fc.FeedItemId = post4.id;
       insert fc;
       
       ContentVersion v = new ContentVersion();          
        v.versionData = blob.valueOf('Test data');
        v.title = 'Test title';
        v.pathOnClient ='/foo.';
        insert v;
        
        FeedItem post5 = new FeedItem();
       post5.body = '[#priority Welcome to test Knowledge]';
       post5.type = 'TextPost';
       Post5.parentid = objAc.id; 
       post5.relatedrecordId = v.id;      
       insert post5;
       
       contentnote cv = new contentnote();
       cv.title = 'Title';
       //cv.TextPreview = 'Preview';
       insert cv;
              
       //AB_AccountDetailsService objClass = new AB_AccountDetailsService();
       AB_AccountDetailsService.AB_AccountDetails_Service();
       AB_AccountDetailsService.PrepareEventData(e);
       /*AccountIdWrapper AcWrap = new AccountIdWrapper();
       AcWrap.AccountId = string.valueOf(objAc.id);
       String myJSON = JSON.serialize(AcWrap);*/
       
       AB_AccountDetailsService.UserDetailsWrapper UserWrap = new AB_AccountDetailsService.UserDetailsWrapper(UserInfo.getUserName(),objAc.id);  //Covering inner/wrapper class
        //AcWrap.compareTo(AcWrap);  
//Covering compareTo()
    }
    
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
             Uname = usr1.Username;
             
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       objAc.billingCity = 'Hyderabad';
       objAc.billingstreet = 'ttt\r\nHyderabad';
       objAc.billingCountry = 'Hyderabad';
       objAc.billingPostalCode = '500459';
       objAc.Trade_Program_NM__c = 'MACRO';
       //objAc.Wholesaler__c = objAcWhole.id;
       insert objAc;
       
       Date d2= System.today()-1;
       String status2='Completed';
       //Id accId2 = objAcWhole.id;
       Task task2 = createTask(d2,status2,null);
       
       FeedItem post5 = new FeedItem();
       post5.body = '[#priority Welcome to test Knowledge]';
       post5.type = 'CreateRecordEvent';
       Post5.parentid = task2.id; 
       //post5.relatedrecordId = v.id;      
       insert post5;
       
       AccId = task2.id;
       AB_AccountDetailsService objClass = new AB_AccountDetailsService();
       AB_AccountDetailsService.AB_AccountDetails_Service();
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
       objAc.billingCity = 'Hyderabad';
       objAc.billingstreet = 'ttt\r\nHyderabad';
       objAc.billingCountry = 'Hyderabad';
       objAc.billingPostalCode = '500459';
       objAc.Trade_Program_NM__c = 'MACRO';
       objAc.Wholesaler__c = objAcWhole.id;
       insert objAc;
       AccId = objAc.id;
       
            
       
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
        /*usr = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '123',
             WSLRNbrRouteNbr__c = '93411D0103'
             );
             insert usr;
             Uname = usr.Username;*/
       usr = UserInfo.getUserId();
             Uname = UserInfo.getUserName();
       system.debug('Uname==test'+Uname);
       
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
         objCon.Title = 'Test Title';
         objCon.email = 'test@test.com';
         objCon.Phone = '8787878787';
         objCon.Office_Hours__c = '8AM-4PM';
         objCon.lboc_Key_Decision_Maker__c = true;
         insert objCon;
         
         Event e = new Event();
         
         e.Subject='Test for trigger';
         e.WhatId=objAc.id;
         e.CurrencyIsoCode = 'USD';
         //e.StartDateTime = system.now();
         e.OwnerId=UserInfo.getUserId();
         e.DurationInMinutes=60;
         e.activitydatetime=system.now();
         e.createddate = system.today();
         e.Type = 'Email';
         e.Description = 'string'; //string
         insert e;
         system.debug('event=='+e);
       //select name,Title,email,Phone,MobilePhone,Office_Hours__c,Delivery_Hours__c from contacts where lboc_Key_Decision_Maker__c = true
       
      // select Visit_in_Progress__c,Visit_Completed__c from Events where createddate = TODAY and owner.username
       event objEve  =  new event();
       objEve.subject = 'Test Event';
       objEve.Visit_in_Progress__c = true;
       objEve.Visit_Completed__c = false;
       objEve.OwnerId = UserInfo.getUserId();
       objEve.Whatid = objAc.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 30;
       objEve.createddate = system.today();
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
       
       Date d5= System.today()-1;
       String status5='Completed';
       Id accId5 = objAc.id;
       Task task5 = createTask(d5,status5,accId5);
       
       FeedItem post1 = new FeedItem();
       post1.body = '[Welcome to test Knowledge]';
       post1.type = 'CreateRecordEvent';
       Post1.parentid = task5.id;       
       insert post1;
       
        FeedLike fl2 = new FeedLike();
       fl2.FeedItemId = post1.id;
       insert fl2;
       
       FeedComment fc2 = new FeedComment();
       fc2.CommentBody = 'test comment';
       fc2.FeedItemId = post1.id;
       insert fc2;
               
       FeedItem post2 = new FeedItem();
       post2.body = '[Welcome to test Knowledge]';
       post2.type = 'TextPost';
       Post2.parentid = objAcWhole.id;       
       insert post2;
       
       FeedItem post3 = new FeedItem();
       post3.body = '[Welcome to test Knowledge]';
       post3.type = 'LinkPost';
       Post3.parentid = task5.id;       
       insert post3;  
       
       FeedItem post4 = new FeedItem();
       post4.body = '[Welcome to test Knowledge]';
       post4.type = 'TextPost';
       Post4.parentid = objAc.id;       
       insert post4;
       
       FeedLike fl = new FeedLike();
       fl.FeedItemId = post4.id;
       insert fl;
       
       FeedComment fc = new FeedComment();
       fc.CommentBody = 'test comment';
       fc.FeedItemId = post4.id;
       insert fc;
       
       ContentVersion v = new ContentVersion();          
        v.versionData = blob.valueOf('Test data');
        v.title = 'Test title';
        v.pathOnClient ='/foo.';
        insert v;
        
        FeedItem post5 = new FeedItem();
       post5.body = '[#priority Welcome to test Knowledge]';
       post5.type = 'TextPost';
       Post5.parentid = objAc.id; 
       post5.relatedrecordId = v.id;      
       insert post5;
       
       contentnote cv = new contentnote();
       cv.title = 'Title';
       //cv.TextPreview = 'Preview';
       insert cv;
              
       AB_AccountDetailsService objClass = new AB_AccountDetailsService();
       AB_AccountDetailsService.AB_AccountDetails_Service();
       AB_AccountDetailsService.PrepareEventData(e);
       /*AccountIdWrapper AcWrap = new AccountIdWrapper();
       AcWrap.AccountId = string.valueOf(objAc.id);
       String myJSON = JSON.serialize(AcWrap);*/
       
       AB_AccountDetailsService.UserDetailsWrapper UserWrap = new AB_AccountDetailsService.UserDetailsWrapper(UserInfo.getUserName(),objAc.id);  //Covering inner/wrapper class
       AB_AccountDetailsService.AccountTargetWrapper actTargetw = new AB_AccountDetailsService.AccountTargetWrapper('123','Core','HighEnd','FMB','colorCore','colorHighEnd','colorFmb','pgmCore','pgmHighEnd','pgmFmb','AccountName','PremiseFlag','Channel','SAPChannel','SAPColor');
       AB_AccountDetailsService.ProductImagesWrapper pImageW = new AB_AccountDetailsService.ProductImagesWrapper('ProductImage','ProductName','BrandCategory','ColorCode','Accountid','BrandPackage');
    }
}