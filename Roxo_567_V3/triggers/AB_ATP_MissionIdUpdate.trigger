/* Update Acct Tgt Program mission id when GSC KPI Mission id is updated.*/
trigger AB_ATP_MissionIdUpdate on GSC_Mission_KPI_Map__c (After update) {
    set<string> setMissionId = new Set<string>();
    map<string,List<US_Account_Target_Program__c>> mapAtp = new map<string,List<US_Account_Target_Program__c>>();
    map<id,GSC_Mission_KPI_Map__c> oldMids = new map<id,GSC_Mission_KPI_Map__c>();
    map<string,string> oldvsNewId = new map<string,string>();
    for(GSC_Mission_KPI_Map__c updMission : Trigger.old)
    {
        oldMids .put(updMission.id,updMission);
    }
    
    for(GSC_Mission_KPI_Map__c updMission : Trigger.new)
    {
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
    list<US_Account_Target_Program__c> LstAtp1 =[select Missions_ID__c,id from US_Account_Target_Program__c
                                                 where Missions_ID__c IN :setMissionId And  Missions_ID__c !=null];

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
    for(GSC_Mission_KPI_Map__c updMission : Trigger.new)
    {
        list<US_Account_Target_Program__c> atpsUpdate = new list<US_Account_Target_Program__c>();
        list<US_Account_Target_Program__c> atpsLstUpdate = new list<US_Account_Target_Program__c>();

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
        
        update atpsLstUpdate;
    
    }
    
   
}