trigger AB_UpdateMission on US_Account_Target_Program__c (before insert,before update) 
{
    set<string> brandCategory = new set<string>();
    list<GSC_Mission_KPI_Map__c> gscMission = new list<GSC_Mission_KPI_Map__c>();
    map<string,string> mapMissionId = new  map<string,string>();
    for(US_Account_Target_Program__c accProgram:trigger.new)
    {
        if(accProgram.Brand_Category__c != '')
            brandCategory.add(accProgram.Brand_Category__c);
            system.debug(brandCategory);
    }
    if(!brandCategory.isEmpty())
    {
        gscMission =[select name,Mission_ID__c from GSC_Mission_KPI_Map__c 
                     where name IN :brandCategory];
        system.debug(gscMission);
    }
    if(!gscMission.isEmpty())
    {
        for(GSC_Mission_KPI_Map__c gMiss:gscMission)
        {
            mapMissionId.put(gMiss.name,gMiss.Mission_ID__c );
        }
    }
    system.debug(gscMission);

    if(trigger.isInsert)
    {
        for(US_Account_Target_Program__c accProgram:trigger.new)
        {
            if(accProgram.Brand_Category__c !='')
            {
                if(!mapMissionId.isEmpty())
                {
                    accProgram.Missions_id__c=mapMissionId.get(accProgram.Brand_Category__c);
                
                }
            
            }
        
        }
     }
     if(trigger.isUpdate)
     {
         map<id,US_Account_Target_Program__c> oldAccPrograms = new map<id,US_Account_Target_Program__c >();
         for(US_Account_Target_Program__c oldAccProgram:trigger.old)
         {
             oldAccPrograms.put(oldAccProgram.id,oldAccProgram);
         }
         for(US_Account_Target_Program__c accProgram:trigger.new)
         {
            US_Account_Target_Program__c oldAcc = new US_Account_Target_Program__c ();
            if(!oldAccPrograms.isEmpty())
            {
                oldAcc =oldAccPrograms.get(accProgram.Id);
            }
            if(accProgram.Brand_Category__c !='' && accProgram.Brand_Category__c!=oldAcc.Brand_Category__c)
            {
                accProgram.Missions_id__c=mapMissionId.get(accProgram.Brand_Category__c);
            }
         }
     }
}