/*Apex class:ABS_WholesalerAccountDetail 
Description:Code coverage for ABS_PocAccountDetail class
This Controller is used in ABS_WholesalerAccountDetail Page
Created By :Vamsi Mohan Batchu
Created Date:03/03/2017
Modified Date:
Modified By:
*/

@isTest
private class ABS_WholesalerAccountDetail_Test{
    public static string strProfile='';
    
    //Utility method to create account
    static Account createAccount()
    {
        Id POCRecId = [Select Id, Name from RecordType where name = :label.POC_RecrdType limit 1].Id;
        
        Account objAcc1= new Account();
        objAcc1.Name='TestAccount1';
        objAcc1.RecordTypeId=POCRecId;
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
        objAcc1.Location__Latitude__s = objAcc1.BillingLatitude;
        objAcc1.Location__Longitude__s = objAcc1.BillingLongitude;
        objAcc1.HE_Away__c = 0;
        return objAcc1;
    }
    
    //Tests getChannelOptions and submit case methods along with constructor creation
    static testMethod void constructorTest(){
        //Test.setCurrentPageReference(new PageReference('Page.ABS_MyFilters'));
        System.currentPageReference().getParameters().put('Premise', 'test');
        System.currentPageReference().getParameters().put('Channel','RESTAURANT');
        System.currentPageReference().getParameters().put('retailersTeam','test');
        System.currentPageReference().getParameters().put('OnPremise','test');
        System.currentPageReference().getParameters().put('OffPremise','test');
        System.currentPageReference().getParameters().put('size','20');
        System.currentPageReference().getParameters().put('ClosetoTargetAchievement','0');
        System.currentPageReference().getParameters().put('miles','10');
        System.currentPageReference().getParameters().put('LargeFormat','true');
        System.currentPageReference().getParameters().put('sapcolor','Red');
        System.currentPageReference().getParameters().put('wholesalerLimit','2');
        
        Account objAcc1 = createAccount();
        insert objAcc1;
        Account acc = [select SAP_Channel__c from Account where id=:objAcc1.Id];
        System.debug('objAcc1 =====>   ' +objAcc1);
        System.debug('SAP_Channel__c =====>   ' +acc.SAP_Channel__c);
        US_Account_Target_Program__c objAcTrgt65 = new US_Account_Target_Program__c();
        objAcTrgt65.Account__c=objAcc1.id;
        objAcTrgt65.Brand_Category__c = '3D';
        insert objAcTrgt65;
        
        ABS_WholesalerAccountDetail abs = new ABS_WholesalerAccountDetail();
        List<SelectOption> selOpts=abs.wholeSalerFilter;
        abs.getChannelOptions();
        abs.submitCase();
    }
    
    //tests EvntLgTrack method
    static testMethod void testEvntLgTrack()
    {
        Apexpages.currentPage().getParameters().put('paramEventType','testType');
        ABS_WholesalerAccountDetail.EvntLgTrack();
    }
    
