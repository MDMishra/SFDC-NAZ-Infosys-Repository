@isTest
public class AB_VisitedAndFutureActivities_Test{
    public static string accId;
    public static Route_Schedule__c TestDta(Route__c objRte,Account objAc,integer i){
       Route_Schedule__c route = new Route_Schedule__c();
       route.Route__c = objRte.id;
       route.SeqNbr__c = 1;
       route.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route.StopDate__c = System.today().addMonths(i);
      // route.Sales_Rep__c = usr;
       insert route;	
    return route;	
   
    }
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
       objEve.subject = 'POC VISIT Test Event';
       objEve.Visit_in_Progress__c = true;
       objEve.OwnerId = usr.id;
       objEve.Whatid = objAc.id;
       objEve.ActivityDateTime = system.today();
       objEve.DurationInMinutes = 30;
       insert objEve;
       
       event objEve2  =  new event();
       objEve2.subject = 'Test Event';
       objEve2.Visit_in_Progress__c = true;
       objEve2.OwnerId = usr.id;
       objEve2.Whatid = objAc.id;
       objEve2.ActivityDateTime = system.today();
       objEve2.DurationInMinutes = 30;
       insert objEve2;
       
        Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = usr.WSLRNbrRouteNbr__c;
       insert objRte;
       
       Route_Schedule__c route = new Route_Schedule__c();
       route.Route__c = objRte.id;
       route.SeqNbr__c = 1;
       route.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route.StopDate__c = System.today().addDays(2);
      // route.Sales_Rep__c = usr;
       insert route;
       
       /*Route_Schedule__c route2 = new Route_Schedule__c();
       route2.Route__c = objRte.id;
       route2.SeqNbr__c = 1;
       route2.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route2.StopDate__c = System.today().addMonths(1);
      // route.Sales_Rep__c = usr;
       insert route2;*/
       Route_Schedule__c route1 = TestDta(objRte,objAc,1);
       Route_Schedule__c route2 = TestDta(objRte,objAc,2);
       Route_Schedule__c route3 = TestDta(objRte,objAc,3);
       Route_Schedule__c route4 = TestDta(objRte,objAc,4);
       Route_Schedule__c route5 = TestDta(objRte,objAc,5);
       Route_Schedule__c route6 = TestDta(objRte,objAc,6);
       Route_Schedule__c route7 = TestDta(objRte,objAc,7);
       Route_Schedule__c route8 = TestDta(objRte,objAc,8);
       Route_Schedule__c route9 = TestDta(objRte,objAc,9);
       Route_Schedule__c route10 = TestDta(objRte,objAc,10);
       Route_Schedule__c route11 = TestDta(objRte,objAc,11);
       
       AB_VisitedAndFutureActivities_Service objCls = new AB_VisitedAndFutureActivities_Service();
       AB_VisitedAndFutureActivities_Service.AB_VisitedAndFutureActivities_Service();
       AB_VisitedAndFutureActivities_Service.RequestWrapper bjWrap = new AB_VisitedAndFutureActivities_Service.RequestWrapper('');
   }
   
}