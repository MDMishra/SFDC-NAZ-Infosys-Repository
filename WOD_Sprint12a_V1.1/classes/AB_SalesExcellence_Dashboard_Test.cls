@isTest
public class AB_SalesExcellence_Dashboard_Test {
    public static string Uname;
    static string usrNmbr = '93411D0106';//[select WSLRNbrRouteNbr__c from user where id =: UserInfo.getUserId()].WSLRNbrRouteNbr__c;
    static testMethod void myTest() {
      // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       insert objAc;
       
       Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
       User usr = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             WSLRNbrRouteNbr__c = '93411D0106',
             LocaleSidKey = 'en_US'
             );
             insert usr;
       Uname = usr.Username;
             
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
       
       event objEve  =  new event();
       objEve.subject = 'Test Event';
       objEve.Visit_Completed__c = true;
       objEve.Out_of_Range_on_Start__c = false;
       objEve.Out_of_Range_on_End__c = false;
       objEve.EndDateTime = system.today();
       objEve.OwnerId = usr.id;
       objEve.Whatid = objAc.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 0;
       insert objEve;
       
       objEve.Out_of_Range_on_Start__c = true;
       objEve.Out_of_Range_on_End__c = true;
       update objEve;
      
       AB_SalesExcellence_Dashboard objClass = new AB_SalesExcellence_Dashboard();
       AB_SalesExcellence_Dashboard.AB_SalesExcellence_Dashboard();
       AB_SalesExcellence_Dashboard.UserDetailsWrapper objUserDets = new AB_SalesExcellence_Dashboard.UserDetailsWrapper(Uname);
   }
   //method to code coverage of AB_salesExcelleceTrg triiger
   static testMethod void SalesExcTrgrTest() {
      // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       insert objAc;
       
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
       Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
       User usr = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             WSLRNbrRouteNbr__c = '93411D0106',
             LocaleSidKey = 'en_US'
             );
             insert usr;
       
       event objEve  =  new event();
       objEve.subject = 'Test Event';
       objEve.Visit_Completed__c = true;
       objEve.Out_of_Range_on_Start__c = true;
       objEve.Out_of_Range_on_End__c = true;
       objEve.EndDateTime = system.today();
       objEve.OwnerId = usr.id;
       objEve.Whatid = objAc.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 0;
       insert objEve;
       
       objEve.Out_of_Range_on_Start__c = false;
       objEve.Out_of_Range_on_End__c = false;
       update objEve;
   }
}