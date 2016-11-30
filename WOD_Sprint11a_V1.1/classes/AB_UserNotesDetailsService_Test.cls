@isTest
public class AB_UserNotesDetailsService_Test {
    public static string Uname;
   
    static testMethod void UnitTest() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
        User usr = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US'
             );
             insert usr;
             user objU = [select id,name,username from user where id =: UserInfo.getUserId()];
             Uname = objU.username;
        ContentNote objCNote = new ContentNote();
        objCNote.title = 'Test Title';
        String body = 'Test Body';
        objCNote.Content = Blob.valueOf(body.escapeHTML4());
        //objCNote.createdbyid = '005f00000029fc3';
        insert objCNote;
             
        AB_UserNotesDetailsService objClass = new AB_UserNotesDetailsService();
        AB_UserNotesDetailsService.AB_UserNotesDetailsService();
        AB_UserNotesDetailsService.UserDetailsWrapper objWrapcls = new AB_UserNotesDetailsService.UserDetailsWrapper('');
        //AB_UserNotesDetailsService.PrepareNoteData();
    }
}