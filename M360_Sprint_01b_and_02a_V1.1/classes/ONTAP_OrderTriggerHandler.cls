public class ONTAP_OrderTriggerHandler {
    public static final String FUTURE_CALL_STATUS = label.OnCall_Call_Status;
    public static void beforeInsert(List<ONTAP__Order__c> newList){
        updateOrigin(newList, null);
        updatePrimary(newlist);
        setCallLookup(newlist);
        
        //check order delivery date against scheduled delivery frequency, set checkbox if for date in future
    }

    public static void beforeUpdate(List<ONTAP__Order__c> newList, Map<Id, ONTAP__Order__c> oldMap) {
        // if order is updated, update order summary
        updateOrderSummary(newList);

        // if status is changed from "submitted" to "draft" for b2b and telesales
        updateOrderStatus(newList, oldMap);
    }

    public static void onAfterInsert(List<ONTAP__Order__c> newList){
        List<ONTAP__Order__c> ordersClonedBySAP = new List<ONTAP__Order__c>();
        List<ONTAP__Order__c> ordersWithCall = new List<ONTAP__Order__c>();
        for(ONTAP__Order__c o:newlist){
            if(o.SAP_External_System_ID__c != null){
                ordersClonedBySAP.add(o);
            }
            if(o.Origin__c == 'Telesales Timeout' && o.SAP_Order_Number__c != null && o.Call__c != null && o.Is_Return__c == FALSE){
                ordersWithCall.add(o);
            }
        }
        if(!ordersClonedBySAP.isEmpty()){
            cloneTimedOutOrder(ordersClonedBySAP);
        }
        if(ordersWithCall != null && !ordersWithCall.isEmpty()){
            setCallStatus(ordersWithCall);
        }

        // create order summary records when order is created
        createOrderSummary(newList);
    }

    public static void onAfterUpdate(Map<Id,ONTAP__Order__c> oldMap, Map<Id,ONTAP__Order__c> newMap){
        List<Id> ordersToSendToSAP = new List<Id>();
        Map<Id, ONTAP__Order__c> ordersWithCall = new Map<Id, ONTAP__Order__c>();
        Map<Id, ONTAP__Order__c> orderSummaries = new Map<Id, ONTAP__Order__c>();
        for(Id oid: newMap.keySet()){
            if(newMap.get(oid).SAP_Order_Number__c == null && newMap.get(oid).B2B_Submit_to_SAP__c == true && oldMap.get(oid).B2B_Submit_to_SAP__c != newMap.get(oid).B2B_Submit_to_SAP__c){
                ordersToSendToSAP.add(oid);
            }
            if(newMap.get(oid).Call__c != null && newMap.get(oid).Is_Return__c == FALSE && oldMap.get(oid).SAP_Order_Number__c == null && newMap.get(oid).SAP_Order_Number__c != null){
                ordersWithCall.put(oid,newMap.get(oid));
            }
            if(newMap.get(oid).Delivery_Date__c != oldMap.get(oid).Delivery_Date__c){
                orderSummaries.put(oid, newMap.get(oid));
            }
        }
        if(!ordersToSendToSAP.isEmpty()){
            sendToSAP(ordersToSendToSAP);
        }
        if(ordersWithCall != null && !ordersWithCall.isEmpty()){
            setCallStatus(ordersWithCall);
        }
        if(orderSummaries != null && !orderSummaries.isEmpty()){
            removeOrderSummary(orderSummaries);
        }
    }

    public static void onAfterDelete(List<ONTAP__Order__c> oldList){
        Id recOnCallOrderId = [Select Id from RecordType where sObjectType = 'ONTAP__Order__c' and Name  = 'OnCall Order'].Id;
        Set<id> onCallOrderIdSet = new Set<id>();
        for(ONTAP__Order__c o:oldList){
            if(o.RecordTypeId == recOnCallOrderId){
                onCallOrderIdSet.add(o.id);
            }
        }

        if(!onCallOrderIdSet.isEmpty()){
            deleteRelatedOrderItems(onCallOrderIdSet);
        }
    }

    public static void deleteRelatedOrderItems (Set<id> orderIds){
        List<ONTAP__Order_Item__c> oiToDelete = [select id, OnCall_Order__c from ONTAP__Order_Item__c where OnCall_Order__c IN: orderIds limit 1000];
        if(!oiToDelete.isEmpty()){
            if(oiToDelete.size()<1000){
                delete oiToDelete;
            }else{
                deleteRelatedOrderItemsFuture(orderIds);
            }
        }
    }

    @future
    public static void deleteRelatedOrderItemsFuture (Set<id> orderIds){
        List<ONTAP__Order_Item__c> oiToDelete = [select id, OnCall_Order__c from ONTAP__Order_Item__c where OnCall_Order__c IN: orderIds];
        if(!oiToDelete.isEmpty()){
            delete oiToDelete;
        }
    }
    
    // set the origin of orders created by the SAP Integration user to Head Office
    public static void updateOrigin(List<ONTAP__Order__c> newOrder, Map<Id, ONTAP__Order__c> oldMap){
        if (system.Userinfo.getName().contains('Integration')){
            for (ONTAP__Order__c o : newOrder) {
                if (o.origin__c != null){
                    o.origin__c = 'Head Office';
                }
            }
        }
    }

    //Check existing orders for this day to see if there already exists a primary order
    public static void updatePrimary(List<ONTAP__Order__c> newOrderList){
        set<id> accForNewOrders = new set<id>();
        set<id> accPrimaryOrder = new set<id>();
        Set<String> deliveryCodes = new Set<String>();
        Map<String,List<Date>> mapDeliveryCodeToDates = new Map<String,List<Date>>();
        List<ONTAP__Order__c> ordersToUpdate = new List<ONTAP__Order__c>();
        
        //Add Account Ids from new Orders to Set
        for(ONTAP__Order__c order: newOrderList){
            accForNewOrders.add(order.OnCall_Account__c);
        }


        Map<Id,Account> accountMap = new Map<Id,Account> ([Select Id, Delivery_Frequency__r.Name from Account where Id in: accForNewOrders]);

        for(Account a : accountMap.values()){
            if(a.Delivery_Frequency__r.Name != null){
                mapDeliveryCodeToDates.put(a.Delivery_Frequency__r.Name,new List<Date>());
            }         
        }

        for(String deliveryCode: mapDeliveryCodeToDates.keySet()){
            List<String> dateStrings = OnCall_Utility.frequencyCalculation(deliveryCode);
            List<Date> dates = new List<Date>();
            for(String s: dateStrings){
                dates.add(Date.valueOf(s));
            }
            mapDeliveryCodeToDates.get(deliveryCode).addAll(dates);
        }

        List<Date> deliveryDatesList = new List<Date>();
        for(List<Date> dates : mapDeliveryCodeToDates.values()){
            deliveryDatesList.addAll(dates);
        }
        //Find any existing Orders with Primary = true and Delivery Date + Account in the lists created above
        List<ONTAP__Order__c> existingOrders = [select id, OnCall_Account__c, CreatedDate, origin__c, Out_of_Frequency__c, Delivery_Date__c, Is_Primary__c from ONTAP__Order__c 
                                               where Is_Primary__c = true AND OnCall_Account__c IN: accForNewOrders AND Delivery_Date__c in: deliveryDatesList];
        


        Map<Id,Map<Date,ONTAP__Order__c>> mapAccountIdToDeliveryDateToOrder = new Map<Id,Map<Date,ONTAP__Order__c>>();
        for(ONTAP__Order__c o: existingOrders){
            if(!mapAccountIdToDeliveryDateToOrder.containsKey(o.OnCall_Account__c)){
                mapAccountIdToDeliveryDateToOrder.put(o.OnCall_Account__c,new Map<Date,ONTAP__Order__c>{o.Delivery_Date__c => o});
            }else{
                mapAccountIdToDeliveryDateToOrder.get(o.OnCall_Account__c).put(o.Delivery_Date__c,o);
            }
        }                                     

        for(ONTAP__Order__c newOrder: newOrderList){
                Id accountId = newOrder.OnCall_Account__c;
                if(accountMap != null && !accountMap.isEmpty() && accountMap.get(accountId).Delivery_Frequency__r != null){
                    Set<Date> onScheduleDates = new Set<Date>(mapDeliveryCodeToDates.get(accountMap.get(accountId).Delivery_Frequency__r.Name));
                    if(onScheduleDates.contains(newOrder.Delivery_Date__c)){
                        if(!mapAccountIdToDeliveryDateToOrder.containsKey(accountId) || !mapAccountIdToDeliveryDateToOrder.get(accountId).containsKey(newOrder.Delivery_Date__c)){
                            if(!newOrder.Is_Return__c){
                                newOrder.Is_Primary__c = true;
                            }
                        }
                    }
                }
        }
/*
        //Find any existing Orders Created today in Salesforce with Primary as True, and an Account in the list above 
        List<ONTAP__Order__c> existingOrders = [select id, OnCall_Account__c, CreatedDate, origin__c, Out_of_Frequency__c, Is_Primary__c from ONTAP__Order__c 
                                               where Is_Primary__c = true AND OnCall_Account__c IN: accForNewOrders AND origin__c = 'Telesales' 
                                               AND CreatedDate >: System.today().addDays(-1)];
        
        //Create a list of Accounts from the Primary Orders
        for(ONTAP__Order__c order: existingOrders){
            accPrimaryOrder.add(order.OnCall_Account__c);
        }
        
        for(ONTAP__Order__c newOrder: newOrderList){
            if(!accPrimaryOrder.contains(newOrder.OnCall_Account__c) && !newOrder.Out_of_Frequency__c){
                newOrder.Is_Primary__c = true;
            }
        }*/
    }


    //Check for Call__c records with the same Account and Date__c = today and set the Call__c lookup to that record if it exists
    public static void setCallLookup(List<ONTAP__Order__c> newOrderList){
        List<ONTAP__Order__c> checkDeliveryDate = new List<ONTAP__Order__c>();
        Map<Id,Call__c> mapAccountIdToCall = new Map<Id,Call__c>();
        List<Id> accountIds = new List<Id>();
        for(ONTAP__Order__c order : newOrderList){
            if(order.OnCall_Account__c != null){
                accountIds.add(order.OnCall_Account__c);
            }
        }

        List<Call__c> callsToday = [Select Id, POC__c, Date__c from Call__c where POC__c in: accountIds and DAY_ONLY(Date__c) = TODAY and Call_Type__c = 'Order'];
        System.debug('CallsToday : ' +callsToday);
        for(Call__c call : callsToday){
            mapAccountIdToCall.put(call.POC__c, call);
        }

        for(ONTAP__Order__c order : newOrderList){
            if(order.OnCall_Account__c != null && mapAccountIdToCall.containsKey(order.OnCall_Account__c)){
                order.Call__c = mapAccountIdToCall.get(order.OnCall_Account__c).Id;
                checkDeliveryDate.add(order);
            }
        }

        if(!checkDeliveryDate.isEmpty()){
            setIsFuture(checkDeliveryDate);
        }

    }

    //Check the Order Delivery Date against the delivery schedule, if it is not for the first date, check the Is_Future checkbox
    public static void setIsFuture(List<ONTAP__Order__c> orderList){
        Set<id> accForNewOrders = new Set<id>();
        Set<String> deliveryCodes = new Set<String>();
        Map<String,List<Date>> mapDeliveryCodeToDates = new Map<String,List<Date>>();
        
        //Add Account Ids from Orders to Set
        for(ONTAP__Order__c order: orderList){
            accForNewOrders.add(order.OnCall_Account__c);
        }


        Map<Id,Account> accountMap = new Map<Id,Account> ([Select Id, Delivery_Frequency__r.Name from Account where Id in: accForNewOrders]);

        for(Account a : accountMap.values()){
            if(a.Delivery_Frequency__r.Name != null){
                mapDeliveryCodeToDates.put(a.Delivery_Frequency__r.Name,new List<Date>());
            }         
        }

        for(String deliveryCode: mapDeliveryCodeToDates.keySet()){
            List<String> dateStrings = OnCall_Utility.frequencyCalculation(deliveryCode);
            List<Date> dates = new List<Date>();
            for(String s: dateStrings){
                dates.add(Date.valueOf(s));
            }
            mapDeliveryCodeToDates.get(deliveryCode).addAll(dates);
        }

        List<Date> deliveryDatesList = new List<Date>();
        for(List<Date> dates : mapDeliveryCodeToDates.values()){
            deliveryDatesList.addAll(dates);
        } 
       
        for(ONTAP__Order__c order: orderList){
                Id accountId = order.OnCall_Account__c;
                if(accountMap.get(accountId).Delivery_Frequency__r != null){
                    List<Date> onScheduleDates = mapDeliveryCodeToDates.get(accountMap.get(accountId).Delivery_Frequency__r.Name);
                    if(!onScheduleDates.isEmpty() && order.Delivery_Date__c != onScheduleDates[0]){
                        order.Is_Future__c = true;
                    }
                }
        }     

    }

    public static void setCallStatus(List<ONTAP__Order__c> newOrder){
        Map<Id, ONTAP__Order__c> orderMap = new Map<Id, ONTAP__Order__c>(newOrder);
        setCallStatus(orderMap);
    }

    public static void setCallStatus(Map<Id, ONTAP__Order__c> newOrder){
        Set<ID> callRecords = new Set<id>();
        List<Call__c> callsToUpdate = new List<Call__c>();
        for(Id oid : newOrder.keySet()){
            callRecords.add(newOrder.get(oid).Call__c);
        }
        List<Call__c> callList = [select id, Call_Status__c, Primary_Order__c from Call__c where id IN:callRecords];
        for(Id oid : newOrder.keySet()){
            for(Call__c call:callList){
                if(newOrder.get(oid).Call__c == call.id){
                    if(!newOrder.get(oid).Is_Future__c){
                        if(newOrder.get(oid).Out_of_Frequency__c){
                        }
                        call.Call_Status__c = 'Complete';
                        if(call.Primary_Order__c == null){
                            call.Primary_Order__c = String.valueof(newOrder.get(oid).name);
                        }
                        callsToUpdate.add(call);
                    }else if(call.Call_Status__c != 'Complete'){
                        if(newOrder.get(oid).Out_of_Frequency__c){
                        }
                        call.Call_Status__c = FUTURE_CALL_STATUS;
                        callsToUpdate.add(call);
                    }
                }                
            }
        }
        if(callsToUpdate != null && !callsToUpdate.isEmpty()){
           update callsToUpdate; 
        }        
    }
    
    public static void removeOrderSummary(Map<Id, ONTAP__Order__c> newOrder){
        Set<ID> orderIds = new Set<id>();
        List<Order_Summary__c> orderSummaryToDelete = new List<Order_Summary__c>();
        for(Id oid : newOrder.keySet()){
            orderIds.add(oid);
        }
        List<Order_Summary__c> orderSummaryList = [select id, Order__c from Order_Summary__c where Order__c IN: orderIds];
        if(!orderSummaryList.isEmpty()){
            for(Id oid : newOrder.keySet()){
                for(Order_Summary__c os:orderSummaryList){
                    if(oid == os.Order__c){
                        orderSummaryToDelete.add(os);               
                    }
                }
            }
        }
        if(orderSummaryToDelete != null && !orderSummaryToDelete.isEmpty()){
           delete orderSummaryToDelete; 
        }        
    }

    //If a new order is created by SAP due to a timeout from the interface the new order will have an existing Order's SFDC ID in the 
    //SAP_External_System_ID__c field.  Find the existing Salesforce Order record, set its status to cancelled and update the new order 
    //from SAP with the Call lookup and set the status to Submitted
    public static void cloneTimedOutOrder(List<ONTAP__Order__c> newOrder){
        List<ONTAP__Order__c> orderFromSAP = new List<ONTAP__Order__c>();
        List<ONTAP__Order__c> orderFromSapToUpdate = [select id, Name, SAP_Order_Number__c, Total_Order_Metric_Cases__c, Total_Order_Item_Quantity__c, Call__c, Is_Future__c, Out_of_Frequency__c, Is_Primary__c, OnCall_Status__c, SAP_External_System_ID__c from ONTAP__Order__c where Id IN: newOrder];
        Set<id> existingOrderIds = new Set<id>();
        for(ONTAP__Order__c o: newOrder){
            existingOrderIds.add(o.SAP_External_System_ID__c);
        }

        List<ONTAP__Order__c> existingOrderToClone = [select id, Name, Call__c, Objective_Score__c, Prime_Objective_Points__c, Inventory_Taken__c, 
                                                    Total_Metric_Case_Over_Suggested__c, Ownerid, Total_Order_Metric_Cases__c, Total_Order_Item_Quantity__c, 
                                                    Is_Future__c, Out_of_Frequency__c, Is_Primary__c, OnCall_Status__c, SAP_Order_Response__c, 
                                                    SAP_Order_Number__c, Origin__c from ONTAP__Order__c where Id IN: existingOrderIds];
        List<ONTAP__Order__c> existingOrderToUpdate = new List<ONTAP__Order__c>();
        for(ONTAP__Order__c newO :orderFromSapToUpdate){
            for(ONTAP__Order__c existingOrder :existingOrderToClone){
                if(newO.SAP_External_System_ID__c == existingOrder.id){
                    if(existingOrder.SAP_Order_Number__c != null){
                        existingOrder.SAP_Order_Response__c = 'Order potentially duplicated by agent - '+newO.Name+'. SAP Order Number: '+newO.SAP_Order_Number__c;
                        newO.Ownerid = existingOrder.Ownerid;
                        if(existingOrder.Origin__c == 'Telesales'){
                            newO.Origin__c = 'Telesales Timeout';
                        }else if(existingOrder.Origin__c == 'Telesales'){
                            newO.Origin__c = 'B2B Timeout';
                        }
                        newO.OnCall_Status__c = 'Submitted';
                        newO.SAP_Order_Response__c = 'Duplicate Order For - '+existingOrder.Name+'. SAP Order Number: '+existingOrder.SAP_Order_Number__c+ ' created in error.';                    
                    }else{
                        existingOrder.OnCall_Status__c = 'Draft Timeout';
                        existingOrder.SAP_Order_Response__c = 'Order Replaced by SAP - '+newO.Name+' SAP Order Number: '+newO.SAP_Order_Number__c;
                        newO.Call__c = existingOrder.Call__c;
                        newO.Ownerid = existingOrder.Ownerid;
                        newO.OnCall_Status__c = 'Submitted';
                        if((newO.SAP_External_System_ID__c.length()==15 || newO.SAP_External_System_ID__c.length()==18) && existingOrder.Origin__c == 'Telesales'){
                            newO.Origin__c = 'Telesales Timeout';
                        }else if((newO.SAP_External_System_ID__c.length()==15 || newO.SAP_External_System_ID__c.length()==18) && existingOrder.Origin__c == 'B2B'){
                            newO.Origin__c = 'B2B Timeout';
                        }
                        if(existingOrder.Is_Future__c){
                            newO.Is_Future__c = TRUE;
                        }
                        if(existingOrder.Out_of_Frequency__c){
                            newO.Out_of_Frequency__c = TRUE;
                        }
                        if(existingOrder.Is_Primary__c && existingOrder.SAP_Order_Number__c == null){
                            existingOrder.Is_Primary__c = FALSE;
                            newO.Is_Primary__c = TRUE;
                        }
                        if(existingOrder.Total_Order_Item_Quantity__c != null){
                            newO.Total_Order_Item_Quantity__c = existingOrder.Total_Order_Item_Quantity__c;
                        }
                        if(existingOrder.Total_Order_Metric_Cases__c != null){
                            newO.Total_Order_Metric_Cases__c = existingOrder.Total_Order_Metric_Cases__c;
                        }
                        if(existingOrder.Objective_Score__c != null){
                            newO.Objective_Score__c = existingOrder.Objective_Score__c;
                        }
                        if(existingOrder.Prime_Objective_Points__c != null){
                            newO.Prime_Objective_Points__c = existingOrder.Prime_Objective_Points__c;
                        }
                        if(existingOrder.Inventory_Taken__c != null){
                            newO.Inventory_Taken__c = existingOrder.Inventory_Taken__c;
                        }
                        if(existingOrder.Total_Metric_Case_Over_Suggested__c != null){
                            newO.Total_Metric_Case_Over_Suggested__c = existingOrder.Total_Metric_Case_Over_Suggested__c;
                        }
                    }
                    orderFromSAP.add(newO);
                    existingOrderToUpdate.add(existingOrder);                    
                }
            }
        }
        if(orderFromSAP != null){
            update orderFromSAP;
        }
        if(existingOrderToUpdate != null){
            update existingOrderToUpdate;
        }        
    }

    public static void createOrderSummary(List<ONTAP__Order__c> newOrderList) {

        List<Order_Summary__c> newOrderSummaryListToCreate = new List<Order_Summary__c>();

        Set<Id> callIdSet = new Set<Id>();

        for(ONTAP__Order__c order : newOrderList) {
            callIdSet.add(order.Call__c);
        }

        // query corresponding calls
        List<Call__c> orderCallList = [Select Id, Delivery_Date__c 
                                    from Call__c
                                    where Id in :callIdSet];

        Map<Id, Date> callDeliveryDateMap = new Map<Id, Date>();

        for (Call__c call : orderCallList) {
            callDeliveryDateMap.put(call.Id, call.Delivery_Date__c);
        }

        for (ONTAP__Order__c newOrder : newOrderList) {
            if (newOrder.Call__c != null && newOrder.Delivery_Date__c == callDeliveryDateMap.get(newOrder.Call__c)) {
                Order_Summary__c newOrderSummary = new Order_Summary__c(); 
                if (newOrder.OnCall_Status__c == 'Draft' && (newOrder.Origin__c == 'Telesales' || newOrder.Origin__c == 'Telesales Timeout') || newOrder.Out_of_Frequency__c == true) {
                    newOrderSummary.Call__c = newOrder.Call__c;
                    newOrderSummary.Order__c = newOrder.Id;
                    newOrderSummary.Order_Origin__c = newOrder.Origin__c;
                    newOrderSummary.Order_Status__c = newOrder.OnCall_Status__c;
                } else {
                    newOrderSummary.Call__c = newOrder.Call__c;
                    newOrderSummary.Order__c = newOrder.Id;
                    newOrderSummary.SAP_Order_Number__c = newOrder.SAP_Order_Number__c;
                    newOrderSummary.Order_Origin__c = newOrder.Origin__c;
                    newOrderSummary.Order_Status__c = newOrder.OnCall_Status__c;
                    newOrderSummary.Order_Volume_Actual__c = newOrder.Total_Order_Metric_Cases__c;
                    newOrderSummary.Weekly_Objective_Score__c = newOrder.Prime_Objective_Points__c;
                    newOrderSummary.Objective_Score__c = newOrder.Objective_Score__c;
                    newOrderSummary.Inventory_Taken__c = newOrder.Inventory_Taken__c;
                    newOrderSummary.Quantity_Over_Suggested__c = newOrder.Total_Metric_Case_Over_Suggested__c;

                }

                newOrderSummaryListToCreate.add(newOrderSummary);
            }

        }

        if (newOrderSummaryListToCreate != null && !newOrderSummaryListToCreate.isEmpty()) {
            insert newOrderSummaryListToCreate;
        }
    }

     public static void updateOrderSummary(List<ONTAP__Order__c> newOrders) {
        
        Map<Id, ONTAP__Order__c> orderMap = new Map<Id, ONTAP__Order__c>();
        for (ONTAP__Order__c newOrder : newOrders) {
            orderMap.put(newOrder.Id, newOrder);  
        }
        // get the related order summary that needs to be updated
        List<Order_Summary__c> orderSummaryList = [Select Id, Order_Volume_Actual__c, Order__c
                                                           from Order_Summary__c
                                                           where Order__c in :orderMap.keySet()];

        List<Order_Summary__c> orderSummaryListToUpdate = new List<Order_Summary__c>();

        for (Order_Summary__c orderSummary : orderSummaryList) {
            orderSummary.SAP_Order_Number__c = orderMap.get(ordersummary.Order__c).SAP_Order_Number__c;
            orderSummary.Order_Origin__c = orderMap.get(ordersummary.Order__c).Origin__c;
            orderSummary.Order_Status__c = orderMap.get(ordersummary.Order__c).OnCall_Status__c;
            orderSummary.Order_Volume_Actual__c = orderMap.get(ordersummary.Order__c).Total_Order_Metric_Cases__c;
            orderSummary.Weekly_Objective_Score__c = orderMap.get(ordersummary.Order__c).Prime_Objective_Points__c;
            orderSummary.Objective_Score__c = orderMap.get(ordersummary.Order__c).Objective_Score__c;
            orderSummary.Inventory_Taken__c = orderMap.get(ordersummary.Order__c).Inventory_Taken__c;
            orderSummary.Quantity_Over_Suggested__c = orderMap.get(ordersummary.Order__c).Total_Metric_Case_Over_Suggested__c;

            orderSummaryListToUpdate.add(orderSummary);
        }

        if (orderSummaryListToUpdate != null && !orderSummaryListToUpdate.isEmpty()) {
            update orderSummaryListToUpdate;
        }
    }


    public static void updateOrderStatus(List<ONTAP__Order__c> newOrders, Map<Id, ONTAP__Order__c> oldMap) {
        Map<Id, String> orderSummaryMap = new Map<Id, String>();

        for (ONTAP__Order__c newOrder : newOrders) {
            if (newOrder.OnCall_Status__c == 'Draft' && oldMap.get(newOrder.Id).get('OnCall_Status__c') == 'Submitted') {
                orderSummaryMap.put(newOrder.Id, newOrder.OnCall_Status__c);
            }
        }

        System.debug('orderSummaryMap ' + orderSummaryMap);

        List<Order_Summary__c> orderSummaryList = [Select Id, Order__c, Order_Status__c
                                                   from Order_Summary__c
                                                   where Order__c in :orderSummaryMap.keySet()];

       List<Order_Summary__c> orderSummaryListToUpdate = new List<Order_Summary__c>();

        for (Order_Summary__c orderSummary : orderSummaryList) {
            orderSummary.Order_Status__c = orderSummaryMap.get(orderSummary.Order__c);
            orderSummary.Order_Volume_Actual__c = null;
            orderSummary.Weekly_Objective_Score__c = null;
            orderSummary.Objective_Score__c = null;
            orderSummary.Inventory_Taken__c = false;
            orderSummary.Quantity_Over_Suggested__c = null;

            orderSummaryListToUpdate.add(orderSummary);
        }

        System.debug('orderSummaryListToUpdate ' + orderSummaryListToUpdate);

        if (orderSummaryListToUpdate != null && !orderSummaryListToUpdate.isEmpty()) {
            update orderSummaryListToUpdate;
        }
    }

    //If the Order came from B2B, use webservice to send to SAP
    @future(callout=true)
    public static void sendToSAP(List<Id> orderList){
        for(Id oid: orderList){
            OnCall_CreateSAPOrder.createSAPOrder(oid);
        }
    }        
}