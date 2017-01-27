@isTest
public class AB_UserNotesUpdateService_Test {
    public static string JSONString;
    static testMethod void UnitTest() {
        JSONString = '{\"Title\":\"Test Title 2\",\"Content\":\"Helo AB Devs Insert\",\"id\":\"\",\"isDelete\":false}';
        AB_UserNotesUpdateService.AB_UserNotesUpdateService();
    }
    static testMethod void UpdatesTest() {
        account a = new account(name = 'rest');
        insert a;
        Note objCNote = new Note();
        objCNote.title = 'Test Title';
        //String body = 'Test Body';
        objCNote.body = 'Test Body';
        objCNote.parentid = a.id;
        //objCNote.createdbyid = '005f00000029fc3';
        insert objCNote;
        JSONString = '{\"Title\":\"Test Title 2\",\"Content\":\"Helo AB Devs Insert\",\"id\":\"'+objCNote.id+'\",\"isDelete\":false}';
        AB_UserNotesUpdateService.AB_UserNotesUpdateService();
        AB_UserNotesUpdateService.UserNotesWrapper objAWrap = new AB_UserNotesUpdateService.UserNotesWrapper('','','',true,'');
        
    }
    static testMethod void DeleteTest() {
    account a = new account(name = 'rest');
        insert a;
        Note objCNote = new Note();
        objCNote.title = 'Test Title';
        String body = 'Test Body';
        objCNote.body = body;
        objCNote.parentid = a.id;
        //objCNote.createdbyid = '005f00000029fc3';
        insert objCNote;
        JSONString = '{\"Title\":\"Test Title 2\",\"Content\":\"Helo AB Devs Insert\",\"id\":\"'+objCNote.id+'\",\"isDelete\":true}';
        AB_UserNotesUpdateService.AB_UserNotesUpdateService();
        
    }
}