@isTest
public class AB_UserDashboards_Service_Test{
    static testMethod void UnitTest() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User usr1 = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '10500',
             Ordering_interface__c = true
             );
             insert usr1;
        AB_UserDashboards_Service.AB_UserDashboards_Service(null,null,null,null,usr1.username,true);
    }
}