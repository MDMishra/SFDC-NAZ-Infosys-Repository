@isTest
private class onCall_AccountInformationCtrlTest {
    
    @isTest static void getInitAccountTest() {
        Account a = new Account();
        a.Name = 'test Account';
        insert a;

        Test.startTest();
        Account act = onCall_AccountInformationCtrl.getInitAccount(a.Id);
        Test.stopTest();

        system.assert(a.Name == act.Name);

    }
    
    @isTest static void getInitAccountFromOrder() {
        Account a = new Account();
        a.Name = 'test Account';
        insert a;

        ONTAP__Order__c order = new ONTAP__Order__c();
        order.OnCall_Account__c = a.Id;
        order.OnCall_Status__c = 'Draft';
        insert order;

        Test.startTest();
        Account act = onCall_AccountInformationCtrl.getInitAccountFromOrder(order.Id);
        Test.stopTest();

        system.assert(a.Name == act.Name);
    }

    static TestMethod void testFrequency(){
        Date futureCheck;
        Frequency__c freqA = new Frequency__c(Name = 'A1', Frequency_Code__c = 'A1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 1, Frequency_Start_Date__c = date.ValueOf('2016-07-25'));
        insert freqA;
        Frequency__c freqQ = new Frequency__c(Name = 'Q1', Frequency_Code__c = 'Q1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 4, Frequency_Start_Date__c = date.valueOf('2016-08-01'));
        insert freqQ;
    
        List<String> freqADates = onCall_AccountInformationCtrl.getFrequency('A1');
        System.Assert(System.now().date()<date.valueOf(freqADates[0]));
    
        List<String> freqQDates = onCall_AccountInformationCtrl.getFrequency('Q1');
        /*System.Assert(System.now().date()<date.valueOf(freqQDates[0]));*/
        
    }

    @isTest
    public static void testIsCallScheduled(){
        Account a = onCall_TestUtilityMethods.createAccount1();
        onCall_TestUtilityMethods.createCall(a.ID);

        onCall_AccountInformationCtrl.isCallScheduled(a.ID);
    }

    @isTest
    public static void testIsCallScheduledFail(){
        Account a = onCall_TestUtilityMethods.createAccount1();
        //onCall_TestUtilityMethods.createCall(a.ID);

        onCall_AccountInformationCtrl.isCallScheduled(a.ID);
    }

    @isTest
    public static void testIsCallScheduledCatch(){

        onCall_AccountInformationCtrl.isCallScheduled('12345');
    }

    @isTest
    public static void testFrequencyFail(){

        onCall_AccountInformationCtrl.getFrequency('');
    }
    
}