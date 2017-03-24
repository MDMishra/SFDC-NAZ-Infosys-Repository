/*
Auhtor Name : Nuvem Developer
Date        : Feb 2 2017
Description : create a user from a contact / Update user associated with contact when contact is updated
*/

/*Test class: AB_CreateUserFromContact_Handler_Test*/

public class AB_CreateUserFromContact_Handler {
    //Crerate new user with contact information
    Public Static void beforeInsert(List<Contact> lstCon){
        set<string> setFeds = new set<string>();  
        set<id> setConIds = new set<id>();  
        set<id> setaccIds = new set<id>();
        if(lstCon != null && !lstCon.isEmpty()){
            for(Contact objCon: lstCon){
                if(objCon.AccountId != null)
                    setaccIds.add(objCon.AccountId);   
            }
        }
        map<id,Account> mapAccounts =new Map<ID, Account>([select id,WSLR_TYP_CD_US__C from Account where Id IN:setaccIds]);
        if(lstCon != null && !lstCon.isEmpty()){
            for(Contact objCon: lstCon){
                system.debug(objCon);
                string WSLR_TYP_CD_US ='';
                account acc=new account();
                if(objCon.AccountId != null)
                {
                    if(!mapAccounts.isEmpty())
                    {
                        acc=mapAccounts.get(objCon.AccountId);
                        WSLR_TYP_CD_US =acc.WSLR_TYP_CD_US__C;
                    }
                }
                if(objCon.FEDERATIONIDENTIFIER__c != null && objCon.LastName != null && objCon.Email != null && objCon.ALIAS__c != null && objCon.NICKNAME__C != null && objCon.USERNAME__c != null && objCon.PROFILEID__c != null && objCon.TIMEZONEIDKEY__c != null && objCon.LOCALESIDKEY__c != null && objCon.EMAILENCODINGKEY__c != null && objCon.LANGUAGELOCALEKEY__c != null && objCon.DEFAULTDIVISION__c != null){
                    if(WSLR_TYP_CD_US !='BB')
                    {
                        setConIds.add(objCon.id);
                        setFeds.add(objCon.FEDERATIONIDENTIFIER__c);
                    }
                    //if(objCon.FEDERATIONIDENTIFIER__c != null)
                      
                }
                else{
                    objCon.addError('Required fields are missing');
                }
            }
            if(!setFeds.isEmpty()){
                AB_CreateUserFromContact_Handler.processFedContacts(setFeds,setConIds);
            }           
        }      
    }
    
