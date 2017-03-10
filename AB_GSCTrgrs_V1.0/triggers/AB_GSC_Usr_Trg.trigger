/*Author: Bharat**********************/
/*Description: GSC Purpose - update Wholesaler_Role__c.Remote_Survey_Vendor_Enabled__c when ever User created or updated*/
/*Created Date: March 1st 2017********/
/*Test Class: AB_GSCTriggers_Test**********/

trigger AB_GSC_Usr_Trg on User (before update,before insert) {
    if(trigger.isInsert && trigger.isBefore){
        set<id> setInsRoles = new set<id>();
        for(user ur : trigger.new){
            if(ur.UserRoleId != null){
                setInsRoles.add(ur.UserRoleId);
                //ur.Remote_Survey_Vendor_Enabled__c = true;
            }
        }
        map<id,boolean> mapIRoles = new map<id,boolean>();
        if(setInsRoles != null && !setInsRoles.isEmpty()){
            list<Wholesaler_Role__c> listWRoles = [select id,Remote_Survey_Vendor_Enabled__c,Role_ID_WSLR__c from Wholesaler_Role__c];//  where Role_ID_WSLR__c in : setInsRoles
            if(listWRoles != null && !listWRoles.isEmpty()){
                for(Wholesaler_Role__c wrole : listWRoles){
                    if(wrole.Role_ID_WSLR__c != null){
                        if(wrole.Role_ID_WSLR__c.Length() == 15 || wrole.Role_ID_WSLR__c.Length() == 18)
                            mapIRoles.put(wrole.Role_ID_WSLR__c.left(15),wrole.Remote_Survey_Vendor_Enabled__c);                        
                    }
                }
            }
        }
        for(user ur : trigger.new){
            if(ur.UserRoleId != null){
                if(mapIRoles != null && mapIRoles.get(string.valueOf(ur.UserRoleId).left(15)) != null ){
                    ur.Remote_Survey_Vendor_Enabled__c = mapIRoles.get(ur.UserRoleId);
                }
                else{
                    ur.Remote_Survey_Vendor_Enabled__c = false;
                }
            }
        }
    }
    if(trigger.isUpdate && trigger.isBefore){
        set<id> setUpdRoles = new set<id>();
        for(user ur : trigger.new){            
            if(ur.UserRoleId != null){
                //user oldURole = Trigger.oldMap.get(ur.Id);
                //if(oldURole.UserRoleId != ur.UserRoleId){
                    setUpdRoles.add(ur.UserRoleId);
                    //ur.Remote_Survey_Vendor_Enabled__c = true;
                //}
            }
        }
        system.debug('setUpdRoles=='+setUpdRoles);
        map<string,boolean> mapURoles = new map<string,boolean>();
        if(setUpdRoles != null && !setUpdRoles.isEmpty()){
            
            list<Wholesaler_Role__c> listWRoles = [select id,Remote_Survey_Vendor_Enabled__c,Role_ID_WSLR__c from Wholesaler_Role__c];//  where Role_ID_WSLR__c like: setUpdRoles+'%'
            system.debug('listWRoles =='+listWRoles );
            if(listWRoles != null && !listWRoles.isEmpty()){
                for(Wholesaler_Role__c wrole : listWRoles){
                    if(wrole.Role_ID_WSLR__c != null){
                        if(wrole.Role_ID_WSLR__c.Length() == 15 || wrole.Role_ID_WSLR__c.Length() == 18)
                            mapURoles.put(string.valueOf(wrole.Role_ID_WSLR__c).left(15),wrole.Remote_Survey_Vendor_Enabled__c);                     
                    }
                }
            }
        }
        for(user ur : trigger.new){
            if(ur.UserRoleId != null){
                if(mapURoles != null && mapURoles.get(string.valueOf(ur.UserRoleId).left(15)) != null ){
                    ur.Remote_Survey_Vendor_Enabled__c = mapURoles.get(string.valueOf(ur.UserRoleId).left(15));
                }
                else{
                    ur.Remote_Survey_Vendor_Enabled__c = false;
                }
            }
        }
    }
}

/*trigger AB_GSC_Usr_Trg on User (before update) {
    set<id> setRoles = new set<id>();
    for(user ur : trigger.new){
        if(ur.UserRoleId != null){
            setRoles.add(ur.UserRoleId);
            //ur.Remote_Survey_Vendor_Enabled__c = true;
        }
    }
    list<Wholesaler_Role__c> listWRoles = new list<Wholesaler_Role__c>();
    list<Wholesaler_Role__c> lstToUpdate = new list<Wholesaler_Role__c>();
    if(setRoles != null){
        listWRoles = [select id, Role_ID_WSLR__c ,Remote_Survey_Vendor_Enabled__c from Wholesaler_Role__c where Role_ID_WSLR__c in :setRoles];
        if(listWRoles != null && !listWRoles.isEmpty()){
            for(Wholesaler_Role__c wr : listWRoles){
                wr.Remote_Survey_Vendor_Enabled__c = true;
                lstToUpdate.add(wr);
            }
        }
        update lstToUpdate;
    }
}*/