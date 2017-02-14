/* Description: Code coverage for ABS_PocAccountDetailPage*/
                                  /*ABS_WholesalerAccountDetail classes and*/
                                  /*ABS_MyRetailerAccountDetailcls */

@isTest
public class TestABS_WholesalerAccountDetail{
    public static string strProfile='';
    
    public static testMethod void findPocs1(){
        //string usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        //String s='Base Product';
        Decimal geolat = 0.2;
        Decimal geolong= 0.2;
        boolean retailersTeams =false;
        boolean OnPremises = true;
        boolean OffPremises= true;
        string myChannel= 'test';
        String recSize='2';
        string targetAchievements='3';
        boolean isFilteradded=true;
        string recMiles='2';
        ABS_WholesalerAccountDetail.findPocs(geolat, geolong, retailersTeams, OnPremises, OffPremises, myChannel, recSize, targetAchievements, isFilteradded, recMiles, true,'red'); //Change
        ABS_WholesalerAccountDetail.findPocs(0, 0, retailersTeams, OnPremises, OffPremises, myChannel, '', targetAchievements, isFilteradded, '', true,'red'); //Change
        //  public static user currentuser;
        user u = new user();
        u=[Select Id,Name,Email,Latitude,Longitude from User where Id=:'005U0000006A8sl'];
    }
    
