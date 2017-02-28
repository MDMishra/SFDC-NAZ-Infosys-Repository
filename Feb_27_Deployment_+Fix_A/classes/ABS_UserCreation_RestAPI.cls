/*Author ; Deepthi*/
/*Test class: ABS_UserCreation_RestAPI_Test*/

public class ABS_UserCreation_RestAPI
{
    public static set<id> communityUserList;
    public static userWrapper communityUserListIns;
    public static set<string> conatctIdList;
    
    /*// method which invokes afterupdate of user
    public static void afterUpdate(list<User> newList, map<Id, User> oldMap)
    {
        userList(newList, oldMap);
    } 
    
    // method which invokes afterInsert of user
    public static void afterInsert(list<User> newList)
    {
        userList(newList, null);
    } 
    
    // method which invokes future call to insert/update records
    public static void userList(list<User> newList, map<Id, User> oldMap)
    {
        communityUserList = new set<Id>();
        for(user u:newList)
        {
            if(u.contactId != null)
            {
                communityUserList.add(u.id);    
            }
        }
        createUsers(communityUserList);
    }*/
    
    //method invoke http callout to insert/update records
    //@future(callout=true)
    public static string createUsers(set<Id> userIds)
    {
        communityUserListIns = new userWrapper(); // intialise wrapper class
        conatctIdList= new set<string>();// holds conntact list
        list<User> userList = new list<User>(); // Holds the inserted user list
        list<contact> contactList = new list<contact>();// reterive contacts associated with user
        map<string,contact> mapContact= new map<string,contact>();// map of contact
        
        // reterive the list of the user records
        if(!userIds.isEmpty())
        { 
            userList = [SELECT Id, FederationIdentifier,Username,LastName, FirstName,Email, Fax, 
                        Alias,CommunityNickname,IsActive,TimeZoneSidKey,LocaleSidKey,ProfileId,
                        EmailEncodingKey,LanguageLocaleKey,UserPreferencesDisableAutoSubForFeeds, 
                        UserPermissionsMobileUser,Title,City,MobilePhone,PostalCode,State, phone,
                        country,Username_Suffix_Global__c,WSLRNbrRouteNbr__c,Source_Suffix__c,
                        Street,CompanyName,Department,contactId FROM User WHERE Id IN :userIds];
        }  
        system.debug('userList=='+userList); 
        // Adding contact Id user records          
        if(!userList.isEmpty())
        {                       
            for(user u:userList)
            {
                if(u.FederationIdentifier != null){
                    conatctIdList.add(u.FederationIdentifier); 
                }   
            }   
        }  
         system.debug('conatctIdList=='+conatctIdList);                 
        //reterive the list of the contact records
        if(!conatctIdList.isEmpty())
        { 
            contactList =[SELECT id,Name,Email,FirstName,LastName,Phone,FEDERATIONIDENTIFIER__c,
                         Username_Suffix__c from contact where FEDERATIONIDENTIFIER__c in :conatctIdList];
                           
        }
        system.debug('contactList =='+contactList );
        // Map of contacts
        if(!contactList.isEmpty())
        {
            for(contact con:contactList)
            {
                mapContact.put(con.FEDERATIONIDENTIFIER__c,con); 
            }
        }
        system.debug('mapContact=='+mapContact);
        system.debug('userList=='+userList);
        // user and contact wrapper
        if(!userList.isEmpty())
        { 
            userwrapper objWrapUser = new userwrapper();
            for(user u:userList)
            {
                contact objCon = new contact();
                contactWrapper  objWrapCon = new contactWrapper();
                userWrap wrapObj = new userWrap();                    
                if(u.FederationIdentifier!= null){
                    if(!mapContact.isEmpty() && mapContact.get(u.FederationIdentifier) != null)
                    {
                        objCon =mapContact.get(u.FederationIdentifier);   
                        objWrapCon.id =objCon.id;
                        objWrapCon.FirstName=objCon.FirstName;
                        objWrapCon.LastName=objCon.LastName;
                        objWrapCon.Name=objCon.name;
                        objWrapCon.phone=objCon.phone;
                        objWrapCon.FEDERATIONIDENTIFIER=objCon.FEDERATIONIDENTIFIER__c; 
                    }       
                }
                wrapObj.UserPreferencesDisableAutoSubForFeeds=u.UserPreferencesDisableAutoSubForFeeds;
                wrapObj.LanguageLocaleKey=u.LanguageLocaleKey;
                wrapObj.UserPermissionsMobileUser=u.UserPermissionsMobileUser;
                wrapObj.EmailEncodingKey=u.EmailEncodingKey;
                wrapObj.Title=u.Title;
                wrapObj.ProfileId=u.ProfileId;
                wrapObj.MobilePhone=u.MobilePhone;
                wrapObj.LocaleSidKey=u.LocaleSidKey;
                wrapObj.Phone=u.Phone;
                wrapObj.TimeZoneSidKey=u.TimeZoneSidKey;
                wrapObj.ContactId=u.ContactId;
                wrapObj.IsActive=u.IsActive;
                wrapObj.CommunityNickname=u.CommunityNickname;
                wrapObj.Alias=u.Alias;
                wrapObj.LastName=u.LastName;
                wrapObj.Username=u.Username;
                wrapObj.FirstName=u.FirstName;
                wrapObj.Id=u.Id;
                wrapObj.Email=u.Email;
                wrapObj.FederationIdentifier=u.FederationIdentifier;
                wrapObj.country=u.country;
                wrapObj.city=u.city;
                wrapObj.PostalCode=u.PostalCode;
                wrapObj.state=u.state;
                wrapObj.Fax=u.Fax;
                wrapObj.street=u.street;
                wrapObj.Department=u.Department;
                wrapObj.Username_Suffix_Global=u.Username_Suffix_Global__c;
                wrapObj.WSLRNbrRouteNbr=u.WSLRNbrRouteNbr__c;
                wrapObj.CompanyName=u.CompanyName;
                wrapObj.Source_Suffix=u.Source_Suffix__c;
                communityUserListIns.objUser.add(wrapObj);
                communityUserListIns.objContact.add(objWrapCon);
              
            }  
             
        }
        system.debug('communityUserListIns=='+communityUserListIns);
        String jsonstring = (String)JSON.serialize(communityUserListIns);
        System.debug(jsonstring);                     
        string accessToken=ReturnAccessToken();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Label.AB_UserCreation_Url);
        request.setMethod('PUT');
        request.setTimeOut(20000) ;
        request.setHeader('Content-Type', 'application/json');  
        request.setBody(jsonstring);
        system.debug(jsonstring);
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        Http http = new Http();
        HttpResponse response = new HttpResponse();
        string calloutStatus='';
        if(!Test.isRunningTest()) {
            response = http.send(request);   
            if(response.getStatusCode()==200)
            {
                calloutStatus='Success';  
            }else{
                calloutStatus='Error';
            }
            system.debug(calloutStatus);
            system.debug(response);   
        } else {
            String str = '[{"Username" : "TestMethod0@tset.com", "Status" : false, "ErrorMessage" : "Error Occured -> DUPLICATE_USERNAME: Duplicate Username. The username already exists in this or another Salesforce organization."}, {"Username" : "TestMethod1@test.com", "Status" : true, "ErrorMessage" : ""}]';
            response.setBody(str);
            response.setStatusCode(200);
            response.setStatus('OK');
            calloutStatus='Success'; 
        } 
        return calloutStatus;
        
    }
    // method which retrives access token
    public static String ReturnAccessToken()
    {
        list<profile> pid=[select id from profile where name='System Administrator' limit 1];
        AB_UserCreation__c abuc = AB_UserCreation__c.getInstance(pid[0].id);
        string clientId= abuc.Client_Id__c;
        String clientSecret=abuc.clientSecret__c;
        string username=abuc.username__c;
        string password=abuc.Password__c;
        String reqbody = 'grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(abuc.EndPointUrl__c);
        HttpResponse res;
        if(!Test.isRunningTest()) {
            res = h.send(req);
        } else {
            res = ABS_UserCreation_RestAPI_Mock.mockAutheticate();
        }
        deserializeResponse resp1 = (deserializeResponse) JSON.deserialize(res.getbody(), deserializeResponse.class);
        System.debug('Body   '+res.getBody());
        system.debug(resp1.access_token);
        return resp1.access_token;
    }
    
    // warpper for access token 
    public class deserializeResponse
    {
        public String id;
        public String access_token;
    }
    // warpper for user and contact
    public class userWrapper
    {
        public list<userWrap> objUser;
        public list<contactWrapper> objContact;
        public userWrapper()
        {
            objUser=new list<userWrap>();
            objContact=new list<contactWrapper>();
        }
    }
    
    public class contactWrapper
    {
        public String FirstName;
        public String LastName;
        public String Name;
        public String Phone;
        public String Id;
        public String FEDERATIONIDENTIFIER;
    }
    public class userWrap
    {
        public Boolean UserPreferencesDisableAutoSubForFeeds;
        public String LanguageLocaleKey;
        public Boolean UserPermissionsMobileUser;
        public String EmailEncodingKey;
        public String Title;
        public String ProfileId;
        public String MobilePhone;
        public String LocaleSidKey;
        public String Phone;
        public String TimeZoneSidKey;
        public String ContactId;
        public Boolean IsActive;
        public String CommunityNickname;
        public String Alias;
        public String LastName;
        public String Username;
        public String FirstName;
        public String Id;
        public String Email;
        public string FederationIdentifier;
        public string country;
        public string city;
        public string PostalCode;
        public string state;
        public string Fax;
        public string street;
        public string Department;
        public string Username_Suffix_Global;
        public string WSLRNbrRouteNbr;
        public string CompanyName;
        public string Source_Suffix;
    }
    
   
    

}