@isTest
public class AB_UserAuthentication_Test {
    public static string Uname;
    //public static string Pword;
    static testMethod void myTest() {
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
             Uname = usr.Username;
             //Pword = 'Hello123';
             system.debug('Uname==test'+Uname);
      
       AB_UserAuthentication objClass = new AB_UserAuthentication();
       AB_UserAuthentication.AB_UserAuthentication();
             
       AB_UserAuthentication.UserDetailsWrapper UserWrap = new AB_UserAuthentication.UserDetailsWrapper();  //Covering inner/wrapper class
        
    }
    static testMethod void myTest2() {
        
        AB_UserAuthentication.AB_UserAuthentication();
    }
}