    public static testMethod void myTest() 
    {
        
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        //System.runAs ( thisUser ) {
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
        objAcc1.RTL_SEG_NM_US__c ='RESTAURANT';
        objAcc1.FMB_Away__c = 0;
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
        
        
        
        Contact objCon = new Contact();
        objCon.LastName='TestCon';
        objCon.AccountId=objAcc2.id;
        insert objCon;
        
        AccountContactRole objACRole = new AccountContactRole();
        objACRole.ContactId=objCon.id;
        objACRole.AccountId=objAcc2.id;
        insert objACRole;
        
        US_Account_Target_Program__c objAcTrgt65 = new US_Account_Target_Program__c();
        objAcTrgt65.Account__c=objAcc1.id;
        objAcTrgt65.Brand_Category__c = '3D';
        insert objAcTrgt65;
        US_Account_Target_Program__c objAcTrg65 = new US_Account_Target_Program__c();
        objAcTrg65.Account__c=objAcc2.id;
        objAcTrg65.Brand_Category__c = '3D';
        insert objAcTrg65;
        
        US_Account_Target_Program__c objAcTrgt63 = new US_Account_Target_Program__c();
        objAcTrgt63.Account__c=objAcc1.id;
        objAcTrgt63.Brand_Category__c = 'Bud Club';
        objAcTrgt63.KPI_Group_Seq__c = 1;
        insert objAcTrgt63;
        US_Account_Target_Program__c objAcTrg63 = new US_Account_Target_Program__c();
        objAcTrg63.Account__c=objAcc2.id;
        objAcTrg63.Brand_Category__c = 'Bud Club';
        insert objAcTrg63;
        
        US_Account_Target_Program__c objAcTrgt611 = new US_Account_Target_Program__c();
        objAcTrgt611.Account__c=objAcc1.id;
        objAcTrgt611.Brand_Category__c = 'PromOpti';
        objAcTrgt611.KPI_Group_Seq__c = 2;
        insert objAcTrgt611;
        US_Account_Target_Program__c objAcTrg611 = new US_Account_Target_Program__c();
        objAcTrg611.Account__c=objAcc2.id;
        objAcTrg611.Brand_Category__c = 'PromOpti';
        insert objAcTrg611;
        
        US_Account_Target_Program__c objAcTrgt61 = new US_Account_Target_Program__c();
        objAcTrgt61.Account__c=objAcc1.id;
        objAcTrgt61.Brand_Category__c = 'FeaturesDisplays';
        insert objAcTrgt61;
        US_Account_Target_Program__c objAcTrg61 = new US_Account_Target_Program__c();
        objAcTrg61.Account__c=objAcc2.id;
        objAcTrg61.Brand_Category__c = 'FeaturesDisplays';
        insert objAcTrg61;
        
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
        objAcTrgt4.Brand_Category__c = 'AL-DR';
        insert objAcTrgt4;
        US_Account_Target_Program__c objAcTrgt5 = new US_Account_Target_Program__c();
        objAcTrgt5.Account__c=objAcc2.id;
        objAcTrgt5.Brand_Category__c = 'AL-DR';
        insert objAcTrgt5;
        
        US_Account_Target__c objAcTgt = new US_Account_Target__c();
        objAcTgt.Account__c = objAcc2.id;
        objAcTgt.Brand_Category__c = 'CORE';
        objAcTgt.SKU__c='test';
        objAcTgt.Account_Target_Program__c = objAcTrgt5.id;
        insert objAcTgt;
        
        US_Account_Target__c objAcTgt2 = new US_Account_Target__c();
        objAcTgt2.Account__c = objAcc1.id;
        objAcTgt2.Brand_Category__c = 'CORE';
        objAcTgt2.SKU__c='test2';
        objAcTgt2.Account_Target_Program__c = objAcTrgt3.id;
        insert objAcTgt2;
        
        US_Account_Target__c objAcTgt2_dup = new US_Account_Target__c();
        objAcTgt2_dup.Account__c = objAcc1.id;
        objAcTgt2_dup.Brand_Category__c = 'CORE';
        objAcTgt2_dup.SKU__c='test3';
        objAcTgt2_dup.Account_Target_Program__c = objAcTrgt3.id;
        insert objAcTgt2_dup;
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = [select id from folder where name = 'Brand Images' limit 1].id;
        insert document;
        
        SKU_Brand_Image__c objSKU = new SKU_Brand_Image__c();
        objSKU.name='test';
        objSKU.Sku_Image_Id__c = string.valueOf(document.id);
        insert objSKU;
        SKU_Brand_Image__c objSKU2 = new SKU_Brand_Image__c();
        objSKU2.name='test2';
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
        ApexPages.currentPage().getParameters().put('accParam',objAcc1.Id);
        
        ABS_WholesalerAccountDetail.accountpocId = objAcc1.Id;
        ABS_WholesalerAccountDetail.Premise = 'On Premise';
        ABS_WholesalerAccountDetail.channel = 'RESTAURANT';
        ABS_WholesalerAccountDetail.MyRetailersTeam = true;
        ABS_WholesalerAccountDetail.OnPremise = true;
        ABS_WholesalerAccountDetail.OffPremise = false;
        
        //PageReference pageRef = Page.ABS_WholesalerAccountDetail;
        //Test.setCurrentPage(pageRef);
        Test.setCurrentPageReference(new PageReference('Page.ABS_WholesalerAccountDetail'));
        System.currentPageReference().getParameters().put('firstParam', '39.810121');
        System.currentPageReference().getParameters().put('secondParam', '-104.970731');
        //strProfile = 'System Administrator';
        strProfile = Label.ABS_Profiles;
        //abs.mapHelper();
        //abs.myActionInController();   
        abs.getChannelOptions(); 
        
        //ABS_WholesalerAccountDetail.findPocs(39.830121, -104.970831,'My Retailers','On Premise','RESTAURANT','1','0');
        ABS_WholesalerAccountDetail.findPocs(39.830121, -104.970831,true,true,false,'RESTAURANT','1','0',true,'2',true,'red'); 
        //Decimal geolat, Decimal geolong,boolean retailersTeams,boolean OnPremises,boolean OffPremises,string myChannel,String recSize,string targetAchievements,boolean isFilteradded,string recMiles
        //ABS_WholesalerAccountDetail.accountColor(1,1);
        ABS_WholesalerAccountDetail.pocdetails();
        abs.submitCase();
        List<SelectOption> selOpts=abs.getChannelOptions();
        
        //code coverage for ABS_PocAccountDetailPage class
        Test.setCurrentPageReference(new PageReference('Page.ABS_MyFilters'));
        ApexPages.currentPage().getParameters().put('lat','39.810121');
        ApexPages.currentPage().getParameters().put('lon','-104.970731');
        ApexPages.currentPage().getParameters().put('id',objAcc2.id);
        ABS_PocAccountDetailcls absPOC = new ABS_PocAccountDetailcls();
        //absPOC.pocId = objAcc2.id;
        system.debug('absPOC.pocId====='+absPOC.pocId);
        
        absPOC.pocdetails();
        System.currentPageReference().getParameters().put('firstParam', '0');
        System.currentPageReference().getParameters().put('secondParam', '0');
        System.debug('ApexPages.currentPage().getParameters().get(firstParam)    '+ApexPages.currentPage().getParameters().get('firstParam'));
        absPOC.pocdetails();
    }
    static testMethod void myTest1() 
    {
        //User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        //System.runAs ( thisUser ) {
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
        
        /*Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' limit 1]; 
User u = new User(Alias = 'tsss', Email='standarduser@testorg.com', 
EmailEncodingKey='UTF-8', LastName='Testingsss', LanguageLocaleKey='en_US', 
LocaleSidKey='en_US', ProfileId = p.Id, 
TimeZoneSidKey='America/Los_Angeles', UserName='testuserNuvem@testorg.com',
Street='1455 E 62nd Ave',City='Denver',State='CO',Latitude=39.810121,Longitude=-104.970731);

insert u;*/
        
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
        objAcTrgt4.Brand_Category__c = 'AL-DR';
        insert objAcTrgt4;
        US_Account_Target_Program__c objAcTrgt5 = new US_Account_Target_Program__c();
        objAcTrgt5.Account__c=objAcc2.id;
        objAcTrgt5.Brand_Category__c = 'AL-DR';
        insert objAcTrgt5;
        
        US_Account_Target__c objAcTgt = new US_Account_Target__c();
        objAcTgt.Account__c = objAcc2.id;
        objAcTgt.Brand_Category__c = 'CORE';
        objAcTgt.SKU__c='test';
        objAcTgt.Account_Target_Program__c = objAcTrgt5.id;
        insert objAcTgt;
        
        US_Account_Target__c objAcTgt2 = new US_Account_Target__c();
        objAcTgt2.Account__c = objAcc1.id;
        objAcTgt2.Brand_Category__c = 'CORE';
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
        objSKU.name='test';
        objSKU.Sku_Image_Id__c = string.valueOf(document.id);
        insert objSKU;
        SKU_Brand_Image__c objSKU2 = new SKU_Brand_Image__c();
        objSKU2.name='test2';
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
        strProfile = 'System Administrator';      
        
        Test.setCurrentPageReference(new PageReference('Page.ABS_MyFilters'));
        System.currentPageReference().getParameters().put('Premise', 'test');
        System.currentPageReference().getParameters().put('Channel','test');
        System.currentPageReference().getParameters().put('retailersTeam','test');
        System.currentPageReference().getParameters().put('OnPremise','test');
        System.currentPageReference().getParameters().put('OffPremise','test');
        System.currentPageReference().getParameters().put('size','20');
        System.currentPageReference().getParameters().put('ClosetoTargetAchievement','test');
        System.currentPageReference().getParameters().put('miles','10');
        System.currentPageReference().getParameters().put('LargeFormat','true');
        System.currentPageReference().getParameters().put('sapcolor','Red');
        ABS_WholesalerAccountDetail abs = new ABS_WholesalerAccountDetail();
        ABS_WholesalerAccountDetail.largeformat = true;
        ABS_WholesalerAccountDetail.findPocs(39.830121, -104.970831,true,true,false,'RESTAURANT','1','0',true,'2',true,'red');
    }
    
