@isTest
public class AB_AccountTeam_Test {
    public static string accId;
    public static string UName;
    public static string routeId;

    static testMethod void myTest() {
       
        
       Recordtype rt = [select id from Recordtype where SobjectType = 'Account' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       insert objAc;
       accId = objAc.id;
       Route__c objRoute = new Route__c();
       objRoute.WSLRNbrRouteNbr__c= 'Test123';
       insert objRoute;
       Route__c objRoute1 = new Route__c();
       objRoute1 .WSLRNbrRouteNbr__c= 'Test1234';
       insert objRoute1 ;
       routeId = objRoute.id;
       RouteCust__c objRouteCust = new RouteCust__c ();
       objRouteCust.WSLRNbrRouteNbr__c = 'Test123';
       objRouteCust.Account__c =accId;
       objRouteCust.Route__c = routeId;
       insert objRouteCust;
       
       
       system.debug('accId==test'+accId);
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
  
        User usr = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.liestonyyy@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             WSLRNbrRouteNbr__c = 'Test123'
             );
             insert usr;
            
            /* usr.WSLRNbrRouteNbr__c = 'Test1234'; 
             update usr; 
             
              usr.WSLRNbrRouteNbr__c = ''; 
              update usr; */
            
               
       User usr1 = new User(LastName = 'LIVESTON',
             FirstName='JASONh',
             Alias = 'jlivh',
             Email = 'jason.livestohhhn@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US'
             //WSLRNbrRouteNbr__c = 'Test123'
             );
             insert usr1;
             usr1.WSLRNbrRouteNbr__c = 'Test1234788'; 
             update usr1;
             
              usr1.WSLRNbrRouteNbr__c = ''; 
              update usr1; 
             
             list<user> lstUsers = new list<user>();
           lstUsers.add(usr);
           list<RouteCust__c> lstrcust = new list<RouteCust__c>();
           lstrcust.add(objRouteCust); 
           //AB_AccountTeam.addAccountTeam(lstUsers);
           AB_AccountTeam.deleteAccountTeam(lstUsers);
           AB_AccountTeam.addAccountteamfromRouteCust(lstrcust);
           AB_AccountTeam.deleteAccountTeams(lstrcust);
    }
}