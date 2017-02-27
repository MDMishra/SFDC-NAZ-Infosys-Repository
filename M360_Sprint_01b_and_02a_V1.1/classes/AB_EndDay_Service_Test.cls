@isTest
public class AB_EndDay_Service_Test {
    //public static string strJSONBody;
    static testMethod void UnitTest() {
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
        account a = new account(name = 'rest');
        insert a;
        //strJSONBody = '{\"AccountId\":\"'+a.id+'\"}';
         event objEve  =  new event();
         objEve.subject = 'POC VISIT Test Event';
         objEve.Visit_in_Progress__c = false;
         objEve.Visit_Completed__c = true;
         objEve.OwnerId = usr.id;
         objEve.Whatid = a.id;
         //objEve.ActivityDateTime = system.now();
         objEve.StartDateTime = system.now();
         objEve.EndDateTime = system.now();
         
         objEve.DurationInMinutes = 0;
         insert objEve;
        
           
        AB_EndDay_Service.AB_EndDay_Service(usr.Username);
        //AB_EndDay_Service.UserDetailsWrapper objWrapcls = new AB_EndDay_Service.UserDetailsWrapper(usr.Username);
    }
 }