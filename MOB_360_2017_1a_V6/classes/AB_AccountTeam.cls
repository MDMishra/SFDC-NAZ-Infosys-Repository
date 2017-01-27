/*Author: Bharat*/
/*Description: Support class fro AccountTeam Triggers.*/
/*Created date: 05/11/2016*/
/*Modification History: */
Public class AB_AccountTeam{
    
    @future
    public static void addAccountTeam(list<id> userIds)
    {
        List<EntitySubscription> listEntitySub = new List<EntitySubscription>();//holds records to follow
        list<string> wsrdId = new list<string>();
        list<string> wsrNmbrs = new list<string>();//holds wholesaler numbers of the users
        list<RouteCust__c> lstRoutecust = new list<RouteCust__c>();
        list<AccountTeamMember> members = new list<AccountTeamMember>();
        list<Account> WholesalerAccountList = new list<Account>();//holds all accounts which are matched with users Wholesaler number
        list<user> lstuser = new list<user>();
        lstuser =[select Wholesaler_Number__c,WSLRNbrRouteNbr__c,id,title from user where Id in :userIds];
        for(user u: lstuser)
        {
            if(u.WSLRNbrRouteNbr__c != '' && u.WSLRNbrRouteNbr__c != null)
                wsrdId.add(u.WSLRNbrRouteNbr__c);
            if(u.Wholesaler_Number__c != '' && u.Wholesaler_Number__c != null)
                wsrNmbrs.add(u.Wholesaler_Number__c);
        }
        if(wsrdId != null && !wsrdId.isEmpty())
            lstRoutecust=[select id,Account__c,WSLRNbrRouteNbr__c from RouteCust__c where 
                      WSLRNbrRouteNbr__c In :wsrdId and Account__c != null];
        //system.debug(lstRoutecust);            
        map<string,list<id>> mapAccountId = new map<string,list<id>>();
        map<string,list<id>> mapWslrAccountId = new map<string,list<id>>();//holds wholer number and list of accountids
        
        
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
        
        
        /*start: to get wholesaler account to follow by user*/
        if(wsrNmbrs != null && !wsrNmbrs.isEmpty())
            WholesalerAccountList = [select id,WSLR_NBR_US__c from account where WSLR_NBR_US__c in :wsrNmbrs and recordtype.name = 'Wholesaler' ];
        for(Account acc:WholesalerAccountList){
            
            if(mapWslrAccountId.containsKey(acc.WSLR_NBR_US__c))
            {
                mapWslrAccountId.get(acc.WSLR_NBR_US__c).add(acc.id); 
                       
            }else
            {
                list<id> WslraccIds = new list<id>();
                WslraccIds.add(acc.id);             
                mapWslrAccountId.put(acc.WSLR_NBR_US__c,WslraccIds);
            }
        }
        /*stop to get wholesaler account to follow by user*/
        
        //system.debug(mapWslrAccountId);
        //system.debug(mapAccountId);
        for(user u: lstuser) 
        {
            list<id> accountIds = new list<id>();
            list<id> WslraccountIds = new list<id>();
            list<id> AccountsToFollow = new list<id>();
            if(!mapAccountId.isEmpty())
            {
                if(mapAccountId.get(u.WSLRNbrRouteNbr__c) != null)
                {
                    accountIds=mapAccountId.get(u.WSLRNbrRouteNbr__c);
                    AccountsToFollow = mapAccountId.get(u.WSLRNbrRouteNbr__c);
                }
                
            }
            
            /* Start: To follow a record by user */
            if(!mapWslrAccountId.isEmpty()){
                if(mapWslrAccountId.get(u.Wholesaler_Number__c) != null)
                {
                    WslraccountIds=mapWslrAccountId.get(u.Wholesaler_Number__c);
                }
            }
            AccountsToFollow.addAll(WslraccountIds);
            if(!AccountsToFollow.isEmpty()){
                for(id acc:AccountsToFollow){
                    EntitySubscription follow = new EntitySubscription(parentId = acc, subscriberid =u.id);
                    listEntitySub.add(follow);
                }
            }
            
            /* Stop: To follow a record by user */
            
            /*if(accountIds != null && !accountIds.isEmpty())
                accountIds.addAll(WslraccountIds);
            else
                accountIds = WslraccountIds;*/
                
            if(!accountIds.isEmpty())
            {
                for(id accId:accountIds)
                {
                    AccountTeamMember acc = new AccountTeamMember();
                    acc.AccountId = accId;
                    acc.UserId=u.id;
                    acc.AccountAccessLevel = 'Edit';
                    if(u.title != '')
                        acc.TeamMemberRole=u.title;
                    /*if(!test.isrunningTest())
                        ConnectApi.ChatterUsers.follow(null, u.id, accId);//to follow an account*/
                    members.add(acc);
                }
            }
            //system.debug(members);
        } 
        if(!listEntitySub.isEmpty())
        {
            try
            {
                insert listEntitySub;
            }
            catch(Exception e)
            {
                system.debug('Dml Exception'+e);               
            }
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
        List<EntitySubscription> listEntityUnfollows = new List<EntitySubscription>();//holds records to unfollow
        list<string> wsrdId = new list<string>();
        list<string> wsrNmbrs = new list<string>();
        list<Id> accountId = new list<Id>();
        list<Id> userId = new list<Id>();
        list<RouteCust__c> lstRoutecust = new list<RouteCust__c>();
        list<AccountTeamMember> deleteMemebers = new list<AccountTeamMember>();
        list<EntitySubscription> unFollowMembers = new list<EntitySubscription>();
        list<Account> ListunFollowAcc = new list<Account>();//holds accounts to unfollow
        for(user u: lstuser)
        {
            wsrdId.add(u.WSLRNbrRouteNbr__c);
            userId.add(u.Id);
            if(u.Wholesaler_Number__c != null && u.Wholesaler_Number__c != '')
                wsrNmbrs.add(u.Wholesaler_Number__c);
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
        /*start: to unfollow an account*/
        if(wsrNmbrs != null && !wsrNmbrs.isEmpty()){
            system.debug('accountId=='+accountId);
            
            /*Batch class call due to override 2000000 acoount records count*/
            Database.executeBatch(new AB_SearchAndReplace_Batch(wsrNmbrs,userId),200);
            
            /* code comented to override 2000000 record count limit*/
            
            /*ListunFollowAcc = [select id from account where WSLR_NBR_US__c in :wsrNmbrs];
            for(account acct : ListunFollowAcc){
                accountId.add(acct.id);
            }   */
        }
        unFollowMembers = [select id, parentid from EntitySubscription where parentid in :accountId and SubscriberId in: userId];       
        
        try{
            if(!unFollowMembers.isEmpty()){
                /*for(EntitySubscription eSub : unFollowMembers){
                    if(!test.isrunningTest())
                        ConnectApi.Chatter.deleteSubscription(null, eSub.id);
                }*/
                delete unFollowMembers;
            }
            
        }
        catch(Exception e){
            system.debug('Dml Exception'+ e);
        }
        /*Stop: to unfollow an account*/
    }
    
    public static void addAccountteamfromRouteCust(list<RouteCust__c> rustCust)
    {
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
        usrList=[select id from user where WSLRNbrRouteNbr__c In :wsrIdList]; 
        for(user u :usrList)
        {
            userId.add(u.id);
        }
        deleteMemebers =[select id from AccountTeamMember where 
                         UserId In :userId And AccountId In :accountId];
        //system.debug(deleteMemebers );
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