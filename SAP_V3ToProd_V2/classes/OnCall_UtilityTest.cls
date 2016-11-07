@isTest
public class OnCall_UtilityTest {
    static recordType recAcc = [Select Id from RecordType where sObjectType = 'Account' and Name  = 'OnCall POC / Sold To'];
    public static Id recDOI = [Select Id from RecordType where sObjectType = 'DOI_Header__c' and Name = 'DOI'].id;
    static testmethod void testFindPocs(){
        
        Account account = new Account();
        account.Name='Test 7/11';
        account.RecordType=recAcc;
        account.DC_Code__c = '2222';
        account.DC_Name__c = 'DC Code';
        account.DSM_ID__c = '1111';
        account.DSM_First_Name__c = 'DSM First Name';
        account.DSM_Last_Name__c = 'DSM Last Name';
        account.TM_ID__c = '3333';
        account.TM_First_Name__c = 'TM First Name';
        account.TM_Last_Name__c = 'Last Name';
        account.Sales_Area_ID__c = '4444';
        account.Sales_Area_Description__c = 'Sales area description';
        account.Banner_ID__c = '5555';
        account.Banner_Description__c = 'Banner Desc5151';
        account.KDKG2__c = '6666';
        account.Customer_Segment__c = '7777';
        insert account; 
        
        List<Account> poc =  OnCall_Utility.FindPocs(recAcc.id, 'ON', null, '2222', '3333', '4444', '5555','6666','7777');
        List<Account> poc2 =  OnCall_Utility.FindPocs(recAcc.id, 'ON', null, null, '3333', '4444', '5555','6666','7777');
        List<Account> poc3 =  OnCall_Utility.FindPocs(recAcc.id, 'ON', null, null, null, '4444', '5555','6666','7777');
        List<Account> poc4 =  OnCall_Utility.FindPocs(recAcc.id, 'ON', null, null, null, null, '5555','6666','7777');
        List<Account> poc5 =  OnCall_Utility.FindPocs(recAcc.id, 'ON', null, null, null, null, null,'6666','7777');
        List<Account> poc6 =  OnCall_Utility.FindPocs(recAcc.id, 'ON', null, null, null, null, null,null,'7777');
    }
    
