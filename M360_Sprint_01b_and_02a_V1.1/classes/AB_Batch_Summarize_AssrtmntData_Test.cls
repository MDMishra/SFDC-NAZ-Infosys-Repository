@isTest
public class AB_Batch_Summarize_AssrtmntData_Test{
    static testMethod void UnitTest() {
        Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
        account objAc = new account();
        objAc.name = 'Test Account';       
        objAc.recordtypeid = POCRtype.id;
        objAc.billingCity = 'Hyderabad';
        objAc.billingstreet = 'ttt\r\nHyderabad';
        objAc.billingCountry = 'Hyderabad';
        objAc.billingPostalCode = '500459';
        objAc.Trade_Program_NM__c = 'MACRO';
        objAc.RTL_SEG_NM_US__c = 'PACKAGE LIQUOR';
        //objAc.Wholesaler__c = objAcWhole.id;
        objAc.WSLR_NBR_US__c = '54554';
        objAc.WSLR_ASGND_CUST_NBR_US__c = '434343';
        insert objAc; 
        
        Route__c objRte2 = new Route__c();
        objRte2.WSLRNbrRouteNbr__c = '0D010093141';      
        insert objRte2;
              
        RouteCust__c objCust = new RouteCust__c();
        objCust.Route__c = objRte2.id;
        objCust.Account__c = objAc.id;
        objCust.WSLRNbrRouteNbr__c = '0D010093141';
        insert objCust;
        
        RouteCust__c objCust2 = new RouteCust__c();
        objCust2.Route__c = objRte2.id;
        objCust2.Account__c = objAc.id;
        objCust2.WSLRNbrRouteNbr__c = '0D010093141';
        insert objCust2;
        
        
        US_Account_Target_Program__c objAcTrgt6 = new US_Account_Target_Program__c();
        objAcTrgt6.Account__c=objAc.id;
        objAcTrgt6.Brand_Category__c = 'FMB';       
        insert objAcTrgt6;
        
        US_Account_Target_Program__c objAcTrg6 = new US_Account_Target_Program__c();
        objAcTrg6.Account__c=objAc.id;
        objAcTrg6.Brand_Category__c = 'FMB';
        insert objAcTrg6;
        
        Test.startTest();
       AB_Batch_Summarize_AssrtmntData c = new AB_Batch_Summarize_AssrtmntData();
       Database.executeBatch(c);
       Test.stopTest();
    }
}