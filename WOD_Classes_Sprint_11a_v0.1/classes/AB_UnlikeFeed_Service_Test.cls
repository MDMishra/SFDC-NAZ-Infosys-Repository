@isTest
public class AB_UnlikeFeed_Service_Test{
       
    static string usrName = [select UserName from user where id =: UserInfo.getUserId()].username;
    static testMethod void TestUnlike() {
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       objAc.Trade_Program_NM__c = 'MACRO';
       insert objAc;
       
       FeedItem post4 = new FeedItem();
       post4.body = '[Welcome to test Knowledge]';
       post4.type = 'TextPost';
       Post4.parentid = objAc.id;       
       insert post4;
       
       FeedLike fl = new FeedLike();
       fl.FeedItemId = post4.id;
       insert fl;
       
       AB_UnlikeFeed_Service.AB_UnlikeFeed_Service(usrName,post4.id);
   }
   static testMethod void Testlike() {
       AB_UnlikeFeed_Service.AB_UnlikeFeed_Service('usrName','post4.id');
   }
}