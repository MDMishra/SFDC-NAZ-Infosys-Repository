/*Author: Deepthi T*/
/*Description: to populate GSC ID when EDWID changes on an account and log the id changes.*/

trigger AB_AccountUpdate on Account (before insert) 
{
    set<string> accOldPartyIds = new set<string>();
    list<PocXRef__c> insLstPocXRef = new list<PocXRef__c>();
    list<account> oldEDWIDAcc = new list<account>(); 
    map<string,account> mapAccount = new map<string,account>(); 
    if(Trigger.isInsert){
        for(Account a:Trigger.new)
        {
            if(a.OldPartyId__c != null)
            {
                accOldPartyIds.add(a.OldPartyId__c);
                //inserting PocXRef records if account OldPartyId is not null
                PocXRef__c insPoc = new PocXRef__c();
                insPoc.OldPartyId__c=a.OldPartyId__c;
                insPoc.PartyID__c= a.EDWID_US__c;
                insLstPocXRef.add(insPoc );
            }
        }
        oldEDWIDAcc =[select id,EDWID_US__c,GSC_Place_ID__c  from Account where EDWID_US__c IN :accOldPartyIds];
        
        if(!oldEDWIDAcc.isEmpty())
        {
           for(Account acc:oldEDWIDAcc) 
           {
               mapAccount.put(acc.EDWID_US__c,acc);    
               
           }
        }
        
        for(Account a:Trigger.new)
        {
            account oldAcc = new account();
            if(a.OldPartyId__c != null)
            {
                if(!mapAccount.isEmpty())
                {
                    oldAcc=mapAccount.get(a.OldPartyId__c);
                }
                if(oldAcc != null)
                {
                   if(oldAcc.GSC_Place_ID__c != null && oldAcc.GSC_Place_ID__c !='')
                   {
                       a.GSC_Place_ID__c = oldAcc.GSC_Place_ID__c;
                       a.Remote_Survey_Vendor_Enabled__c = true;   
                   }   
                }
            } 

        }
        if(!insLstPocXRef.isEmpty())
        {
            try{
                insert insLstPocXRef;
            }catch(exception e){
                system.debug('Dml Exception'+e);
            }
        }
        
        if(!oldEDWIDAcc.isEmpty())
        {
           for(Account acc:oldEDWIDAcc) 
           {
               acc.Remote_Survey_Vendor_Enabled__c = false;
               acc.GSC_Place_ID__c = null;//added according to the change req on Feb14
           }
        }
        try{
            update oldEDWIDAcc;
        }catch(exception e){
            system.debug('Dml Exception'+e);
        }
    }
}