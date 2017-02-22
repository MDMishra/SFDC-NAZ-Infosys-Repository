/*
Auhtor Name : Nuvem Developer
Date        : Feb 3 2017
Description : Test class for create a user from a contact / Update user associated with contact when contact is updated
*/
@isTest
private class AB_CreateUserFromContact_Handler_Test {
    public static contact createCon(){
        Recordtype Rtype = [select id,name from Recordtype where SobjectType = 'contact' and name ='NAZ User'];
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        Contact objCon = new Contact();
        objCon.LastName =  'User';
        objCon.recordtypeid = Rtype.id;
        objCon.FirstName = 'Test';
        objCon.ALIAS__c = 'TestUser';
        objCon.Email = 'babitha.jampani@nuvemconsulting.com';
        objCon.MobilePhone = '9966784275';
        objCon.ISACTIVE__c = true;
        objCon.USERNAME__c = 'abiqtestuser@abiq.com';
        objCon.NICKNAME__C = 'abiq';
        objCon.PROFILEID__c = p.Id;
        objCon.COMPANYNAME__c = 'abiq';
        objCon.CurrencyIsoCode = 'USD';
        objCon.ROUTEKEY__c = '123456';
        objCon.Title = 'ABIQTitle';
        objCon.TIMEZONEIDKEY__c = 'GMT';
        objCon.LOCALESIDKEY__c = 'en_US';
        objCon.EMAILENCODINGKEY__c = 'ISO-8859-1';
        objCon.LANGUAGELOCALEKEY__c = 'en_US';
        objCon.DEFAULTDIVISION__c = '02dU0000000PAvHIAW';
        return objCon;
    }
    private Static testMethod void createContact(){
        List<Contact> lstCon = new List<Contact>();
        contact con  = createCon();
        lstCon.add(con);
        INSERT lstCon;
        
        AB_CreateUserFromContact_Handler.beforeInsert(lstCon);
        AB_CreateUserFromContact_Handler.beforeUpdate(lstCon);
    }
    private Static testMethod void updateContact(){
        List<Contact> lstCon = new List<Contact>();
        contact con  = createCon();
        lstCon.add(con);
        INSERT lstCon;
        update lstCon;
        //insert objCon;
        //objCon.lastname = 'test';
        
        
        AB_CreateUserFromContact_Handler.beforeInsert(lstCon);
        AB_CreateUserFromContact_Handler.beforeUpdate(lstCon);
    }
}