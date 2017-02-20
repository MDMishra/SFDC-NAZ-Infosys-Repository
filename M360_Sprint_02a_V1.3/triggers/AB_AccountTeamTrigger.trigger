/*Author: Deepthi*/
trigger AB_AccountTeamTrigger on User (after insert,after update,after delete ) {
    list<user> userList = new list<user>();
    list<user> olduserList = new list<user>();
    list<Id> userId= new list<Id>();
    if(Trigger.isAfter && trigger.isInsert)
    {
        system.debug(Trigger.new);
        list<string> wslnrNumber = new list<string>();
        for(user u:Trigger.new)
        {
            if(u.WSLRNbrRouteNbr__c != null || u.Wholesaler_Number__c != null)
            {
                userList.add(u);
                userId.add(u.id);
            }
        }
        system.debug(userList);
        if(!system.isFuture()){
        if(!userList.isEmpty())
            {
                AB_AccountTeam.addAccountTeam(userId);
            }
        }
        userList.clear();
    }
    if(Trigger.isAfter && trigger.isUpdate)
    {
        map<id,user> userOldMap = new map<id,user>();
        for(user u:Trigger.old)
        {
            system.debug(u.Wholesaler_Number__c);
            userOldMap.put(u.id,u);
        }
        for(user u:Trigger.new)
        {
            system.debug(u.Wholesaler_Number__c);
            user olduser = new user();
            if(!userOldMap.isEmpty()){
                olduser=userOldMap.get(u.id);
            }
            if(olduser != null)
            {
                if((olduser.WSLRNbrRouteNbr__c== null && u.WSLRNbrRouteNbr__c != null) || (olduser.Wholesaler_Number__c== null && u.Wholesaler_Number__c != null))
                {
                    userList.add(u);
                    userId.add(u.id);
                }
                if((olduser.WSLRNbrRouteNbr__c != null && u.WSLRNbrRouteNbr__c == null) || (olduser.Wholesaler_Number__c != null && u.Wholesaler_Number__c == null))
                {
                    olduserList.add(olduser);    
                }
                if((olduser.WSLRNbrRouteNbr__c != null && u.WSLRNbrRouteNbr__c != null && olduser.WSLRNbrRouteNbr__c != u.WSLRNbrRouteNbr__c) || (olduser.Wholesaler_Number__c != null && u.Wholesaler_Number__c != null && olduser.Wholesaler_Number__c != u.Wholesaler_Number__c))
                {
                    system.debug('old and new not matched');
                    userList.add(u);
                    userId.add(u.id);
                    olduserList.add(olduser);
                }
            }
        }
        if(!System.isFuture()){
            if(!userList.isEmpty())
            {
                AB_AccountTeam.addAccountTeam(userId);
            }
            userList.clear();
            if(!olduserList.isEmpty())
            {
                AB_AccountTeam.deleteAccountTeam(olduserList);
            }
        }
        olduserList.clear();
    }
    
    
}