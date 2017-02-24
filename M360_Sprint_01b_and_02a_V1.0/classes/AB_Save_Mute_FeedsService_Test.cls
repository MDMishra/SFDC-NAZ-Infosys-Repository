@isTest
public class AB_Save_Mute_FeedsService_Test {// implements HttpCalloutMock
    
    public static string strJSONBody ='';
    static testMethod void UnitTest() {
        string usrnme = [select id,username from user where id =: UserInfo.getUserId() limit 1].username;
        strJSONBody = '{\"UserName\":\"'+usrnme+'\",\"FeedItemId\":\"appshark@2\",\"MuteValue\":\"true\"}';
        AB_Save_Mute_FeedsService objClass = new AB_Save_Mute_FeedsService();
        AB_Save_Mute_FeedsService.AB_Save_Mute_FeedsService();
        AB_Save_Mute_FeedsService.UserWrapper uWrapr = new AB_Save_Mute_FeedsService.UserWrapper('','','');
    }
    static testMethod void UnitTest2() {
        strJSONBody = '{\"UserName\":\"\",\"FeedItemId\":\"appshark@2\",\"MuteValue\":\"true\"}';
        AB_Save_Mute_FeedsService objClass = new AB_Save_Mute_FeedsService();
        AB_Save_Mute_FeedsService.AB_Save_Mute_FeedsService();
        AB_Save_Mute_FeedsService.UserWrapper uWrapr = new AB_Save_Mute_FeedsService.UserWrapper('','','');
    }
    
}