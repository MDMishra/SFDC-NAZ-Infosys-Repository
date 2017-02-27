/*Author: Bharat*/
/*Description: Support Batch for AccountTeam Trigger to unfollow accounts.*/
/*Dependent class: AB_AccountTeam*/
/*Created date: 23/11/2016*/
/*Modification History: 11/29/2016 Removed conectapi to resolve Too many DML exception issue */

global class AB_SearchAndReplace_Batch implements Database.Batchable<sObject>,Schedulable {

   global list<id> Userids = new list<id>();
   

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator([SELECT Id FROM User WHERE Account_Team__c = true and lastmodifieddate = today]);
       
   }

   global void execute(Database.BatchableContext BC, List<user> scope){
       system.debug('scope=='+scope);
       list<string> strAccs = new list<string>();
       for(user u : scope)
       {
           Userids.add(u.id);
       }   
       list<EntitySubscription> unFollowMembers = [select id from EntitySubscription where  SubscriberId in: Userids];       
       system.debug('unFollowMembers=='+unFollowMembers);
        try{
            if(!unFollowMembers.isEmpty()){
                delete unFollowMembers;
            }
        
        }
        catch(Exception e){
            system.debug('Dml Exception'+ e);
        }
   }
   global void execute(schedulablecontext sc){
    }

   global void finish(Database.BatchableContext BC)
   {
       AB_Batch_AccountTeam b=new AB_Batch_AccountTeam();
       Database.executeBatch(b);
   }
}