@isTest
public class AB_MutedFeedsService_Test {
    
    public static string strJSONBody;
    static testMethod void UnitTest1() {
        Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
        account objAc = new account();
        objAc.name = 'Test Account';
        objAc.recordtypeid = rt.id;
        insert objAc;
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
             muteFeeds__c = 'Test,ing'
             );
        insert usr1;
        strJSONBody = '{\"UserName\":\"'+usr1.Username+'\"}';
        AB_MutedFeedsService.AB_MutedFeedsService();
        AB_MutedFeedsService.UserWrapper objWrapp = new AB_MutedFeedsService.UserWrapper('Uname');
    }
    static testMethod void noUsersTest() {
        strJSONBody = '{\"UserName\":\"'+'tester'+'\"}';
        AB_MutedFeedsService.AB_MutedFeedsService();
    }
    static testMethod void catchTest() {
        
        AB_MutedFeedsService.AB_MutedFeedsService();
    }
}