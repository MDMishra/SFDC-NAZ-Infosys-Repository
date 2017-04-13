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
        objCon.EMPLOYEE_NUMBER_US__c = '0123';
        objCon.WSLRNbrRouteNbr__c = '0123434556';
        objCon.Global_User_Only__c=false;
        return objCon;
      
    }
    private Static testMethod void createContact()
    {
        AB_UserCreation__c objUC = new AB_UserCreation__c();
        objUC.Client_Id__c = 'clientId';
        objUC.clientSecret__c = 'ClSecret';
        objUC.username__c = 'uName';
        objUC.Password__c = 'pwd';
        objUC.EndPointUrl__c = 'testUrl';
        insert objUC;
        
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
            FederationIdentifier = 'teskings986@nuvemconsulting.com'
            //Send_To_Global__c = true
        );
        Database.insert(user1);
        Account objAcc = new Account();
        objAcc.name = 'Test Account';
        objAcc.WSLR_NBR_US__c = '55';
        objAcc.Type = 'wholesaler';
        insert objAcc;
        
        createCon();
        List<Contact> lstCon = new List<Contact>();
        contact con=createCon();
        con.AccountId=objAcc.id;
        lstCon.add(con);
        INSERT lstCon;
        objAcc.WSLR_NBR_US__c = '6';
        update objAcc;
        con.WHOLESALER_NUMBER__c = '6';
        con.Department = 'Test Dept';
        con.Global_User_Only__c=true;
        con.ISACTIVE__c = true;
        update con;
    }
    
    private Static testMethod void createContact2(){
        AB_UserCreation__c objUC = new AB_UserCreation__c();
        objUC.Client_Id__c = 'clientId';
        objUC.clientSecret__c = 'ClSecret';
        objUC.username__c = 'uName';
        objUC.Password__c = 'pwd';
        objUC.EndPointUrl__c = 'testUrl';
        insert objUC;
        
        Account objAcc = new Account();
        objAcc.name = 'Test Account';
        objAcc.WSLR_NBR_US__c = '55';
        objAcc.Type = 'wholesaler';
        insert objAcc;
        
        createCon();
        List<Contact> lstCon = new List<Contact>();
        contact con=createCon();
        con.AccountId=objAcc.id;
        con.FEDERATIONIDENTIFIER__c = 'teskings987@nuvemconsulting.com';
        con.Email = 'babitha.jampani1@nuvemconsulting.com';
        con.Global_User_Only__c=false;
        con.ISACTIVE__c = true;
        lstCon.add(con);
        INSERT lstCon;
    
    }
    
     private Static testMethod void createContact3(){
        AB_UserCreation__c objUC = new AB_UserCreation__c();
        objUC.Client_Id__c = 'clientId';
        objUC.clientSecret__c = 'ClSecret';
        objUC.username__c = 'uName';
        objUC.Password__c = 'pwd';
        objUC.EndPointUrl__c = 'testUrl';
        insert objUC;
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%WOD Lead%' Limit 1];
        User user1 = new User(
            Username = 'teskings987@test.com',
            ProfileId = portalProfile.Id,
            Alias = 'te987',
            Email = 'teskings987@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            FederationIdentifier = 'teskings987@nuvemconsulting.com'
            //Send_To_Global__c = true
        );
        Database.insert(user1);
        Account objAcc = new Account();
        objAcc.name = 'Test Account';
        objAcc.WSLR_NBR_US__c = '55';
        objAcc.Type = 'wholesaler';
        insert objAcc;
        
        createCon();
        List<Contact> lstCon = new List<Contact>();
        contact con=createCon();
        con.AccountId=objAcc.id;
        con.FEDERATIONIDENTIFIER__c = 'teskings987@nuvemconsulting.com';
        con.Email = 'babitha.jampani2@nuvemconsulting.com';
        con.Global_User_Only__c=false;
        con.ISACTIVE__c = true;
        lstCon.add(con);
        INSERT lstCon;
        con.Global_User_Only__c=false;
        con.ISACTIVE__c = false;
        update con;
    
    }
    
     private Static testMethod void createContact4(){
        AB_UserCreation__c objUC = new AB_UserCreation__c();
        objUC.Client_Id__c = 'clientId';
        objUC.clientSecret__c = 'ClSecret';
        objUC.username__c = 'uName';
        objUC.Password__c = 'pwd';
        objUC.EndPointUrl__c = 'testUrl';
        insert objUC;
        
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name LIKE '%WOD Lead%' Limit 1];
        User user1 = new User(
            Username = 'teskings988@test.com',
            ProfileId = portalProfile.Id,
            Alias = 'te987',
            Email = 'teskings987@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            FederationIdentifier = 'teskings988@nuvemconsulting.com'
            //Send_To_Global__c = true
        );
        Database.insert(user1);
        Account objAcc = new Account();
        objAcc.name = 'Test Account';
        objAcc.WSLR_NBR_US__c = '55';
        objAcc.Type = 'wholesaler';
        insert objAcc;
        
        createCon();
        List<Contact> lstCon = new List<Contact>();
        contact con=createCon();
        con.AccountId=objAcc.id;
        con.FEDERATIONIDENTIFIER__c = 'teskings988@nuvemconsulting.com';
        con.Email = 'babitha.jampani3@nuvemconsulting.com';
        con.Global_User_Only__c=false;
        con.ISACTIVE__c = true;
        lstCon.add(con);
        INSERT lstCon;
        con.Global_User_Only__c=false;
        con.ISACTIVE__c = true;
        update con;
    
    }
    
    public static testMethod void createContact5(){
        Recordtype Rtype = [select id,name from Recordtype where SobjectType = 'contact' and name ='NAZ User'];
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        AB_UserCreation__c objUC = new AB_UserCreation__c();
        objUC.Client_Id__c = 'clientId';
        objUC.clientSecret__c = 'ClSecret';
        objUC.username__c = 'uName';
        objUC.Password__c = 'pwd';
        objUC.EndPointUrl__c = 'testUrl';
        insert objUC;
        Contact objCon1 = new Contact();
        objCon1.LastName =  'User';
        objCon1.recordtypeid = Rtype.id;
        objCon1.FirstName = 'Test';
        objCon1.ALIAS__c = 'TestUser';
        objCon1.Email = 'babitha.jampani@nuvemconsulting.com';
        objCon1.MobilePhone = '9966784275';
        objCon1.ISACTIVE__c = false;
        objCon1.USERNAME__c = 'abiqtestuser@abiq.com';
        objCon1.NICKNAME__C = 'abiq';
        objCon1.PROFILEID__c = p.Id;
        objCon1.COMPANYNAME__c = 'abiq';
        objCon1.CurrencyIsoCode = 'USD';
        objCon1.ROUTEKEY__c = '123456';
        objCon1.Title = 'ABIQTitle';
        objCon1.TIMEZONEIDKEY__c = 'GMT';
        objCon1.LOCALESIDKEY__c = 'en_US';
        objCon1.EMAILENCODINGKEY__c = 'ISO-8859-1';
        objCon1.LANGUAGELOCALEKEY__c = 'en_US';
        objCon1.DEFAULTDIVISION__c = '02dU0000000PAvHIAW';
        objCon1.FEDERATIONIDENTIFIER__c = 'teskings986@nuvemconsulting.com';
        objCon1.HE_Primary_Contact__c = true;
        objCon1.WHOLESALER_NUMBER__c = '55';
        objCon1.Username_Suffix__c = 'SuffixTest';
        objCon1.EMPLOYEE_NUMBER_US__c = '0123';
        objCon1.WSLRNbrRouteNbr__c = '0123434556';
        objCon1.Global_User_Only__c=false;
        insert objCon1;
        
        Contact objCon2 = new Contact();
        objCon2.LastName =  'User';
        objCon2.recordtypeid = Rtype.id;
        objCon2.FirstName = 'Test';
        objCon2.ALIAS__c = 'TestUser';
        objCon2.Email = 'babitha.jampani@nuvemconsulting.com';
        objCon2.MobilePhone = '9966784275';
        objCon2.ISACTIVE__c = true;
        objCon2.USERNAME__c = 'abiqtestuser@abiq.com';
        objCon2.NICKNAME__C = 'abiq';
        objCon2.PROFILEID__c = p.Id;
        objCon2.COMPANYNAME__c = 'abiq';
        objCon2.CurrencyIsoCode = 'USD';
        objCon2.ROUTEKEY__c = '123456';
        objCon2.Title = 'ABIQTitle';
        objCon2.TIMEZONEIDKEY__c = 'GMT';
        objCon2.LOCALESIDKEY__c = 'en_US';
        objCon2.EMAILENCODINGKEY__c = 'ISO-8859-1';
        objCon2.LANGUAGELOCALEKEY__c = 'en_US';
        objCon2.DEFAULTDIVISION__c = '02dU0000000PAvHIAW';
        objCon2.FEDERATIONIDENTIFIER__c = 'teskings986@nuvemconsulting.com';
        objCon2.HE_Primary_Contact__c = true;
        objCon2.WHOLESALER_NUMBER__c = '55';
        objCon2.Username_Suffix__c = 'SuffixTest';
        objCon2.EMPLOYEE_NUMBER_US__c = '0123';
        objCon2.WSLRNbrRouteNbr__c = '0123434556';
        objCon2.Global_User_Only__c=true;
        insert objCon2;
        
        Contact objCon3 = new Contact();
        objCon3.LastName =  'User';
        objCon3.recordtypeid = Rtype.id;
        objCon3.FirstName = 'Test';
        objCon3.ALIAS__c = 'TestUser';
        objCon3.Email = 'babitha.jampani@nuvemconsulting.com';
        objCon3.MobilePhone = '9966784275';
        objCon3.ISACTIVE__c = false;
        objCon3.USERNAME__c = 'abiqtestuser@abiq.com';
        objCon3.NICKNAME__C = 'abiq';
        objCon3.PROFILEID__c = p.Id;
        objCon3.COMPANYNAME__c = 'abiq';
        objCon3.CurrencyIsoCode = 'USD';
        objCon3.ROUTEKEY__c = '123456';
        objCon3.Title = 'ABIQTitle';
        objCon3.TIMEZONEIDKEY__c = 'GMT';
        objCon3.LOCALESIDKEY__c = 'en_US';
        objCon3.EMAILENCODINGKEY__c = 'ISO-8859-1';
        objCon3.LANGUAGELOCALEKEY__c = 'en_US';
        objCon3.DEFAULTDIVISION__c = '02dU0000000PAvHIAW';
        objCon3.FEDERATIONIDENTIFIER__c = 'teskings986@nuvemconsulting.com';
        objCon3.HE_Primary_Contact__c = true;
        objCon3.WHOLESALER_NUMBER__c = '55';
        objCon3.Username_Suffix__c = 'SuffixTest';
        objCon3.EMPLOYEE_NUMBER_US__c = '0123';
        objCon3.WSLRNbrRouteNbr__c = '0123434556';
        objCon3.Global_User_Only__c=true;
        insert objCon3;
        
    
    }
    
}