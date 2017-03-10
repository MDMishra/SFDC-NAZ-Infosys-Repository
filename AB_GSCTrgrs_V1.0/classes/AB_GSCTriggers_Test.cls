////code coverage for AB_GSC_Usr_Trg and AB_GSC_WsrRole_Trg
@isTest
public class AB_GSCTriggers_Test{
    //code coverage for AB_GSC_Usr_Trg
    static testMethod void AB_GSC_Usr_Trg_Test() {
    
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];        
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        list<userrole> rle = [select id,name from userrole limit 2];
        
        System.runAs (thisUser) {
            Wholesaler_Role__c objWR = new Wholesaler_Role__c();
            objWR.Name = 'testNm1';
            objWR.Wholesaler_Number__c = '98989';
            objWR.Wholesaler_Type__c = 'WOD';
            objWR.Role_ID_WSLR__c = rle[1].id;
            objWR.Role_Name_WSLR__c = rle[1].name;
            objWR.Wholesaler_Name__c = 'TestWsaler';
            insert objWR;
             
            User usr1 = new User(LastName = 'LIVESTON',
                 FirstName='JASON',
                 Alias = 'jliv',
                 Email = 'jason.liveston@asdf.com',
                 Username = 'jason.lieston@as.com',
                 ProfileId = profileId.id,
                 TimeZoneSidKey = 'GMT',
                 LanguageLocaleKey = 'en_US',
                 EmailEncodingKey = 'UTF-8',
                 LocaleSidKey = 'en_US',
                 Wholesaler_Number__c = '10500',
                 userRoleId = rle[0].id
                 );
                 insert usr1;
                 usr1.userRoleId = rle[1].id;
                 update usr1;
                               
           /*AB_Batch_GSCUsrToWRoleCreation sh2 = new AB_Batch_GSCUsrToWRoleCreation();      
            String sc3 = '0  00 1 3 * ?';
            system.schedule('Test1', sc3, sh2);*/
           
       }
    }
    
    //code coverage for AB_GSC_WsrRole_Trg
    static testMethod void AB_GSC_WRole_Trg_Test() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
        list<userrole> rle = [select id,name from userrole limit 2];
        System.runAs (thisUser) {
            Wholesaler_Role__c objWR = new Wholesaler_Role__c();
            objWR.Name = 'testNm1';
            objWR.Wholesaler_Number__c = '98989';
            objWR.Wholesaler_Type__c = 'WOD';
            objWR.Role_ID_WSLR__c = rle[1].id;
            objWR.Role_Name_WSLR__c = rle[1].name;
            objWR.Wholesaler_Name__c = 'TestWsaler';
            objWR.Remote_Survey_Vendor_Enabled__c = true;
            insert objWR;
            objWR.Remote_Survey_Vendor_Enabled__c = false;
            update objWR;
            
            User usr1 = new User(LastName = 'LIVESTON',
                 FirstName='JASON',
                 Alias = 'jliv',
                 Email = 'jason.liveston@asdf.com',
                 Username = 'jason.lieston@as.com',
                 ProfileId = profileId.id,
                 TimeZoneSidKey = 'GMT',
                 LanguageLocaleKey = 'en_US',
                 EmailEncodingKey = 'UTF-8',
                 LocaleSidKey = 'en_US',
                 Wholesaler_Number__c = '10500',
                 userRoleId = rle[1].id,
                 Remote_Survey_Vendor_Enabled__c = true
                 );
                 insert usr1;
            
           /* AB_Batch_GSCUsrToWRoleCreation abg= new AB_Batch_GSCUsrToWRoleCreation();
            database.executeBatch(abg);*/
           
        }
    }
    
    //code coverage for AB_GSC_WsrRole_Trg
    static testMethod void AB_GSC_WRole_Trg_Test2() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];  
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1]; 
        list<userrole> rle = [select id,name from userrole limit 2];
        System.runAs (thisUser) {
            Wholesaler_Role__c objWR = new Wholesaler_Role__c();
            objWR.Name = 'testNm1';
            objWR.Wholesaler_Number__c = '98989';
            objWR.Wholesaler_Type__c = 'WOD';
            objWR.Role_ID_WSLR__c = rle[1].id;
            objWR.Role_Name_WSLR__c = rle[1].name;
            objWR.Wholesaler_Name__c = 'TestWsaler';
            objWR.Remote_Survey_Vendor_Enabled__c = true;
            insert objWR;
            objWR.Role_ID_WSLR__c = rle[0].id;
            update objWR;
            
            User usr1 = new User(LastName = 'LIVESTON',
                 FirstName='JASON',
                 Alias = 'jliv',
                 Email = 'jason.liveston@asdf.com',
                 Username = 'jason.lieston@as.com',
                 ProfileId = profileId.id,
                 TimeZoneSidKey = 'GMT',
                 LanguageLocaleKey = 'en_US',
                 EmailEncodingKey = 'UTF-8',
                 LocaleSidKey = 'en_US',
                 Wholesaler_Number__c = '10500',
                 userRoleId = rle[0].id,
                 Remote_Survey_Vendor_Enabled__c = true
                 );
                 insert usr1;
            
            
        }
    }
}