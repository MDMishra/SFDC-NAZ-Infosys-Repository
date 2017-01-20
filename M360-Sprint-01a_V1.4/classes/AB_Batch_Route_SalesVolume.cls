/*Author: Bharat*/
/*Description: Batch class to create MOB_Sales_Volume_Route__c when Route_TotYR_Actuals__c is created
               To get sales volume deshboard data*/ 

global class AB_Batch_Route_SalesVolume implements Database.Batchable<AggregateResult> {
    /*global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select sum(ACTUALS__c) Actual,sum(LY_Volume__c) Volume,BrandGroupID__c,Route__c from Route_TotYR_Actuals__c where Date__c = this_month group by BrandGroupID__c,Route__c limit 2000';
        return Database.getQueryLocator(query);
    }*/
    global Iterable<AggregateResult> start(Database.batchableContext info){
        // just instantiate the new iterable here and return
        return new AB_AggregateResultIterable();
    }
   
    global void execute(Database.BatchableContext BC, List<AggregateResult> scope) {
    	set<id> setRid = new set<id>();
    	//list<MOB_Sales_Volume_Account__c> listSVAccounts = new list<MOB_Sales_Volume_Account__c>();
    	list<MOB_Sales_Volume_Route__c> listSVRouts = new list<MOB_Sales_Volume_Route__c>();
    	set<string> setBrands = new set<string>();
    	system.debug('scope=='+scope);
         for(AggregateResult a : scope)
         {
             setRid.add(string.valueOf(a.get('Route__c')));  
             setBrands.add(string.valueOf(a.get('BrandGroupID__c'))); 
             //SumActuals = +a.         
         }
        set<string> SetSVRteGrpIds = new set<string>();
        Date startOfMonth = Date.today().toStartOfMonth();
        list<MOB_Sales_Volume_Route__c> lstSVRteToInsert = new list<MOB_Sales_Volume_Route__c>();
        if(setRid != null && setBrands != null)
        	//listSVRouts = [select id,Account__c,Brand_Category__c,BrandGroupID__c,Actual_Volume__c,Target_Volume__c,Sales_Days__c from MOB_Sales_Volume_Account__c where Account__c in : setAid and BrandGroupID__c in : setBrands and Date__c =: startOfMonth];
        	listSVRouts = [select id,Route__c,Brand_Category__c,BrandGroupID__c,Actual_Volume__c,Target_Volume__c,Sales_Days__c from MOB_Sales_Volume_Route__c where Route__c in : setRid and BrandGroupID__c in : setBrands and Date__c =: startOfMonth];
        delete listSVRouts;
        
        //list<MOB_Sales_Volume_Route__c> lstSVRteToInsert = new list<MOB_Sales_Volume_Route__c>();
        for(AggregateResult a : scope)
        {
        	if(a.get('Route__c') != null)
            	lstSVRteToInsert.add(Insertdata(a));
        }
        insert lstSVRteToInsert;
    }   
    public MOB_Sales_Volume_Route__c Insertdata(AggregateResult objRute){
    	MOB_Sales_Volume_Route__c objNewSV = new MOB_Sales_Volume_Route__c();
    	objNewSV.Actual_Volume__c = double.valueOf(objRute.get('Actual'));
    	objNewSV.LY_Volume__c = double.valueOf(objRute.get('Volume'));
    	objNewSV.Target_Volume__c = double.valueOf(objRute.get('Target'));
    	objNewSV.date__c = Date.today().toStartOfMonth();
    	objNewSV.BrandGroupID__c = string.valueOf(objRute.get('BrandGroupID__c'));
    	objNewSV.Brand_Category__c = string.valueOf(objRute.get('BrandGroupName__c'));
    	
    	objNewSV.Route__c = string.valueOf(objRute.get('Route__c'));
    	return objNewSV;
    	
    }
    global void finish(Database.BatchableContext BC) {
    }
}