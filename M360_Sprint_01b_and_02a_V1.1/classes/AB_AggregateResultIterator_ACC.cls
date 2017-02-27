global class AB_AggregateResultIterator_ACC implements Iterator<AggregateResult> {
   AggregateResult [] results {get;set;}
   // tracks which result item is returned
   Integer index {get; set;} 
          
   global AB_AggregateResultIterator_ACC() {
      index = 0;
      // Fire query here to load the results
      String query = 'select sum(ACTUALS__c) Actual,sum(LY_Volume__c) Volume,sum(TARGET__c) Target,BrandGroupID__c,BrandGroupName__c,account__c from Acct_TotYR_Actuals__c where BrandGroupID__c != null and account__c != null and BrandGroupName__c != null and Date__c = this_month group by BrandGroupID__c,account__c,BrandGroupName__c limit 20000';
      
      results = Database.query(query);            
   } 
    
   global boolean hasNext(){ 
      return results != null && !results.isEmpty() && index < results.size(); 
   }    
    
   global AggregateResult next(){        
      return results[index++];            
   }       
}