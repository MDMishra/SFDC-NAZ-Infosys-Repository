@isTest
private class AB_UpdateMissionTest {

    // Method tests trigger onBefore Insert
    static testMethod void testOnBeforeInsert() {
        //createTestData();
        Test.startTest();
        Id POCRecId = [Select Id, Name from RecordType where name = :label.POC_RecrdType limit 1].Id;
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
        
        US_Account_Target_Program__c objAcTrgt = new US_Account_Target_Program__c();
        objAcTrgt .Account__c=objAcc1.id;
        objAcTrgt .Brand_Category__c = 'High End';
        insert objAcTrgt ;
        GSC_Mission_KPI_Map__c objgac = new GSC_Mission_KPI_Map__c();
        objgac.name = 'CORE';
        insert objgac;
        objAcTrgt.Brand_Category_Text__c = 'High End';
        update objAcTrgt;
   //    GSC_Mission_KPI_Map__c objgac1 = new GSC_Mission_KPI_Map__c();
        objgac.name = 'High End';
        update objgac;
        objAcTrgt.Channel__c = 'Test';
        update objAcTrgt;
        Test.stopTest();
    }
    
    
 }