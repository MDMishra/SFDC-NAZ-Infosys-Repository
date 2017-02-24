/*Author: Deepthi*/
trigger ONTAP_OrderTrigger_TapwiserUpate on ONTAP__Order__c (before insert,before update)
{
    set<string> wslrId = new set<string>();
    list<RouteCust__c> routeCustlst = new list<RouteCust__c>();
    map<string,RouteCust__c> mapWslrId = new map<string,RouteCust__c>();
    Schema.DescribeSObjectResult d = Schema.SObjectType.ONTAP__Order__c;
    Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
    Schema.RecordTypeInfo rtByName =  rtMapByName.get('RAS');
    system.debug(rtByName.getRecordTypeId());
    list<account> updateAccount = new list<account>();
    set<string> setCusts = new set<string>();
    /*start : added later - to make tapwiser is true if inserted or updated order.RAS_OrderSource__c = tapwiser and any account.WSLR_ASGND_CUST_NBR_US__c  = order.RAS_CustID__c*/
    if(trigger.isupdate && trigger.isbefore){
        for(ONTAP__Order__c OnTap:trigger.new)
        {
            if(OnTap.RAS_CustID__c != null && OnTap.RAS_OrderSource__c != null && OnTap.RAS_OrderSource__c.equalsIgnoreCase('Tapwiser')){
                setCusts.add(OnTap.RAS_CustID__c);
            }
            list<account> accList = new list<account>();
            if(setCusts != null){
                accList = [select id,WSLR_ASGND_CUST_NBR_US__c,Tapwiser__c from account where WSLR_ASGND_CUST_NBR_US__c in: setCusts];
                if(accList != null && !accList.isEmpty()){
                    for(account acc : accList){
                        acc.Tapwiser__c = true;
                        updateAccount.add(acc);
                    }
                }
            }
        }
        
        if(!updateAccount.isEmpty())
        {
            try{
                update updateAccount;
            }catch(Exception e){
                system.debug('Dml Exception'+e);
            }
        }
    }
    /*end : added later*/
    if(trigger.isInsert && trigger.isbefore)
    {
        
        for(ONTAP__Order__c OnTap:trigger.new)
        {
            if(OnTap.RAS_CustID__c != null && OnTap.RAS_OrderSource__c != null && OnTap.RAS_OrderSource__c.equalsIgnoreCase('Tapwiser')){
                setCusts.add(OnTap.RAS_CustID__c);
            }
            if(OnTap.RecordTypeId==rtByName.getRecordTypeId()){
            if(OnTap.RAS_WSLRNbrCustIDRouteNbr__c !=null)
            {
               wslrId.add(OnTap.RAS_WSLRNbrCustIDRouteNbr__c);
             }
               /*start: changing owner id to sub user*/
               if(userinfo.getuserroleid() != null){
                    userrole ur2 = [select id, userrole.name from userrole where ParentRoleID =: userinfo.getuserroleid() limit 1];
                    system.debug(ur2);
                    user u = [select id,userroleid from user where userroleid =: ur2.id limit 1];
                    system.debug(u);
                    if(u != null)
                        OnTap.ownerid = u.id;
               }
                /*end: changing owner id to sub role user*/
            }
        }
        /*start : added later - to make tapwiser is true if inserted or updated order.RAS_OrderSource__c = tapwiser and any account.WSLR_ASGND_CUST_NBR_US__c  = order.RAS_CustID__c****/
        list<account> accList = new list<account>();
        if(setCusts != null){
            accList = [select id,WSLR_ASGND_CUST_NBR_US__c,Tapwiser__c from account where WSLR_ASGND_CUST_NBR_US__c in: setCusts];
            if(accList != null && !accList.isEmpty()){
                for(account acc : accList){
                    acc.Tapwiser__c = true;
                    updateAccount.add(acc);
                }
            }
        }
        /*end: added later***************************************/
        system.debug(wslrId);
        routeCustlst =[select id,WSLRNbrCustIDRouteNbr__c,Account__c,
                       Account__r.tapwiser__c from RouteCust__c 
                       where WSLRNbrCustIDRouteNbr__c In :wslrId];
                       
        system.debug(routeCustlst );
        for(RouteCust__c r:routeCustlst)
        {
            mapWslrId.put(r.WSLRNbrCustIDRouteNbr__c,r);
        }
        system.debug(mapWslrId);
        for(ONTAP__Order__c OnTap:trigger.new)
        {
            if(OnTap.RecordTypeId==rtByName.getRecordTypeId() && OnTap.RAS_WSLRNbrCustIDRouteNbr__c !=null){
                if(!mapWslrId.isEmpty()){
                    RouteCust__c rutCust =new RouteCust__c();
                    if(mapWslrId.get(OnTap.RAS_WSLRNbrCustIDRouteNbr__c) != null)
                        rutCust=mapWslrId.get(OnTap.RAS_WSLRNbrCustIDRouteNbr__c);
                    if(rutCust != null){
                        system.debug(rutCust.Account__c);
                        OnTap.ONTAP__OrderAccount__c=rutCust.Account__c;
                        if(OnTap.RAS_OrderSource__c != null){
                            system.debug('OnTap.RAS_OrderSource__c != null=='+OnTap.RAS_OrderSource__c);
                            if(rutCust.Account__r.tapwiser__c==false && OnTap.RAS_OrderSource__c.equalsIgnoreCase('TapWiser'))//OnTap.RAS_OrderSource__c =='TapWiser'
                            {
                                system.debug(rutCust.Account__c);
                                Account acc = new Account();
                                acc.id=rutCust.Account__c;
                                acc.tapwiser__c=true;
                                updateAccount.add(acc);
                            }
                        }
                    }
                }
            }
        
        }
        if(!updateAccount.isEmpty())
        {
            try{
                update updateAccount;
            }catch(Exception e){
                system.debug('Dml Exception'+e);
            }
        }
                           
    }
}