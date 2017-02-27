@isTest
public class ONTAP_OrderTriggerHandlerTest {
    static recordType recAcc = [Select Id from RecordType where sObjectType = 'Account' and Name  = 'OnCall POC / Sold To'];
    static testMethod void testSetOrderOrigin(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'intUser', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Integration User', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='integrationuser@testorg.com');
        
        Account pocAccount = new Account(Name='Test 7/11', RecordType=recAcc, DC_Code_from_SAP__c = '2222', DC_Name__c = 'DC Code', DSM_ID__c = '1111', 
                                         DSM_First_Name__c = 'DSM First Name', DSM_Last_Name__c = 'DSM Last Name', TM_ID__c = '3333',
                                         TM_First_Name__c = 'TM First Name', TM_Last_Name__c = 'Last Name', Sales_Area_ID__c = '4444', 
                                         Sales_Area_Description__c = 'Sales area description', Banner_ID__c = '5555', Banner_Description__c = 'Banner Desc5151', 
                                         KDKG2__c = '6666', Customer_Segment__c = '7777');
        
        insert pocAccount; 
        // Set the User to an Integration User
        System.runAs(u) {
            ONTAP__Order__c order = new ONTAP__Order__c(OnCall_Account__c=pocAccount.Id);
            insert order;
        }
        List<ONTAP__Order__c> orderToCheck = [select OnCall_Account__c, Origin__c from ONTAP__Order__c where OnCall_Account__c =: pocAccount.id];
        //When an Order is created by an Integration User the Origin will be set to Head Office
        System.assertEquals('Head Office',orderToCheck[0].Origin__c);
   }
    
    /*static testMethod void testSetPrimary(){
        Account pocAccount = onCall_TestUtilityMethods.createAccount('Test');
        insert pocAccount; 
        
        ONTAP__Order__c order1 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '12345', origin__c = 'Telesales');
        insert order1;
        
        Datetime today1 = Datetime.now();
    Test.setCreatedDate(order1.Id, today1);
        
        //The first Order of the day created by Telesales will be set as the primary
        ONTAP__Order__c orderList1 = [select id, Is_Primary__c, SAP_Order_Number__c from ONTAP__Order__c where SAP_Order_Number__c =: '12345' limit 1];
        system.assertEquals(true, orderList1.Is_Primary__c);
        
        ONTAP__Order__c order2 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '54321', origin__c = 'Telesales');
        insert order2;
        
        Datetime today2 = Datetime.now();
    Test.setCreatedDate(order2.Id, today2);
        
        //The next Orders of the day created by Telesales will not be set as primary
        ONTAP__Order__c orderList2 = [select id, Is_Primary__c, SAP_Order_Number__c from ONTAP__Order__c where SAP_Order_Number__c =: '54321' limit 1];
        system.assertEquals(false, orderList2.Is_Primary__c);
    }
    */
    static testMethod void testSetPrimary(){

        Frequency__c freq = onCall_TestUtilityMethods.createFrequencyA1();
        Account pocAccount = onCall_TestUtilityMethods.createAccount('Test');
        pocAccount.Delivery_Frequency__c = freq.Id;
        insert pocAccount; 

        List<String> dateStrings = OnCall_Utility.frequencyCalculation(freq.Name);
        
        ONTAP__Order__c order1 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '12345', origin__c = 'Telesales', Delivery_Date__c = Date.valueOf(dateStrings[0]));
        insert order1;
        order1 = [Select Is_Primary__c from ONTAP__Order__c where Id =: order1.Id];
        System.assertEquals(order1.Is_Primary__c, true);
        
