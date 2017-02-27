/*Author: Bharat*/
/*Description: Support class fro AccountTeam Triggers.*/
/*Created date: 05/11/2016*/
/*Modification History: */
Public class AB_AccountTeam{
    
    //@future
    public static void addAccountTeam(set<id> userIds)
    {
        list<EntitySubscription> listEntitySub = new List<EntitySubscription>();//holds records to follow
        set<EntitySubscription> setEntitySub = new set<EntitySubscription>();//holds records to follow
        list<string> wsrdId = new list<string>();
        list<string> wsrNmbrs = new list<string>();//holds wholesaler numbers of the users
        list<RouteCust__c> lstRoutecust = new list<RouteCust__c>();
        list<AccountTeamMember> members = new list<AccountTeamMember>();
        list<Account> WholesalerAccountList = new list<Account>();//holds all accounts which are matched with users Wholesaler number
        list<user> lstuser = new list<user>();
        map<string,list<id>> mapAccountId = new map<string,list<id>>();
        map<string,list<id>> mapWslrAccountId = new map<string,list<id>>();//holds wholer number and list of accountids
        list<EntitySubscription> deleteSub= new list<EntitySubscription>();
        set<id> uniqIds = new set<id>();
        map<id,EntitySubscription> mapSubscription = new map<id,EntitySubscription>();
        set<id> uniqUserids = new set<id>();
        lstuser =[select Wholesaler_Number__c,WSLRNbrRouteNbr__c,id,title,IsActive from user where Id in :userIds];
        
        for(user u: lstuser)
        {
            if(u.WSLRNbrRouteNbr__c != '' && u.WSLRNbrRouteNbr__c != null)
                wsrdId.add(u.WSLRNbrRouteNbr__c);
            if(u.Wholesaler_Number__c != '' && u.Wholesaler_Number__c != null)
                wsrNmbrs.add(u.Wholesaler_Number__c);
        }
        
        if(wsrdId != null && !wsrdId.isEmpty())
        {
            lstRoutecust=[select id,Account__c,WSLRNbrRouteNbr__c from RouteCust__c where 
                          WSLRNbrRouteNbr__c In :wsrdId and Account__c != null and WSLRNbrRouteNbr__c != null];
        }
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
            WholesalerAccountList = [select id,WSLR_NBR_US__c from account where WSLR_NBR_US__c in :wsrNmbrs and recordtype.name = 'Wholesaler' and WSLR_NBR_US__c != null];
        
        for(Account acc:WholesalerAccountList)
        {
            
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
        
        // HE trigger code 
        
        List<CollaborationGroup> chatterGroupList = new List<CollaborationGroup>();
        chatterGroupList = [SELECT id, InformationTitle FROM   CollaborationGroup Order By Name];
         List<CollaborationGroupMember> groupMemberList = new List<CollaborationGroupMember>();                        
                              
        
        for(user u: lstuser) 
        {
            uniqUserids.add(u.id);
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
            uniqIds.addAll(AccountsToFollow);
            // Adding follow and Unfollow
            if(!AccountsToFollow.isEmpty() && u.IsActive){
                for(id acc:uniqIds){
                    EntitySubscription follow = new EntitySubscription(parentId = acc, subscriberid =u.id);
                    setEntitySub.add(follow);
                    mapSubscription.put(acc,follow);
                }
            }
            system.debug(mapSubscription);
            listEntitySub.addALL(mapSubscription.Values());
            system.debug(listEntitySub);
            
            // Adding of Team Members
            if(!accountIds.isEmpty() && u.IsActive)
            {
                for(id accId:accountIds)
                {
                    AccountTeamMember acc = new AccountTeamMember();
                    acc.AccountId = accId;
                    acc.UserId=u.id;
                    acc.AccountAccessLevel = 'Edit';
                    if(u.title != '')
                        acc.TeamMemberRole=u.title;
                    
                    members.add(acc);
                }
            }
            if(u.IsActive)
            {
                if(u.Wholesaler_Number__c != null) 
                {
                    for(CollaborationGroup chatterGroup: chatterGroupList)
                    {
                    system.debug(chatterGroup);
                        if(!string.isBlank(chatterGroup.InformationTitle) && chatterGroup.InformationTitle.contains('WSLR'+u.Wholesaler_Number__c)) 
                        {
                            system.debug('Entered in contains.');
                            CollaborationGroupMember member = new CollaborationGroupMember(CollaborationGroupId=chatterGroup.Id, MemberId = u.Id);
                            groupMemberList.add(member);
                        }
                    }
                }
             }
        } 
        system.debug(deleteSub);
        deleteSub=[SELECT Id FROM EntitySubscription where ParentId in :uniqIds and SubscriberId in: uniqUserids and parentid != null]; 
        if(!deleteSub.isEmpty())
        {
            try
            {
                delete deleteSub;
            }
            catch(Exception e)
            {
                system.debug('Dml Exception'+e);               
            }
        }
        
        system.debug(listEntitySub);
        if(!listEntitySub.isEmpty())
        {
            try
            {
                insert listEntitySub;
                mapSubscription.clear();
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
        if(!groupMemberList.isEmpty()){
            system.debug('size' + groupMemberList.size());
            try{
                insert groupMemberList;      
            }
            catch(Exception e){
            }
        }
    
    }
    
   
    
    public static void addAccountteamfromRouteCust(list<RouteCust__c> rustCust)
    {
        list<string> wsrIdList = new list<string>();
        list<user> userList = new list<user>();
        list<AccountTeamMember> members = new list<AccountTeamMember>();
        list<AccountTeamMember> deleteMemebers = new list<AccountTeamMember>();
        for(RouteCust__c rc:rustCust)
        {
            //if()
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
                         UserId In :userId And AccountId In :accountId and UserId != null and AccountId != null];
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
    
    Public static void deletefollow(set<id> userId)
    {
        list<EntitySubscription> deleteSub= new list<EntitySubscription>();
        deleteSub=[SELECT Id FROM EntitySubscription where SubscriberId in: userId and SubscriberId !=null]; 
        system.debug(deleteSub);
        if(!deleteSub.isEmpty())
        {
            try
            {
                delete deleteSub;
            }
            catch(Exception e)
            {
                system.debug('Dml Exception'+e);               
            }
        }
    
    }
    
    Public static void deleteAccountTeam(set<id> userId)
    {
    
        list<AccountTeamMember> deleteMemebers = new list<AccountTeamMember>();
        deleteMemebers =[select id from AccountTeamMember where 
                         UserId In :userId and UserId != null ];
                         
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