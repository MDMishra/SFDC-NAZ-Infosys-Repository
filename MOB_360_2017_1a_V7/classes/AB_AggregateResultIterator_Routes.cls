global class AB_AggregateResultIterator_Routes implements Iterator<AggregateResult> {
   AggregateResult [] results {get;set;}
   // tracks which result item is returned
   Integer index {get; set;} 
          
   global AB_AggregateResultIterator_Routes() {
      index = 0;
      // Fire query here to load the results
      String query = 'select sum(ACTUALS__c) Actual,sum(LY_Volume__c) Volume,sum(TARGET__c) Target,BrandGroupID__c,BrandGroupName__c,Route__c from Route_TotYR_Actuals__c where Date__c = this_month and BrandGroupID__c != null and BrandGroupName__c != null and Route__c  != null group by BrandGroupID__c,Route__c,BrandGroupName__c limit 2000';
      results = Database.query(query);            
   } 
    
   global boolean hasNext(){ 
      return results != null && !results.isEmpty() && index < results.size(); 
   }    
    
   global AggregateResult next(){        
      return results[index++];            
   }       
}