    //tests findPocs method
    static testMethod void testFindPocs(){
        
        Decimal geolat = 39.910121;
        Decimal geolong= -104.070731;
        boolean retailersTeams =false;
        boolean OnPremises = true;
        boolean OffPremises= true;
        string myChannel= 'RESTAURANT';
        String recSize='2';
        string targetAchievements='0';
        boolean isFilteradded=true;
        string recMiles='100';
        retailersTeams =false;
        OnPremises = false;
        OffPremises= false;
        myChannel= '';
        recSize='';
        targetAchievements='';
        isFilteradded=false;
        recMiles='';
        
        Id WsRecId = [Select Id, Name from RecordType where name = :label.WholeSaler_RecrdType limit 1].Id;
        
        Account objAcc= new Account();
        objAcc.Name='TestAccount';
        objAcc.RecordTypeId=WsRecId;
        objAcc.BillingStreet='1455 E 62nd Ave';
        objAcc.BillingCity='Denver';
        objAcc.BillingState='CO';
        objAcc.BillingLatitude=39.910121;
        objAcc.BillingLongitude=-104.970731;       
        objAcc.Phone = '232323454';
        objAcc.BillingCountry = 'USA';
        objAcc.BillingPostalCode='80123';
        objAcc.buzz_retail__lon__c=39.910121;
        objAcc.buzz_retail__lat__c=-104.970731;
        objAcc.WSLR_NBR_US__c='255';
        objAcc.WSLR_ACTV_FLG_US__c=true;
        insert objAcc;
        
        Account objAcc1 = createAccount();
        objAcc1.Wholesaler__c= objAcc.Id;
        insert objAcc1;
        
        AccountTeamMember objAcTeam = new AccountTeamMember();
        objAcTeam.AccountId = objAcc1.id;
        objAcTeam.UserId = userinfo.getuserId();
        insert objAcTeam;
        
        US_Account_Target_Program__c objAcTrgt6 = new US_Account_Target_Program__c();
        objAcTrgt6.Account__c=objAcc1.id;
        objAcTrgt6.Brand_Category__c = 'FMB';
        objAcTrgt6.SAP_Color_Indicator_Num__c = 1;
        objAcTrgt6.KPI_Group__c = 'Assortment';
        insert objAcTrgt6;
        
        US_Account_Target_Program__c objAcTrgt7 = new US_Account_Target_Program__c();
        objAcTrgt7.Account__c=objAcc1.id;
        objAcTrgt7.Brand_Category__c = 'FMB';
        objAcTrgt7.Brand_Category_Text__c = 'test2';
        insert objAcTrgt7;
        
        ABS_WholesalerAccountDetail.findPocs(geolat, geolong, retailersTeams, OnPremises, OffPremises, myChannel, recSize, targetAchievements, isFilteradded, recMiles, false,'',''); //Change
        ABS_WholesalerAccountDetail.findPocs(0, 0, retailersTeams, OnPremises, OffPremises, myChannel, '', targetAchievements, isFilteradded, '', true,'Green','2'); //Change
    }
    
    //tests POCDetails method
    static testMethod void testPOCDetails()
    {
        Id WsRecId = [Select Id, Name from RecordType where name = :label.WholeSaler_RecrdType limit 1].Id;
        
        Account objAccs1= new Account();
        objAccs1.Name='TestAccount';
        objAccs1.RecordTypeId=WsRecId;
        objAccs1.BillingStreet='1455 E 62nd Ave';
        objAccs1.BillingCity='Denver';
        objAccs1.BillingState='CO';
        objAccs1.BillingLatitude=39.810121;
        objAccs1.BillingLongitude=-104.970731;       
        objAccs1.Phone = '232323454';
        objAccs1.BillingCountry = 'USA';
        objAccs1.BillingPostalCode='80123';
        objAccs1.buzz_retail__lon__c=39.810121;
        objAccs1.buzz_retail__lat__c=-104.970731;
        objAccs1.WSLR_NBR_US__c='255';
        insert objAccs1;
        
        Account objAcc = createAccount();
        objAcc.Wholesaler__c= objAccs1.Id;
        insert objAcc;
        
        US_Account_Target_Program__c objAcTrgt6 = new US_Account_Target_Program__c();
        objAcTrgt6.Account__c=objAcc.id;
        objAcTrgt6.Brand_Category__c = 'FMB';
        objAcTrgt6.Brand_Category_Text__c = 'test';
        insert objAcTrgt6;
        
        US_Account_Target__c objAcTgt = new US_Account_Target__c();
        objAcTgt.Account__c = objAcc.id;
        objAcTgt.Brand_Category__c = 'CORE';
        objAcTgt.SKU__c='test';
        objAcTgt.Account_Target_Program__c = objAcTrgt6.id;
        insert objAcTgt;
        
        US_Account_Target__c objAcTgt2 = new US_Account_Target__c();
        objAcTgt2.Account__c = objAcc.id;
        objAcTgt2.Brand_Category__c = 'CORE';
        objAcTgt2.SKU__c='test2';
        objAcTgt2.Account_Target_Program__c = objAcTrgt6.id;
        insert objAcTgt2;
        
        SKU_Brand_Image__c objSKU = new SKU_Brand_Image__c();
        objSKU.name = 'test';
        insert objSKU;
        
        Apexpages.currentPage().getParameters().put('firstParam', '39.810121');
        Apexpages.currentPage().getParameters().put('secondParam', '-104.970731');
        ApexPages.currentPage().getParameters().put('accParam',objAcc.Id);
        ABS_WholesalerAccountDetail.pocdetails();
        
    }
    
    //tests extra getter and setters
    static testMethod void testGetAndSet()
    {
        ABS_WholesalerAccountDetail.assortmentList = new List<String>();
        ABS_WholesalerAccountDetail.executionList = new List<String>();
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
}