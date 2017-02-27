@isTest
public class AB_AccountTeamfromRouteCust_Test{
    public static string accId;
    public static string UName;
    public static string routeId;

    static testMethod void myTest() {
       
        
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       insert objAc;
       account objAc1 = new account();
       objAc1.name = 'Test Account1';
       objAc1.recordtypeid = rt.id;
       insert objAc1 ;
       accId = objAc.id;
       Route__c objRoute = new Route__c();
       objRoute.WSLRNbrRouteNbr__c= 'Test123';
       insert objRoute;
       Route__c objRoute1 = new Route__c();
       objRoute1.WSLRNbrRouteNbr__c= 'Test1234';
       insert objRoute1 ;
       routeId = objRoute.id;
       RouteCust__c objRouteCust = new RouteCust__c ();
       objRouteCust.WSLRNbrRouteNbr__c = 'Test123';
       objRouteCust.Account__c =accId;
       objRouteCust.Route__c = routeId;
       insert objRouteCust;
       objRouteCust.Account__c =objAc1.id;
       update objRouteCust;
       
       RouteCust__c objRouteCust1 = new RouteCust__c ();
       objRouteCust1.id =  objRouteCust.id;
       objRouteCust1.WSLRNbrRouteNbr__c = 'Test1234';
       objRouteCust1.Account__c =objAc1.id;
       objRouteCust1.Route__c = routeId;
       //update objRouteCust1 ;
       RouteCust__c objRouteCust2 = new RouteCust__c ();
       objRouteCust2.id = objRouteCust1.id;
       delete objRouteCust2;
       
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
             LocaleSidKey = 'en_US',
             WSLRNbrRouteNbr__c = 'Test123'
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
       list<user> lstUsers = new list<user>();
       lstUsers.add(usr);
       list<RouteCust__c> lstrcust = new list<RouteCust__c>();
       lstrcust.add(objRouteCust); 
       
       insert objAteam;
       system.debug('objAteam=test='+objAteam);
       
       //AB_AccountTeam objClass = new AB_AccountTeam();
       //AB_AccountTeam.addAccountTeam(lstUsers);
       //AB_AccountTeam.deleteAccountTeam(lstUsers);
       AB_AccountTeam.addAccountteamfromRouteCust(lstrcust);
       AB_AccountTeam.deleteAccountTeams(lstrcust);
       //AB_AccountTeamMembsService.AB_AccountTeamMembsService();
       /*AccountIdWrapper AcWrap = new AccountIdWrapper();
       AcWrap.AccountId = string.valueOf(objAc.id);
       String myJSON = JSON.serialize(AcWrap);*/
       
       //AB_AccountTeamMembsService.AccountIdWrapper AcWrap = new AB_AccountTeamMembsService.AccountIdWrapper(objAc.id,usr.UserName);  //Covering inner/wrapper class
       //AcWrap.compareTo(AcWrap);  
       //Covering compareTo()
    }
}