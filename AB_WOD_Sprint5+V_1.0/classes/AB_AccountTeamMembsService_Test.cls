@isTest
public class AB_AccountTeamMembsService_Test {
    public static string accId;
    public static string UName;
    static testMethod void myTest() {
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       insert objAc;
       accId = objAc.id;
       system.debug('accId==test'+accId);
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
       UName = usr.Username;
       AccountTeamMember objAteam = new AccountTeamMember();
       objAteam.UserId = usr.id;
       objAteam.TeamMemberRole = 'BAM';
       objAteam.AccountAccessLevel = 'Edit';
       objAteam.CaseAccessLevel = 'Edit'; 
       objAteam.OpportunityAccessLevel = 'Edit';
       objAteam.AccountId =objAc.id; 
       
       insert objAteam;
       system.debug('objAteam=test='+objAteam);
       
       AB_AccountTeamMembsService objClass = new AB_AccountTeamMembsService();
       AB_AccountTeamMembsService.AB_AccountTeamMembsService();
       /*AccountIdWrapper AcWrap = new AccountIdWrapper();
       AcWrap.AccountId = string.valueOf(objAc.id);
       String myJSON = JSON.serialize(AcWrap);*/
       
       //AB_AccountTeamMembsService.AccountIdWrapper AcWrap = new AB_AccountTeamMembsService.AccountIdWrapper(objAc.id,usr.UserName);  //Covering inner/wrapper class
        //AcWrap.compareTo(AcWrap);  
//Covering compareTo()
    }
}