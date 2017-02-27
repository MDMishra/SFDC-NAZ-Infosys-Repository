//test class for AB_UserAuthentication and AB_EndDayDate_Service
@isTest
public class AB_UserAuthentication_Test {
    public static string strJSONBody;
    static testMethod void myTest() {
       //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       insert objAc;
       
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'BAM Manager Platform User' LIMIT 1];
  
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
             WSLRNbrRouteNbr__c = '0D010093041',
             M360_Dashboards__c = 't1,t2,t3,t4',
             Ordering_interface__c = true,
             M360_EndDayDate__c = system.today()
             );
             insert usr;
             strJSONBody = '{\"username\":\"'+usr.Username+'\"}';
             
       Route__c rte = new Route__c();
       rte.WSLRNbrRouteNbr__c = '0D010093041';
       insert rte;
      
       AB_UserAuthentication objClass = new AB_UserAuthentication();
       AB_UserAuthentication.AB_UserAuthentication();
       
       AB_EndDayDate_Service.AB_EndDayDate_Service(usr.username,true);
             
       AB_UserAuthentication.UserDetailsWrapper UserWrap = new AB_UserAuthentication.UserDetailsWrapper();  //Covering inner/wrapper class
        
    }
    
    static testMethod void UserTest() {
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
             Username = 'jasontr.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             WSLRNbrRouteNbr__c = '0D010093041',
             M360_Dashboards__c = 't1,t2,t3',
             Ordering_interface__c = true
             );
             insert usr;
             strJSONBody = '{\"username\":\"'+usr.Username+'\"}';
             
       Route__c rte = new Route__c();
       rte.WSLRNbrRouteNbr__c = '0D010093041';
       insert rte;
      
       AB_UserAuthentication objClass = new AB_UserAuthentication();
       AB_UserAuthentication.AB_UserAuthentication();
             
       AB_UserAuthentication.UserDetailsWrapper UserWrap = new AB_UserAuthentication.UserDetailsWrapper();  //Covering inner/wrapper class
       
       AB_EndDayDate_Service.AB_EndDayDate_Service(usr.username,false); 
    }
    static testMethod void myTest2() {
    
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
        User usr = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jasontr.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             WSLRNbrRouteNbr__c = '0D010093041',
             //M360_Dashboards__c = 't1,t2,t3',
             Ordering_interface__c = true
             );
             insert usr;
        
        strJSONBody = '{\"username\":\"'+usr.username+'\"}';
        AB_UserAuthentication.AB_UserAuthentication();
    }
}