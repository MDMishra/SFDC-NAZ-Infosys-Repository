trigger AB_salesExcelleceTrg on Event (after update) {
    set<id> aid1 = new set<id>();
    set<id> aid2 = new set<id>();
    set<id> uid = new set<id>();
    decimal TimeSpent;
    for(event objEv : trigger.new){
        
        if(objEv.Visit_Completed__c == true)
        {
            if(objEv.Out_of_Range_on_Start__c == true && objEv.Out_of_Range_on_End__c == true)
            {
                if(objEv.Whatid != null)
                    aid2.add(objEv.Whatid);
            }
            if(objEv.ownerid != null)
                uid.add(objEv.ownerid);
            
            Long dt1Long = objEv.StartDateTime.getTime();
            Long dt2Long = objEv.EndDateTime.getTime();
            Long milliseconds = dt2Long - dt1Long;
            Long seconds = milliseconds / 1000;
            Long minutes = seconds / 60;
            decimal hours = integer.valueOf(minutes) / (60.0);
            TimeSpent = hours;
            system.debug(milliseconds);
            system.debug(seconds);
            system.debug(minutes);
            system.debug(hours);
            if(objEv.Out_of_Range_on_Start__c == false && objEv.Out_of_Range_on_End__c == false)
            {
                if(objEv.Whatid != null)
                    aid1.add(objEv.Whatid);
            }  
        }
    }
    system.debug('aid1=='+aid1);
    try{
    list<user> userDetail = new list<user>();
    string strRouteNmbr = '';
    if(uid != null && !uid.isEmpty())
        userDetail = [select id,WSLRNbrRouteNbr__c from user where id in :uid and WSLRNbrRouteNbr__c != null limit 1];
    if(userDetail != null && !userDetail.isEmpty())
        strRouteNmbr = userDetail[0].WSLRNbrRouteNbr__c;
    list<Route_Schedule__c> listToUpdate = new list<Route_Schedule__c>();
    list<Route_Schedule__c> RoutesInRangeList = [select id,Route__r.WSLRNbrRouteNbr__c,Account__c from Route_Schedule__c where Route__r.WSLRNbrRouteNbr__c =: strRouteNmbr and Account__c in :aid1 and StopDate__c = TODAY]; 
    list<Route_Schedule__c> RoutesOutRangeList = [select id,Route__r.WSLRNbrRouteNbr__c,Account__c from Route_Schedule__c where Route__r.WSLRNbrRouteNbr__c =: strRouteNmbr and Account__c in :aid2 and StopDate__c = TODAY]; 
    if(RoutesInRangeList != null && RoutesInRangeList.size() != 0){
        for(Route_Schedule__c objRte : RoutesInRangeList){
            objRte.Visits_Count__c = 1;
            objRte.Time_Spent__c = TimeSpent;
            listToUpdate.add(objRte);
        }
    } 
    if(RoutesOutRangeList != null && RoutesOutRangeList.size() != 0){
        for(Route_Schedule__c objRte : RoutesOutRangeList){
            objRte.Time_Spent__c = TimeSpent;
            objRte.Visits_Count__c = 0;
            listToUpdate.add(objRte);
        }
    }
    update listToUpdate; 
    }
    catch(exception e){
        system.debug('e.getmessage()=='+e.getmessage()+e.getlinenumber());
        
    }
}