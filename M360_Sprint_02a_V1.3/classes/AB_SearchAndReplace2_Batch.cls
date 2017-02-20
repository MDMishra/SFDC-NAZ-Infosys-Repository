/*Author: Bharat*/
/*Description: Support Batch for AccountTeam Trigger to delete teammembers.*/
/*Dependent class: AB_AccountTeam*/
/*Created date: Feb 3rd 2016*/
/*Modification History: */

global class AB_SearchAndReplace2_Batch implements Database.Batchable<sObject>{

   global list<string> wsrNmbrsss = new list<string>();
   global list<Id> userId = new list<Id>();
   global AB_SearchAndReplace2_Batch(list<String> wsrNmbrs,list<Id> userIds){//,list<Id> AccountId

      wsrNmbrsss=wsrNmbrs;
      userId = userIds;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([select id,Account__c,WSLRNbrRouteNbr__c from RouteCust__c where 
                          WSLRNbrRouteNbr__c In :wsrNmbrsss and WSLRNbrRouteNbr__c != null and Account__c != null]);// or id in:accountId
   }

   global void execute(Database.BatchableContext BC, List<RouteCust__c> scope){
   system.debug('scope=='+scope);
        list<Id> accountId = new list<Id>();
        list<AccountTeamMember> deleteMemebers = new list<AccountTeamMember>();
        for(RouteCust__c rotcust : scope) 
        {
           accountId.add(rotcust.Account__c);      
        }  
        system.debug(accountId +'==='+ userId);
        if(accountId != null){
            deleteMemebers =[select id from AccountTeamMember where 
                         UserId In :userId And AccountId In :accountId and AccountId != null and UserId != null];
        }
        system.debug('deleteMemebers=='+ deleteMemebers);
        if(!deleteMemebers.isEmpty())
        {
            try{
                delete deleteMemebers;
            }catch(Exception e){
                system.debug('Dml Exception'+ e);
            }
        
        }
   }

   global void finish(Database.BatchableContext BC){
   }
}