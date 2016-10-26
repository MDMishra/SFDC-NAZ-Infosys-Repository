@isTest
public class AB_ForgotPassword_Test {
    public static string Uname;
   
    static testMethod void myTest() {
              
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
       system.debug('Uname==test'+Uname);
      
       AB_ForgotPassword objClass = new AB_ForgotPassword();
       AB_ForgotPassword.AB_ForgotPassword();
             
       AB_ForgotPassword.UserDetailsWrapper UserWrap = new AB_ForgotPassword.UserDetailsWrapper(usr.Username);  //Covering inner/wrapper class
        
    }
}