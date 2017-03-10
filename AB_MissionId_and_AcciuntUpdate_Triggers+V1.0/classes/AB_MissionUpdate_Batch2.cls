/*Author: Bharat*/
/*Description: Support Batch for AB_ATP_MissionIdUpdate Trigger*/
/*Dependent class: AB_ATP_MissionIdUpdate Trigger*/
/*Created date: mar 9th 2017*/
/*Modification History: */

global class AB_MissionUpdate_Batch2 implements Database.Batchable<sObject>{

   global set<string> setaddedBT = new set<string>();
   global map<string,string> mapBTm = new map<string,string>();
   global AB_MissionUpdate_Batch2(set<string> setaddedBTs,map<string,string> mapBTms){
       if(setaddedBTs != null && !setaddedBTs.isEmpty())
           setaddedBT =setaddedBTs;
       if(mapBTms != null && !mapBTms.isEmpty())
           mapBTm = mapBTms;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([select Brand_Category__c ,Missions_ID__c,id 
                                                     from US_Account_Target_Program__c where Brand_Category__c 
                                                     IN :setaddedBT and Brand_Category__c !=null]);
   }

   global void execute(Database.BatchableContext BC, List<US_Account_Target_Program__c> scope){
       
       list<US_Account_Target_Program__c> atpsUpdate = new list<US_Account_Target_Program__c>();
        if(scope != null && !scope.isEmpty())
        {
            system.debug('scope=='+scope);
            system.debug('scope size=='+scope.size());
            for(US_Account_Target_Program__c iATP : scope)
            { 
                if(mapBTm != null && !mapBTm.isEmpty())
                    iATP.Missions_id__c = mapBTm.get(iATP.Brand_Category__c); 
                atpsUpdate.add(iATP);
            } 
            //update atpsUpdate;
        }
        
        if(atpsUpdate != null && !atpsUpdate.isEmpty())
        {
            system.debug('atpsUpdate=='+atpsUpdate);
            system.debug('atpsUpdate size=='+atpsUpdate.size());
            try{
                update atpsUpdate;
            }
            catch(Exception e){
                system.debug('Dml Exception'+ e);
            }
        
        }
   }

   global void finish(Database.BatchableContext BC){
   }
}