    // test method for AccountTargetBrandWrapper class
    static testMethod void testATBW()
    {
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        ABS_WholesalerAccountDetail.AccountTargetBrandWrapper objATBW1 = new ABS_WholesalerAccountDetail.AccountTargetBrandWrapper();
        objATBW1.grpSeq = 2;
        objATBW1.catSeq = 1;
        objATBW1.brandGrp = 'brandGrp';
        objATBW1.KPIGrpSeq = 1;
        objATBW1.brandCatSeq = 2;
        objATBW1.mappinColor = 'mappinColor';
        objATBW1.userName = 'userName';
        objATBW1.userlat = 'userlat';
        objATBW1.userlong = 'userlong';
        objATBW1.mapUrl = 'mapUrl';
        objATBW1.pocAccount = objAcc;
        objATBW1.ATBcolor = 'Red';
        objATBW1.recId = 'RecId';
        objATBW1.Filter = 'Filter';
        objATBW1.Pannelvalue = 'Pannelvalue';
        
        ABS_WholesalerAccountDetail.AccountTargetBrandWrapper objATBW2 = new ABS_WholesalerAccountDetail.AccountTargetBrandWrapper();
        objATBW2.grpSeq = 1;
        objATBW2.catSeq = 1;
        
        ABS_WholesalerAccountDetail.AccountTargetBrandWrapper objATBW6 = new ABS_WholesalerAccountDetail.AccountTargetBrandWrapper();
        objATBW6.grpSeq = 3;
        objATBW6.catSeq = 1;
        
        ABS_WholesalerAccountDetail.AccountTargetBrandWrapper objATBW3 = new ABS_WholesalerAccountDetail.AccountTargetBrandWrapper();
        objATBW3.grpSeq = 2;
        objATBW3.catSeq = 1;
        
        ABS_WholesalerAccountDetail.AccountTargetBrandWrapper objATBW4 = new ABS_WholesalerAccountDetail.AccountTargetBrandWrapper();
        objATBW4.grpSeq = 2;
        objATBW4.catSeq = 3;
        
        ABS_WholesalerAccountDetail.AccountTargetBrandWrapper objATBW5 = new ABS_WholesalerAccountDetail.AccountTargetBrandWrapper();
        objATBW5.grpSeq = 2;
        objATBW5.catSeq = 2;
        
        List<ABS_WholesalerAccountDetail.AccountTargetBrandWrapper> lstATBW = new List<ABS_WholesalerAccountDetail.AccountTargetBrandWrapper>();
        lstATBW.add(objATBW1);
        lstATBW.add(objATBW2);
        lstATBW.add(objATBW3);
        lstATBW.add(objATBW4);
        lstATBW.add(objATBW5);
        lstATBW.add(objATBW6);
        lstATBW.sort();
    }
    
