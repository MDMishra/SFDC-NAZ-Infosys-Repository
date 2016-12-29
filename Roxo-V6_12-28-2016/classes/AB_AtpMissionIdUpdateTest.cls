/*Created Date : 21/12/2016
Discription  : Test class for Trigger to update mission id from GSC object to ATP*/
@isTest
private class AB_AtpMissionIdUpdateTest {
    static testMethod void myTest() {
        GSC_Mission_KPI_Map__c ObjGsc = new GSC_Mission_KPI_Map__c(name='Test Gsc', Mission_ID__c= '12345');
        insert ObjGsc; //Insert GSC Record
        system.debug('ObjGsc=Test='+ObjGsc.id);
        Account objAcc = new Account(Name='Test Account');
        insert objAcc;
        US_Account_Target_Program__c ObjAtp = new US_Account_Target_Program__c (Account__c = objAcc.Id,Missions_ID__c=ObjGsc.Mission_ID__c);
        insert ObjAtp; //Insert ATP Record
        ObjGsc.Mission_ID__c = '12487';
        update ObjGsc;
        ObjGsc.Mission_ID__c = '';
        update ObjGsc;
    }
}