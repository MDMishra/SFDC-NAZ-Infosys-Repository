@isTest
public class AB_UserNotesDetailsService_Test {
    public static string strJSONBody;
    static testMethod void UnitTest() {
                     
        account a = new account(name = 'rest');
        insert a;
        strJSONBody = '{\"AccountId\":\"'+a.id+'\"}';
        Note objCNote = new Note();
        objCNote.title = 'Test Title';
        objCNote.body = 'Test Body';
        objCNote.parentid = a.id;
        
        insert objCNote;
        objCNote.title = 'Test Title3';
        update objCNote;     
        AB_UserNotesDetailsService.AB_UserNotesDetailsService();
        AB_UserNotesDetailsService.UserDetailsWrapper objWrapcls = new AB_UserNotesDetailsService.UserDetailsWrapper('');
    }
    static testMethod void UnitTest2() {
    account a = new account(name = 'rest');
        insert a;
        Note objCNote = new Note();
        objCNote.title = 'Test Title';
        objCNote.parentid = a.id;
        insert objCNote;
        strJSONBody = '{\"AccountId\":\"'+a.id+'\"}';  
        AB_UserNotesDetailsService.AB_UserNotesDetailsService();
    }
}