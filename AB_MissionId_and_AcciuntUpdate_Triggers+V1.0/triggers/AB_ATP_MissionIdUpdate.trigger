/* Update Acct Tgt Program mission id when GSC KPI Mission id is updated.
Test Class:AB_AtpMissionIdUpdateTest
*/
trigger AB_ATP_MissionIdUpdate on GSC_Mission_KPI_Map__c (After update,After Insert) {
    set<string> setMissionId = new Set<string>();
    map<string,List<US_Account_Target_Program__c>> mapAtp = new map<string,List<US_Account_Target_Program__c>>();
    map<id,GSC_Mission_KPI_Map__c> oldMids = new map<id,GSC_Mission_KPI_Map__c>();
    map<string,string> oldvsNewId = new map<string,string>();
    set<id> setGSCId = new set<id>();
    if(trigger.isUpdate && trigger.isAfter)// Added new lines on 3/8/2017
    {
        for(GSC_Mission_KPI_Map__c updMission : Trigger.old)
        {
            oldMids .put(updMission.id,updMission);
        }
        
        for(GSC_Mission_KPI_Map__c updMission : Trigger.new)
        {
            setGSCId.add(updMission.id);
            GSC_Mission_KPI_Map__c oldgsc = new GSC_Mission_KPI_Map__c();
            if(!oldMids .isEmpty()){
                oldgsc = oldMids.get(updMission.id);
            }
            
            if(updMission.Mission_ID__c != null && updMission.Mission_ID__c !='' && oldgsc.Mission_ID__c !=updMission.Mission_ID__c)
            {
                if(oldgsc.Mission_ID__c !='' && oldgsc.Mission_ID__c !=null) 
                {  
                    setMissionId.add(oldgsc.Mission_ID__c);
                }
                oldvsNewId.put(updMission.id,oldgsc.Mission_ID__c);
            }
            else if(updMission.Mission_ID__c == null && oldgsc.Mission_ID__c !=null)
            {
                system.debug(updMission.Mission_ID__c);
                setMissionId.add(oldgsc.Mission_ID__c);
                oldvsNewId.put(updMission.id,oldgsc.Mission_ID__c);
            }
        }
        system.debug('setMissionId=='+setMissionId);
        Database.executeBatch(new AB_MissionUpdate_Batch(setMissionId,setGSCId,oldvsNewId));
        /*list<US_Account_Target_Program__c> LstAtp1 =[select Missions_ID__c,id from US_Account_Target_Program__c
                                                     where Missions_ID__c IN :setMissionId];
    
        if(!LstAtp1.isEmpty())
        {
            for(US_Account_Target_Program__c atp:LstAtp1)
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
        list<US_Account_Target_Program__c> atpsLstUpdate = new list<US_Account_Target_Program__c>();

        for(GSC_Mission_KPI_Map__c updMission : Trigger.new)
        {
            list<US_Account_Target_Program__c> atpsUpdate = new list<US_Account_Target_Program__c>();
            string oldMissionId='';
            if(!oldvsNewId.isEmpty())
            {
                oldMissionId=oldvsNewId.get(updMission.id); 
            }
            if(oldMissionId != '')
            {
                if(!mapAtp.isEmpty())
                {
                    atpsUpdate=mapAtp.get(oldMissionId);
                
                }
            }
            if(!atpsUpdate.isempty())
            {
                for(US_Account_Target_Program__c atp:atpsUpdate)
                {
                    atp.Missions_ID__c=updMission.Mission_ID__c;
                    atpsLstUpdate.add(atp);   
                }      
            
            }
        }
        update atpsLstUpdate;*/
    }
    
    // Added below code on 3/8/2017
    if((trigger.isInsert || trigger.isUpdate) && trigger.isAfter )
    {
        Set<string> setaddedBT = new Set<string>(); 
        Map<string,string> mapBTm = new Map<string,string>(); 
        list<US_Account_Target_Program__c> atpsUpdate = new list<US_Account_Target_Program__c>();
        for(GSC_Mission_KPI_Map__c updMission : Trigger.new) 
        { 
            setaddedBT.add(updMission.name); 
            mapBTm.put(updMission.name, updMission.Mission_ID__c);
        } 
        Database.executeBatch(new AB_MissionUpdate_Batch2(setaddedBT,mapBTm),1000);
        /*list<US_Account_Target_Program__c> LstAtpIns =[select Brand_Category__c ,Missions_ID__c,id 
                                                     from US_Account_Target_Program__c where Brand_Category__c 
                                                     IN :setaddedBT and Brand_Category__c !=null]; 
        for(US_Account_Target_Program__c iATP : LstAtpIns)
        { 
            iATP.Missions_id__c = mapBTm.get(iATP.Brand_Category__c); 
            atpsUpdate.add(iATP);
        } 
        update atpsUpdate;*/
        
     }
   
}