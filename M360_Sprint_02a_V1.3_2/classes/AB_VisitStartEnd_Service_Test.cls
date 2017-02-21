@isTest
public class AB_VisitStartEnd_Service_Test {
    
    public static string JSONString;
    
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
             LocaleSidKey = 'en_US'
             );
             insert usr;
     
         JSONString = '{\"AccountId\":\"'+objAc.id+'\",'+'\"UserName\":\"'+usr.Username+'\",'+'\"EndGeoLatitude\":\"'+'17.4474120'+'\",'+'\"EndGeoLongitude\":\"'+'78.3762300'+'\",';
         JSONString = JSONString+'\"StartGeoLatitude\":\"'+'17.4474120'+'\",'+'\"StartGeoLongitude\":\"'+'78.3762300'+'\",'+'\"StartdateAndTime\":\"'+'2016-09-06 23:00:00'+'\",'+'\"EnddateAndTime\":\"'+''+'\",';
         JSONString = JSONString+'\"isVisitInprogress\":true,';
         JSONString = JSONString+'\"isStartOutOfRange\":false,'+'\"isEndOutOfRange\":false,';
         //JSONString = JSONString+'\"StartdateAndTime\":\"'+StrtdateTime+'\",'+'\"EnddateAndTime\":\"'+EnddateTime+'\"}';
         JSONString = JSONString+'\"Reason\":\"'+'Order Entry'+'\",'+'\"isVisitCompleted\":true}';
             
         event objEve  =  new event();
         objEve.subject = 'Test Event';
         objEve.Visit_in_Progress__c = true;
         objEve.OwnerId = usr.id;
         objEve.Whatid = objAc.id;
         objEve.ActivityDateTime = system.today();
         objEve.DurationInMinutes = 30;
         insert objEve;
      
       AB_VisitStartEnd_Service.AB_VisitStartEnd_Service();
       AB_VisitStartEnd_Service.VisitDetailsWrapper objwrapcls = new  AB_VisitStartEnd_Service.VisitDetailsWrapper('','','','','','','','',true,true,true,'',true,'');    
       //AB_VisitStartEnd_Service.VisitDetailsWrapper UserWrap = new AB_VisitStartEnd_Service.VisitDetailsWrapper();  //Covering inner/wrapper class
        
    }
    static testMethod void NoEvntTest() {
       //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
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
             
             
             JSONString = '{\"AccountId\":\"'+objAc.id+'\",'+'\"UserName\":\"'+usr.Username+'\",'+'\"EndGeoLatitude\":\"'+'17.4474120'+'\",'+'\"EndGeoLongitude\":\"'+'78.3762300'+'\",';
            JSONString = JSONString+'\"StartGeoLatitude\":\"'+'17.4474120'+'\",'+'\"StartGeoLongitude\":\"'+'78.3762300'+'\",'+'\"StartdateAndTime\":\"'+'2016-09-06 23:00:00'+'\",'+'\"EnddateAndTime\":\"'+'2016-09-06 23:20:00'+'\",';
            JSONString = JSONString+'\"isVisitInprogress\":true,';
            JSONString = JSONString+'\"isStartOutOfRange\":false,'+'\"isEndOutOfRange\":false,';
            //JSONString = JSONString+'\"StartdateAndTime\":\"'+StrtdateTime+'\",'+'\"EnddateAndTime\":\"'+EnddateTime+'\"}';
            JSONString = JSONString+'\"Reason\":\"'+'Order Entry'+'\",'+'\"isVisitCompleted\":true}';
             
      
       AB_VisitStartEnd_Service.AB_VisitStartEnd_Service();
                     
    }
}