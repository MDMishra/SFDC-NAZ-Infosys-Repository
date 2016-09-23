/* Description: Code coverage for ABS_PocAccountDetailPage*/
                                  /*ABS_WholesalerAccountDetail classes and*/
                                  /*ABS_MyRetailerAccountDetailcls */

@isTest
public class TestABS_WholesalerAccountDetail{
    
    static testMethod void myTest() 
    {
    
     User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
     System.runAs ( thisUser ) {
    
        Id WsRecId = [Select Id, Name from RecordType where name = :label.WholeSaler_RecrdType limit 1].Id;
        Id POCRecId = [Select Id, Name from RecordType where name = :label.POC_RecrdType limit 1].Id;
        Account objAcc= new Account();
        objAcc.Name='TestAccount';
        objAcc.RecordTypeId=WsRecId;
        objAcc.BillingStreet='1455 E 62nd Ave';
        objAcc.BillingCity='Denver';
        objAcc.BillingState='CO';
        objAcc.BillingLatitude=39.810121;
        objAcc.BillingLongitude=-104.970731;       
        objAcc.Phone = '232323454';
        objAcc.BillingCountry = 'USA';
        objAcc.BillingPostalCode='80123';
        objAcc.buzz_retail__lon__c=39.810121;
        objAcc.buzz_retail__lat__c=-104.970731;
        objAcc.WSLR_NBR_US__c='255';
        insert objAcc;
        
        objAcc.Location__Latitude__s = objAcc.BillingLatitude;
        objAcc.Location__Longitude__s = objAcc.BillingLongitude;
        update objAcc;
        
        Account objAcc1= new Account();
        objAcc1.Name='TestAccount1';
        objAcc1.RecordTypeId=POCRecId;
        //objAcc1.ParentId=objAcc.id;
        //objAcc1.Wholesaler__c=objAcc.id;
        objAcc1.BillingStreet='1455 E 62nd Ave';
        objAcc1.BillingCity='Denver';
        objAcc1.BillingState='CO';
        objAcc1.BillingLatitude=39.820921;
        objAcc1.BillingLongitude=-104.970531;
        objAcc1.Phone = '232323454';
        objAcc1.BillingCountry = 'USA';
        objAcc1.BillingPostalCode='80123';
        objAcc1.buzz_retail__lon__c=39.810121;
        objAcc1.buzz_retail__lat__c=-104.970731;
        objAcc1.WSLR_NBR_US__c='255';
        insert objAcc1;
        
        objAcc1.Location__Latitude__s = objAcc1.BillingLatitude;
        objAcc1.Location__Longitude__s = objAcc1.BillingLongitude;
        update objAcc1;
        
        Account objAcc2= new Account();
        objAcc2.Name='TestAccount2';
        objAcc2.RecordTypeId=POCRecId;
        //objAcc2.Wholesaler__c=objAcc.id;
        objAcc2.BillingStreet='1455 E 62nd Ave';
        objAcc2.BillingCity='Denver';
        objAcc2.BillingState='CO';      
        objAcc2.BillingLatitude=39.830121;
        objAcc2.BillingLongitude=-104.970831;
        objAcc2.Phone = '232323454';
        objAcc2.BillingCountry = 'USA';
        objAcc2.BillingPostalCode='80123';
        objAcc2.buzz_retail__lon__c=39.810121;
        objAcc2.buzz_retail__lat__c=-104.970731;
        objAcc2.WSLR_NBR_US__c='255';
        insert objAcc2;
        
        objAcc2.Location__Latitude__s = objAcc2.BillingLatitude;
        objAcc2.Location__Longitude__s = objAcc2.BillingLongitude;
        update objAcc2;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' limit 1]; 
        User u = new User(Alias = 'tsss', Email='standarduser@testorg.com', 
                        EmailEncodingKey='UTF-8', LastName='Testingsss', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='testuserNuvem@testorg.com',
                        Street='1455 E 62nd Ave',City='Denver',State='CO',Latitude=39.810121,Longitude=-104.970731);
        
        insert u;
        
        Contact objCon = new Contact();
        objCon.LastName='TestCon';
        objCon.AccountId=objAcc2.id;
        insert objCon;
        
        AccountContactRole objACRole = new AccountContactRole();
        objACRole.ContactId=objCon.id;
        objACRole.AccountId=objAcc2.id;
        insert objACRole;
        
        US_Account_Target_Program__c objAcTrgt6 = new US_Account_Target_Program__c();
        objAcTrgt6.Account__c=objAcc1.id;
        objAcTrgt6.Brand_Category__c = 'FMB';
        insert objAcTrgt6;
        US_Account_Target_Program__c objAcTrg6 = new US_Account_Target_Program__c();
        objAcTrg6.Account__c=objAcc2.id;
        objAcTrg6.Brand_Category__c = 'FMB';
        insert objAcTrg6;
        
        US_Account_Target_Program__c objAcTrgt = new US_Account_Target_Program__c();
        objAcTrgt.Account__c=objAcc1.id;
        objAcTrgt.Brand_Category__c = 'CORE';
        insert objAcTrgt;
        US_Account_Target_Program__c objAcTrg = new US_Account_Target_Program__c();
        objAcTrg.Account__c=objAcc2.id;
        objAcTrg.Brand_Category__c = 'CORE';
        insert objAcTrg;
        
        US_Account_Target_Program__c objAcTrgt3 = new US_Account_Target_Program__c();
        objAcTrgt3.Account__c=objAcc1.id;
        objAcTrgt3.Brand_Category__c = 'High End';
        insert objAcTrgt3;
        US_Account_Target_Program__c objAcTrg3 = new US_Account_Target_Program__c();
        objAcTrg3.Account__c=objAcc2.id;
        objAcTrg3.Brand_Category__c = 'High End';
        insert objAcTrg3;
        
        US_Account_Target_Program__c objAcTrgt4 = new US_Account_Target_Program__c();
        objAcTrgt4.Account__c=objAcc2.id;
        objAcTrgt4.Brand_Category__c = 'ALNR';
        insert objAcTrgt4;
        US_Account_Target_Program__c objAcTrgt5 = new US_Account_Target_Program__c();
        objAcTrgt5.Account__c=objAcc2.id;
        objAcTrgt5.Brand_Category__c = 'DRFT';
        insert objAcTrgt5;
        
        US_Account_Target__c objAcTgt = new US_Account_Target__c();
        objAcTgt.Account__c = objAcc2.id;
        objAcTgt.Brand_Category__c = 'CORE';
        objAcTgt.SKU__c='test1';
        objAcTgt.Brand_Package__c = 'Flex Flavor';
        objAcTgt.Account_Target_Program__c = objAcTrgt5.id;
        insert objAcTgt;
        
        US_Account_Target__c objAcTgt2 = new US_Account_Target__c();
        objAcTgt2.Account__c = objAcc1.id;
        objAcTgt2.Brand_Category__c = 'CORE';
        objAcTgt2.Brand_Package__c = 'BDL/BUD/MUL dfds';
        objAcTgt2.SKU__c='test2';
        objAcTgt2.Account_Target_Program__c = objAcTrgt3.id;
        insert objAcTgt2;
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = [select id from folder where name = 'Brand Images' limit 1].id;
        insert document;
        
        SKU_Brand_Image__c objSKU = new SKU_Brand_Image__c();
        objSKU.name='FLEX';
        objSKU.Sku_Image_Id__c = string.valueOf(document.id);
        insert objSKU;
        SKU_Brand_Image__c objSKU2 = new SKU_Brand_Image__c();
        objSKU2.name='ALUM';
        objSKU2.Sku_Image_Id__c = string.valueOf(document.id);
        insert objSKU2;
        
        AccountTeamMember objAcTeam = new AccountTeamMember();
        objAcTeam.AccountId = objAcc1.id;
        objAcTeam.UserId = userinfo.getuserId();
        insert objAcTeam;
             
        // The following code runs as user 'u' 
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        // The following code runs as user 'u' 
        System.debug('Current User: ' + UserInfo.getUserName());
        System.debug('Current Profile: ' + UserInfo.getProfileId()); 
               
        ABS_WholesalerAccountDetail abs = new ABS_WholesalerAccountDetail();
        //PageReference pageRef = Page.ABS_WholesalerAccountDetail;
        //Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(new PageReference('Page.ABS_WholesalerAccountDetail'));
        System.currentPageReference().getParameters().put('firstParam', '39.810121');
        System.currentPageReference().getParameters().put('secondParam', '-104.970731');
        
        abs.mapHelper();
        abs.myActionInController();    
        system.assertEquals(abs.relatesPOCAccounts.size(),2);   
               
        //code coverage for ABS_PocAccountDetailPage class
        ApexPages.currentPage().getParameters().put('lat','39.810121');
        ApexPages.currentPage().getParameters().put('lon','-104.970731');
        ApexPages.currentPage().getParameters().put('id',objAcc2.id);
        ABS_PocAccountDetailcls absPOC = new ABS_PocAccountDetailcls();
        //absPOC.pocId = objAcc2.id;
        system.debug('absPOC.pocId====='+absPOC.pocId);
        absPOC.pocdetails();
        
        ABS_MyRetailerAccountDetailcls  objRets = new ABS_MyRetailerAccountDetailcls ();
        objRets.wholesalerId = objAcc.id;
        objRets.myRetailers();
     }
    }    
}