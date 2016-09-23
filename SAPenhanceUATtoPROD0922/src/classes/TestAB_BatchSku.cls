@isTest
private class TestAB_BatchSku {

    static testmethod void test() {
        // The query used by the batch job.
        String query = 'Select  SKU__c FROM US_Account_Target__c where SKU__c!=null';

       // Create some test US_Account_Target__c items
       //   by the batch job.
       US_Account_Target__c[] objAcc = new List<US_Account_Target__c>();
       RecordType objRec = [select id from RecordType where SObjectType = 'Account' limit 1];
       Account acc = new Account();
       acc.RecordTypeId = objRec.id;
       acc.name = 'Test';
       insert acc;
       
       US_Account_Target_Program__c objTrgt = new US_Account_Target_Program__c();
       objTrgt.Account__c = acc.id;
       insert objTrgt;
       
       SKU_Brand_Image__c objSkuBrnd = new SKU_Brand_Image__c();
       objSkuBrnd.name = 'Text2';
       insert objSkuBrnd;
                
       for (Integer i=0;i<10;i++) {
           US_Account_Target__c m = new US_Account_Target__c();
           US_Account_Target__c objAccTgt = new US_Account_Target__c();
           objAccTgt.Account__c = acc.id;
           objAccTgt.SKU__c = 'Text';
           objAccTgt.Account_Target_Program__c = objTrgt.id;
           objAcc.add(objAccTgt);
       }
       insert objAcc;

       objAcc = database.query(query);
       Test.startTest(); 
       AB_BatchSku  obj= new AB_BatchSku();
       Database.BatchableContext BC;
       obj.start(BC);
       obj.execute(BC,objAcc);
       obj.finish(BC);  
       Test.stopTest();

    }
    static testmethod void SKUtest2() {
        // The query used by the batch job.
        String query = 'Select  SKU__c FROM US_Account_Target__c where SKU__c!=null';

       // Create some test US_Account_Target__c items
       //   by the batch job.
       US_Account_Target__c[] objAcc = new List<US_Account_Target__c>();
       RecordType objRec = [select id from RecordType where SObjectType = 'Account' limit 1];
       Account acc = new Account();
       acc.RecordTypeId = objRec.id;
       acc.name = 'Test';
       insert acc;
       
       US_Account_Target_Program__c objTrgt = new US_Account_Target_Program__c();
       objTrgt.Account__c = acc.id;
       insert objTrgt;
       
       SKU_Brand_Image__c objSkuBrnd = new SKU_Brand_Image__c();
       objSkuBrnd.name = 'Text';
       insert objSkuBrnd;
                
       for (Integer i=0;i<10;i++) {
           US_Account_Target__c m = new US_Account_Target__c();
           US_Account_Target__c objAccTgt = new US_Account_Target__c();
           objAccTgt.Account__c = acc.id;
           objAccTgt.SKU__c = 'Text';
           objAccTgt.Account_Target_Program__c = objTrgt.id;
           objAcc.add(objAccTgt);
       }
       insert objAcc;

       objAcc = database.query(query);
       Test.startTest(); 
       AB_BatchSku  obj= new AB_BatchSku();
       Database.BatchableContext BC;
       obj.start(BC);
       obj.execute(BC,objAcc);
       obj.finish(BC);  
       Test.stopTest();

    }
}