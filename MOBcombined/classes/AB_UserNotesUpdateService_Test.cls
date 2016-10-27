@isTest
public class AB_UserNotesUpdateService_Test {
    public static string NoteId;
    public static boolean isDelete;
   
    static testMethod void UnitTest() {
        AB_UserNotesUpdateService objClass = new AB_UserNotesUpdateService();
        AB_UserNotesUpdateService.AB_UserNotesUpdateService();
    }
    static testMethod void UnitTest2() {
        ContentNote objCNote = new ContentNote();
        objCNote.title = 'Test Title';
        String body = 'Test Body';
        objCNote.Content = Blob.valueOf(body.escapeHTML4());
        //objCNote.createdbyid = '005f00000029fc3';
        insert objCNote;
        NoteId = objCNote.id;
        AB_UserNotesUpdateService objClass = new AB_UserNotesUpdateService();
        AB_UserNotesUpdateService.AB_UserNotesUpdateService();
        
    }
    static testMethod void UnitTest3() {
        ContentNote objCNote = new ContentNote();
        objCNote.title = 'Test Title';
        String body = 'Test Body';
        objCNote.Content = Blob.valueOf(body.escapeHTML4());
        //objCNote.createdbyid = '005f00000029fc3';
        insert objCNote;
        NoteId = objCNote.id;
        isDelete = true;
        AB_UserNotesUpdateService objClass = new AB_UserNotesUpdateService();
        AB_UserNotesUpdateService.AB_UserNotesUpdateService();
        
    }
}