    //test method for AccountTargetWrapper class
    static testMethod void testATW()
    {
        ABS_WholesalerAccountDetail.AccountTargetWrapper objATW = new ABS_WholesalerAccountDetail.AccountTargetWrapper();
        objATW.brandSeq = 1;
        objATW.catSeq = 2;
        objATW.mappinColor = 'Grey';
        objATW.mapUrl = 'mapUrl';
        objATW.userName = 'userName';
        objATW.userlat = 2.0;
        objATW.userlong = 4.0;
        objATW.Filter = 'Filter';
        objATW.pocAccount = new Account();
        objATW.id = '1221';
    }
    
    static testMethod void testPAW()
    {
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        ABS_WholesalerAccountDetail.pocAccountWrapper objPAW = new ABS_WholesalerAccountDetail.pocAccountWrapper();
        objPAW.pocName = 'pocName';
        objPAW.objPocAccount = objAcc;
        objPAW.mapPocPinColor = 'Blue';
        objPAW.palat = 3.2;
        objPAW.palon = 2.1;
        objPAW.lstSeq3 = new list<ABS_WholesalerAccountDetail.AccountTargetBrandWrapper>();
        objPAW.lstSeq4 = new list<ABS_WholesalerAccountDetail.AccountTargetBrandWrapper>();
    }
    
    static testMethod void testEvntLgTrack()
    {
        //ABS_WholesalerAccountDetail objWAD = new ABS_WholesalerAccountDetail();
        Apexpages.currentPage().getParameters().put('paramEvent','testEvent//test2//testPlace//test4//testMission');
        ABS_WholesalerAccountDetail.EvntLgTrack();
        Apexpages.currentPage().getParameters().put('paramEventType','testType');
        ABS_WholesalerAccountDetail.EvntLgTrack();
    }
    
    static testMethod void testGetAndSet()
    {
        ABS_WholesalerAccountDetail.assortmentList = new List<String>();
        ABS_WholesalerAccountDetail.executionList = new List<String>();
    }
}