@isTest
public class AB_TaskUpdateService_Test {
    
    public static string JSONString;
    static testMethod void UnitTest() {
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        t.description = 'testing desc';
        insert t; 
        JSONString = '{\"id\":\"'+t.id+'\",\"Status\":\"In Progress\"}';
        AB_TaskUpdateService objClass = new AB_TaskUpdateService();
        AB_TaskUpdateService.AB_TaskUpdateService();
        AB_TaskUpdateService.UserNotesWrapper objWrapp = new AB_TaskUpdateService.UserNotesWrapper('','');
    }
    static testMethod void CatchTest() {
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        insert t; 
        AB_TaskUpdateService objClass = new AB_TaskUpdateService();
        AB_TaskUpdateService.AB_TaskUpdateService();
    }
}