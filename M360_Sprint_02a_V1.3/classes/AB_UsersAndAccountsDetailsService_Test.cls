@isTest
public class AB_UsersAndAccountsDetailsService_Test {
    public static string strJSONBody;
    static testMethod void UnitTest1() {
       Recordtype WholesalerRType = [select id ,name from recordtype where sobjecttype = 'account' and name ='Wholesaler'];
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       insert objAc;
       
       account objAcWhole = new account();
       objAcWhole.name = 'Test Account';       
       objAcWhole.recordtypeid = WholesalerRType.id;
       objAcWhole.WSLR_NBR_US__c = '123';
       insert objAcWhole;
       
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
             Wholesaler_Number__c = '123',
             WSLRNbrRouteNbr__c = '4556',
             IsActive = true
             );
             insert usr;
       strJSONBody = '{\"username\":\"'+usr.Username+'\",\"accountid\":\"'+objAc.id+'\"}';
       Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = '4556';
       insert objRte;
       
       Route_Schedule__c route = new Route_Schedule__c();
       route.Route__c = objRte.id;
       route.SeqNbr__c = 1;
       route.Account__C = objAc.id;
       //route.Schedule_Date__c = system.today();
       route.StopDate__c = System.today();
       //route.Sales_Rep__c = usr;
       insert route;
       
       AccountTeamMember objAteam = new AccountTeamMember ();
       objAteam.UserId = usr.id;
       objAteam.TeamMemberRole = 'BAM';
       objAteam.AccountAccessLevel = 'Edit';
       objAteam.CaseAccessLevel = 'Edit'; 
       objAteam.OpportunityAccessLevel = 'Edit';
       objAteam.AccountId =objAc.id;       
       insert objAteam;
       
       AB_UsersAndAccountsDetailsService.AB_UsersAndAccountsDetailsService();
       AB_UsersAndAccountsDetailsService.UserDetailsWrapper objWrap = new AB_UsersAndAccountsDetailsService.UserDetailsWrapper('','');
    }
    static testMethod void UnitTest2() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
        User usr = new User(LastName = 'LIVESTON',FirstName='JASON',Alias = 'jliv',Email = 'jason.liveston@asdf.com',Username = 'jason.lieston@asp.com',ProfileId = profileId.id,           
             TimeZoneSidKey = 'GMT',LanguageLocaleKey = 'en_US',EmailEncodingKey = 'UTF-8',LocaleSidKey = 'en_US',Wholesaler_Number__c = '123',WSLRNbrRouteNbr__c = '4556',IsActive = true
             );
             insert usr;
        strJSONBody = '{\"username\":\"'+usr.Username+'\"}';
       User usr2 = new User(LastName = 'LIVESTON2',FirstName='JASON2',Alias = 'jliv2',Email = 'jason.liveston2@asdf.com',Username = 'jason.lieston2@asp.com',ProfileId = profileId.id,           
             TimeZoneSidKey = 'GMT',LanguageLocaleKey = 'en_US',EmailEncodingKey = 'UTF-8',LocaleSidKey = 'en_US',Wholesaler_Number__c = '123',WSLRNbrRouteNbr__c = '4556',IsActive = true
             );
             insert usr2;      
        
        AB_UsersAndAccountsDetailsService.AB_UsersAndAccountsDetailsService();
    }
}