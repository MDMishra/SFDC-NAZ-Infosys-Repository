/* 
 * @author: Vamsi Mohan Batchu
 * @date: 16.Feb.2016
 * @description: Test class to test user insertion or update trigger
 * @Modification History:
 */
@isTest
private class ABS_UserCreation_RestAPI_Test {
    
    public static contact createCon()
    {
        Recordtype Rtype = [select id,name from Recordtype where SobjectType = 'contact' and name ='NAZ User'];
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        Contact objCon = new Contact();
        objCon.LastName =  'User';
        objCon.recordtypeid = Rtype.id;
        objCon.FirstName = 'Test';
        objCon.ALIAS__c = 'TestUser';
        objCon.Email = 'babitha.jampani@nuvemconsulting.com';
        objCon.MobilePhone = '9966784275';
        objCon.ISACTIVE__c = true;
        objCon.USERNAME__c = 'abiqtestuser@abiq.com';
        objCon.NICKNAME__C = 'abiq';
        objCon.PROFILEID__c = p.Id;
        objCon.COMPANYNAME__c = 'abiq';
        objCon.CurrencyIsoCode = 'USD';
        objCon.ROUTEKEY__c = '123456';
        objCon.Title = 'ABIQTitle';
        objCon.TIMEZONEIDKEY__c = 'GMT';
        objCon.LOCALESIDKEY__c = 'en_US';
        objCon.EMAILENCODINGKEY__c = 'ISO-8859-1';
        objCon.LANGUAGELOCALEKEY__c = 'en_US';
        objCon.DEFAULTDIVISION__c = '02dU0000000PAvHIAW';
        objCon.FEDERATIONIDENTIFIER__c = 'teskings986@test.com';
        objCon.HE_Primary_Contact__c = true;
        objCon.WHOLESALER_NUMBER__c = '55';
        objCon.Username_Suffix__c = 'SuffixTest';
        return objCon;
        
    }
    
    //Tests user insert and update trigger
    static testMethod void myUnitTest() {
        
        //Custom setting obejct for callout details
        set<id> contactIds = new set<id>();
        AB_UserCreation__c objUC = new AB_UserCreation__c();
        objUC.Client_Id__c = 'clientId';
        objUC.clientSecret__c = 'ClSecret';
        objUC.username__c = 'uName';
        objUC.Password__c = 'pwd';
        objUC.EndPointUrl__c = 'testUrl';
        insert objUC;
        User portalAccountOwner1;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        System.runAs (thisUser) {
            //Create portal account owner
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            portalAccountOwner1 = new User(
                //UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = 'test123130@test.com',
                Alias = 'Alias',
                Email='test@owner.com',
                EmailEncodingKey='UTF-8',
                Lastname='lNameTest',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                
                FederationIdentifier = 'test123130@test.com',
                Send_To_Global__c = true
            );
            Database.insert(portalAccountOwner1);
        }
        //Create account
        Account portalAccount1 = new Account(
            Name = 'TestAccount',
            OwnerId = portalAccountOwner1.Id
        );
        Database.insert(portalAccount1);
            
        //Create contact
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = portalAccount1.Id,
            Email = 'test123130@test.com',
            FederationIdentifier__c = 'test123130@test.com',
            USERNAME__c='test123130@test.com',
            Username_Suffix__c='test.com',
            ALIAS__c='test1231',
            NICKNAME__c='test123130',
            ROLEID__c='',
            PROFILEID__c='00e0B000000Rx35',
            LOCALESIDKEY__c='en_US',
            LANGUAGELOCALEKEY__c='en_US',    
            TIMEZONEIDKEY__c='Asia/Beirut',
            EMAILENCODINGKEY__c='UTF-8',
            MobilityID__c='90018',
            CurrencyIsoCode='USD',
            DEFAULTDIVISION__c='02dU0000000PAvH'
        );
        Database.insert(contact1);
        contactIds.add(contact1.id);
        System.runAs (thisUser) {
            Database.executeBatch(new AB_Batch_RestUserCreation(contactIds));
            AB_Batch_RestUserCreation sh1 = new AB_Batch_RestUserCreation(contactIds);
            String sch = '0  00 1 3 * ?';
            system.schedule('Testss', sch, sh1);
        }       
    }
    static testMethod void TestSchedule() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
                //AB_Batch_RestUserCreation sh1 = new AB_Batch_RestUserCreation(); 
                //String sch = '0  00 1 3 * ?';
                //system.schedule('Testss', sch, sh1);
            }  
    }
}