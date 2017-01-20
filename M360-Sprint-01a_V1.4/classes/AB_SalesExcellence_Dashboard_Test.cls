@isTest
public class AB_SalesExcellence_Dashboard_Test {
    public static string strJSONBody; 
    static string usrNmbr = '93411D0106';//[select WSLRNbrRouteNbr__c from user where id =: UserInfo.getUserId()].WSLRNbrRouteNbr__c;
    static testMethod void myTest() {
      // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
      
       Frequency__c objFreq = new Frequency__c(name = 'Test Frequency');
       insert objFreq;
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       objAc.Delivery_Frequency__c = objFreq.id;
        
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
       strJSONBody = '{\"username\":\"'+usr.Username+'\"}'; 
            
       Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = usrNmbr;
       objRte.RouteNbr__c = 'TestR1';
       objRte.Call_Route_Adherence__c = 80;
       objRte.Tapwiser_Adherence__c=80;
       objRte.Strike_Rate_Adherence__c=40;
       insert objRte;
       
       Route_Schedule__c route = new Route_Schedule__c();
       route.Route__c = objRte.id;
       route.SeqNbr__c = 1;
       route.Account__C = objAc.id;
       route.RouteNbr__c = 'TestR1';
       //route.Schedule_Date__c = system.today();
       route.StopDate__c = System.today();
      // route.Sales_Rep__c = usr;
       insert route;
       
       Route_Schedule__c route2 = new Route_Schedule__c();
       route2.Route__c = objRte.id;
       route2.SeqNbr__c = 1;
       route2.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route2.StopDate__c = System.today();
       route2.RouteNbr__c = 'TestR1';
      // route.Sales_Rep__c = usr;
       insert route2;
       
       ONTAP__Order__c objOrdr =  new ONTAP__Order__c();
       objOrdr.ONTAP__OrderAccount__c = objAc.id;
       //objOrdr.ONTAP__Account__c = objAc.id;
       objOrdr.RAS_RouteNbr__c = 'TestR1';
        objOrdr.OnCall_Account__c = objAc.id;
        objOrdr.Delivery_Date__c = system.today();
       objOrdr.RAS_SubmitDateTime__c = system.now();
       insert objOrdr;
       
       ONTAP__Order__c objOrdr2 =  new ONTAP__Order__c();
       objOrdr2.ONTAP__OrderAccount__c = objAc.id;
       //objOrdr2.ONTAP__Account__c = objAc.id;
       objOrdr2.RAS_RouteNbr__c = 'TestR1';
        objOrdr2.OnCall_Account__c = objAc.id;
        objOrdr2.Delivery_Date__c = system.today();
       objOrdr2.RAS_SubmitDateTime__c = system.now();
       insert objOrdr2;
       
       RouteCust__c objCust = new RouteCust__c();
       objCust.Route__c = objRte.id;
       objCust.Account__c = objAc.id;
       objCust.WSLRNbrRouteNbr__c = usr.WSLRNbrRouteNbr__c;
       insert objCust;
       
       
       MOB_Sales_Volume_Route__c objSVR =  new MOB_Sales_Volume_Route__c();
       objSVR.Actual_Volume__c = 300;
       objSVR.Brand_Category__c = 'ABI';
       objSVR.Target_Volume__c = 600;
       //objSVR.Daily_Challenge__c = 900;
       objSVR.Date__c = system.today();
       objSVR.Route__c = objRte.id;
       objSVR.Sales_Days__c = 98;
       insert objSVR;
       
       MOB_Sales_Volume_Account__c objSVA =  new MOB_Sales_Volume_Account__c();
       objSVA.Actual_Volume__c = 300;
       objSVA.Brand_Category__c = 'ABI';
       objSVA.Target_Volume__c = 600;
       //objSVA.Daily_Challenge__c = 900;
       objSVA.Date__c = system.today();
       objSVA.Account__c = objAc.id;
       objSVA.Sales_Days__c = 98;
       insert objSVA;
              
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
      
       AB_SalesExcellence_Dashboard.AB_SalesExcellence_Dashboard();
       AB_SalesExcellence_Dashboard.UserDetailsWrapper objUserDets = new AB_SalesExcellence_Dashboard.UserDetailsWrapper(usr.Username,'','');
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