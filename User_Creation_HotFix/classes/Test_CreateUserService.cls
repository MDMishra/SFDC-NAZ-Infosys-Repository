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
            FederationIdentifier='test1@nuvemconsulting.com',
            TimeZoneSidKey='America/New_York'
        );
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
            insert portalAccountOwner1;
        }
        Account objAcc = new Account();
        //recordtype rte = [select id from recordtype where name = 'Person Account' and SobjectType = 'Account'].id;
        objAcc.LastName = label.AB_Community_Account;
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.RecordTypeid = [select id from recordtype where name = 'Person Account' and SobjectType = 'Account'].id;
        insert objAcc;
        Contact objCon = new Contact();
        objCon.lastName = 'robbbbb biii';
        objCon.FEDERATIONIDENTIFIER__c = 'test1@nuvemconsulting.com';
        insert objCon;
        System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        /*String json = '{"objUser":[{"attributes":{"type":"User","url":"/services/data/v39.0/sobjects/User/005f0000002D54mAAC"},"Id":"005f0000002D54mAAC","Username":"test@nuvemconsulting.com","LastName":"userrrdddvvdddd","FirstName":"hiiiii user","Email":"test@nuvemconsulting.com","Alias":"huserss","CommunityNickname":"test","IsActive":true,"TimeZoneSidKey":"America/New_York","LocaleSidKey":"en_US","ProfileId":"00eU0000000ionTIAQ","EmailEncodingKey":"ISO-8859-1","LanguageLocaleKey":"en_US","UserPreferencesDisableAutoSubForFeeds":false,"UserPermissionsMobileUser":false,"Title":"title","MobilePhone":"0*86655457","Phone":"8765689","ContactId":"003f000000rTCjYAAW","FederationIdentifier":"test@nuvemconsulting.com"},'
            +'{"attributes":{"type":"User","url":"/services/data/v39.0/sobjects/User/005f0000002D5EIAA0"},"Id":"005f0000002D5EIAA0","Username":"test2@nuvemconsulting.com","LastName":"biii","FirstName":"robbbbb","Email":"test2@nuvemconsulting.com","Alias":"rbiii","CommunityNickname":"test2","IsActive":true,"TimeZoneSidKey":"America/New_York","LocaleSidKey":"en_US","ProfileId":"00eU0000000ionTIAQ","EmailEncodingKey":"ISO-8859-1","LanguageLocaleKey":"en_US","UserPreferencesDisableAutoSubForFeeds":false,"UserPermissionsMobileUser":false,"Title":"tioooo","MobilePhone":"999999","Phone":"999999","ContactId":"003f000000rStMTAA0","FederationIdentifier":"test2@nuvemconsulting.com"}],'
            +'"objContact":[{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/003f000000rTCjYAAW"},"Id":"003f000000rTCjYAAW","Name":"hiiiii user userrrr","FirstName":"hiiiii user","LastName":"test3","Phone":"8765689","FederationIdentifier":"test@nuvemconsulting.com"},'
            +'{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/003f000000rStMTAA0"},"Id":"003f000000rStMTAA0","Name":"robbbbb biii","Email":"test2@nuvemconsulting.com","FirstName":"robbbbb","LastName":"biii","Phone":"999999","FederationIdentifier":"test2@nuvemconsulting.com"}]}';*/
        
        String json=        '{"objUser":[{"WSLRNbrRouteNbr":"93411R0110","UserPreferencesDisableAutoSubForFeeds":false,"UserPermissionsMobileUser":false,"Username_Suffix_Global":".globalsit","Username":"test2@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","street":"Nuvem 42 Street","state":"Nuvem 42 State","Source_Suffix":".nazsapapp","ProfileId":"00ef0000000DzcXAAS","PostalCode":"424242","Phone":null,"MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 42 Test Deepthi","LanguageLocaleKey":"en_US","IsActive":true,"Id":"005f0000002D6jWAAS","FirstName":"Nuvem","FederationIdentifier":"test2@nuvemconsulting.com","Fax":null,"EmailEncodingKey":"UTF-8","Email":"test2@nuvemconsulting.com","Department":null,"country":"Nuvem 42 Country","ContactId":null,"CompanyName":"Nuvem Company2","CommunityNickname":"Nuvem42222","city":"Nuvem 42 City","Alias":"Nuvem43222"}],"objContact":[{"Phone":null,"Name":"Nuvem User 42 Test Deepthi","LastName":"User 42 Test Deepthi","Id":"003f000000rTH5aAAG","FirstName":"Nuvem","FEDERATIONIDENTIFIER":"test2@nuvemconsulting.com"}]}';

        req.requestURI = URL.getSalesforceBaseUrl()+'/services/apexrest/CreateUserService/test';
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response = res;
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
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
        objAcc.LastName = label.AB_Community_Account;
        objAcc.OwnerId = portalAccountOwner1.Id;
        objAcc.RecordTypeid = [select id from recordtype where name = 'Person Account' and SobjectType = 'Account'].id;
        insert objAcc;
        Contact objCon = new Contact();
        objCon.lastName = 'robbbbb biii';
        objCon.FEDERATIONIDENTIFIER__c = 'test@nuvemconsulting.com';
        insert objCon;
        System.debug('Test insert   '+objAcc);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        /*String json = '{"objUser":[{"attributes":{"type":"User","url":"/services/data/v39.0/sobjects/User/005f0000002D54mAAC"},"Id":"005f0000002D54mAAC","Username":"test@nuvemconsulting.com","LastName":"userrrdddvvdddd","FirstName":"hiiiii user","Email":"test@nuvemconsulting.com","Alias":"huserss","CommunityNickname":"test","IsActive":true,"TimeZoneSidKey":"America/New_York","LocaleSidKey":"en_US","ProfileId":"00eU0000000ionTIAQ","EmailEncodingKey":"ISO-8859-1","LanguageLocaleKey":"en_US","UserPreferencesDisableAutoSubForFeeds":false,"UserPermissionsMobileUser":false,"Title":"title","MobilePhone":"0*86655457","Phone":"8765689","ContactId":"003f000000rTCjYAAW","FederationIdentifier":"test@nuvemconsulting.com"},'
            +'{"attributes":{"type":"User","url":"/services/data/v39.0/sobjects/User/005f0000002D5EIAA0"},"Id":"005f0000002D5EIAA0","Username":"test2@nuvemconsulting.com","LastName":"biii","FirstName":"robbbbb","Email":"test2@nuvemconsulting.com","Alias":"rbiii","CommunityNickname":"test2","IsActive":true,"TimeZoneSidKey":"America/New_York","LocaleSidKey":"en_US","ProfileId":"00eU0000000ionTIAQ","EmailEncodingKey":"ISO-8859-1","LanguageLocaleKey":"en_US","UserPreferencesDisableAutoSubForFeeds":false,"UserPermissionsMobileUser":false,"Title":"tioooo","MobilePhone":"999999","Phone":"999999","ContactId":"003f000000rStMTAA0","FederationIdentifier":"test2@nuvemconsulting.com"}],'
            +'"objContact":[{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/003f000000rTCjYAAW"},"Id":"003f000000rTCjYAAW","Name":"hiiiii user userrrr","FirstName":"hiiiii user","LastName":"test3","Phone":"8765689","FederationIdentifier":"test@nuvemconsulting.com"},'
            +'{"attributes":{"type":"Contact","url":"/services/data/v39.0/sobjects/Contact/003f000000rStMTAA0"},"Id":"003f000000rStMTAA0","Name":"robbbbb biii","Email":"test2@nuvemconsulting.com","FirstName":"robbbbb","LastName":"biii","Phone":"999999","FederationIdentifier":"test2@nuvemconsulting.com"}]}';*/
        
        String json=        '{"objUser":[{"WSLRNbrRouteNbr":"93411R0110","UserPreferencesDisableAutoSubForFeeds":false,"UserPermissionsMobileUser":false,"Username_Suffix_Global":".globalsit","Username":"test@nuvemconsulting.com","Title":"Developer","TimeZoneSidKey":"Asia/Beirut","street":"Nuvem 42 Street","state":"Nuvem 42 State","Source_Suffix":".nazsapapp","ProfileId":"00ef0000000DzcXAAS","PostalCode":"424242","Phone":null,"MobilePhone":"(990) 844-4539","LocaleSidKey":"en_US","LastName":"User 42 Test Deepthi","LanguageLocaleKey":"en_US","IsActive":true,"Id":"005f0000002D6jWAAS","FirstName":"Nuvem","FederationIdentifier":"test@nuvemconsulting.com","Fax":null,"EmailEncodingKey":"UTF-8","Email":"test@nuvemconsulting.com","Department":null,"country":"Nuvem 42 Country","ContactId":null,"CompanyName":"Nuvem Company","CommunityNickname":"Nuvem42","city":"Nuvem 42 City","Alias":"Nuvem43"}],"objContact":[{"Phone":null,"Name":"Nuvem User 42 Test Deepthi","LastName":"User 42 Test Deepthi","Id":"003f000000rTH5aAAG","FirstName":"Nuvem","FEDERATIONIDENTIFIER":"test@nuvemconsulting.com"}]}';

        
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