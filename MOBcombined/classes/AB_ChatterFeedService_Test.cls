@isTest
public class AB_ChatterFeedService_Test {
    public static string Uname;
    public static string aId;
    static testMethod void unitTest() {
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
             
           Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
           account objAc = new account();
           objAc.name = 'Test Account';       
           objAc.recordtypeid = POCRtype.id;
           insert objAc;
           aId = objAc.id;
           
           AB_ChatterFeedService objClass = new AB_ChatterFeedService();
       AB_ChatterFeedService.AB_ChatterFeedService();
    }
}