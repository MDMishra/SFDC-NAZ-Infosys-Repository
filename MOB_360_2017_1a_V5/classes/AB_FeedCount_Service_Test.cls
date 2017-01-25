@isTest
public class AB_FeedCount_Service_Test{
       
    static testMethod void TestMuteCount() {
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
             muteFeeds__c = '4444,5555'
             );
             insert usr1;
             string Uname = usr1.Username;
             
       
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       objAc.Trade_Program_NM__c = 'MACRO';
       insert objAc;
       
       FeedItem post4 = new FeedItem();
       post4.body = '#priority[Welcome to test Knowledge]';
       post4.type = 'TextPost';
       Post4.parentid = objAc.id;       
       insert post4;
       
       FeedItem post5 = new FeedItem();
       post5.body = '[Welcome to test Knowledge]';
       post5.type = 'TextPost';
       Post5.parentid = objAc.id;       
       insert post5;
       
       AB_FeedCount_Service.AB_FeedCount_Service(Uname,objAc.id);
   }
   static testMethod void TestCatch() {
       AB_FeedCount_Service.AB_FeedCount_Service('Uname','objAc.id');
   }
}