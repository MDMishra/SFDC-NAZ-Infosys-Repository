/*Code coverage for 
AB_AccountTeam,
AB_AccountTeamTrigger,
AB_SearchAndReplace2_Batch,
AB_SearchAndReplace_Batch*/

@isTest
public class AB_AccountTeam_Test {
    public static string accId;
    public static string UName;
    public static string routeId;

    static testMethod void myTest() {
       
        CollaborationGroup cb = new CollaborationGroup();
        cb.Name = 'Test CB';
        cb.CollaborationType = 'Public';
        insert cb;
        
       Recordtype rt = [select id from Recordtype where Recordtype.name = 'Wholesaler' limit 1];
       account objAc = new account();
       objAc.name = 'Test Account';
       objAc.recordtypeid = rt.id;
       objAc.WSLR_NBR_US__c = '93411';
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
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '93411'
             //WSLRNbrRouteNbr__c = 'Test123'
             );
             insert usr1;
             
             //ConnectApi.ChatterUsers.follow(null, usr1.id, objAc.id);
             EntitySubscription eSub1 = new EntitySubscription(ParentID = objAc.Id, SubscriberId = usr1.id);
             insert eSub1;
             
        usr1.Wholesaler_Number__c = '93411';
             usr1.WSLRNbrRouteNbr__c = '93411D0106'; 
             update usr1;
             
              usr1.WSLRNbrRouteNbr__c = ''; 
              update usr1; 
             
             list<user> lstUsers = new list<user>();
           lstUsers.add(usr);
        lstUsers.add(usr1);
           list<RouteCust__c> lstrcust = new list<RouteCust__c>();
           lstrcust.add(objRouteCust); 
           usr.Account_Team__c = true;
            update usr;
        
        //Database.executeBatch(new AB_SearchAndReplace2_Batch());//'Test123',usr.id
        //Database.executeBatch(new AB_Batch_AccountTeam());
        AB_Batch_AccountTeam sh1 = new AB_Batch_AccountTeam();      
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        
        Set<Id> setIds = new Set<Id>();
        setIds.add(usr.Id);
        setIds.add(usr1.Id);
        List<Id> listUserIds = new List<Id>();
        listUserIds.add(usr.Id);
        listUserIds.add(usr1.Id);
        List<String> lstWSRNums = new List<String>();
        lstWSRNums.add('93411');
        Test.startTest();
        //Database.executeBatch(new AB_SearchAndReplace_Batch());//'Test123',usr.id,'WSLRNbrRouteNbr'
        AB_SearchAndReplace_Batch sh2 = new AB_SearchAndReplace_Batch();      
        String sc3 = '0  00 1 3 * ?';
        system.schedule('Test1', sc3, sh2);
        
        Test.stopTest();
        AB_AccountTeam.deletefollow(setIds);
        //insert lstUsers;
        AB_AccountTeam.deleteAccountTeam(setIds);
           AB_AccountTeam.addAccountteamfromRouteCust(lstrcust);
           AB_AccountTeam.deleteAccountTeams(lstrcust);
        
        
        
    }
}