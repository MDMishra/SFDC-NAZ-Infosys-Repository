/*
Auhtor Name : Nuvem Developer
Date        : Feb 2 2017
Description : create a user from a contact / Update user associated with contact when contact is updated
*/
public class AB_CreateUserFromContact_Handler {
    //Crerate new user with contact information
    Public Static void beforeInsert(List<Contact> lstCon){
        List<contact> lstUpdatedCon = new List<contact>(); //Updated contact information
        List<User> lstUser = new List<User>(); //users to insert
        map<string,Id> mapNickNameToConId = new map<string,Id>();
        if(lstCon != null && !lstCon.isEmpty()){
            User objUser;
            for(Contact objCon: lstCon){
                if(objCon.LastName != null && objCon.Email != null && objCon.ALIAS__c != null && objCon.NICKNAME__C != null && objCon.USERNAME__c != null && objCon.PROFILEID__c != null && objCon.TIMEZONEIDKEY__c != null && objCon.LOCALESIDKEY__c != null && objCon.EMAILENCODINGKEY__c != null && objCon.LANGUAGELOCALEKEY__c != null){
                    if(objCon.Username_Suffix__c != null && objCon.Username_Suffix__c != ''){
                        objCon.USERNAME__c= objCon.USERNAME__c+objCon.Username_Suffix__c;
                    }
                    system.debug('objCon.DEFAULTDIVISION__c=='+objCon.DEFAULTDIVISION__c);
                    objUser = new User();
                    objUser.LastName = objCon.LastName;
                    objUser.Firstname = objCon.FirstName;
                    objUser.Alias = objCon.ALIAS__c;
                    objUser.Email = objCon.Email;
                    objUser.MobilePhone = objCon.MobilePhone;
                    objUser.IsActive = objCon.ISACTIVE__c;
                    objUser.Username = objCon.USERNAME__c;
                    objUser.CommunityNickname = objCon.NICKNAME__C;
                    objUser.UserRoleId = objCon.ROLEID__c;
                    objUser.ProfileId = objCon.PROFILEID__c;
                    objUser.CompanyName = objCon.COMPANYNAME__c;
                    objUser.CurrencyIsoCode = objCon.CurrencyIsoCode;
                    objUser.DefaultDivision = objCon.DEFAULTDIVISION__c;
                    objUser.RouteKey__c = objCon.ROUTEKEY__c;
                    objUser.FederationIdentifier = objCon.FEDERATIONIDENTIFIER__c;
                    objUser.Title = objCon.Title;
                    objUser.DefaultCurrencyIsoCode = objCon.CurrencyIsoCode;
                    objUser.TimeZoneSidKey = objCon.TIMEZONEIDKEY__c;
                    objUser.LocaleSidKey = objCon.LOCALESIDKEY__c;
                    objUser.EmailEncodingKey = objCon.EMAILENCODINGKEY__c;
                    objUser.LanguageLocaleKey = objCon.LANGUAGELOCALEKEY__c;
                    lstUser.add(objUser);
                    lstUpdatedCon.add(objCon);
                }
                else{
                    objCon.addError('Required fields are missing');
                }
            }
        }
        map<integer,string> mapIndexToError = new map<integer,string>(); //To hold errors
        if(!lstUser.isEmpty()){
            Database.SaveResult[] srList;
            try{
                srList = Database.insert(lstUser, false);
            }
            catch(Exception ex){
               system.debug('@@@Ex'+ex.getMessage());
            }
            set<id> setUserId = new set<id>(); //To hold user id's
            if(srList != null){
                integer i; //To maintain errors
                string strErrorMsg;
                for (Database.SaveResult sr : srList) {
                    i = 0;
                    if (sr.isSuccess()) {
                        setUserId.add(sr.getId());
                    }
                    else{
                        // Operation failed, so get all errors     
                        strErrorMsg = '';   
                        for(Database.Error err : sr.getErrors()) {                
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            if(mapIndexToError.containsKey(i)){
                               strErrorMsg = mapIndexToError.get(i) + ';' + err.getMessage();                              
                            }
                            else{
                            strErrorMsg = err.getMessage(); 
                            }
                            mapIndexToError.put(i,strErrorMsg); 
                         }
                    }
                     i++;
                }
                if(!setUserId.isEmpty())
                for(user objUsr : [select id,CommunityNickname from user where id IN:setUserId]){
                    mapNickNameToConId.put(objUsr.CommunityNickname,objUsr.id);
                }
            }
        }
        if(!lstUpdatedCon.isEmpty()){
            integer i = 0;
            for(contact objContact : lstUpdatedCon ){
                if(mapNickNameToConId.containsKey(objContact.NICKNAME__C)){
                objContact.User__c = mapNickNameToConId.containsKey(objContact.NICKNAME__C) ? mapNickNameToConId.get(objContact.NICKNAME__C) : null;
                }
                else{
                    if(mapIndexToError.containsKey(i)){
                      objContact.addError('Error while creating user:'+mapIndexToError.get(i));
                    }
                    else{
                        objContact.addError('User not created with the given details. Please provide valid details for user creation.');
                    }
                }
               i++;
            }
        }
    }
    //Update conatct information in user
    Public Static void beforeUpdate(List<Contact> lstCon){
        Set<id> setContactID = new Set<id>();
        for(contact objCon:lstCon){
            if(objCon.LastName != null && objCon.Email != null && objCon.ALIAS__c != null && objCon.NICKNAME__C != null && objCon.USERNAME__c != null && objCon.PROFILEID__c != null && objCon.TIMEZONEIDKEY__c != null && objCon.LOCALESIDKEY__c != null && objCon.EMAILENCODINGKEY__c != null && objCon.LANGUAGELOCALEKEY__c != null && objCon.DEFAULTDIVISION__c != null){
                setContactID.add(objCon.id);
            }
            else{
                 objCon.addError('Required fields are missing');
            }
        }
        if(!setContactID.isEmpty()){
            AB_CreateUserFromContact_Handler.processContacts(setContactID);
        }
        
    }
    @future
     public static void processContacts(Set<id> conIds) {
       List<user> lstUserToUpdate= new List<user>();
       List<contact> lstCon = [select id,User__c,LastName,FirstName,ALIAS__c,Email,MobilePhone,ISACTIVE__c,DEFAULTDIVISION__c,USERNAME__c,Username_Suffix__c,NICKNAME__C,ROLEID__c,PROFILEID__c,COMPANYNAME__c,FEDERATIONIDENTIFIER__c,Title,CurrencyIsoCode,ROUTEKEY__c,TIMEZONEIDKEY__c,LOCALESIDKEY__c,EMAILENCODINGKEY__c,LANGUAGELOCALEKEY__c from contact where id IN:conIds];
       Map<ID, user> mapUser = new Map<ID, user>([select LastName,Alias,Email,Username,CommunityNickname,UserRoleId,ProfileId,CurrencyIsoCode,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,LanguageLocaleKey from user]);
       User objUser;
       for(contact objCon:lstCon){
        objUser = mapUser.get(objCon.User__c);
        objUser.LastName = objCon.LastName;
        objUser.Firstname = objCon.FirstName;
        objUser.Alias = objCon.ALIAS__c;
        objUser.Email = objCon.Email;
        objUser.MobilePhone = objCon.MobilePhone;
        objUser.IsActive = objCon.ISACTIVE__c;
        objUser.DefaultDivision = objCon.DEFAULTDIVISION__c;
        if(objCon.Username_Suffix__c != null){
            objUser.Username = objCon.USERNAME__c+objCon.Username_Suffix__c;
        }
        else{
            objUser.Username = objCon.USERNAME__c;
        }
        objUser.CommunityNickname = objCon.NICKNAME__C;
        objUser.UserRoleId = objCon.ROLEID__c;
        objUser.ProfileId = objCon.PROFILEID__c;
        objUser.CompanyName = objCon.COMPANYNAME__c;
        objUser.FederationIdentifier = objCon.FEDERATIONIDENTIFIER__c;
        objUser.Title = objCon.Title;
        objUser.DefaultCurrencyIsoCode = objCon.CurrencyIsoCode;
        objUser.CurrencyIsoCode = objCon.CurrencyIsoCode;
        objUser.RouteKey__c = objCon.ROUTEKEY__c;
        objUser.TimeZoneSidKey = objCon.TIMEZONEIDKEY__c;
        objUser.LocaleSidKey = objCon.LOCALESIDKEY__c;
        objUser.EmailEncodingKey = objCon.EMAILENCODINGKEY__c;
        objUser.LanguageLocaleKey = objCon.LANGUAGELOCALEKEY__c;
        lstUserToUpdate.add(objUser); 
       }
        if(!lstUserToUpdate.isEmpty()){
            Database.SaveResult[] srList;
            try{
                srList = Database.update(lstUserToUpdate, false);
            }
            catch(Exception ex){
               system.debug('@@@Ex'+ex.getMessage());
            }
       }
    }
}