    //Update conatct information in user
    Public Static void beforeUpdate(List<Contact> lstCon){
        system.debug('lstCon=='+lstCon);
        Set<id> setContactID = new Set<id>();
        set<string> setFeds = new set<string>();
        for(contact objCon:lstCon){
            if(objCon.FEDERATIONIDENTIFIER__c != null && objCon.LastName != null && objCon.Email != null && objCon.ALIAS__c != null && objCon.NICKNAME__C != null && objCon.USERNAME__c != null && objCon.PROFILEID__c != null && objCon.TIMEZONEIDKEY__c != null && objCon.LOCALESIDKEY__c != null && objCon.EMAILENCODINGKEY__c != null && objCon.LANGUAGELOCALEKEY__c != null && objCon.DEFAULTDIVISION__c != null){
                setContactID.add(objCon.id);
                setFeds.add(objCon.FEDERATIONIDENTIFIER__c);
            }
            else{
                 objCon.addError('Required fields are missing');
            }
        }
        system.debug('setContactID=='+setContactID);
        if(!setContactID.isEmpty()){
            AB_CreateUserFromContact_Handler.processFedContacts(setFeds,setContactID);
        }
        
    }

    
    @future(callout=true)
     public static void processFedContacts(Set<string> setFeds,set<id> setConIds) {
         map<string,Id> mapNickNameToConId = new map<string,Id>();
         List<contact> lstUpdatedCon = new List<contact>(); //Updated contact information
         map<integer,string> mapIndexToError = new map<integer,string>(); //To hold errors
        map<string,user> mapFedUsers = new map<string,user>();
        list<user> ListFedusers = new list<user>();
        List<contact> lstCon = new List<contact>();
        list<user> lstUser = new list<user>();
        if(setConIds != null)
            lstCon = [select id,EMPLOYEE_NUMBER_US__c,LastName,FirstName,ALIAS__c,Email,MobilePhone,ISACTIVE__c,DEFAULTDIVISION__c,USERNAME__c,Username_Suffix__c,NICKNAME__C,ROLEID__c,PROFILEID__c,COMPANYNAME__c,FEDERATIONIDENTIFIER__c,Title,CurrencyIsoCode,ROUTEKEY__c,TIMEZONEIDKEY__c,LOCALESIDKEY__c,EMAILENCODINGKEY__c,LANGUAGELOCALEKEY__c,Username_Suffix_Global__c,WSLRNbrRouteNbr__c,WHOLESALER_NUMBER__c from contact where id IN:setConIds];
        if(setFeds != null){            
            ListFedusers = [select id,LastName,Alias,Email,FederationIdentifier,Username,CommunityNickname,UserRoleId,ProfileId,CurrencyIsoCode,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,LanguageLocaleKey from user where FederationIdentifier in :setFeds ];
            if(!ListFedusers.isEmpty()){
                for(user us : ListFedusers){
                    mapFedUsers.put(string.valueOf(us.FederationIdentifier),us);
                }
            }
        }
        system.debug(lstCon +' lstCon');
        system.debug(mapFedUsers+' mapFedUsers.');
        User objUser;
        if(lstCon != null && !lstCon.isEmpty()){
            for(Contact objCon: lstCon){
                if(objCon.Username_Suffix__c != null && objCon.Username_Suffix__c != ''){
                    objCon.USERNAME__c= objCon.USERNAME__c+objCon.Username_Suffix__c;
                }
                system.debug('objCon.DEFAULTDIVISION__c=='+objCon.DEFAULTDIVISION__c);
                objUser = new User();
                if(mapFedUsers.containsKey(objCon.FEDERATIONIDENTIFIER__c))
                    objUser.id = mapFedUsers.get(objCon.FEDERATIONIDENTIFIER__c).id;
                objUser.LastName = objCon.LastName;
                objUser.Firstname = objCon.FirstName;
                //objUser.Related_Naz_User__c = objCon.id;//stores contact id
                objUser.Alias = objCon.ALIAS__c;
                objUser.Email = objCon.Email;
                objUser.MobilePhone = objCon.MobilePhone;
                objUser.IsActive = objCon.ISACTIVE__c;
                objUser.Username = objCon.USERNAME__c;
                objUser.CommunityNickname = objCon.FEDERATIONIDENTIFIER__c;//NICKNAME__C
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
                objUser.Send_To_Global__c = true;
                objUser.WHOLESALER_NUMBER__c=objCon.WHOLESALER_NUMBER__c != null?objCon.WHOLESALER_NUMBER__c:'';
                objUser.WSLRNbrRouteNbr__c=objCon.WSLRNbrRouteNbr__c != null?objCon.WSLRNbrRouteNbr__c:'';
                /*if(objCon.WHOLESALER_NUMBER__c != null)
                    objUser.WHOLESALER_NUMBER__c = objCon.WHOLESALER_NUMBER__c;
                if(objCon.WSLRNbrRouteNbr__c != null)
                    objUser.WSLRNbrRouteNbr__c = objCon.WSLRNbrRouteNbr__c;*/
                if(objCon.Username_Suffix_Global__c != null)
                    objUser.Username_Suffix_Global__c = objCon.Username_Suffix_Global__c;
                if(objCon.EMPLOYEE_NUMBER_US__c != null)
                    objUser.EmployeeNumber = objCon.EMPLOYEE_NUMBER_US__c;
                if(objCon.Username_Suffix__c != null)    
                     objUser.Source_Suffix__c = objCon.Username_Suffix__c ;
                lstUser.add(objUser);
                lstUpdatedCon.add(objCon);
                //mapConsToUpdate.put();
            }
            system.debug('lstUser=='+lstUser);
            system.debug('lstUpdatedCon=='+lstUpdatedCon);
            /*if(!lstUser.isEmpty()){
                Database.UpsertResult[] srList;
                try{
                    srList = Database.upsert(lstUser, false);
                }
                catch(Exception ex){
                   system.debug('@@@Ex'+ex.getMessage());
                }
            }*/
            if(!lstUser.isEmpty()){
                Database.UpsertResult[] srList;
                try{
                    srList = Database.upsert(lstUser, false);
                }
                catch(Exception ex){
                   system.debug('@@@Ex'+ex.getMessage());
                }
                system.debug('srList=='+srList);
                set<id> setUserId = new set<id>(); //To hold user id's
                if(srList != null){
                    integer i; //To maintain errors
                    string strErrorMsg;
                    for (Database.UpsertResult sr : srList) {
                        i = 0;
                        if (sr.isSuccess()) {
                            setUserId.add(sr.getId());
                        }
                        /*else{
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
                        }*/
                         i++;
                    }
                    system.debug('setUserId=='+setUserId);
                    /*if(!setUserId.isEmpty())
                        ABS_UserCreation_RestAPI.createUsers(setUserId);*/
                }
            }
            //system.debug('mapNickNameToConId=='+mapNickNameToConId);
                        
        }
           
    }
    
