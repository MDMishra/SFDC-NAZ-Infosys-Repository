/*Code coverage for AB_Batch_Acc_SalesVolume and AB_SVolumeBatches_Execution_Trg*/
@isTest
private class AB_Batch_Acc_SalesVolume_Test{

    static testmethod void test() {
        // The query used by the batch job.
        EventLog__c objEve = new EventLog__c();
        objEve.Application__c = 'Mob360';
        objEve.Event__c = 'AccountActualVolumeLoaded';
        insert objEve;
        
        Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;       
       insert objAc;
       
       account objAc2 = new account();
       objAc2.name = 'Test Account2';       
       objAc2.recordtypeid = POCRtype.id;       
       insert objAc2;
       
       Acct_TotYR_Actuals__c objact = new Acct_TotYR_Actuals__c();
       objact.BrandGroupID__c = '1234';
       objact.account__c = objAc.id;
       objact.BrandGroupName__c = 'Bud';
       objact.Date__c = system.today();
       insert objact;
       
       Acct_TotYR_Actuals__c objact2 = new Acct_TotYR_Actuals__c();
       objact2.BrandGroupID__c = '12345';
       objact2.account__c = objAc2.id;
       objact2.BrandGroupName__c = 'Bud LIGHT';
       objact2.Date__c = system.today();
       insert objact2;
        
       MOB_Sales_Volume_Account__c  obj1 = new MOB_Sales_Volume_Account__c();
       obj1.Account__c = objAc.id;
       obj1.BrandGroupID__c = '1234';
       obj1.Date__c = system.today();
       OBJ1.Brand_Category__c = 'Bud';
       insert obj1;
       
       
       
       Test.startTest();
       AB_Batch_Acc_SalesVolume c = new AB_Batch_Acc_SalesVolume();
       Database.executeBatch(c);
       Test.stopTest();

       
    }
}