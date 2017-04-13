@isTest
private class Test_CreateUserService
{
    static testMethod void myUnitTest()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
              
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test1@nuvemconsulting.com',
            Alias = 'huserss',
            Email='test1@nuvemconsulting.com',
            EmailEncodingKey='ISO-8859-1',
            Lastname='userrrdddvvdddd',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            FederationIdentifier='',
            TimeZoneSidKey='America/New_York'
        );
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           insert portalAccountOwner1;
        }
        
        Account objAcc = new Account();
        objAcc.Name =label.AB_Community_Account;
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.RecordTypeid =[select id from RecordType where SobjectType='Account' and name='Business Account' limit 1].id;
        insert objAcc;
        
        System.runAs( new User(Id = UserInfo.getUserId()))
        {
            
        }    
        //System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
      
        String json= '{"conWrap":[{"Username_Suffix_Global":".globalSIT","Username":"Nuvem62666@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 6266 test Deeothi hell","LanguageLocaleKey":"en_US","IsActive":true,"Global_User_Only":false,"Firstname":"Nuvem","FederationIdentifier":"Nuvem62666@nuvem.com","EmailEncodingKey":"UTF-8","Email":"nuvem62666@nuvemconsulting.com","DefaultDivision":"02dU0000000PAvHIAW","DefaultCurrencyIsoCode":"USD","CurrencyIsoCode":"USD","CompanyName":"Nuvem Company","CommunityNickname":"Nuvem62666@nuvem.com","Alias":"vem666"}]}';
        req.requestURI = URL.getSalesforceBaseUrl()+'/services/apexrest/CreateUserService/test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
        System.runAs( new User(Id = UserInfo.getUserId())) {
             CreateUserService.doPut();   
        }
        
    }
    
    static testMethod void myUnitTestIns()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
              
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test1@nuvemconsulting.com',
            Alias = 'huserss',
            Email='test1@nuvemconsulting.com',
            EmailEncodingKey='ISO-8859-1',
            Lastname='userrrdddvvdddd',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            FederationIdentifier='',
            TimeZoneSidKey='America/New_York'
        );
        
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
           insert portalAccountOwner1;
        }
        
        Account objAcc = new Account();
        objAcc.Name =label.AB_Community_Account;
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.RecordTypeid =[select id from RecordType where SobjectType='Account' and name='Business Account' limit 1].id;
        insert objAcc;
        
        System.runAs( new User(Id = UserInfo.getUserId()))
        {
            
        }    
        //System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
      
        String json= '{"conWrap":[{"Username_Suffix_Global":null,"Username":"Nuvem62668@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 6266 test Deeothi hell","LanguageLocaleKey":"en_US","IsActive":true,"Global_User_Only":true,"Firstname":"Nuvem","FederationIdentifier":"Nuvem62668@nuvem.com","EmailEncodingKey":"UTF-8","Email":"nuvem62668@nuvemconsulting.com","DefaultDivision":"02dU0000000PAvHIAW","DefaultCurrencyIsoCode":"USD","CurrencyIsoCode":"USD","CompanyName":"Nuvem Company","CommunityNickname":"Nuvem62668@nuvem.com","Alias":"vem666"}]}';
        req.requestURI = URL.getSalesforceBaseUrl()+'/services/apexrest/CreateUserService/test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
        System.runAs( new User(Id = UserInfo.getUserId())) {
             CreateUserService.doPut();   
        }
        
    }
    static testMethod void myUnitTest1()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test@nuvemconsulting.com',
            Alias = 'huserss',
            Email='test1@nuvemconsulting.com',
            EmailEncodingKey='ISO-8859-1',
            Lastname='userrrdddvvdddd',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            FederationIdentifier='test@nuvemconsulting.com',
            TimeZoneSidKey='America/New_York'
        );
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert portalAccountOwner1;
        }
        Account objAcc = new Account();
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.LastName = label.AB_Community_Account;
        //objAcc.RecordTypeid = [select id from recordtype where name = 'Person Account' and SobjectType = 'Account'].id;
        insert objAcc;
        
        Contact objCon = new Contact();
        objCon.lastName = 'robbbbb biii';
        objCon.FEDERATIONIDENTIFIER__c = 'test@nuvemconsulting.com';
        insert objCon;
        System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String json= '{"conWrap":[{"Username_Suffix_Global":".globalSIT","Username":"test@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 62 test Deeothi hell","LanguageLocaleKey":"en_US","IsActive":true,"Global_User_Only":false,"Firstname":"Nuvem","FederationIdentifier":"test@nuvemconsulting.com","EmailEncodingKey":"UTF-8","Email":"test@nuvemconsulting.com","DefaultDivision":"02dU0000000PAvHIAW","DefaultCurrencyIsoCode":"USD","CurrencyIsoCode":"USD","CompanyName":"Nuvem Company","CommunityNickname":"test@nuvemconsulting.com","Alias":"Nuv66"}]}';
        
        req.requestURI = URL.getSalesforceBaseUrl()+'/services/apexrest/CreateUserService/test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            CreateUserService.doPut();
        }
    }
    
     static testMethod void myUnitTest2()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test@nuvemconsulting.com',
            Alias = 'huserss',
            Email='test1@nuvemconsulting.com',
            EmailEncodingKey='ISO-8859-1',
            Lastname='userrrdddvvdddd',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            FederationIdentifier='test@nuvemconsulting.com',
            TimeZoneSidKey='America/New_York'
        );
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert portalAccountOwner1;
        }
        Account objAcc = new Account();
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.LastName = label.AB_Community_Account;
        //objAcc.RecordTypeid = [select id from recordtype where name = 'Person Account' and SobjectType = 'Account'].id;
        insert objAcc;
        
        Contact objCon = new Contact();
        objCon.lastName = 'robbbbb biii';
        objCon.FEDERATIONIDENTIFIER__c = 'test@nuvemconsulting.com';
        insert objCon;
        System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String json= '{"conWrap":[{"Username_Suffix_Global":".globalSIT","Username":"test@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 62 test Deeothi hell","LanguageLocaleKey":"en_US","IsActive":false,"Global_User_Only":false,"Firstname":"Nuvem","FederationIdentifier":"test@nuvemconsulting.com","EmailEncodingKey":"UTF-8","Email":"test@nuvemconsulting.com","DefaultDivision":"02dU0000000PAvHIAW","DefaultCurrencyIsoCode":"USD","CurrencyIsoCode":"USD","CompanyName":"Nuvem Company","CommunityNickname":"test@nuvemconsulting.com","Alias":"Nuv66"}]}';
        
        req.requestURI = URL.getSalesforceBaseUrl()+'/services/apexrest/CreateUserService/test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            CreateUserService.doPut();
        }
    }
    
     static testMethod void myUnitTest3()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test@nuvemconsulting.com',
            Alias = 'huserss',
            Email='test1@nuvemconsulting.com',
            EmailEncodingKey='ISO-8859-1',
            Lastname='userrrdddvvdddd',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            FederationIdentifier='test@nuvemconsulting.com',
            TimeZoneSidKey='America/New_York'
        );
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert portalAccountOwner1;
        }
        Account objAcc = new Account();
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.LastName = label.AB_Community_Account;
        //objAcc.RecordTypeid = [select id from recordtype where name = 'Person Account' and SobjectType = 'Account'].id;
        insert objAcc;
        
        Contact objCon = new Contact();
        objCon.lastName = 'robbbbb biii';
        objCon.FEDERATIONIDENTIFIER__c = 'test@nuvemconsulting.com';
        insert objCon;
        System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String json= '{"conWrap":[{"Username_Suffix_Global":".globalSIT","Username":"test@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 62 test Deeothi hell","LanguageLocaleKey":"en_US","IsActive":true,"Global_User_Only":true,"Firstname":"Nuvem","FederationIdentifier":"test@nuvemconsulting.com","EmailEncodingKey":"UTF-8","Email":"test@nuvemconsulting.com","DefaultDivision":"02dU0000000PAvHIAW","DefaultCurrencyIsoCode":"USD","CurrencyIsoCode":"USD","CompanyName":"Nuvem Company","CommunityNickname":"test@nuvemconsulting.com","Alias":"Nuv66"}]}';
        
        req.requestURI = URL.getSalesforceBaseUrl()+'/services/apexrest/CreateUserService/test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            CreateUserService.doPut();
        }
    }
    
     static testMethod void myUnitTest4()
    {
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test@nuvemconsulting.com',
            Alias = 'huserss',
            Email='test1@nuvemconsulting.com',
            EmailEncodingKey='ISO-8859-1',
            Lastname='userrrdddvvdddd',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            FederationIdentifier='test@nuvemconsulting.com',
            TimeZoneSidKey='America/New_York'
        );
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert portalAccountOwner1;
        }
        Account objAcc = new Account();
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.LastName = label.AB_Community_Account;
        //objAcc.RecordTypeid = [select id from recordtype where name = 'Person Account' and SobjectType = 'Account'].id;
        insert objAcc;
        
        Contact objCon = new Contact();
        objCon.lastName = 'robbbbb biii';
        objCon.FEDERATIONIDENTIFIER__c = 'test@nuvemconsulting.com';
        insert objCon;
        System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String json= '{"conWrap":[{"Username_Suffix_Global":".globalSIT","Username":"test@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 62 test Deeothi hell","LanguageLocaleKey":"en_US","IsActive":false,"Global_User_Only":true,"Firstname":"Nuvem","FederationIdentifier":"test@nuvemconsulting.com","EmailEncodingKey":"UTF-8","Email":"test@nuvemconsulting.com","DefaultDivision":"02dU0000000PAvHIAW","DefaultCurrencyIsoCode":"USD","CurrencyIsoCode":"USD","CompanyName":"Nuvem Company","CommunityNickname":"test@nuvemconsulting.com","Alias":"Nuv66"}]}';
        
        req.requestURI = URL.getSalesforceBaseUrl()+'/services/apexrest/CreateUserService/test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            CreateUserService.doPut();
        }
    }

   


}