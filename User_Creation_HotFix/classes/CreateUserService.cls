@RestResource(urlMapping='/CreateUserService/*')
global class CreateUserService
{ 
    
    public static string ERROR=''; 
    public static string SUCCESS='Scucessful';

    @HttpPut
    global static string doPut()
    {
         string sucMessage='Scucessful';
         set<string> userNameList= new set<string>();
         set<string> existingcontacts = new set<string>();
         set<string> fredrationId = new set<string>();

         list<user> newInsertUser = new list<user>();
         list<User> existingUsers = new list<User>();
         list<user> lstusers = new list<user>();
         list<Contact> lstcontact = new list<Contact>();
         list<user> updateUser = new list<user>();
         list<contact> updateContact= new list<contact>();
         list<contact> existingContact = new list<contact>();
         list<Account> accountList=new list<Account>();

         map<string,user> existingUsersMap= new map<string,user>();
         map<string,string> conUser = new map<string,string>();
         map<string,string> conUserExisting = new map<string,string>();
         map<string,contact> mapInsContact=new map<string,contact>();
         map<string,contact> contactmap = new map<string,contact>();
         map<string,user> usermap = new map<string,user>();
         map<string,user> insertUserMap = new map<string,user>();
         map<string,user> incomUser = new map<string,user>();
         map<string,contact> exitingContacts = new map<string,contact>();
         map<String,user> mapConatct = new  map<String,user>();       

         
         // Query to reterive Profile
         list<Profile> profileList=[select id,name from profile where name=:label.AB_UserCreation_Profile limit 1];
         System.debug('profileList'+profileList);
         accountList=[select id,name from account where name=:label.AB_Community_Account limit 1];
         system.debug('accountList==='+accountList);
         // desearilze json
         RestRequest req = RestContext.request;
         Blob body = req.requestBody;
         String bodyString = body.toString();
         system.debug(req );
         AB_UserJsonParser insJson=AB_UserJsonParser.parse(bodyString);
         //system.debug(jsonString);
         system.debug(insJson);
         
         for(integer i=0;i<insJson.objUser.size();i++)
         {
            User newUser = new User();
            if(insJson.objUser[i].Username != null) newUser.Username = insJson.objUser[i].Username;
            if(insJson.objUser[i].Username_Suffix_Global !=null) newUser.Username_Suffix_Global__c=insJson.objUser[i].Username_Suffix_Global;
            if(insJson.objUser[i].Lastname != null) newUser.Lastname = insJson.objUser[i].Lastname;
            if(insJson.objUser[i].Firstname != null) newUser.Firstname = insJson.objUser[i].Firstname;
            if(insJson.objUser[i].Email != null) newUser.Email = insJson.objUser[i].Email;
            if(insJson.objUser[i].Alias != null) newUser.Alias = insJson.objUser[i].Alias;
            if(insJson.objUser[i].CommunityNickname != null) newUser.CommunityNickname = insJson.objUser[i].CommunityNickname;
            //if(insJson.objUser[i].IsActive != null) newUser.IsActive = insJson.objUser[i].IsActive;
            if(insJson.objUser[i].TimeZoneSidKey != null) newUser.TimeZoneSidKey = insJson.objUser[i].TimeZoneSidKey;
            newUser.ProfileId = profileList.get(0).Id;
            if(insJson.objUser[i].LocaleSidKey != null) newUser.LocaleSidKey = insJson.objUser[i].LocaleSidKey;
            if(insJson.objUser[i].EmailEncodingKey != null) newUser.EmailEncodingKey = insJson.objUser[i].EmailEncodingKey;
            if(insJson.objUser[i].LanguageLocaleKey != null) newUser.LanguageLocaleKey = insJson.objUser[i].LanguageLocaleKey;
            //if(insJson.objUser[i].UserPreferencesDisableAutoSubForFeeds != null) newUser.UserPreferencesDisableAutoSubForFeeds = insJson.objUser[i].UserPreferencesDisableAutoSubForFeeds;
            //if(insJson.objUser[i].UserPermissionsMobileUser != null)  newUser.UserPermissionsMobileUser = insJson.objUser[i].UserPermissionsMobileUser;
            if(insJson.objUser[i].FederationIdentifier != null) newUser.FederationIdentifier = insJson.objUser[i].FederationIdentifier;
            if(insJson.objUser[i].Title != null)    newUser.Title = insJson.objUser[i].Title;
            if(insJson.objUser[i].City != null) newUser.City = insJson.objUser[i].City;
            if(insJson.objUser[i].MobilePhone != null)   newUser.MobilePhone = insJson.objUser[i].MobilePhone;
            if(insJson.objUser[i].PostalCode != null)   newUser.PostalCode = insJson.objUser[i].PostalCode;
            if(insJson.objUser[i].State != null)    newUser.State = insJson.objUser[i].State;
            if(insJson.objUser[i].Phone != null)    newUser.Phone = insJson.objUser[i].Phone;
            if(insJson.objUser[i].Fax != null)  newUser.Fax = insJson.objUser[i].Fax;
            if(insJson.objUser[i].Street != null)   newUser.Street = insJson.objUser[i].Street;
            if(insJson.objUser[i].country!= null)   newUser.country= insJson.objUser[i].country;
            if(insJson.objUser[i].CompanyName!= null) newUser.CompanyName= insJson.objUser[i].CompanyName;
            if(insJson.objUser[i].Department != null) newUser.Department = insJson.objUser[i].Department;
            if(insJson.objUser[i].WSLRNbrRouteNbr!= null) newUser.WSLRNbrRouteNbr__c= insJson.objUser[i].WSLRNbrRouteNbr;
            if(insJson.objUser[i].Source_Suffix != null) newUser.Source_Suffix__c= insJson.objUser[i].Source_Suffix;
            lstusers.add(newUser);
            system.debug(newUser);
            usermap.put(insJson.objUser[i].FederationIdentifier,newUser);
            if(insJson.objUser[i].FederationIdentifier != null)
                userNameList.add(insJson.objUser[i].FederationIdentifier);
            system.debug(userNameList);
            conUser.put(insJson.objUser[i].Username,insJson.objUser[i].FederationIdentifier);
            system.debug(conUser);
            incomUser.put(insJson.objUser[i].Username,newUser);
            system.debug(incomUser);

         }
         
         for(integer j=0;j<insJson.objContact.size();j++)
         {
            contact newCon = new contact();
            if(insJson.objContact[j].Phone!= null) newCon.phone= insJson.objContact[j].phone;
            if(insJson.objContact[j].LastName!= null) newCon .Lastname = insJson.objContact[j].Lastname;
            if(insJson.objContact[j].Firstname != null) newCon .Firstname = insJson.objContact[j].Firstname;
            //if(insJson.objContact[j].Id != null) newCon .Email = insJson.objContact[j].id;
            if(insJson.objContact[j].FEDERATIONIDENTIFIER!= null) newCon.FEDERATIONIDENTIFIER__c= insJson.objContact[j].FEDERATIONIDENTIFIER;
            if(insJson.objContact[j].FEDERATIONIDENTIFIER!= null)
                contactmap.put(insJson.objContact[j].FEDERATIONIDENTIFIER,newCon); 
            system.debug(contactmap);  
            
         }
         if(!userNameList.isEmpty())
         {
             existingUsers = [SELECT FederationIdentifier,Id,Username,LastName,FirstName,Email,Alias,Fax,  
                              CommunityNickname,IsActive,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,City, 
                              LanguageLocaleKey,UserPreferencesDisableAutoSubForFeeds,phone,contactId, 
                              UserPermissionsMobileUser,Title,MobilePhone,PostalCode,State,Street,ProfileId,
                              CompanyName,Department,Username_Suffix_Global__c FROM User WHERE FederationIdentifier 
                              IN :userNameList and FederationIdentifier !=null];
         
         }
        
         if(!existingUsers.isEmpty())
         {
             for(user u:existingUsers)
             {
                 existingUsersMap.put(u.FederationIdentifier,u);
                 system.debug(existingUsersMap);
                 existingcontacts.add(u.contactId);
                 conUserExisting.put(u.username,u.FederationIdentifier);
             }
             
         }
         for(integer j=0;j<insJson.objContact.size();j++)
        {
            contact newCon = new contact();
            if(insJson.objContact[j].Phone!= null) newCon.phone= insJson.objContact[j].phone;
            if(insJson.objContact[j].LastName!= null) newCon .Lastname = insJson.objContact[j].Lastname;
            if(insJson.objContact[j].Firstname != null) newCon .Firstname = insJson.objContact[j].Firstname;
            if(insJson.objContact[j].FEDERATIONIDENTIFIER!= null) newCon.FEDERATIONIDENTIFIER__c= insJson.objContact[j].FEDERATIONIDENTIFIER;
            contactmap.put(insJson.objContact[j].FEDERATIONIDENTIFIER,newCon);  
            if(insJson.objContact[j].FEDERATIONIDENTIFIER!= null)
                fredrationId.add(insJson.objContact[j].FEDERATIONIDENTIFIER); 
         }
         if(!fredrationId.isEmpty()){
         
             existingContact =[SELECT id,Name,Email,FirstName,LastName,Phone,FEDERATIONIDENTIFIER__c from contact 
                               where FEDERATIONIDENTIFIER__c IN :fredrationId and FEDERATIONIDENTIFIER__c !=null];
            
         }
         if(!existingcontact.isEmpty())
         {
             for(contact c:existingcontact)
             {
                 exitingContacts.put(c.FEDERATIONIDENTIFIER__c,c);   
             }
         }
         for(contact c:contactmap.values())
         {
             if(exitingContacts.containsKey(c.FEDERATIONIDENTIFIER__c))
             {
                 updateContact.add(c);
             }
         }
        System.debug('Conuser =====> '+ conUser);
        System.debug('Contact Map ====>  '+contactmap);
         for(user u:lstusers)
         {
            if(existingUsersMap.containsKey(u.FederationIdentifier)){
                user updUser = new  user();
                user existUser = new user();
                updUser=incomUser.get(u.username);   
                existUser=existingUsersMap.get(u.FederationIdentifier);
                string id=existUser.id;
                existUser=updUser;
                existUser.id=id;
                String myString1 = u.username;
                String myString2 = 'com';
                Integer result = myString1.indexOf(mystring2);
                system.debug(result);
                string subStrings=myString1.substring(0,result+3);
                system.debug(subStrings);
                //existUser.username=subStrings+label.AB_User_Suffix;
                if(u.Username_Suffix_Global__c ==null)
                {
                    existUser.username=u.email+label.AB_User_Suffix;
                }else{
                    existUser.username=u.email+u.Username_Suffix_Global__c; 
                }
                //existUser.username=u.username.RemoveEnd(u.Source_Suffix__c)+u.Username_Suffix_Global__c;
                //existUser.contactId=conUserExisting.get(u.username);
                updateUser.add(existUser);
            }
            else{
                contact conIns = new contact(); 
                 
                if(!conUser.isEmpty())
                {
                    string contactId = conUser.get(u.username);
                    string myString1 = u.username;
                    String myString2 = 'com';
                    Integer result = myString1.indexOf(mystring2);
                    system.debug(result);
                    string subStrings=myString1.substring(0,result+3);
                    system.debug(subStrings);
                    u.username=subStrings+label.AB_User_Suffix;
                    insertUserMap.put(u.username,u);
                    system.debug(contactId);
                    system.debug('insertUserMap'+insertUserMap);
                    //u.username=u.username.RemoveEnd(u.Source_Suffix__c)+u.Username_Suffix_Global__c;
                    //insertUserMap.put(u.username+u.Username_Suffix_Global__c,u); 
                    if(!contactmap.isEmpty())
                        conIns =contactmap.get(contactId);
                        system.debug(conIns);
                        if(conIns !=null)
                        {
                            if(!accountList.isEmpty() && accountList[0] !=null)
                            {
                                if(accountList[0].id !=null)
                                    conIns.AccountId=accountList[0].id;
                            }
                            mapInsContact.put(u.username,conIns);
                            system.debug(mapInsContact);
                         }
                }
                system.debug(insertUserMap); 
            } 
             
         }
         RestResponse res = RestContext.response;
         Savepoint sp = Database.setSavepoint();

         try{
             if(!mapInsContact.isEmpty())
             {
                 insert mapInsContact.values();
                 system.debug(mapInsContact.values());
                 res.statusCode = 200;
             }
         }catch(Exception e){
             system.debug('Dml exception'+e);
             error=string.valueof(e);
             res.statusCode = 500;
             Database.rollback(sp);
             return error;
         }
         
         if(!insertUserMap.isEmpty())
         {
             for(user u:insertUserMap.values())
             {
                 contact insCon= new contact();
                 insCon=mapInsContact.get(u.username);
                 u.contactId=insCon.Id;
                 if(u.Username_Suffix_Global__c ==null)
                 {
                    u.username=u.email+label.AB_User_Suffix;
                 }else{
                    u.username=u.email+u.Username_Suffix_Global__c; 
                 }
                 Database.DMLOptions dlo = new Database.DMLOptions();
                 dlo.EmailHeader.triggerUserEmail = true;
                 dlo.EmailHeader.triggerAutoResponseEmail= true;
                 u.setOptions(dlo);  
                 newInsertUser.add(u);
             }  
         }
         system.debug(newInsertUser);
         if(!newInsertUser.isEmpty())
         {
             try{
                 insert newInsertUser;
                 system.debug(newInsertUser);
                 res.statusCode = 200;
             }
             catch(Exception e){
                 system.debug('Dml exception'+e);
                 error=string.valueof(e);
                 res.statusCode = 500;
                 Database.rollback(sp);
                 return error;
             }
         }
         if(!updateContact.isEmpty())
         {
             insContact(bodyString);  
         } 
         if(!updateUser.isEmpty()){
             try{
                 update updateUser;
                 system.debug(updateUser);
                 res.statusCode = 200;
             }catch(Exception e){
                 system.debug('Dml exception'+e);
                 error=string.valueof(e);
                 res.statusCode = 500;
                 Database.rollback(sp);
                 return error;

             }
         } 
           
         if(error==''){
             
             return sucMessage;
         }
         return null;
    }
    
    @future
    public static void insContact(string Json){
    
        AB_UserJsonParser insJson=AB_UserJsonParser.parse(Json);
        map<string,contact> contactmap = new map<string,contact>();
        list<contact> existingContact = new list<contact>();
        set<string> fredrationId = new set<string>();
        map<string,contact> exitingContacts = new map<string,contact>();
        list<contact> updateContact = new list<contact>();
       
        for(integer j=0;j<insJson.objContact.size();j++)
        {
            contact newCon = new contact();
            if(insJson.objContact[j].Phone!= null) newCon.phone= insJson.objContact[j].phone;
            if(insJson.objContact[j].LastName!= null) newCon .Lastname = insJson.objContact[j].Lastname;
            if(insJson.objContact[j].Firstname != null) newCon .Firstname = insJson.objContact[j].Firstname;
            if(insJson.objContact[j].FEDERATIONIDENTIFIER!= null) newCon.FEDERATIONIDENTIFIER__c= insJson.objContact[j].FEDERATIONIDENTIFIER;
            contactmap.put(insJson.objContact[j].FEDERATIONIDENTIFIER,newCon);  
            if(insJson.objContact[j].FEDERATIONIDENTIFIER!= null)
                fredrationId.add(insJson.objContact[j].FEDERATIONIDENTIFIER); 
         }
         if(!fredrationId.isEmpty()){
         
             existingContact =[SELECT id,Name,Email,FirstName,LastName,Phone,FEDERATIONIDENTIFIER__c from contact 
                               where FEDERATIONIDENTIFIER__c IN :fredrationId and FEDERATIONIDENTIFIER__c != null];
            
         }
         if(!existingcontact.isEmpty())
         {
             for(contact c:existingcontact)
             {
                 exitingContacts.put(c.FEDERATIONIDENTIFIER__c,c);   
             }
         }
         for(contact c:contactmap.values())
         {
             if(exitingContacts.containsKey(c.FEDERATIONIDENTIFIER__c))
             {
                contact existCon = new contact ();
                existCon =exitingContacts.get(c.FEDERATIONIDENTIFIER__c);
                c.id=existCon.id;
                updateContact.add(c);
             }
         }
         if(!updateContact.isEmpty())
         {
             try{
                 update updateContact;
             }catch(Exception e)
             {
                 system.debug('Dml Excpetion'+e);
             
             }
         }
    
    
    }

}