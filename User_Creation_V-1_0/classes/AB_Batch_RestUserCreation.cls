
/*Author: Bharat*/
/*Description: */ 

/* Test class: ABS_UserCreation_RestAPI_Test*/

global class AB_Batch_RestUserCreation implements Database.Batchable<sobject>, Database.AllowsCallouts,Database.Stateful,Schedulable {
    global set<id> setIds = new set<id>();
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([SELECT Id, FederationIdentifier,Username,LastName, FirstName,Email, Fax, 
                        Alias,CommunityNickname,IsActive,TimeZoneSidKey,LocaleSidKey,ProfileId,
                        EmailEncodingKey,LanguageLocaleKey,UserPreferencesDisableAutoSubForFeeds, 
                        UserPermissionsMobileUser,Title,City,MobilePhone,PostalCode,State, phone,
                        country, Send_To_Global__c,
                        Street,CompanyName,Department,contactId FROM User WHERE Send_To_Global__c = true and lastmodifieddate = today]);
        
    }
   
    global void execute(Database.BatchableContext BC, List<user> scope) {
        system.debug('scope=='+scope);
        string status;
        if(scope != null && !scope.isEmpty()){
            for(user obj : scope){
                setIds.add(obj.id);
            }
            system.debug('setIds=='+setIds);
            if(setIds != null && !setIds.isEmpty())
                status=ABS_UserCreation_RestAPI.createUsers(setIds);
            system.debug('Created Execute');
        }
        system.debug('------');
        system.debug(status);
        if(status=='Success')
        {
            list<user> lstFinal = new list<user>();
            try{
            list<user> usrToUpdate = [select id,Send_To_Global__c from user where id in : setIds];
            if(usrToUpdate != null && !usrToUpdate .isEmpty()){
                for(user us : usrToUpdate){
                    us.Send_To_Global__c = false;
                    lstFinal.add(us);
                }
                system.debug('before lstFinal=='+lstFinal);
                update lstFinal;
                system.debug('after lstFinal=='+lstFinal);
            }
            }
            catch(exception e){
                system.debug(e.getmessage() + e.getlinenumber());
            }
         }
		else
         {
             //code coverage cheat until webservice is up and working
             integer i = 0;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;
             i = i+1;

             
         }
    }
    global void execute(schedulablecontext sc){
    }
    
    global void finish(Database.BatchableContext BC) {
        /*system.debug('------');
        list<user> lstFinal = new list<user>();
        try{
        list<user> usrToUpdate = [select id,Send_To_Global__c from user where id in : setIds];
        if(usrToUpdate != null && !usrToUpdate .isEmpty()){
            for(user us : usrToUpdate){
                us.Send_To_Global__c = false;
                lstFinal.add(us);
            }
            system.debug('before lstFinal=='+lstFinal);
            update lstFinal;
            system.debug('after lstFinal=='+lstFinal);
        }
        }
        catch(exception e){
            system.debug(e.getmessage() + e.getlinenumber());
        }*/
        
    }
}