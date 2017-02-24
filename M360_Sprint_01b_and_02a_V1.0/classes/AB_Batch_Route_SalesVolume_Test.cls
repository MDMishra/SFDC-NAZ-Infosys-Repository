@isTest
private class AB_Batch_Route_SalesVolume_Test{

    static testmethod void test() {
       
       Route__c objRte2 = new Route__c();
       objRte2.WSLRNbrRouteNbr__c = 'usrNmbr';
       insert objRte2;
       
       Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = 'usrNmbr';
       insert objRte;
       
       
       
       Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
       
       account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;       
       insert objAc;
       
       account objAc2 = new account();
       objAc2.name = 'Test Account2';       
       objAc2.recordtypeid = POCRtype.id;       
       insert objAc2;
       
       RouteCust__c objCust2 = new RouteCust__c();
       objCust2.Route__c = objRte.id;
       objCust2.Account__c = objAc.id;
       objCust2.WSLRNbrRouteNbr__c = 'usrNmbr';
       insert objCust2;
       
       RouteCust__c objCust = new RouteCust__c();
       objCust.Route__c = objRte.id;
       objCust.Account__c = objAc2.id;
       objCust.WSLRNbrRouteNbr__c = 'usrNmbr';
       insert objCust;
       
       Acct_TotYR_Actuals__c objact = new Acct_TotYR_Actuals__c();
       objact.BrandGroupID__c = '1234';
       objact.account__c = objAc.id;
       objact.BrandGroupName__c = 'Bud';
       objact.Date__c = system.today();
       insert objact;
       
       Acct_TotYR_Actuals__c objact3 = new Acct_TotYR_Actuals__c();
       objact3.BrandGroupID__c = '1234';
       objact3.account__c = objAc.id;
       objact3.BrandGroupName__c = 'Bud';
       objact3.Date__c = system.today();
       insert objact3;
       
       Acct_TotYR_Actuals__c objact2 = new Acct_TotYR_Actuals__c();
       objact2.BrandGroupID__c = '12345';
       objact2.account__c = objAc2.id;
       objact2.BrandGroupName__c = 'Bud LIGHT';
       objact2.Date__c = system.today();
       insert objact2;
        
       MOB_Sales_Volume_Route__c obj1 = new MOB_Sales_Volume_Route__c();
       obj1.Route__c = objRte2.id;
       obj1.BrandGroupID__c = '1234';
       obj1.Date__c = system.today();
       OBJ1.Brand_Category__c = 'Bud';
       insert obj1;
       
       
       
       Test.startTest();
       AB_Batch_Route_SalesVolume c = new AB_Batch_Route_SalesVolume();
       Database.executeBatch(c);
       Test.stopTest();

       
    }
}