// 
// (c) 2015 Appirio, Inc.
//
// This trigger will Validate that is only one Contact.HE_Primary_Contact__c exist for an Account
//
// 11 Nov 2015     Jitendra Kothari       Original - T-443470 : Trigger Validation for only one Contact "HE Primary flag" for each Account
//
//Modification History:
//Refactored: 3/27/2017        Modified By: Scott Meidroth/Slalom

/*Test class: AB_CreateUserFromContact_Handler_Test*/

trigger HE_ContactTrigger on Contact (before insert, before update,after insert,after update) {
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
    //3/27/2017 Scott Meidroth/Slalom
    //adding Before Insert to the trigger context below, to pre-fill some required fields on the contact record
    if(!system.isBatch()){
        if((Trigger.isBefore && Trigger.isUpdate) || (Trigger.isAfter && Trigger.isInsert) || (Trigger.isBefore && Trigger.isInsert)){
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
                    if(Trigger.isBefore && Trigger.isInsert){
                        AB_CreateUserFromContact_Handler.preFillFields(lstcon);
                    }
                    if(Trigger.isInsert){
                        AB_CreateUserFromContact_Handler.beforeInsert(lstCon);
                    }
                    if(Trigger.isUpdate){
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
    
    // Creating User in destination org when contact is inserted/Updated added by deepthi 4/11/2017
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert))
    {
        set<id> conIdsInsert = new set<id>();
        set<id> conIdsUpdate = new set<id>();
        map<id,contact> oldUser = new map<id,contact>();
        Schema.DescribeSObjectResult contactSchema = Schema.SObjectType.Contact;  
        Map<String,Schema.RecordTypeInfo> contactRecordTypeInfo = contactSchema.getRecordTypeInfosByName();
        string strRecordTypeId = contactRecordTypeInfo.containsKey('NAZ User') ? contactRecordTypeInfo.get('NAZ User').getRecordTypeId() : null;
        if(Trigger.isInsert)
        {
            for(Contact objCon: Trigger.new)
            {
                if(objCon.RecordTypeId==strRecordTypeId){
                    if(!objCon.Global_User_Only__c && objCon.ISACTIVE__c)
                    {
                        conIdsInsert.add(objCon.id);    
                    }else if(!objCon.Global_User_Only__c && !objCon.ISACTIVE__c){
                        conIdsInsert.add(objCon.id);
                    }else if(objCon.Global_User_Only__c && objCon.ISACTIVE__c){
                        conIdsInsert.add(objCon.id);
                    }else if(objCon.Global_User_Only__c && !objCon.ISACTIVE__c){
                        conIdsInsert.add(objCon.id);
                    }
                }
            }
        }
        if(Trigger.isUpdate)
        {
            for(Contact objCon: Trigger.old)
            {
                oldUser.put(objCon.id,objCon);
            }
            contact conOld = new contact();
            for(Contact objCon: Trigger.new)
            {
                if(objCon.RecordTypeId==strRecordTypeId){
                    conOld =oldUser.get(objCon.id);
                    if(conOld.Global_User_Only__c != objCon.Global_User_Only__c || conOld.ISACTIVE__c !=objCon.ISACTIVE__c )
                    {
                        if(!objCon.Global_User_Only__c && objCon.ISACTIVE__c )
                        {
                            conIdsUpdate.add(objCon.id);
                        }else if(!objCon.Global_User_Only__c && !objCon.ISACTIVE__c){
                            conIdsUpdate.add(objCon.id);
                        }else if(objCon.Global_User_Only__c && objCon.ISACTIVE__c){
                            conIdsUpdate.add(objCon.id);
                        }else if(objCon.Global_User_Only__c && !objCon.ISACTIVE__c){
                            conIdsUpdate.add(objCon.id);
                        }
                    }
                 }
            }
        }
        if(!conIdsInsert.isEmpty())
        {
            Database.executeBatch(new AB_Batch_RestUserCreation(conIdsInsert));
        }
        if(!conIdsUpdate.isEmpty())
        {
            Database.executeBatch(new AB_Batch_RestUserCreation(conIdsUpdate));
        }
    }
}