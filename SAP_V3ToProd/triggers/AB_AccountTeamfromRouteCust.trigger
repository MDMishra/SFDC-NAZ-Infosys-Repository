trigger AB_AccountTeamfromRouteCust on RouteCust__c (after insert,after update,before delete){
    list<RouteCust__c> rtList = new list<RouteCust__c >();
    list<RouteCust__c> oldrutCust = new list<RouteCust__c>();
    if(Trigger.isAfter && trigger.isInsert)
    {
        for(RouteCust__c rotCust:trigger.new)
        {
            if(rotCust.WSLRNbrRouteNbr__c != null && rotCust.Account__c != null)
            {
                rtList.add(rotCust); 
            }   
        }
        if(!rtList .isEmpty())
        {
            AB_AccountTeam.addAccountteamfromRouteCust(rtList);
        }
        rtList .clear();  
    }
    if(Trigger.isAfter && trigger.isUpdate)
    {
        map<id,RouteCust__c > rutOldMap = new map<id,RouteCust__c >();
        for(RouteCust__c rt:Trigger.old)
        {
            rutOldMap .put(rt.id,rt);
        }
        for(RouteCust__c rt:Trigger.new)
        {
            RouteCust__c oldrtcust = new RouteCust__c ();
            if(!rutOldMap.isEmpty()){
                oldrtcust =rutOldMap.get(rt.id);
            }
            if(oldrtcust != null)
            {
                if(rt.Account__c != null && oldrtcust.Account__c != rt.Account__c )
                {
                    if(rt.WSLRNbrRouteNbr__c != null && rt.Account__c != null)
                    {
                        rtList.add(rt);
                    }
                    
                    system.debug(oldrutCust);   
                }
                if(oldrtcust.Account__c != null && oldrtcust.WSLRNbrRouteNbr__c != null && oldrtcust.Account__c != rt.Account__c)
                {
                    oldrutCust.add(oldrtcust);
                }
            }
        }
        if(!rtList .isEmpty())
        {
            AB_AccountTeam.addAccountteamfromRouteCust(rtList);
        }
        rtList.clear();
        if(!oldrutCust.isEmpty())
        {
            AB_AccountTeam.deleteAccountTeams(oldrutCust);
        }
        oldrutCust.clear();
    }
    if(Trigger.isbefore && trigger.isdelete)
    {
        for(RouteCust__c rotCust:trigger.old)
        {
            if(rotCust.WSLRNbrRouteNbr__c != null && rotCust.Account__c != null)
            {
                rtList.add(rotCust); 
            }   
        } 
        system.debug(rtList);
        if(!rtList .isEmpty())
        {
            AB_AccountTeam.deleteAccountTeams(rtList);
        }
        rtList .clear();  
    }
}