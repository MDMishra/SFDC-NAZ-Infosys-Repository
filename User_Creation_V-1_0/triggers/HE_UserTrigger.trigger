// 
// (c) 2016 Appirio, Inc.
//
// Handler Class for HE_UserTrigger
//
// 07 May 2016     Gagandeep Kaur   Original : T-503075 : Auto-join Chatter Group where Information includes the Wholesaler Number
//
trigger HE_UserTrigger on User (after insert, after update) {
    /*if(trigger.isInsert && trigger.isAfter){
        List<Id> allUsers = new List<Id>();
        for(User usr : Trigger.new) {
            
                allUsers.add(usr.Id);
        }
        HE_UserTriggerHandler.addToChatterGroup(allUsers);
     }
     else if(trigger.isUpdate && trigger.isAfter){
     List<Id> allUsers = new List<Id>();
     for(User usr : Trigger.new) {
     
         if(Trigger.oldMap.get(usr.Id).Wholesaler_Number__c != usr.Wholesaler_Number__c) {
             allUsers.add(usr.Id);
             system.debug('User added in list : ' + usr.Id);
         }
     }
         HE_UserTriggerHandler.addToChatterGroup(allUsers);

 }*/
 }