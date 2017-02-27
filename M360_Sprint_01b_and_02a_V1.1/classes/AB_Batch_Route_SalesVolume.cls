/*Author: Bharat*/
/*Description: Batch class to create MOB_Sales_Volume_Route__c when EventLog__c is created
               To get sales volume deshboard data*/ 

global class AB_Batch_Route_SalesVolume implements Database.Batchable<sobject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([select ACTUALS__c,LY_Volume__c ,TARGET__c,BrandGroupID__c,BrandGroupName__c,Account__c from Acct_TotYR_Actuals__c where Date__c = this_month and BrandGroupID__c != null and BrandGroupName__c != null and Account__c  != null]);
   }
   
    global void execute(Database.BatchableContext BC, List<Acct_TotYR_Actuals__c> scope) {
        set<id> aid = new set<id>();
        list<RouteCust__c> lstRCusts = new list<RouteCust__c>();
        map<id,list<RouteCust__c>> mapRteAccts = new map<id,list<RouteCust__c>>();
        map<string,list<Acct_TotYR_Actuals__c>> mapRteActuals = new map<string,list<Acct_TotYR_Actuals__c>>();
        if(scope != null && !scope.isEmpty()){
        	for(Acct_TotYR_Actuals__c act : scope){
        		if(act.Account__c != null){
        			aid.add(act.Account__c);
        		}
        	}
        	if(!aid.isEmpty()){
	        	lstRCusts = [select id,Route__c, account__c from RouteCust__c where account__c in : aid];
	       		if(!lstRCusts.isEmpty()){
	       			for(RouteCust__c rte : lstRCusts){
	       				if(mapRteAccts.get(rte.Route__c) == null){
	       					list<RouteCust__c> lstRcsts = new list<RouteCust__c>();
	       					lstRcsts.add(rte);
	       					mapRteAccts.put(rte.Route__c,lstRcsts);
	       				}
	       				else{
	       					/*list<RouteCust__c> lstRcsts = new list<RouteCust__c>();
	       					lstRcsts.addAll(mapRteAccts.get(rte.Route__c));
	       					lstRcsts.add(rte);
	       					mapRteAccts.put(rte.Route__c,lstRcsts);*/
	       					list<RouteCust__c> lstRcsts = new list<RouteCust__c>();
	       					for(RouteCust__c rt : mapRteAccts.get(rte.Route__c)){
	       						if(rt.Account__c != rte.Account__c){
	       							lstRcsts.add(rte);
	       						}
	       					}
	       					lstRcsts.addAll(mapRteAccts.get(rte.Route__c));
	       					mapRteAccts.put(rte.Route__c,lstRcsts);
	       				}
	       			}
	       		}
        	}
        	if(mapRteAccts != null && !mapRteAccts.isEmpty()){
        		for(id rte : mapRteAccts.keyset()){
        			if(mapRteAccts.get(rte) != null){
		        		for(RouteCust__c rtCust : mapRteAccts.get(rte)){
		        			for(Acct_TotYR_Actuals__c act : scope){
		        				if(act.Account__c == rtCust.Account__c){
			        				string str = rtCust.Route__C+'-=-'+act.BrandGroupID__c+'-=-'+System.today().toStartOfMonth();
			        				if(mapRteActuals.get(str) == null){
			        					list<Acct_TotYR_Actuals__c> lstActuals = new list<Acct_TotYR_Actuals__c>();
			        					lstActuals.add(act);
			        					mapRteActuals.put(str,lstActuals);
			        				}
			        				else{
			        					list<Acct_TotYR_Actuals__c> lstActuals = new list<Acct_TotYR_Actuals__c>();
			        					lstActuals.addAll(mapRteActuals.get(str));
			        					lstActuals.add(act);
			        					mapRteActuals.put(str,lstActuals);
			        				}
		        				}
		        			}
		        		}
        			}
        		}
        	}
        	list<MOB_Sales_Volume_Route__c> lstMOBRoutes = new list<MOB_Sales_Volume_Route__c>();
        	if(!mapRteActuals.isEmpty()){
        		for(string str : mapRteActuals.keyset()){
        			decimal ActualSum = 0;
        			decimal VolumeSum = 0;
        			string bCategory = '';
        			if(mapRteActuals.get(str) != null){
	        			for(Acct_TotYR_Actuals__c actuals : mapRteActuals.get(str)){
	        				if(actuals.ACTUALS__c != null)
	        					ActualSum += actuals.ACTUALS__c;
	        		 		if(actuals.LY_Volume__c != null)
	        					VolumeSum += actuals.LY_Volume__c;
	        				if(actuals.BrandGroupName__c != null){
	        					bCategory = actuals.BrandGroupName__c;
	        				}
	        			}
        			}
        			list<string> strData = str.split('-=-');
        			MOB_Sales_Volume_Route__c objNewSV = new MOB_Sales_Volume_Route__c();
        			objNewSV.Actual_Volume__c = double.valueOf(ActualSum);
        			objNewSV.LY_Volume__c = double.valueOf(VolumeSum);
        			//objNewSV.Target_Volume__c = double.valueOf(objRute.get('Target'));
        			objNewSV.date__c = Date.today().toStartOfMonth();
        			objNewSV.BrandGroupID__c = strData[1];
        			objNewSV.Brand_Category__c = bCategory;        
        			objNewSV.Route__c = strData[0];
        			objNewSV.ExternalId__c = str;
        			lstMOBRoutes.add(objNewSV);
        		}
        	}
        	
        	try{
        		system.debug('lstMOBRoutes=='+lstMOBRoutes);
        		if(lstMOBRoutes != null && !lstMOBRoutes.isEmpty())
        			upsert lstMOBRoutes ExternalId__c;
        	}
        	catch(exception e) {
        		system.debug('DML Exception'+e);
        	}
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}