@isTest
public class AB_VisitedAndFutureActivities_Test{
    public static string accId;
    static testMethod void TestActs() {
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       insert objAc;
       accId = objAc.id;
       system.debug('accId==test'+accId);
       
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
             LocaleSidKey = 'en_US',
             WSLRNbrRouteNbr__c = '234524'
             );
             insert usr;
             
       event objEve  =  new event();
       objEve.subject = 'Test Event';
       objEve.Visit_in_Progress__c = true;
       objEve.OwnerId = usr.id;
       objEve.Whatid = objAc.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 30;
       insert objEve;
       
        Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = usr.WSLRNbrRouteNbr__c;
       insert objRte;
       
       Route_Schedule__c route = new Route_Schedule__c();
       route.Route__c = objRte.id;
       route.SeqNbr__c = 1;
       route.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route.StopDate__c = System.today();
      // route.Sales_Rep__c = usr;
       insert route;
       
       AB_VisitedAndFutureActivities_Service objCls = new AB_VisitedAndFutureActivities_Service();
       AB_VisitedAndFutureActivities_Service.AB_VisitedAndFutureActivities_Service();
   }
   
}