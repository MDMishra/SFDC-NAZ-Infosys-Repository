/* code coverage for AONTAP_OrderTrigger_TapwiserUpate*/

@isTest
public class ONTAP_OrderTrigger_TapwiserUpate_Test {
    static testmethod void UnitTest(){
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
        //objAc.WSLR_ASGND_CUST_NBR_US__c = '434343';
        //objAc.Wholesaler__c = objAcWhole.id;
        objAc.WSLR_NBR_US__c = '54554';
        objAc.WSLR_ASGND_CUST_NBR_US__c = '434343';
        insert objAc; 
       
        Route__c objRte2 = new Route__c();
        objRte2.WSLRNbrRouteNbr__c = '32323232';      
        insert objRte2;
       
        RouteCust__c objCust = new RouteCust__c();
        objCust.Route__c = objRte2.id;
        objCust.Account__c = objAc.id;
        objCust.WSLRNbrRouteNbr__c = '32323232';
        objCust.WSLRNbrCustIDRouteNbr__c = '434343';
        insert objCust;
        
        Recordtype RASRtype = [select id,name from Recordtype where SobjectType = 'ONTAP__Order__c' and name ='RAS'];
        system.debug('======='+RASRtype);
        ONTAP__Order__c OnTap = new ONTAP__Order__c();
        OnTap.RAS_OrderSource__c = 'tapwiser';
        OnTap.RAS_WSLRNbrCustIDRouteNbr__c = '434343';
        OnTap.RecordTypeId = RASRtype.id;
        OnTap.RAS_CustID__c = '67675';
        insert OnTap;
        //update OnTap;
    }
    static testmethod void UnitTest2(){
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
        //objAc.WSLR_ASGND_CUST_NBR_US__c = '434343';
        //objAc.Wholesaler__c = objAcWhole.id;
        objAc.WSLR_NBR_US__c = '54554';
        objAc.WSLR_ASGND_CUST_NBR_US__c = '67675';
        insert objAc; 
       
        Route__c objRte2 = new Route__c();
        objRte2.WSLRNbrRouteNbr__c = '32323232';      
        insert objRte2;
       
        RouteCust__c objCust = new RouteCust__c();
        objCust.Route__c = objRte2.id;
        objCust.Account__c = objAc.id;
        objCust.WSLRNbrRouteNbr__c = '32323232';
        objCust.WSLRNbrCustIDRouteNbr__c = '434343';
        insert objCust;
        
        Recordtype RASRtype = [select id,name from Recordtype where SobjectType = 'ONTAP__Order__c' and name ='RAS'];
        system.debug('======='+RASRtype);
        ONTAP__Order__c OnTap = new ONTAP__Order__c();
        OnTap.RAS_OrderSource__c = 'tapwiser';
        OnTap.RAS_WSLRNbrCustIDRouteNbr__c = '434343';
        OnTap.RecordTypeId = RASRtype.id;
        OnTap.RAS_CustID__c = '67675';
        insert OnTap;
        update OnTap;
    }
}