        //Second order for same account and delivery date will have isPrimary unchecked
        ONTAP__Order__c order2 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '12346', origin__c = 'Telesales', Delivery_Date__c = Date.valueOf(dateStrings[0]));
        insert order2;
        order2 = [Select Is_Primary__c from ONTAP__Order__c where Id =: order2.Id];
        System.assertEquals(order2.Is_Primary__c, false);

        //Third order for same account, but with different delivery date will have isPrimary checked
        ONTAP__Order__c order3 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '12347', origin__c = 'Telesales', Delivery_Date__c = Date.valueOf(dateStrings[1]));
        insert order3;
        order3 = [Select Is_Primary__c from ONTAP__Order__c where Id =: order3.Id];
        System.assertEquals(order3.Is_Primary__c, true);

        Account pocAccount2 = onCall_TestUtilityMethods.createAccount('Test');
        pocAccount2.Delivery_Frequency__c = freq.Id;
        insert pocAccount2; 

        //Order for a different account, with same delivery date as order3, should have isPrimary checked
        ONTAP__Order__c order4 = new ONTAP__Order__c(OnCall_Account__c = pocAccount2.Id, SAP_Order_Number__c = '12348', origin__c = 'Telesales', Delivery_Date__c = Date.valueOf(dateStrings[1]));
        insert order4;
        order4 = [Select Is_Primary__c from ONTAP__Order__c where Id =: order4.Id];
        System.assertEquals(order4.Is_Primary__c, true);

        //Cover the mapAccountIdToDeliveryDateToOrder.containskey case, where two primary orders already exist for pocAccount.
        ONTAP__Order__c order5 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '12349', origin__c = 'Telesales', Delivery_Date__c = Date.valueOf(dateStrings[1]));
        insert order5;
        order5 = [Select Is_Primary__c from ONTAP__Order__c where Id =: order5.Id];
        System.assertEquals(order5.Is_Primary__c, false);

    }

     static testMethod void testSetCallLookup(){  
        Frequency__c freq = onCall_TestUtilityMethods.createFrequencyA1();
        Account pocAccount = onCall_TestUtilityMethods.createAccount('Test');
        pocAccount.Delivery_Frequency__c = freq.Id;
        insert pocAccount; 

        List<String> dateStrings = OnCall_Utility.frequencyCalculation(freq.Name);
  
        Call__c call = onCall_TestUtilityMethods.createCall(pocAccount.Id);
        call.Call_Type__c = 'Order';
        insert call;
      
        ONTAP__Order__c order1 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '12345', origin__c = 'Telesales', Delivery_Date__c = Date.valueOf(dateStrings[0]));
        insert order1;
        order1 = [Select Call__c, Is_Future__c from ONTAP__Order__c where Id =: order1.Id];
        System.assertEquals(order1.Call__c, call.Id);

        //Verify isFuture checkbox is unchecked, as the delivery date is the first date in the schedule
        System.assertEquals(order1.Is_Future__c, false);


        ONTAP__Order__c order2 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, SAP_Order_Number__c = '12346', origin__c = 'Telesales', Delivery_Date__c = Date.valueOf(dateStrings[1]));
        insert order2;
        order2 = [Select Call__c, Is_Future__c from ONTAP__Order__c where Id =: order2.Id];
        System.assertEquals(order2.Call__c, call.Id);

        //Verify isFuture checkbox is checked, as the delivery date is the not the first date in the schedule
        System.assertEquals(order2.Is_Future__c, true);


    }

    static testMethod void testSAPOrderCreation(){
        Profile p = [select id from profile where name='OnCall Basic'];

        User u = new User(alias = 'test123', email='test123@testemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test123@testemail.com');
        insert u;
        
        User u1 = [select id from User where username =: 'test123@testemail.com' limit 1];
        //System.runas(u){
            Account pocAccount = onCall_TestUtilityMethods.createAccount('Test');
            insert pocAccount; 

            ONTAP__Order__c order1 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, Ownerid = u1.id, origin__c = 'Telesales', 
                                                            Is_Primary__c = TRUE, Total_Order_Item_Quantity__c = 10, Total_Order_Metric_Cases__c = 100,
                                                            Objective_Score__c = 10, Prime_Objective_Points__c = 100, Inventory_Taken__c = TRUE, 
                                                            Total_Metric_Case_Over_Suggested__c = 40);
            insert order1;     
        
        //}      
        Account acc = [select id from account where Name =: 'TestTest' limit 1];
        //ONTAP__Order__c order = [select id from ONTAP__Order__c where SAP_Order_Number__c =: '12345' limit 1];
        
        ONTAP__Order__c order2 = new ONTAP__Order__c(OnCall_Account__c = acc.Id, SAP_Order_Number__c = '54321', 
                                                    origin__c = 'Telesales', SAP_External_System_ID__c = String.valueOf(order1.id));
        insert order2;
        
        ONTAP__Order__c orderToCheck = [select id, SAP_Order_Number__c, Is_Primary__c, OnCall_Status__c from ONTAP__Order__c where id =: order1.id limit 1];
        System.assertEquals(orderToCheck.OnCall_Status__c, 'Draft Timeout');
        System.assertEquals(orderToCheck.Is_Primary__c, FALSE);
        ONTAP__Order__c orderToCheck2 = [select id, SAP_Order_Number__c, Is_Primary__c, Total_Order_Item_Quantity__c, Total_Order_Metric_Cases__c, 
                                            origin__c from ONTAP__Order__c where id =: order2.id limit 1];
        System.assertEquals(orderToCheck2.origin__c, 'Telesales Timeout');
        System.assertEquals(orderToCheck2.Is_Primary__c, TRUE);
        System.assertEquals(orderToCheck2.Total_Order_Item_Quantity__c, 10);
        System.assertEquals(orderToCheck2.Total_Order_Metric_Cases__c, 100);
    
    }

    static testMethod void testSAPOrderCreation2(){
        Profile p = [select id from profile where name='OnCall Basic'];

        User u = new User(alias = 'test123', email='test123@testemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test123@testemail.com');
        insert u;
        
        User u1 = [select id from User where username =: 'test123@testemail.com' limit 1];

        Account pocAccount = onCall_TestUtilityMethods.createAccount('Test');
        insert pocAccount; 

        ONTAP__Order__c order1 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, 
                                                        Ownerid = u1.id, origin__c = 'Telesales', SAP_Order_Number__c = '12345');
        insert order1;     
        
           
        Account acc = [select id from account where Name =: 'TestTest' limit 1];
        ONTAP__Order__c order = [select id from ONTAP__Order__c where SAP_Order_Number__c =: '12345' limit 1];
        
        ONTAP__Order__c order2 = new ONTAP__Order__c(OnCall_Account__c = acc.Id, SAP_Order_Number__c = '54321', 
                                                    origin__c = 'Telesales', SAP_External_System_ID__c = String.valueOf(order.id));
        insert order2;
        
        ONTAP__Order__c orderToCheck = [select id, SAP_Order_Number__c, Is_Primary__c, origin__c from ONTAP__Order__c where id =: order.id limit 1];
        System.assertEquals(orderToCheck.origin__c, 'Telesales');
        ONTAP__Order__c orderToCheck2 = [select id, SAP_Order_Number__c, origin__c from ONTAP__Order__c where id =: order2.id limit 1];
        System.assertEquals(orderToCheck2.origin__c, 'Telesales Timeout');
    }

    static testMethod void testSAPOrderCreation3(){
        Profile p = [select id from profile where name='OnCall Basic'];

        User u = new User(alias = 'test123', email='test123@testemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test123@testemail.com');
        insert u;
        
        User u1 = [select id from User where username =: 'test123@testemail.com' limit 1];
        //System.runas(u){
            Account pocAccount = onCall_TestUtilityMethods.createAccount('Test');
            insert pocAccount; 

            ONTAP__Order__c order1 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, Ownerid = u1.id, origin__c = 'Telesales', 
                                                            Is_Future__c = TRUE, Out_of_Frequency__c = TRUE);
            insert order1;     
        
        //}        
        Account acc = [select id from account where Name =: 'TestTest' limit 1];
        //ONTAP__Order__c order = [select id from ONTAP__Order__c where SAP_Order_Number__c =: '12345' limit 1];
        
        ONTAP__Order__c order2 = new ONTAP__Order__c(OnCall_Account__c = acc.Id, SAP_Order_Number__c = '54321', 
                                                    origin__c = 'Telesales', SAP_External_System_ID__c = String.valueOf(order1.id));
        insert order2;
        
        ONTAP__Order__c orderToCheck = [select id, SAP_Order_Number__c, Is_Future__c, OnCall_Status__c from ONTAP__Order__c where id =: order1.id limit 1];
        System.assertEquals(orderToCheck.OnCall_Status__c, 'Draft Timeout');
        ONTAP__Order__c orderToCheck2 = [select id, SAP_Order_Number__c, Is_Future__c, Out_of_Frequency__c, origin__c from ONTAP__Order__c where id =: order2.id limit 1];
        System.assertEquals(orderToCheck2.origin__c, 'Telesales Timeout');
        System.assertEquals(orderToCheck2.Is_Future__c, TRUE);
        System.assertEquals(orderToCheck2.Out_of_Frequency__c, TRUE);
    }


    static testMethod void testSetCallStatus(){
        String futureCallString = label.OnCall_Call_Status;
        Account pocAccount = onCall_TestUtilityMethods.createAccount('Test');
        insert pocAccount; 

        Call__c call = onCall_TestUtilityMethods.createCall(pocAccount.Id);
        call.Call_Type__c = 'Order';
        insert call;

        ONTAP__Order__c order1 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, Is_Future__c = TRUE, 
                                                    origin__c = 'Telesales Timeout', SAP_Order_Number__c = '12345');
        insert order1;

        String orderToCheck = [select Call__c from ONTAP__Order__c where id =: order1.id].Call__c;
        Call__c callToCheck = [select id, Call_Status__c from Call__c where id =: orderToCheck];
        system.assertEquals(futureCallString, callToCheck.Call_Status__c);

        ONTAP__Order__c order2 = new ONTAP__Order__c(OnCall_Account__c = pocAccount.Id, Is_Future__c = FALSE, 
                                                    origin__c = 'Telesales');
        insert order2;

        ONTAP__Order__c orderToUpdate = [select id, SAP_Order_Number__c from ONTAP__Order__c where id =: order2.id];
        orderToUpdate.SAP_Order_Number__c = '54321';
        update orderToUpdate;

        String orderToCheck2 = [select Call__c from ONTAP__Order__c where id =: order1.id].Call__c;
        Call__c callToCheck2 = [select id, Call_Status__c from Call__c where id =: orderToCheck2];
        system.assertEquals('Complete', callToCheck2.Call_Status__c);
    } 
        
}