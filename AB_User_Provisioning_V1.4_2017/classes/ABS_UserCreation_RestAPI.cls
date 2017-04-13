/*Author ; Deepthi*/
/*Test class: ABS_UserCreation_RestAPI_Test*/

public class ABS_UserCreation_RestAPI
{
   
    public static wrapContact ContactUserList;
    
    public static string createUser(set<Id> ContactIds)
    {
        List<contact> lstCons = new List<contact>();
        ContactUserList = new wrapContact();
        system.debug('ContactIds'+ContactIds);
        lstCons = [select id,EMPLOYEE_NUMBER_US__c,LastName,FirstName,Email,MobilePhone,ISACTIVE__c,DEFAULTDIVISION__c,
                   USERNAME__c,Username_Suffix__c,NICKNAME__C,ROLEID__c,PROFILEID__c,TIMEZONEIDKEY__c,LOCALESIDKEY__c,ROUTEKEY__c,
                   COMPANYNAME__c,FEDERATIONIDENTIFIER__c,Title,CurrencyIsoCode,EMAILENCODINGKEY__c,LANGUAGELOCALEKEY__c,ALIAS__c,
                   Username_Suffix_Global__c,Global_User_Only__c,WSLRNbrRouteNbr__c,WHOLESALER_NUMBER__c from contact where id IN:ContactIds];
        system.debug(lstCons );
        if(!lstCons.isEmpty())
        {
            for(contact objCon:lstCons)
            {
                conWrapper cons = new conWrapper();
                cons.LastName = objCon.LastName;
                cons.Firstname = objCon.FirstName;
                cons.Alias = objCon.ALIAS__c;
                cons.Email = objCon.Email;
                cons.MobilePhone = objCon.MobilePhone;
                cons.IsActive = objCon.ISACTIVE__c;
                cons.Username = objCon.USERNAME__c;
                cons.CommunityNickname = objCon.FEDERATIONIDENTIFIER__c;//NICKNAME__C
                cons.CompanyName = objCon.COMPANYNAME__c;
                cons.CurrencyIsoCode = objCon.CurrencyIsoCode;
                cons.DefaultDivision = objCon.DEFAULTDIVISION__c;
                cons.FederationIdentifier = objCon.FEDERATIONIDENTIFIER__c;
                cons.Title = objCon.Title;
                cons.DefaultCurrencyIsoCode = objCon.CurrencyIsoCode;
                cons.TimeZoneSidKey = objCon.TIMEZONEIDKEY__c;
                cons.LocaleSidKey = objCon.LOCALESIDKEY__c;
                cons.EmailEncodingKey = objCon.EMAILENCODINGKEY__c;
                cons.LanguageLocaleKey = objCon.LANGUAGELOCALEKEY__c;
                cons.Username_Suffix_Global = objCon.Username_Suffix_Global__c;
                cons.Global_User_Only=objCon.Global_User_Only__c;
                cons.Source_Suffix=objCon.Username_Suffix__c;
                cons.WSLRNbrRouteNbr=objCon.WSLRNbrRouteNbr__c;
                ContactUserList.conWrap.add(cons);
            }
        }
        system.debug('communityUserListIns=='+ContactUserList);
        String jsonstring = (String)JSON.serialize(ContactUserList);
        System.debug(jsonstring);                     
        string accessToken=ReturnAccessToken();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Label.AB_UserCreation_Url);
        request.setMethod('PUT');
        request.setTimeOut(120000) ;
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
        req.setTimeout(120000);
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
    
    
    public class wrapContact
    {
        public list<conWrapper> conWrap;
        public wrapContact()
        {
            conWrap= new list<conWrapper>();
        }
    
    }
   
    
    public class conWrapper
    {
        public string LastName;
        public string Firstname; 
        public string Alias;
        public string Email;
        public string MobilePhone;
        public boolean IsActive;
        public string Username ;
        public string CommunityNickname;
        public string CompanyName;
        public string CurrencyIsoCode;
        public string DefaultDivision;
        public string FederationIdentifier;
        public string Title;
        public string DefaultCurrencyIsoCode;
        public string TimeZoneSidKey;
        public string LocaleSidKey;
        public string EmailEncodingKey;
        public string LanguageLocaleKey;
        public string Username_Suffix_Global;
        public boolean Global_User_Only;
        public string Source_Suffix;
        public string WSLRNbrRouteNbr;
    }
   
    

}