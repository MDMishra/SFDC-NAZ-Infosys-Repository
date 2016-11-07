Public class AB_AccountTeam{
    
    @future
    public static void addAccountTeam(list<id> userIds)
    {
        list<string> wsrdId = new list<string>();
        list<RouteCust__c> lstRoutecust = new list<RouteCust__c>();
        list<AccountTeamMember> members = new list<AccountTeamMember>();
        list<user> lstuser = new list<user>();
        lstuser =[select WSLRNbrRouteNbr__c,id,title from user where Id in :userIds ];
        for(user u: lstuser)
        {
            wsrdId.add(u.WSLRNbrRouteNbr__c);
        }
        lstRoutecust=[select id,Account__c,WSLRNbrRouteNbr__c from RouteCust__c where 
                      WSLRNbrRouteNbr__c In :wsrdId and Account__c != null];
        system.debug(lstRoutecust);            
        map<string,list<id>> mapAccountId = new map<string,list<id>>();
        
        for(RouteCust__c routeCust:lstRoutecust)
        {
            if(routeCust.Account__c != null)
                if(mapAccountId.containsKey(routeCust.WSLRNbrRouteNbr__c))
                {
                    mapAccountId.get(routeCust.WSLRNbrRouteNbr__c).add(routeCust.Account__c); 
                           
                }else
                {
                    list<id> accIds = new list<id>();
                    accIds.add(routeCust.Account__c);             
                    mapAccountId.put(routeCust.WSLRNbrRouteNbr__c,accIds);
                }
        }
        system.debug(mapAccountId);
        for(user u: lstuser) 
        {
            system.debug(u);
            list<id> accountIds = new list<id>();
            if(!mapAccountId.isEmpty())
            {
                if(mapAccountId.get(u.WSLRNbrRouteNbr__c) != null)
                {
                    accountIds=mapAccountId.get(u.WSLRNbrRouteNbr__c);
                }
            }
            if(!accountIds.isEmpty())
            {
                for(id accId:accountIds)
                {
                    AccountTeamMember acc = new AccountTeamMember();
                    acc.AccountId = accId;
                    acc.UserId=u.id;
                    if(u.title != '')
                        acc.TeamMemberRole=u.title;
                    members.add(acc);
                }
            }
            system.debug(members);
        } 
        if(!members.isEmpty())
        {
            try{
                insert members;
            }catch(Exception e)
            {
                system.debug('Dml Exception'+e);
            
            }
        
        }
    
    }
    
    public static void deleteAccountTeam(list<user> lstuser)
    {
        list<string> wsrdId = new list<string>();
        list<Id> accountId = new list<Id>();
        list<Id> userId = new list<Id>();
        list<RouteCust__c> lstRoutecust = new list<RouteCust__c>();
        list<AccountTeamMember> deleteMemebers = new list<AccountTeamMember>();
        for(user u: lstuser)
        {
            wsrdId.add(u.WSLRNbrRouteNbr__c);
            userId.add(u.Id);
        }
        lstRoutecust=[select id,Account__c,WSLRNbrRouteNbr__c from RouteCust__c where 
                      WSLRNbrRouteNbr__c In :wsrdId]; 
        for(RouteCust__c rotcust:lstRoutecust) 
        {
           accountId.add(rotcust.Account__c);      
        }
        
        deleteMemebers =[select id from AccountTeamMember where 
                         UserId In :userId And AccountId In :accountId];
        if(!deleteMemebers.isEmpty())
        {
            try{
                delete deleteMemebers;
            }catch(Exception e){
                system.debug('Dml Exception'+ e);
            }
        
        }
    }
    
    public static void addAccountteamfromRouteCust(list<RouteCust__c> rustCust)
    {
        system.debug(rustCust);
        list<string> wsrIdList = new list<string>();
        list<user> userList = new list<user>();
        list<AccountTeamMember> members = new list<AccountTeamMember>();
        list<AccountTeamMember> deleteMemebers = new list<AccountTeamMember>();
        for(RouteCust__c rc:rustCust)
        {
            wsrIdList.add(rc.WSLRNbrRouteNbr__c);
        }
        userList =[select id,title,WSLRNbrRouteNbr__c from user where 
                   WSLRNbrRouteNbr__c In :wsrIdList];
        map<string,list<user>> userMap = new map<string,list<user>>();
        for(user ul:userList)
        {
               if(userMap.containsKey(ul.WSLRNbrRouteNbr__c))
               {
                    userMap.get(ul.WSLRNbrRouteNbr__c).add(ul); 
               }else
               {
                    list<user> userlst= new list<user>();
                    userlst.add(ul);             
                    userMap.put(ul.WSLRNbrRouteNbr__c,userlst);
               }
        
        }
        for(RouteCust__c rc:rustCust)
        {
           
             list<user> ulist = new list<user>();
             if(!userMap.isEmpty()){
                 if(userMap.get(rc.WSLRNbrRouteNbr__c) != null)
                 {
                     ulist=userMap.get(rc.WSLRNbrRouteNbr__c);
                 }
             }
             for(user u:ulist)
             {
                 AccountTeamMember acc = new AccountTeamMember();
                 acc.AccountId = rc.Account__c;
                 if(u != null)
                 {
                     acc.UserId=u.id;
                     if(u.title != '')
                         acc.TeamMemberRole=u.title;
                 }
                 members.add(acc);
             }
        }
        if(!members.isEmpty())
        {
            try{
                insert members;
            }catch(Exception e)
            {
                system.debug('Dml excpetion'+e);
            }
        
        }
    }
    
    public static void deleteAccountTeams(list<RouteCust__c> rustCust)
    {
        system.debug(rustCust);
        list<Id> accountId = new list<Id>();
        list<Id> userId = new list<Id>();
        list<user> usrList = new list<user>();
        list<string> wsrIdList = new list<string>();
        list<AccountTeamMember> deleteMemebers = new list<AccountTeamMember>();
        for(RouteCust__c rc:rustCust)
        {
            wsrIdList.add(rc.WSLRNbrRouteNbr__c);
            accountId.add(rc.Account__c);
        }
        system.debug(wsrIdList);
        system.debug(accountId);
        usrList=[select id from user where WSLRNbrRouteNbr__c In :wsrIdList]; 
        for(user u :usrList)
        {
            userId.add(u.id);
        }
        deleteMemebers =[select id from AccountTeamMember where 
                         UserId In :userId And AccountId In :accountId];
        system.debug(deleteMemebers );
        if(!deleteMemebers.isEmpty())
        {
            try
            {
                delete deleteMemebers;
            }catch(Exception e){
                system.debug('Dml Exception'+ e);
            }
        
        }
    
    
    }

}