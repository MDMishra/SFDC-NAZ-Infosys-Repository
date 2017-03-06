/*Author: Bharat**********************/
/*Description: GSC Purpose - update user.Remote_Survey_Vendor_Enabled__c when ever Wholesaler_Role__c created or updated*/
/*Created Date: March 1st 2017********/
/*Test Class: AB_GSCTriggers_Test**********/

trigger AB_GSC_WsrRole_Trg on Wholesaler_Role__c (After insert,After update) {
    if(trigger.isAfter && trigger.isInsert){
        set<id> setRoles = new set<id>();
        list<user> ListUser = new list<user>();
        list<user> updateList = new list<user>();
        for(Wholesaler_Role__c wr : trigger.new){
            if(wr.Role_ID_WSLR__c != null && wr.Remote_Survey_Vendor_Enabled__c == true){
                string str = wr.Role_ID_WSLR__c;
                if(str.Length() == 15 || str.Length() == 18)
                    setRoles.add(wr.Role_ID_WSLR__c);
            }
        }
        system.debug('setRoles=='+setRoles);
        if(setRoles != null && !setRoles.isEmpty()){
            ListUser = [select id,Remote_Survey_Vendor_Enabled__c , UserRoleid from user where UserRoleid in : setRoles];
            if(ListUser != null && !ListUser .isEmpty()){
                for(user ur : ListUser){
                    ur.Remote_Survey_Vendor_Enabled__c = true;
                    updateList.add(ur);
                }
            }
            update updateList;
        }
        
    }
    if(trigger.isAfter && trigger.isUpdate){
        set<id> setOldRoles = new set<id>();
        set<id> setNewRoles = new set<id>();
        list<user> listNewUsers = new list<user>();
        list<user> listOldUsers = new list<user>();
        list<user> updateUsrs = new list<user>();
        for(Wholesaler_Role__c wr : trigger.new){
            if(wr.Role_ID_WSLR__c != null){// && wr.Remote_Survey_Vendor_Enabled__c == true
                Wholesaler_Role__c oldWRole = Trigger.oldMap.get(wr.Id);
                //setRoles.add(wr.Role_ID_WSLR__c);
                if(oldWRole.Role_ID_WSLR__c.left(15) != wr.Role_ID_WSLR__c.left(15)){
                    system.debug('not matched========');
                    if(oldWRole.Remote_Survey_Vendor_Enabled__c == true && (oldWRole.Role_ID_WSLR__c.Length() == 15 || oldWRole.Role_ID_WSLR__c.Length() == 18)){
                        setOldRoles.add(oldWRole.Role_ID_WSLR__c);
                    }
                    if(wr.Remote_Survey_Vendor_Enabled__c == true && (wr.Role_ID_WSLR__c.Length() == 15 || wr.Role_ID_WSLR__c.Length() == 18)){
                        setNewRoles.add(wr.Role_ID_WSLR__c);
                    }
                }
                system.debug('oldWRole.Role_ID_WSLR__c=='+oldWRole.Role_ID_WSLR__c);
                system.debug('wr.Role_ID_WSLR__c=='+wr.Role_ID_WSLR__c);
                if(oldWRole.Role_ID_WSLR__c.left(15) == wr.Role_ID_WSLR__c.left(15)){
                    system.debug('Matched========');
                    if(oldWRole.Remote_Survey_Vendor_Enabled__c == true && wr.Remote_Survey_Vendor_Enabled__c == false && (wr.Role_ID_WSLR__c.Length() == 15 || wr.Role_ID_WSLR__c.Length() == 18))
                        setOldRoles.add(wr.Role_ID_WSLR__c);
                    if(oldWRole.Remote_Survey_Vendor_Enabled__c == false && wr.Remote_Survey_Vendor_Enabled__c == true && (wr.Role_ID_WSLR__c.Length() == 15 || wr.Role_ID_WSLR__c.Length() == 18))
                        setNewRoles.add(wr.Role_ID_WSLR__c);
                }
            }
        }
        system.debug('setOldRoles=='+setOldRoles);
        system.debug('setNewRoles=='+setNewRoles);
        listNewUsers = [select id,Remote_Survey_Vendor_Enabled__c , UserRoleid from user where UserRoleid in : setNewRoles];
        listOldUsers = [select id,Remote_Survey_Vendor_Enabled__c , UserRoleid from user where UserRoleid in : setOldRoles];
        system.debug('listNewUsers=='+listNewUsers);
        system.debug('listOldUsers =='+listOldUsers );
        if(listNewUsers != null && !listNewUsers.isEmpty()){
            for(user u : listNewUsers){
                u.Remote_Survey_Vendor_Enabled__c = true;
                updateUsrs.add(u);
            }
        }
        if(listOldUsers != null && !listOldUsers.isEmpty()){
            for(user u : listOldUsers){
                u.Remote_Survey_Vendor_Enabled__c = false;
                updateUsrs.add(u);
            }
        }
        update updateUsrs;
        system.debug('updateUsrs=='+updateUsrs);
    }
}