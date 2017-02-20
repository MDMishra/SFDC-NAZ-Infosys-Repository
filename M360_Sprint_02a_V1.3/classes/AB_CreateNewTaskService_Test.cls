@isTest
public class AB_CreateNewTaskService_Test {
    public static string JSONString;
   
    static testMethod void TryTest() {
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
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '123'
             );
             insert usr;
                
        Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
        account objAc = new account();
        objAc.name = 'Test Account';       
        objAc.recordtypeid = POCRtype.id;
        insert objAc;
        
        JSONString = '{\"Subject\":\"Test Subject\",\"DueDate\":\"'+system.today()+'\",\"AssignedTo\":\"'+usr.id+'\",\"Accountid\":\"'+objAc.id+'\",\"Priority\":\"Normal\",\"Category\":\"Display\",\"Description\":\"Hello\"}';
        AB_CreateNewTaskService objClass = new AB_CreateNewTaskService();
        AB_CreateNewTaskService.AB_CreateNewTaskService();
        AB_CreateNewTaskService.TaskWrapper objWrap = new AB_CreateNewTaskService.TaskWrapper('trinSubject','DueDate','AssignedTo','Accountid','Priority','Category','Description');
    }
    static testMethod void CatchTest() {
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
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '123'
             );
             insert usr;
                
        Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
        account objAc = new account();
        objAc.name = 'Test Account';       
        objAc.recordtypeid = POCRtype.id;
        insert objAc;
        
        JSONString = '{\"Subject\":\"Test Subject\",\"DueDate\":\"'+system.today()+'\",\"AssignedTo\":\"'+usr.Username+'\",\"Accountid\":\"'+objAc.id+'\",\"Priority\":\"Normal\",\"Category\":\"Display\",\"Description\":\"Hello\"}';
        AB_CreateNewTaskService objClass = new AB_CreateNewTaskService();
        AB_CreateNewTaskService.AB_CreateNewTaskService();
    }
}