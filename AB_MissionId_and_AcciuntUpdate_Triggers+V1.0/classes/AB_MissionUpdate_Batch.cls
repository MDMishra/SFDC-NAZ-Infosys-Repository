/*Author: Bharat*/
/*Description: Support Batch for AB_ATP_MissionIdUpdate Trigger*/
/*Dependent class: AB_ATP_MissionIdUpdate Trigger*/
/*Created date: mar 9th 2017*/
/*Modification History: */

global class AB_MissionUpdate_Batch implements Database.Batchable<sObject>{

   global set<string> setMissionId = new set<string>();
   global set<id> setGSCId = new set<id>();
   global map<string,string> oldvsNewId = new map<string,string>();
   global AB_MissionUpdate_Batch(set<string> setMissionIds,set<id> setGSCIds,map<string,string> oldvsNewIds){
      if(setMissionIds != null && !setMissionIds.isEmpty())
          setMissionId =setMissionIds;
      if(setGSCIds != null && !setGSCIds.isEmpty())
          setGSCId = setGSCIds;
      if(oldvsNewIds != null && !oldvsNewIds.isEmpty())
          oldvsNewId = oldvsNewIds;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([select Missions_ID__c,id from US_Account_Target_Program__c
                                                     where Missions_ID__c IN :setMissionId]);
   }

   global void execute(Database.BatchableContext BC, List<US_Account_Target_Program__c> scope){
   
       map<string,List<US_Account_Target_Program__c>> mapAtp = new map<string,List<US_Account_Target_Program__c>>();
        if(scope != null && !scope.isEmpty())
        {
            system.debug('scope=='+scope);
            system.debug('scope size=='+scope.size());
            for(US_Account_Target_Program__c atp:scope)
            {
                if(mapAtp.containsKey(atp.Missions_ID__c))
                {
                    list<US_Account_Target_Program__c> lstATP =mapAtp.get(atp.Missions_ID__c); 
                    lstATP.add(atp);
                    mapAtp.put(atp.Missions_ID__c,lstATP);
                }else{
                    mapAtp.put(atp.Missions_ID__c,new list<US_Account_Target_Program__c>{atp});
                }
            }
        }
        if(setGSCId != null && !setGSCId.isEmpty()){
            list<GSC_Mission_KPI_Map__c> listNewGSC = [select id,Mission_ID__c from GSC_Mission_KPI_Map__c where id in :setGSCId];
            list<US_Account_Target_Program__c> atpsLstUpdate = new list<US_Account_Target_Program__c>();
            if(listNewGSC != null && !listNewGSC.isEmpty()){
                for(GSC_Mission_KPI_Map__c updMission : listNewGSC)
                {
                    list<US_Account_Target_Program__c> atpsUpdate = new list<US_Account_Target_Program__c>();
                    string oldMissionId='';
                    if(oldvsNewId != null && !oldvsNewId.isEmpty())
                    {
                        oldMissionId=oldvsNewId.get(updMission.id); 
                    }
                    if(oldMissionId != null && oldMissionId != '')
                    {
                        if(mapAtp != null && !mapAtp.isEmpty())
                        {
                            atpsUpdate=mapAtp.get(oldMissionId);
                        
                        }
                    }
                    if(atpsUpdate != null && !atpsUpdate.isEmpty())
                    {
                        for(US_Account_Target_Program__c atp:atpsUpdate)
                        {
                            atp.Missions_ID__c=updMission.Mission_ID__c;
                            atpsLstUpdate.add(atp);   
                        }      
                    
                    }
                }
            
                if(!atpsLstUpdate.isEmpty())
                {
                    system.debug('atpsLstUpdate=='+atpsLstUpdate);
                    system.debug('atpsLstUpdate size=='+atpsLstUpdate.size());
                    try{
                        update atpsLstUpdate;
                    }
                    catch(Exception e){
                        system.debug('Dml Exception'+ e);
                    }
                
                }
            }
        }
   }

   global void finish(Database.BatchableContext BC){
   }
}