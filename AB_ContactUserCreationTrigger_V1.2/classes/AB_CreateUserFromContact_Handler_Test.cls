/*
Auhtor Name : Nuvem Developer
Date        : Feb 3 2017
Description : Test class for create a user from a contact / Update user associated with contact when contact is updated
*/
@isTest
private class AB_CreateUserFromContact_Handler_Test {
    public static contact createCon(){
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
        objCon.FEDERATIONIDENTIFIER__c = 'teskings986@nuvemconsulting.com';
        objCon.HE_Primary_Contact__c = true;
        objCon.WHOLESALER_NUMBER__c = '55';
        objCon.Username_Suffix__c = 'SuffixTest';
        return objCon;
    }
    private Static testMethod void createContact(){
        Account objAcc = new Account();
        objAcc.name = 'Test Account';
        //insert objAcc;
        List<Contact> lstCon = new List<Contact>();
        contact con  = createCon();
        //con.AccountId = objAcc.Id;
        con.User__c = userinfo.getUserId();
        lstCon.add(con);
        INSERT lstCon;
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%WOD Lead%' Limit 1];
        User user1 = new User(
            Username = 'teskings986@test.com',
            ProfileId = portalProfile.Id,
            Alias = 'te986',
            Email = 'teskings986@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            FederationIdentifier = 'teskings986@nuvemconsulting.com',
            Send_To_Global__c = true
        );
        Database.insert(user1);
        AB_CreateUserFromContact_Handler.beforeInsert(lstCon);
        AB_CreateUserFromContact_Handler.beforeUpdate(lstCon);
    }
    
}