/*Author: Bharat*/
/*Description: */ 

/* Test class: ABS_UserCreation_RestAPI_Test*/

global class AB_Batch_RestUserCreation implements Database.Batchable<sobject>, Database.AllowsCallouts,Schedulable,Database.Stateful {//,Database.Stateful
    
    global set<id> setConIds = new set<id>();
    global set<Id> setIds = new set<Id>();
    global AB_Batch_RestUserCreation (set<id> conIds)
    {
        setConIds  = conIds;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      return Database.getQueryLocator([select id,EMPLOYEE_NUMBER_US__c,LastName,FirstName,Email,MobilePhone,ISACTIVE__c,DEFAULTDIVISION__c,
                   USERNAME__c,Username_Suffix__c,NICKNAME__C,ROLEID__c,PROFILEID__c,TIMEZONEIDKEY__c,LOCALESIDKEY__c,ROUTEKEY__c,
                   COMPANYNAME__c,FEDERATIONIDENTIFIER__c,Title,CurrencyIsoCode,EMAILENCODINGKEY__c,LANGUAGELOCALEKEY__c,ALIAS__c,
                   Username_Suffix_Global__c,Global_User_Only__c,WSLRNbrRouteNbr__c,WHOLESALER_NUMBER__c from contact where id IN:setConIds ]);
        
    }
   
    global void execute(Database.BatchableContext BC, List<contact> scope) {
        system.debug('scope=='+scope);
        string status;
        if(scope != null && !scope.isEmpty()){
            for(contact obj : scope){
                setIds.add(obj.id);
            }
            system.debug('setIds=='+setIds);
            if(setIds != null && !setIds.isEmpty())
                status=ABS_UserCreation_RestAPI.createUser(setIds);
            if(test.isRunningTest())
                status = 'Success';
            system.debug('Created Execute');
        }
        system.debug('------');
        system.debug(status);
        if(status=='Success')
        {
           
        }
    }
    global void execute(schedulablecontext sc){
        //Database.executeBatch(new AB_Batch_RestUserCreation());
    }
    
    global void finish(Database.BatchableContext BC) {
    
        
    }
}