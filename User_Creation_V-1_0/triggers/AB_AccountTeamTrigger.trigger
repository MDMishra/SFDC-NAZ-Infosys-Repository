/*Author: Deepthi*/
trigger AB_AccountTeamTrigger on User (after insert,after update,after delete,before insert,before update ) {
    list<user> userList = new list<user>();
    list<user> olduserList = new list<user>();
    list<Id> userId= new list<Id>();
    if(Trigger.isbefore && trigger.isInsert)
    {
        for(user u:Trigger.new)
        {
            if(u.WSLRNbrRouteNbr__c != null || u.Wholesaler_Number__c != null)
            {
                u.Account_Team__c= true;
            }
        }   
    
    }
    
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
                //AB_AccountTeam.addAccountTeam(userId);
            }
        }
        userList.clear();
    }
    if(Trigger.isbefore && trigger.isUpdate)
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
                //if(olduser.WSLRNbrRouteNbr__c== null && u.WSLRNbrRouteNbr__c != null)
                //When updated with WSLRNbrRouteNbr__c
                if(olduser.WSLRNbrRouteNbr__c != u.WSLRNbrRouteNbr__c)
                {
                    //If new route number is not blank need to follow account team
                    if(String.isNotBlank(u.WSLRNbrRouteNbr__c))
                    {
                        u.Account_Team__c= true;   
                    }
                }  
                //if(olduser.Wholesaler_Number__c != null && u.Wholesaler_Number__c != null && olduser.Wholesaler_Number__c != u.Wholesaler_Number__c)
                //When updated with Wholesaler_Number__c
                if(olduser.Wholesaler_Number__c != u.Wholesaler_Number__c)
                {
                    //If new Wholesaler number is not blank need to follow account team
                    if(String.isNotBlank(u.Wholesaler_Number__c) )
                    {
                        u.Account_Team__c= true;
                    }
                }
             }
         }
    
    }
    if(Trigger.isAfter && trigger.isUpdate)
    {
        map<id,user> userOldMap = new map<id,user>();
        for(user u:Trigger.old)
        {
            system.debug(u.Wholesaler_Number__c);
            userOldMap.put(u.id,u);
        }
        set<id> deletefollows = new set<id>();
        set<id> deleteAccountTeams = new set<id>();
        for(user u:Trigger.new)
        {
            system.debug(u.Wholesaler_Number__c);
            user olduser = new user();
            
            if(!userOldMap.isEmpty()){
                olduser=userOldMap.get(u.id);
            }
            if(olduser != null)
            {
                /*if((olduser.WSLRNbrRouteNbr__c== null && u.WSLRNbrRouteNbr__c != null) || (olduser.Wholesaler_Number__c== null && u.Wholesaler_Number__c != null))
                {
                    userList.add(u);
                    userId.add(u.id);
                }
                if((olduser.WSLRNbrRouteNbr__c != null && u.WSLRNbrRouteNbr__c != null && olduser.WSLRNbrRouteNbr__c != u.WSLRNbrRouteNbr__c) || (olduser.Wholesaler_Number__c != null && u.Wholesaler_Number__c != null && olduser.Wholesaler_Number__c != u.Wholesaler_Number__c))
                {
                    system.debug('old and new not matched');
                    userList.add(u);
                    userId.add(u.id);
                    olduserList.add(olduser);
                }*/
                system.debug('entered1');
                if((olduser.WSLRNbrRouteNbr__c != null && u.WSLRNbrRouteNbr__c != null && olduser.WSLRNbrRouteNbr__c !=u.WSLRNbrRouteNbr__c ) ||(olduser.WSLRNbrRouteNbr__c != null && u.WSLRNbrRouteNbr__c == null) )
                {
                    //olduserList.add(olduser); 
                    deleteAccountTeams.add(u.id); 
                    deletefollows.add(u.id);
                     system.debug('entered2');  
                }
                if((olduser.Wholesaler_Number__c !='' && u.Wholesaler_Number__c  != '' && olduser.Wholesaler_Number__c  !=u.Wholesaler_Number__c  ) || (olduser.Wholesaler_Number__c != '' && u.Wholesaler_Number__c == ''))
                {
                    //olduserList.add(olduser); 
                    deletefollows.add(u.id);   
                     system.debug('entered3');
                     
                }
                if(( olduser.Wholesaler_Number__c != null && u.Wholesaler_Number__c != null && olduser.Wholesaler_Number__c != u.Wholesaler_Number__c) && (olduser.WSLRNbrRouteNbr__c != null && u.WSLRNbrRouteNbr__c != null && olduser.WSLRNbrRouteNbr__c != u.WSLRNbrRouteNbr__c))
                {
                     deletefollows.add(u.id);
                      system.debug('entered4');

                }
                 
            }
        }
            if(!userList.isEmpty())
            {
                //AB_AccountTeam.addAccountTeam(userId);
            }
            if(!userList.isEmpty())
            {
                //AB_AccountTeam.addAccountTeam(userId);
            }
            userList.clear();
            if(!deleteAccountTeams.isEmpty())
            {
                AB_AccountTeam.deleteAccountTeam(deleteAccountTeams);
            }
            if(!deletefollows.isEmpty())
            {
                ///AB_AccountTeam.deletefollow(deletefollows);
            }
             
        }
        olduserList.clear();
    
    
}