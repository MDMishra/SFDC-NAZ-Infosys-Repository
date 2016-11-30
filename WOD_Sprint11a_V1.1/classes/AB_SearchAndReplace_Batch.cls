/*Author: Bharat*/
/*Description: Support Batch for AccountTeam Trigger to unfollow accounts.*/
/*Dependent class: AB_AccountTeam*/
/*Created date: 23/11/2016*/
/*Modification History: 11/29/2016 Removed conectapi to resolve Too many DML exception issue */

global class AB_SearchAndReplace_Batch implements Database.Batchable<sObject>{

   global list<Id> accountId = new list<Id>();
   global list<string> wsrNmbrsss = new list<string>();
   global list<id> Userids = new list<id>();
   global AB_SearchAndReplace_Batch(list<String> wsrNmbrs,list<Id> userId){//,list<Id> AccountId

      //Query='select id from account where WSLR_NBR_US__c in :'+wsrNmbrs;
      //accountId = AccountId;
      wsrNmbrsss=wsrNmbrs;
      Userids = userId;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([select id from account where WSLR_NBR_US__c in :wsrNmbrsss]);// or id in:accountId
   }

   global void execute(Database.BatchableContext BC, List<account> scope){
   //system.debug('scope=='+scope);
       list<string> strAccs = new list<string>();
        for(account acct : scope){
        
            accountId.add(acct.id);
        }   
        
        list<EntitySubscription> unFollowMembers = [select id, parentid from EntitySubscription where parentid in :accountId and SubscriberId in: Userids];       
        //system.debug('unFollowMembers=='+unFollowMembers);
        try{
            if(!unFollowMembers.isEmpty()){
                /*for(EntitySubscription eSub : unFollowMembers){
                    //if(!test.isrunningTest())
                        ConnectApi.Chatter.deleteSubscription(null, eSub.id);
                }*/
                delete unFollowMembers;
            }
        
        }
        catch(Exception e){
            system.debug('Dml Exception'+ e);
        }
   }

   global void finish(Database.BatchableContext BC){
   }
}