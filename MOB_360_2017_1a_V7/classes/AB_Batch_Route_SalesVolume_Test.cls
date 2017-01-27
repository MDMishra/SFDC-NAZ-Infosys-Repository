@isTest
private class AB_Batch_Route_SalesVolume_Test{

    static testmethod void test() {
       
       Route__c objRte2 = new Route__c();
       objRte2.WSLRNbrRouteNbr__c = 'usrNmbr';
       insert objRte2;
       
       Route__c objRte = new Route__c();
       objRte.WSLRNbrRouteNbr__c = 'usrNmbr';
       insert objRte;
       
       Route_TotYR_Actuals__c objact = new Route_TotYR_Actuals__c();
       objact.BrandGroupID__c = '1234';
       objact.Route__c = objRte2.id;
       objact.BrandGroupName__c = 'Bud';
       objact.Date__c = system.today();
       insert objact;
       
       Route_TotYR_Actuals__c objact2 = new Route_TotYR_Actuals__c();
       objact2.BrandGroupID__c = '12345';
       objact2.Route__c = objRte.id;
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