/*Author: Bharat*/
/*Description: Batch class to create MOB_Sales_Volume_Account__c when Account_TotYR_Actuals__c is created
               To get sales volume deshboard data*/

global class AB_Batch_Acc_SalesVolume implements Database.Batchable<AggregateResult> {//sObject
    
    global Iterable<AggregateResult> start(Database.batchableContext info){
        // just instantiate the new iterable here and return
        return new AB_AggregateResultIterable_ACC();
    }
   
    global void execute(Database.BatchableContext BC, List<AggregateResult> scope) {
        set<id> setAid = new set<id>();
        list<MOB_Sales_Volume_Account__c> listSVAccounts = new list<MOB_Sales_Volume_Account__c>();
        set<string> setBrands = new set<string>();
        system.debug('scope=='+scope);
        
         for(AggregateResult a : scope)
         {
             if(a.get('Account__c') != null)
             	setAid.add(string.valueOf(a.get('Account__c'))); 
             if(a.get('BrandGroupID__c') != null) 
             	setBrands.add(string.valueOf(a.get('BrandGroupID__c'))); 
             
         }
         //system.debug('mapActuals=='+mapActuals);
              
         system.debug('setAid=='+setAid);
                system.debug('setBrands=='+setBrands);
        set<string> SetSVAccGrpIds = new set<string>();
        set<string> setAccts = new set<string>();
        
        Date startOfMonth = Date.today().toStartOfMonth();
        if(setAid != null && setBrands != null)
            listSVAccounts = [select id,Account__c,Brand_Category__c,BrandGroupID__c,Actual_Volume__c,Target_Volume__c,Sales_Days__c from MOB_Sales_Volume_Account__c where Account__c in : setAid and BrandGroupID__c in : setBrands and Date__c =this_month];
        system.debug('listSVAccounts=='+listSVAccounts);
        delete listSVAccounts;
        
        list<MOB_Sales_Volume_Account__c> lstSVAccToInsert = new list<MOB_Sales_Volume_Account__c>();
        for(AggregateResult a : scope)
        {
        	if(a.get('Account__c') != null)
            	lstSVAccToInsert.add(Insertdata(a));
        }
        insert lstSVAccToInsert;
    }   
    public MOB_Sales_Volume_Account__c Insertdata(AggregateResult objAccAct){
        MOB_Sales_Volume_Account__c objNewSVAcc = new MOB_Sales_Volume_Account__c();
        objNewSVAcc.Actual_Volume__c = double.valueOf(objAccAct.get('Actual'));
        objNewSVAcc.LY_Volume__c = double.valueOf(objAccAct.get('Volume'));
        objNewSVAcc.Target_Volume__c = double.valueOf(objAccAct.get('Target'));
        objNewSVAcc.date__c = Date.today().toStartOfMonth();
        objNewSVAcc.BrandGroupID__c = string.valueOf(objAccAct.get('BrandGroupID__c'));
        objNewSVAcc.Brand_Category__c = string.valueOf(objAccAct.get('BrandGroupName__c'));
        objNewSVAcc.account__c = string.valueOf(objAccAct.get('account__c'));
        return objNewSVAcc;
        
    }
    global void finish(Database.BatchableContext BC) {
    }
}