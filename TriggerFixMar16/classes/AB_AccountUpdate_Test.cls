@isTest
Public Class AB_AccountUpdate_Test{
    static testMethod void ValidateAcc() {
        Account acc =new Account();
        acc.name='Test';
        acc.EDWID_US__c='151386309';
        acc.GSC_Place_ID__c='8702453'; 
        insert acc;
        
        Account acc1 =new Account();
        acc1.name='Test';
        acc1.EDWID_US__c='151386309';
        acc1.OldPartyId__c='151386309'; 
        insert acc1;
    }
}