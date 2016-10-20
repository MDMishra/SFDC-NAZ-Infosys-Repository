@isTest
public class AB_VisitStartEnd_Service_Test {
    public static string Uname;
    public static string AId;
    public static string EndGeoLatitude;
    public static string EndGeoLongitude;
    public static string StartGeoLatitude;
    public static string StartGeoLongitude;
    public static boolean isVisitInprogress;
    public static boolean isStartOutOfRange;
    public static boolean isEndOutOfRange;
    public static string Reason;
    public static boolean isVisitCompleted;
    public static string StartdateAndTime;
    public static string EnddateAndTime;
    
    static testMethod void myTest() {
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
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
             LocaleSidKey = 'en_US'
             );
             insert usr;
             Uname = usr.Username;
             AId = objAc.id;
             EndGeoLatitude = '17.4474120';
             EndGeoLongitude = '78.3762300';
             StartGeoLatitude = '17.4474120';
             StartGeoLongitude = '78.3762300';
             isVisitInprogress = true;
             isStartOutOfRange = false;
             isEndOutOfRange = false;
             Reason = 'Order Entry';
             isVisitCompleted = true; 
             StartdateAndTime = '2016-09-06 23:00:00';
             EnddateAndTime = '';
             system.debug('Uname==test'+Uname);
             
     event objEve  =  new event();
     objEve.subject = 'Test Event';
     objEve.Visit_in_Progress__c = true;
     objEve.OwnerId = usr.id;
     objEve.Whatid = objAc.id;
     objEve.ActivityDateTime = system.today();
     objEve.DurationInMinutes = 30;
     insert objEve;
      
       AB_VisitStartEnd_Service objClass = new AB_VisitStartEnd_Service();
       AB_VisitStartEnd_Service.AB_VisitStartEnd_Service();
             
       //AB_VisitStartEnd_Service.VisitDetailsWrapper UserWrap = new AB_VisitStartEnd_Service.VisitDetailsWrapper();  //Covering inner/wrapper class
        
    }
    static testMethod void NoEvntTest() {
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
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
             LocaleSidKey = 'en_US'
             );
             insert usr;
             Uname = usr.Username;
             AId = objAc.id;
             EndGeoLatitude = '17.4474120';
             EndGeoLongitude = '78.3762300';
             StartGeoLatitude = '17.4474120';
             StartGeoLongitude = '78.3762300';
             isVisitInprogress = true;
             isStartOutOfRange = false;
             isEndOutOfRange = false;
             Reason = 'Order Entry';
             isVisitCompleted = true; 
             StartdateAndTime = '2016-09-06 23:00:00';
             EnddateAndTime = '';
             system.debug('Uname==test'+Uname);
             
     
      
       AB_VisitStartEnd_Service objClass = new AB_VisitStartEnd_Service();
       AB_VisitStartEnd_Service.AB_VisitStartEnd_Service();
             
       //AB_VisitStartEnd_Service.VisitDetailsWrapper UserWrap = new AB_VisitStartEnd_Service.VisitDetailsWrapper();  //Covering inner/wrapper class
        
    }
}