    public static void updateAccount(list<contact> newContacts,list<contact> oldContacts,boolean isInsert)
    {
       
        set<string> wholesalerId = new set<string>();
        list<Account> lstAccount = new list<Account>();
        map<string,Account> accMap = new map<string,Account>();
        map<string,Contact> oldMapCons = new map<string,Contact>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.contact;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('NAZ User');
        if(!isInsert)
        {
            for(contact con:oldContacts)
            {
                oldMapCons.put(con.id,con);   
            }
        }
        for(Contact c:newContacts)
        {
           if(c.WHOLESALER_NUMBER__c != null && c.RecordTypeId==rtByName.getRecordTypeId())
           {
               wholesalerId.add(c.WHOLESALER_NUMBER__c);
           }
        }
        if(!wholesalerId.isEmpty())
        {
            lstAccount =[select id,name,WSLR_NBR_US__c from account where WSLR_NBR_US__c
                     IN : wholesalerId and type='wholesaler'];
        }
        if(!lstAccount.isEmpty())
        {
            for(account acc:lstAccount)
            {
                accMap.put(acc.WSLR_NBR_US__c,acc);   
            }
        }
        for(Contact c:newContacts)
        {
            if(!isInsert)
            {
                Contact oldConatct = new contact();
                oldConatct =oldMapCons.get(c.id);
                if(c.WHOLESALER_NUMBER__c != null && c.RecordTypeId==rtByName.getRecordTypeId() && oldConatct.WHOLESALER_NUMBER__c != c.WHOLESALER_NUMBER__c)
                {
                    if(!accMap.isEmpty())
                    {
                        account acc = new account();
                        acc=accMap.get(c.WHOLESALER_NUMBER__c);
                        if(acc !=null)
                        {
                            c.accountId = acc.id;
                        }else{
                            c.accountId =null;
                        }
                    
                    }else{
                            c.accountId =null;
                    }
                }
            
            }else{
                 if(c.WHOLESALER_NUMBER__c != null && c.RecordTypeId==rtByName.getRecordTypeId())
                 {
                    if(!accMap.isEmpty())
                    {
                        account acc = new account();
                        acc=accMap.get(c.WHOLESALER_NUMBER__c);
                        if(acc !=null)
                        {
                            c.accountId = acc.id;
                        }else{
                            c.accountId =null;
                        }
                    
                    }
                 
                 }
            }
        
        }
    }

}