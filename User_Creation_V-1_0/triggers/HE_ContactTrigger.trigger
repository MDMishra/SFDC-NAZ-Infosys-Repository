// 
// (c) 2015 Appirio, Inc.
//
// This trigger will Validate that is only one Contact.HE_Primary_Contact__c exist for an Account
//
// 11 Nov 2015     Jitendra Kothari       Original - T-443470 : Trigger Validation for only one Contact "HE Primary flag" for each Account
//

/*Test class: AB_CreateUserFromContact_Handler_Test*/

trigger HE_ContactTrigger on Contact (before insert, before update,after insert) {
    //Verify the user has permission to fire the trigger and verify that the trigger
    if (HE_Util.canTrigger('HE_ContactTrigger') ){
        //Only execute the trigger if the current user is not exempt by looking up the user in
        if(Trigger.isBefore){
            if(Trigger.isUpdate){ 
                HE_ContactTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap); 
            }
            if(Trigger.isInsert){ 
                HE_ContactTriggerHandler.onBeforeInsert(Trigger.new);
            }
        }
    }
    
   //Start: AB M360 purpose
    //Description : create a user from a contact OR Update user associated with contact when contact is updated
    if(!system.isBatch()){
    if((Trigger.isBefore && Trigger.isUpdate) || (Trigger.isAfter && Trigger.isInsert)){
        Schema.DescribeSObjectResult contactSchema = Schema.SObjectType.Contact;  
        Map<String,Schema.RecordTypeInfo> contactRecordTypeInfo = contactSchema.getRecordTypeInfosByName();
        String strRecordTypeId = contactRecordTypeInfo.containsKey('NAZ User') ? contactRecordTypeInfo.get('NAZ User').getRecordTypeId() : null;
        if(strRecordTypeId != null && strRecordTypeId != ''){
            List<Contact> lstCon = new List<Contact>();
            for(Contact objCon: Trigger.new){
                if(objCon.RecordTypeId == strRecordTypeId){
                    lstCon.add(objCon);
                }
            }
            if(!lstCon.isEmpty()){
                if(Trigger.isInsert){
                    AB_CreateUserFromContact_Handler.beforeInsert(lstCon);
                }
                if(Trigger.isUpdate){
                    system.debug('lstCon=='+lstCon);
                    AB_CreateUserFromContact_Handler.beforeUpdate(lstCon);
                }
            }
        }
    }
    }
    
    if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)){
        if(Trigger.isInsert)
        {
            AB_CreateUserFromContact_Handler.updateAccount(trigger.new,null,true);  
        }
        if(Trigger.isUpdate)
        {
            AB_CreateUserFromContact_Handler.updateAccount(trigger.new,trigger.old,false);
        }
        
    }
}