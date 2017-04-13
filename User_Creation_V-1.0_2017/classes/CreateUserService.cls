@RestResource(urlMapping='/CreateUserService/*')
global class CreateUserService
{ 
    
    public static string ERROR=''; 
    public static string SUCCESS='Scucessful';

    @HttpPut
    global static string doPut()
    {
         string sucMessage='Scucessful';
         boolean contactExist=false;
         set<string> fredrationId = new set<string>();
         list<user> updateUser = new list<user>();
         list<contact> existingContact = new list<contact>();
         list<User> existingUsers = new list<User>();
         list<Account> accountList=new list<Account>();
         list<user> newInsertUser = new list<user>();
         map<string,contact> exitingContacts = new map<string,contact>();
         map<string,user> existingUsersMap= new map<string,user>();
         map<string,contact> insertConMap = new map<string,contact>();
         map<string,user> insertUserMap = new map<string,user>();

         
         // Query to reterive Profile
         list<Profile> profileList=[select id,name from profile where name=:label.AB_UserCreation_Profile limit 1];
         
         accountList=[select id,name from account where name=:label.AB_Community_Account limit 1];
         
         RestRequest req = RestContext.request;
         Blob body = req.requestBody;
         String bodyString = body.toString();
         system.debug(bodyString );
         system.debug(req );
         AB_UserJsonParser insJson= new AB_UserJsonParser();
         insJson = AB_UserJsonParser.parse(bodyString);
         system.debug(insJson);
         if(insJson.conWrap != null && insJson.conWrap.size() > 0){
             for(integer i=0;i<insJson.conWrap.size();i++)
             {
                 fredrationId.add(insJson.conWrap[i].FederationIdentifier);   
             
             }
         }
         system.debug(fredrationId);
         existingContact =[SELECT id,Name,Email,FirstName,LastName,Phone,FEDERATIONIDENTIFIER__c from contact 
                           where FEDERATIONIDENTIFIER__c IN :fredrationId and FEDERATIONIDENTIFIER__c != null];
                           
         if(!existingcontact.isEmpty())
         {
             for(contact c:existingcontact)
             {
                 exitingContacts.put(c.FEDERATIONIDENTIFIER__c,c);   
             }
         }
         
         
         existingUsers =[SELECT FederationIdentifier,Id,Username,LastName,FirstName,Email,Alias,Fax,  
                         CommunityNickname,IsActive,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,City, 
                         LanguageLocaleKey,UserPreferencesDisableAutoSubForFeeds,phone,contactId, 
                         UserPermissionsMobileUser,Title,MobilePhone,PostalCode,State,Street,ProfileId,
                         CompanyName,Department,Username_Suffix_Global__c FROM User 
                         WHERE FederationIdentifier IN :fredrationId and FederationIdentifier !=null];
         system.debug(existingUsers);
         if(!existingUsers.isEmpty())
         {
             for(user u:existingUsers)
             {
                 existingUsersMap.put(u.FederationIdentifier,u);
             }
             
         }
         
         if(insJson.conWrap != null && insJson.conWrap.size() > 0){
             for(integer i=0;i<insJson.conWrap.size();i++)
             {
                
                
                 if(existingUsersMap.containskey(insJson.conWrap[i].FederationIdentifier))
                 {
                     user existUser = new user();
                     user objUser = new user();
                     existUser =existingUsersMap.get(insJson.conWrap[i].FederationIdentifier);
                     objUser.id=existUser.id;
                     objUser.LastName = insJson.conWrap[i].LastName;// != null?objCon.LastName:'';
                     objUser.Firstname = insJson.conWrap[i].FirstName;// != null?objCon.FirstName;
                     objUser.Alias =insJson.conWrap[i].Alias;
                     objUser.Email = insJson.conWrap[i].Email;
                     objUser.MobilePhone = insJson.conWrap[i].MobilePhone;
                     objUser.CommunityNickname = insJson.conWrap[i].FederationIdentifier;
                     objUser.CompanyName = insJson.conWrap[i].CompanyName;
                     objUser.FederationIdentifier = insJson.conWrap[i].FederationIdentifier;
                     objUser.Title = insJson.conWrap[i].Title;
                     objUser.TimeZoneSidKey = insJson.conWrap[i].TimeZoneSidKey;
                     objUser.LocaleSidKey = insJson.conWrap[i].LocaleSidKey;
                     objUser.EmailEncodingKey = insJson.conWrap[i].EmailEncodingKey;
                     objUser.LanguageLocaleKey = insJson.conWrap[i].LanguageLocaleKey;
                     objUser.WSLRNbrRouteNbr__c= insJson.conWrap[i].WSLRNbrRouteNbr;
                     objUser.Source_Suffix__c = insJson.conWrap[i].Source_Suffix;
                     objUser.Username_Suffix_Global__c=insJson.conWrap[i].Username_Suffix_Global;
                     system.debug(insJson.conWrap[i].Username_Suffix_Global);
                     if(insJson.conWrap[i].Username_Suffix_Global ==null || insJson.conWrap[i].Username_Suffix_Global =='')
                     {
                        objUser.username=insJson.conWrap[i].email+label.AB_User_Suffix;
                     }else{
                        objUser.username=insJson.conWrap[i].email+insJson.conWrap[i].Username_Suffix_Global; 
                     }
                     if(!insJson.conWrap[i].Global_User_Only &&  insJson.conWrap[i].IsActive) 
                     {
                         objUser.isActive=insJson.conWrap[i].IsActive;
                     }else if(!insJson.conWrap[i].Global_User_Only &&  !insJson.conWrap[i].IsActive)
                     {
                         objUser.isActive=false;
                     }else if(insJson.conWrap[i].Global_User_Only &&  insJson.conWrap[i].IsActive)
                     {
                         objUser.isActive=insJson.conWrap[i].IsActive;
                     }
                     else if(insJson.conWrap[i].Global_User_Only &&  !insJson.conWrap[i].IsActive)
                     {
                         objUser.isActive=false;
                     }
                     updateUser.add(objUser);
                 }else
                 {
                     if((!insJson.conWrap[i].Global_User_Only &&  insJson.conWrap[i].IsActive) ||(insJson.conWrap[i].Global_User_Only &&  insJson.conWrap[i].IsActive))
                     {   
                         user objUser = new user();
                         contact existCon = new contact();
                         if(exitingContacts.containskey(insJson.conWrap[i].FederationIdentifier))
                         {
                             existCon=exitingContacts.get(insJson.conWrap[i].FederationIdentifier);
                         }else{
                              contact newCon = new contact();
                              if(insJson.conWrap[i].MobilePhone!= null) newCon.phone= insJson.conWrap[i].MobilePhone;
                              if(insJson.conWrap[i].LastName!= null) newCon .Lastname = insJson.conWrap[i].LastName;
                              if(insJson.conWrap[i].Firstname!= null) newCon .Firstname = insJson.conWrap[i].Firstname;
                              if(insJson.conWrap[i].FederationIdentifier!= null) newCon.FEDERATIONIDENTIFIER__c= insJson.conWrap[i].FederationIdentifier;
                              insertConMap.put(insJson.conWrap[i].FederationIdentifier,newCon);
                              newCon.accountId=accountList[0].id;
                         }
                         objUser.LastName = insJson.conWrap[i].LastName;// != null?objCon.LastName:'';
                         objUser.Firstname = insJson.conWrap[i].FirstName;// != null?objCon.FirstName;
                         objUser.Alias =insJson.conWrap[i].Alias;
                         objUser.Email = insJson.conWrap[i].Email;
                         objUser.MobilePhone = insJson.conWrap[i].MobilePhone;
                         objUser.CommunityNickname = insJson.conWrap[i].FederationIdentifier;
                         objUser.CompanyName = insJson.conWrap[i].CompanyName;
                         objUser.FederationIdentifier = insJson.conWrap[i].FederationIdentifier;
                         objUser.Title = insJson.conWrap[i].Title;
                         objUser.TimeZoneSidKey = insJson.conWrap[i].TimeZoneSidKey;
                         objUser.LocaleSidKey = insJson.conWrap[i].LocaleSidKey;
                         objUser.EmailEncodingKey = insJson.conWrap[i].EmailEncodingKey;
                         objUser.LanguageLocaleKey = insJson.conWrap[i].LanguageLocaleKey;
                         objUser.WSLRNbrRouteNbr__c= insJson.conWrap[i].WSLRNbrRouteNbr;
                         objUser.Source_Suffix__c = insJson.conWrap[i].Source_Suffix;
                         objUser.Username_Suffix_Global__c=insJson.conWrap[i].Username_Suffix_Global;
                         system.debug(insJson.conWrap[i].Username_Suffix_Global);
                         if(insJson.conWrap[i].Username_Suffix_Global ==null || insJson.conWrap[i].Username_Suffix_Global == '')
                         {
                            objUser.username=insJson.conWrap[i].email+label.AB_User_Suffix;
                         }else{
                            objUser.username=insJson.conWrap[i].email+insJson.conWrap[i].Username_Suffix_Global; 
                         }
                         if(!insJson.conWrap[i].Global_User_Only &&  insJson.conWrap[i].IsActive) 
                         {
                             objUser.isActive=insJson.conWrap[i].IsActive;
                         }else if(insJson.conWrap[i].Global_User_Only &&  insJson.conWrap[i].IsActive)
                         {
                             objUser.isActive=insJson.conWrap[i].IsActive;
                         }
                         objUser.contactId=existCon.id;
                         objUser.profileId=profileList[0].id;
                         insertUserMap.put(insJson.conWrap[i].FederationIdentifier,objUser);
                     }
                 }
             }
         }
         if(insJson.conWrap != null && insJson.conWrap.size() > 0){
             for(integer j=0;j<insJson.conWrap.size();j++)
             {
                 if(exitingContacts.containsKey(insJson.conWrap[j].FederationIdentifier))
                 {
                     contactExist=true;
                     break;
                 }
             }
         }
         
         RestResponse res = RestContext.response;
         Savepoint sp = Database.setSavepoint();
         
         try{
             if(!insertConMap.isEmpty())
             {
                 insert insertConMap.values();
                 system.debug(insertConMap.values());
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
                 insCon=insertConMap.get(u.FederationIdentifier);
                 if(insCon != null)
                     u.contactId=insCon.Id;
                 Database.DMLOptions dlo = new Database.DMLOptions();
                 dlo.EmailHeader.triggerUserEmail = true;
                 dlo.EmailHeader.triggerAutoResponseEmail= true;
                 u.setOptions(dlo);  
                 newInsertUser.add(u);
             }  
         }
         
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
         
         if(contactExist)
         {
             insContact(bodyString);
         }
         
         if(!updateUser.isEmpty()){
             try{
                 update updateUser;
                 system.debug(updateUser);
                 res.statusCode = 500;
             }catch(Exception e){
                 system.debug('Dml exception'+e);
                 error=string.valueof(e);
                 res.statusCode = 500;
                 Database.rollback(sp);
                 return error;
    
             }
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
       
        for(integer k=0;k<insJson.conWrap.size();k++)
        {
            contact newCon = new contact();
            if(insJson.conWrap[k].MobilePhone!= null) newCon.phone= insJson.conWrap[k].MobilePhone;
            if(insJson.conWrap[k].LastName!= null) newCon .Lastname = insJson.conWrap[k].LastName;
            if(insJson.conWrap[k].Firstname!= null) newCon .Firstname = insJson.conWrap[k].Firstname;
            if(insJson.conWrap[k].FederationIdentifier!= null) newCon.FEDERATIONIDENTIFIER__c= insJson.conWrap[k].FederationIdentifier;
            contactmap.put(insJson.conWrap[k].FederationIdentifier,newCon);  
            fredrationId.add(insJson.conWrap[k].FederationIdentifier); 
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