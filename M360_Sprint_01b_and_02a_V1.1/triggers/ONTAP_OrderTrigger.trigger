trigger ONTAP_OrderTrigger on ONTAP__Order__c (before insert, before update, after insert, after update, after delete) {
    if(Trigger.isInsert && Trigger.isBefore){
        ONTAP_OrderTriggerHandler.beforeInsert(trigger.new);
    }

    if(Trigger.isInsert && Trigger.isAfter){
        ONTAP_OrderTriggerHandler.onAfterInsert(trigger.new);
    }

    if(Trigger.isUpdate && Trigger.isAfter){
        ONTAP_OrderTriggerHandler.onAfterUpdate(trigger.oldMap,trigger.newMap);
    }

    if (Trigger.isUpdate && Trigger.isBefore) {
        ONTAP_OrderTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
    }
    if(Trigger.isDelete && Trigger.isAfter){
        ONTAP_OrderTriggerHandler.onAfterDelete(trigger.old);
    }
}