    static TestMethod void freqTestAandQ(){
        Date futureCheck;
        Frequency__c freqA = new Frequency__c(Name = 'A1', Frequency_Code__c = 'A1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 1, Frequency_Start_Date__c = date.ValueOf('2016-07-25'));
        insert freqA;
        Frequency__c freqQ = new Frequency__c(Name = 'Q1', Frequency_Code__c = 'Q1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 4, Frequency_Start_Date__c = date.valueOf('2016-08-01'));
        insert freqQ;
    
        List<String> freqADates = OnCall_Utility.frequencyCalculation('A1');
        System.Assert(System.now().date()<date.valueOf(freqADates[0]));
    
        List<String> freqQDates = OnCall_Utility.frequencyCalculation('Q1');
      /*  System.Assert(System.now().date()<date.valueOf(freqQDates[0]));*/
        
    }

    static TestMethod void freqTestAandQBulk(){
        Date futureCheck;
        Frequency__c freqA = new Frequency__c(Name = 'A1', Frequency_Code__c = 'A1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 1, Frequency_Start_Date__c = date.ValueOf('2016-07-25'));
        insert freqA;
        Frequency__c freqQ = new Frequency__c(Name = 'Q1', Frequency_Code__c = 'Q1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 4, Frequency_Start_Date__c = date.valueOf('2016-08-01'));
        insert freqQ;
    
        List<String> freqADates = OnCall_Utility.frequencyCalculationBulk(new List<String>{'A1'},5).get('A1');
        System.Assert(System.now().date()<date.valueOf(freqADates[0]));
    
        List<String> freqQDates = OnCall_Utility.frequencyCalculationBulk(new List<String>{'Q1'},5).get('Q1');
       /* System.Assert(System.now().date()<date.valueOf(freqQDates[0]));*/
        
    }
    
    static TestMethod void freqTestR(){
        Frequency__c freqR = new Frequency__c(Name = 'R1', Frequency_Code__c = 'R1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 4, Frequency_Start_Date__c =  date.ValueOf('2016-08-08'));
        insert freqR;
            
        List<String> freqRDates = OnCall_Utility.frequencyCalculation('R1');
        System.Assert(System.now().date()<date.valueOf(freqRDates[0]));
    
    }
    
    static TestMethod void freqTestSandT(){
        Date futureCheck;
        Frequency__c freqS = new Frequency__c(Name = 'S2', Frequency_Code__c = 'S2', Active__c = true, Day_of_Week__c = 'Tuesday', 
                                             Frequency_of_Weeks__c = 8, Frequency_Start_Date__c = date.ValueOf('2016-07-04'));
        insert freqS;
        Frequency__c freqT = new Frequency__c(Name = 'T3', Frequency_Code__c = 'T3', Active__c = true, Day_of_Week__c = 'Wednesday', 
                                             Frequency_of_Weeks__c = 8, Frequency_Start_Date__c = date.ValueOf('2016-08-01'));
        insert freqT;
        List<String> freqSDates = OnCall_Utility.frequencyCalculation('S2');
       /* System.Assert(System.now().date()<date.valueOf(freqSDates[0]));*/
    
        List<String> freqTDates = OnCall_Utility.frequencyCalculation('T3');
        System.Assert(System.now().date()<date.valueOf(freqTDates[0]));
    }
    
    static TestMethod void freqTestEmpty(){
        Frequency__c freqR = new Frequency__c(Name = 'R1', Frequency_Code__c = 'R1', Active__c = true, Day_of_Week__c = 'Monday', 
                                             Frequency_of_Weeks__c = 4, Frequency_Start_Date__c =  date.ValueOf('2016-08-08'));
        insert freqR;
            
        List<String> freqEmptyDates = OnCall_Utility.frequencyCalculation('Z1');
        System.Assertequals(0, freqEmptyDates.size());
    }
    
    @isTest
    static void testDOIForScreen1(){
        //init();
        Account acc = onCall_TestUtilityMethods.createAccount('TestAcc');
        insert acc; 
    
        List<ONTAP__Product__c> prodList = new List<ONTAP__Product__c>();
        ONTAP__Product__c prod1 = onCall_TestUtilityMethods.CreateProduct('TestProd1');
        ONTAP__Product__c prod2 = onCall_TestUtilityMethods.CreateProduct('TestProd2');
        prodList.add(prod1);
        prodList.add(prod2);
        insert prodList;
        
        DOI_Max_Budget__c DOIMax = new DOI_Max_Budget__c(Internal_Order_Number__c = 'Internal Order Number', 
                                                         Maximum_Discount_Budget__c = 100.00, Current_Discount_Total__c=0.00);
        insert DOIMax;
        
        //Account poc = [select id, Name from Account where Name =: 'TestAccTest' limit 1];
        
        //List<ONTAP__Product__c> productList = [select id, Name from ONTAP__Product__c];
        
        //DOI_Header__c DOIList = [select id, Name from DOI_Header__c where Name =: 'POC DOI' limit 1];
        
        List<DOI_Header__c> DOIList = new List<DOI_Header__c>();
        DOI_Header__c DOI = new DOI_Header__c(RecordTypeId = recDOI, Name = 'POC DOI', DOI_Max_Budget__c = DOIMax.id);
        DOIList.add(DOI);
        DOI_Header__c DOI2 = new DOI_Header__c(RecordTypeId = recDOI, Name = 'POC DOI2', DOI_Max_Budget__c = DOIMax.id);
        DOIList.add(DOI2);
        DOI_Header__c DOI3 = new DOI_Header__c(RecordTypeId = recDOI, Name = 'POC DOI3', DOI_Max_Budget__c = DOIMax.id);
        DOIList.add(DOI3);
        insert DOIList;
        
        List<Table_Control_POC__c> tcpList = new List<Table_Control_POC__c>();
        Table_Control_POC__c tcp1 = new Table_Control_POC__c(Table_Control_Header__c = DOI.id, POC__c = acc.id);
        tcpList.add(tcp1);
        Table_Control_POC__c tcp2 = new Table_Control_POC__c(Table_Control_Header__c = DOI2.id);
        tcpList.add(tcp2);
        insert tcpList;
        
        List<Table_Control_SKU__c> tcsList = new List<Table_Control_SKU__c>();
        Table_Control_SKU__c tcs1 = new Table_Control_SKU__c(Table_Control_Header__c = DOI.id, SKU__c = prod1.id);
        tcsList.add(tcs1);
        Table_Control_SKU__c tcs2 = new Table_Control_SKU__c(Table_Control_Header__c = DOI.id, SKU__c = prod1.id);
        tcsList.add(tcs2);
        Table_Control_SKU__c tcs3 = new Table_Control_SKU__c(Table_Control_Header__c = DOI.id);
        tcsList.add(tcs3);
        Table_Control_SKU__c tcs4 = new Table_Control_SKU__c(Table_Control_Header__c = DOI3.id, SKU__c = prod1.id);
        tcsList.add(tcs4);
        Table_Control_SKU__c tcs5 = new Table_Control_SKU__c(Table_Control_Header__c = DOI2.id);
        tcsList.add(tcs5);
        insert tcsList;
        
        List<ONTAP__Product__c> productList = [select id, Name from ONTAP__Product__c];
        Map<Id, List<DOI_Header__c>> DOIForScreen = OnCall_Utility.DOIForOrderScreen(acc.id, productList);
        
        ONTAP__Product__c prodInMap = [select id, OnCall_Product_Name__c from ONTAP__Product__c where OnCall_Product_Name__c =: 'TestProd1MICHELOB ULTRA' limit 1];
        System.assertEquals(2, DOIForScreen.get(prodInMap.id).size()); 
    }
    
    @isTest
    static void testDOIForScreen2(){
        Account acc = onCall_TestUtilityMethods.createAccount('TestAcc');
        insert acc; 
    
        List<ONTAP__Product__c> prodList = new List<ONTAP__Product__c>();
        ONTAP__Product__c prod1 = onCall_TestUtilityMethods.CreateProduct('TestProd1');
        prodList.add(prod1);
        insert prodList;
        
        DOI_Max_Budget__c DOIMax = new DOI_Max_Budget__c(Internal_Order_Number__c = 'Internal Order Number', 
                                                         Maximum_Discount_Budget__c = 100.00, Current_Discount_Total__c=0.00);
        insert DOIMax;
        
        List<DOI_Header__c> DOIList = new List<DOI_Header__c>();
        DOI_Header__c DOI1 = new DOI_Header__c(RecordTypeId = recDOI, Name = 'POC DOI', DOI_Max_Budget__c = DOIMax.id);
        DOIList.add(DOI1);
        DOI_Header__c DOI2 = new DOI_Header__c(RecordTypeId = recDOI, Name = 'POC DOI2', DOI_Max_Budget__c = DOIMax.id);
        DOIList.add(DOI2);
        insert DOIList;
        
        List<Table_Control_POC__c> tcpList = new List<Table_Control_POC__c>();
        Table_Control_POC__c tcp1 = new Table_Control_POC__c(Table_Control_Header__c = DOI1.id);
        tcpList.add(tcp1);
        Table_Control_POC__c tcp2 = new Table_Control_POC__c(Table_Control_Header__c = DOI2.id);
        tcpList.add(tcp2);
        insert tcpList;
        
        List<Table_Control_SKU__c> tcsList = new List<Table_Control_SKU__c>();
        Table_Control_SKU__c tcs1 = new Table_Control_SKU__c(Table_Control_Header__c = DOI1.id, SKU__c = prod1.id);
        tcsList.add(tcs1);
        Table_Control_SKU__c tcs2 = new Table_Control_SKU__c(Table_Control_Header__c = DOI2.id, SKU__c = prod1.id);
        tcsList.add(tcs2);
        insert tcsList;
        
        List<ONTAP__Product__c> productList = [select id, Name from ONTAP__Product__c];
        Map<Id, List<DOI_Header__c>> DOIForScreen = OnCall_Utility.DOIForOrderScreen(acc.id, productList);
        
        ONTAP__Product__c prodInMap = [select id, OnCall_Product_Name__c from ONTAP__Product__c where OnCall_Product_Name__c =: 'TestProd1MICHELOB ULTRA' limit 1];
        System.assertEquals(2, DOIForScreen.get(prodInMap.id).size()); 
    }


    @isTest
    static void testgetProductsOnProposalListForAccount(){
    
    ONTAP__Product__c prod = onCall_TestUtilityMethods.CreateProduct('TestProd');
    insert prod;
    Base_Price__c bp = onCall_TestUtilityMethods.CreateBasePrice(prod.Id);
    insert bp;
    DOI_Header__c propList = onCall_TestUtilityMethods.createProposalList();
    insert propList;
    Proposal_List_Header__c propListHeader = onCall_TestUtilityMethods.createProposalListHeader(propList.Id);
    insert propListHeader;
    Proposal_List_Header__c propListHeader2 = onCall_TestUtilityMethods.createProposalListHeader(propList.Id);
    propListHeader2.Name = propListHeader2.Name + '2ndHeader';
    insert propListHeader2;
    Proposal_List_Product__c propListProduct = onCall_TestUtilityMethods.createProposalListProduct(prod.Id, propListHeader.Id);
    insert propListProduct;
    Account acc = onCall_TestUtilityMethods.createAccount('TestAcc');
    acc.Proposal_List__c = propList.Id;
    acc.OnCall_Ignore_PL_POCFilter__c = true;
    insert acc;

     Map<Id, List<onCall_Utility.ProductWrapper>> returnVal = onCall_Utility.getProductsOnProposalListForAccount(new List<Id>{acc.Id});
     System.assert(returnVal.containsKey(acc.Id));
     System.assertEquals(returnVal.get(acc.Id).size(),1);
     System.assertEquals(returnVal.get(acc.Id).get(0).product.Id, prod.Id);
     System.assertEquals(returnVal.get(acc.Id).get(0).proposalList.Id, propListProduct.Id);
     System.assertEquals(returnVal.get(acc.Id).get(0).product.Base_Prices__r[0].Id, bp.Id);
    }

    @isTest
    static void testcalculatePricingForProducts(){
    
    ONTAP__Product__c prod = onCall_TestUtilityMethods.CreateProduct('TestProd');
    insert prod;
    Base_Price__c bp = onCall_TestUtilityMethods.CreateBasePrice(prod.Id);
    insert bp;
    DOI_Header__c propList = onCall_TestUtilityMethods.createProposalList();
    insert propList;
    Proposal_List_Header__c propListHeader = onCall_TestUtilityMethods.createProposalListHeader(propList.Id);
    insert propListHeader;
    /*Proposal_List_Header__c propListHeader2 = onCall_TestUtilityMethods.createProposalListHeader(propList.Id);
    propListHeader2.Name = propListHeader2.Name + '2ndHeader';
    insert propListHeader2;*/
    Proposal_List_Product__c propListProduct = onCall_TestUtilityMethods.createProposalListProduct(prod.Id, propListHeader.Id);
    insert propListProduct;
    Account acc = onCall_TestUtilityMethods.createAccount('TestAcc');
    acc.Proposal_List__c = propList.Id;
    acc.OnCall_Ignore_PL_POCFilter__c = true;
    acc.KDKG2__c = 'KDK';
    acc.KDKG1__c = 'a';
    acc.KATR10__c = 'a';
    acc.KATR2__c = 'a';
    acc.Tax_Class__c = 'a';

    insert acc;
    Account acc2 = onCall_TestUtilityMethods.createAccount('TestAcc2');
    acc2.KATR10__c = 'a';
    acc2.KATR2__c = 'a';
    insert acc2;
    acc.Ship_To_Account__c = acc2.Id;
    update acc;
    prod = [Select Id, Pricing_Product_Hierarchy_Code__c from ONTAP__Product__c where Id =: prod.Id];
    Pre_Populated_Discount__c prepopDiscount = onCall_TestUtilityMethods.CreatePrepopulatedDiscount(acc.Id);
    prepopDiscount.Global_Product_Hierarchy__c = prod.Pricing_Product_Hierarchy_Code__c;
    insert prepopDiscount;
    Price_List_Discount__c priceListDiscount = onCall_TestUtilityMethods.CreatePriceListDiscount('KDK');
    priceListDiscount.Global_Product_Hierarchy__c = prod.Pricing_Product_Hierarchy_Code__c;
    insert priceListDiscount;

    
    System.debug('PROD' + prod);

    Map<Id, List<onCall_Utility.ProductWrapper>> mapAccountToProducts = new Map<Id, List<onCall_Utility.ProductWrapper>>();
    prod = [SELECT Id, Pricing_Product_Hierarchy_Code__c, Conversion_to_Consumer_Units__c,
                                                                            (SELECT Name, Base_Price__c, Deposits__c, Consignment__c, Free_Beer_Price__C, 
                                                                            Ship_To_KATR10__c,  Ship_To_KATR2__c, Sold_to_KDKG1__c, Sold_To_Tax_Classification__c
                                                                            FROM Base_Prices__r)                                                                        
                                                                            FROM ONTAP__Product__c WHERE ID =: prod.Id];
    propListProduct = [SELECT Product_Name__c, Name, Product__c, Sort_Order__c FROM Proposal_List_Product__c where Id =: propListProduct.Id];                                                                        
    mapAccountToProducts.put(acc.Id, new List<onCall_Utility.ProductWrapper>{new onCall_Utility.ProductWrapper(propListProduct,prod)});

    List<Staging_Order_Table__c> stagingRecords = onCall_Utility.calculatePricingForProducts(mapAccountToProducts);
    System.assertEquals(stagingRecords.size(),1);
    System.assertEquals(stagingRecords[0].Sold_To__c, acc.Id);
    System.assertEquals(stagingRecords[0].Product__c, prod.Id);
    System.assertEquals(stagingRecords[0].PTC__c, prepopDiscount.PTC__c);
    System.assertEquals(stagingRecords[0].PTR__c, bp.Base_Price__c  - prepopDiscount.Pre_Populated_Discount__c - priceListDiscount.Price_List_Discount__c);
    System.assertEquals(stagingRecords[0].Free_Beer_Price__C, bp.Free_Beer_Price__c);

    }

    @isTest
    static void testcalculateInventoryForStagingRecordss(){
    
    ONTAP__Product__c prod = onCall_TestUtilityMethods.CreateProduct('TestProd');
    insert prod;

    Frequency__c freq = onCall_TestUtilityMethods.createFrequencyA1();
    Account acc = onCall_TestUtilityMethods.createAccount('TestAcc'); 
    acc.Delivery_Frequency__c = freq.Id;
    insert acc;

    List<String> dateStrings = OnCall_Utility.frequencyCalculation(freq.Name);
    List<Date> dates = new List<Date>();
    for(String s: dateStrings){
        dates.add(Date.valueOf(s));
    }
    List<Staging_Order_Table__c> stagingRecords = new List<Staging_Order_Table__c>{new Staging_Order_Table__c(Sold_To__c = acc.Id, Product__c = prod.Id)};

    Call__c call = onCall_TestUtilityMethods.createCall(acc.Id);
    insert call;

    ONTAP__Order__c regorder1 = onCall_TestUtilityMethods.createOrder(acc.Id, call.Id);
    regorder1.Delivery_Date__c = Date.today().addDays(-7);
    regorder1.is_Primary__c = true;
    ONTAP__Order__c regorder2 = onCall_TestUtilityMethods.createOrder(acc.Id, call.Id);
    regorder2.Delivery_Date__c = Date.today().addDays(-14);
    regorder2.is_Primary__c = true;
    ONTAP__Order__c regorder3 = onCall_TestUtilityMethods.createOrder(acc.Id, call.Id);
    regorder3.Delivery_Date__c = Date.today().addDays(-21);
    regorder3.is_Primary__c = true;
    ONTAP__Order__c regNonPrimaryorder1 = onCall_TestUtilityMethods.createOrder(acc.Id, call.Id);
    regNonPrimaryorder1.Delivery_Date__c = Date.today().addDays(-7);
    insert new List<ONTAP__Order__c>{regorder3,regorder2,regorder1,regNonPrimaryorder1};


    Test.setCreatedDate(regorder1.Id,Datetime.newInstance(regorder1.Delivery_Date__c, Time.newInstance(0,  0,0,  0)));
    Test.setCreatedDate(regNonPrimaryorder1.Id,Datetime.newInstance(regNonPrimaryorder1.Delivery_Date__c, Time.newInstance(0,  0,0,  0)));
    Test.setCreatedDate(regorder2.Id,Datetime.newInstance(regorder2.Delivery_Date__c, Time.newInstance(0,  0,0,  0)));
    Test.setCreatedDate(regorder3.Id,Datetime.newInstance(regorder3.Delivery_Date__c, Time.newInstance(0,  0,0,  0)));
    regNonPrimaryorder1.is_Primary__c = false;
    update regNonPrimaryorder1;
    regNonPrimaryorder1 = [Select Id, createddate, is_Primary__c from ONTAP__Order__c where id =: regNonPrimaryorder1.Id];
    System.debug(regNonPrimaryorder1);
    ONTAP__Order_Item__c oi1 = onCall_TestUtilityMethods.createOrderItem(prod.Id, regorder1.Id);
    oi1.POC_Inventory__c = 10;
    oi1.onCall_Quantity__c = 10;
    ONTAP__Order_Item__c oi2 = onCall_TestUtilityMethods.createOrderItem(prod.Id, regorder2.Id);
    oi2.POC_Inventory__c = 20;
    oi2.onCall_Quantity__c = 20;
    ONTAP__Order_Item__c oi3 = onCall_TestUtilityMethods.createOrderItem(prod.Id, regorder3.Id);
    oi3.POC_Inventory__c = 30;
    oi3.onCall_Quantity__c = 30;
    ONTAP__Order_Item__c oiNonPrimary1 = onCall_TestUtilityMethods.createOrderItem(prod.Id, regNonPrimaryorder1.Id);
    oiNonPrimary1.POC_Inventory__c = 5;
    oiNonPrimary1.onCall_Quantity__c = 5;
    insert new List<ONTAP__Order_Item__c>{oi1, oi2, oi3, oiNonPrimary1};

    ONTAP__Order__c ooforder1 = onCall_TestUtilityMethods.createOrder(acc.Id, call.Id);
    ooforder1.Delivery_Date__c = Date.today().addDays(-3);
    ooforder1.Out_Of_Frequency__c = true;
    ONTAP__Order__c ooforder2 = onCall_TestUtilityMethods.createOrder(acc.Id, call.Id);
    ooforder2.Delivery_Date__c = Date.today().addDays(-10);
    ooforder2.Out_Of_Frequency__c = true;
    ONTAP__Order__c ooforder3 = onCall_TestUtilityMethods.createOrder(acc.Id, call.Id);
    ooforder3.Delivery_Date__c = Date.today().addDays(-17);
    ooforder3.Out_Of_Frequency__c = true;
    insert new List<ONTAP__Order__c>{ooforder1,ooforder2, ooforder3};
    /*Test.setCreatedDate(ooforder1.Id,Datetime.newInstance(ooforder1.Delivery_Date__c, Time.newInstance(0,  0,0,  0)));
    Test.setCreatedDate(ooforder2.Id,Datetime.newInstance(ooforder2.Delivery_Date__c, Time.newInstance(0,  0,0,  0)));
    Test.setCreatedDate(ooforder3.Id,Datetime.newInstance(ooforder3.Delivery_Date__c, Time.newInstance(0,  0,0,  0)));*/

    Invoice__c regOrder1Invoice = onCall_TestUtilityMethods.createInvoice(acc.Id, regorder1.Id);
    Invoice__c regOrder2Invoice = onCall_TestUtilityMethods.createInvoice(acc.Id, regorder2.Id);
    Invoice__c regOrder3Invoice = onCall_TestUtilityMethods.createInvoice(acc.Id, regorder3.Id);
    Invoice__c oofOrder1Invoice = onCall_TestUtilityMethods.createInvoice(acc.Id, ooforder1.Id);
    Invoice__c oofOrder2Invoice = onCall_TestUtilityMethods.createInvoice(acc.Id, ooforder2.Id);
    Invoice__c oofOrder3Invoice = onCall_TestUtilityMethods.createInvoice(acc.Id, ooforder3.Id);
    insert new List<Invoice__c>{regOrder1Invoice,regOrder2Invoice,regOrder3Invoice,oofOrder3Invoice,oofOrder2Invoice,oofOrder1Invoice};
    Invoice_Item__c regOrder1InvoiceItem = onCall_TestUtilityMethods.createInvoiceItem(regOrder1Invoice.Id, prod.Id);
    regOrder1InvoiceItem.Quantity__c = 11;
    Invoice_Item__c regOrder2InvoiceItem = onCall_TestUtilityMethods.createInvoiceItem(regOrder2Invoice.Id, prod.Id);
    regOrder2InvoiceItem.Quantity__c = 22;
    Invoice_Item__c regOrder3InvoiceItem = onCall_TestUtilityMethods.createInvoiceItem(regOrder3Invoice.Id, prod.Id);
    regOrder3InvoiceItem.Quantity__c = 33;
    Invoice_Item__c oofOrder1InvoiceItem = onCall_TestUtilityMethods.createInvoiceItem(oofOrder1Invoice.Id, prod.Id);
    oofOrder1InvoiceItem.Quantity__c = 13;
    Invoice_Item__c oofOrder2InvoiceItem = onCall_TestUtilityMethods.createInvoiceItem(oofOrder2Invoice.Id, prod.Id);
    oofOrder2InvoiceItem.Quantity__c = 25;
    Invoice_Item__c oofOrder3InvoiceItem = onCall_TestUtilityMethods.createInvoiceItem(oofOrder3Invoice.Id, prod.Id);
    oofOrder3InvoiceItem.Quantity__c = 37;
    insert new List<Invoice_Item__c>{regOrder1InvoiceItem,regOrder2InvoiceItem,regOrder3InvoiceItem,oofOrder1InvoiceItem,oofOrder2InvoiceItem,oofOrder3InvoiceItem};
    
    stagingRecords = onCall_Utility.calculateInventoryForStagingRecords(stagingRecords);
    System.assertEquals(stagingRecords.size(),1);
    Staging_Order_Table__c stage = stagingRecords[0];
    System.assertEquals(stage.Date_Range1__c, regorder1.Delivery_Date__c);
    System.assertEquals(stage.Date_Range2__c, regorder2.Delivery_Date__c);
    System.assertEquals(stage.Date_Range3__c, regorder3.Delivery_Date__c);
    System.assertEquals(stage.INV1__c, oi1.POC_Inventory__c + oiNonPrimary1.POC_Inventory__c);
    System.assertEquals(stage.Quantity1__c, oi1.onCall_Quantity__c + oiNonPrimary1.onCall_Quantity__c);
    System.assertEquals(stage.INV2__c, oi2.POC_Inventory__c);
    System.assertEquals(stage.Quantity2__c, oi2.onCall_Quantity__c);
    System.assertEquals(stage.INV3__c, oi3.POC_Inventory__c);
    System.assertEquals(stage.Quantity3__c, oi3.onCall_Quantity__c);
    System.assertEquals(stage.LIV1__c, regOrder1InvoiceItem.Quantity__c + oofOrder1InvoiceItem.Quantity__c);
    System.assertEquals(stage.LIV2__c, regOrder2InvoiceItem.Quantity__c + oofOrder2InvoiceItem.Quantity__c);
    System.assertEquals(stage.LIV3__c, regOrder3InvoiceItem.Quantity__c + oofOrder3InvoiceItem.Quantity__c);
    System.assert(stage.hasOOF1__c);
    System.assert(stage.hasOOF2__c);
    System.assert(stage.hasOOF3__c);
    }
  

  @isTest
    static void testrefreshStagingRecordsForCalls(){
    ONTAP__Product__c prod = onCall_TestUtilityMethods.CreateProduct('TestProd');
    insert prod;
    Base_Price__c bp = onCall_TestUtilityMethods.CreateBasePrice(prod.Id);
    insert bp;
    DOI_Header__c propList = onCall_TestUtilityMethods.createProposalList();
    insert propList;
    Proposal_List_Header__c propListHeader = onCall_TestUtilityMethods.createProposalListHeader(propList.Id);
    insert propListHeader;
    /*Proposal_List_Header__c propListHeader2 = onCall_TestUtilityMethods.createProposalListHeader(propList.Id);
    propListHeader2.Name = propListHeader2.Name + '2ndHeader';
    insert propListHeader2;*/
    Proposal_List_Product__c propListProduct = onCall_TestUtilityMethods.createProposalListProduct(prod.Id, propListHeader.Id);
    insert propListProduct;
    Account acc = onCall_TestUtilityMethods.createAccount('TestAcc');
    acc.Proposal_List__c = propList.Id;
    acc.OnCall_Ignore_PL_POCFilter__c = true;
    acc.KDKG2__c = 'KDK';
    acc.KDKG1__c = 'a';
    acc.KATR10__c = 'a';
    acc.KATR2__c = 'a';
    acc.Tax_Class__c = 'a';

    insert acc;
    Account acc2 = onCall_TestUtilityMethods.createAccount('TestAcc2');
    acc2.KATR10__c = 'a';
    acc2.KATR2__c = 'a';
    insert acc2;
    acc.Ship_To_Account__c = acc2.Id;
    update acc;
    Pre_Populated_Discount__c prepopDiscount = onCall_TestUtilityMethods.CreatePrepopulatedDiscount(acc.Id);
    insert prepopDiscount;
    Price_List_Discount__c priceListDiscount = onCall_TestUtilityMethods.CreatePriceListDiscount('KDK');
    insert priceListDiscount;

    Call__c call = new Call__c(POC__c = acc.Id);
    insert call;
    Staging_Order_Table__c oldStagingRecord = new Staging_Order_Table__c(Sold_To__c = acc.Id);
    insert oldStagingRecord;

    onCall_Utility.refreshStagingRecordsForCalls(new List<Id>{call.Id});

    List<Staging_Order_Table__c> oldRecords = [Select Id from Staging_Order_Table__c where Id =: oldStagingRecord.Id];
    System.assert(oldRecords.isEmpty());
    List<Staging_Order_Table__c> newRecords = [Select Id from Staging_Order_Table__c where Sold_To__c =: acc.Id];
    System.assert(!newRecords.isEmpty());
    }
}