@isTest
public class AB_TaskUpdateService_Test {
    public static string TaskId;
   
    static testMethod void UnitTest() {
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        insert t; 
        TaskId = t.id;
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
        //TaskId = t.id;
        AB_TaskUpdateService objClass = new AB_TaskUpdateService();
        AB_TaskUpdateService.AB_TaskUpdateService();
    }
}