public class AB_UserJsonParser{

    public list<conWrap> conWrap{get;set;}
    
    public class conWrap
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
    
    public static AB_UserJsonParser parse(String json){
        return (AB_UserJsonParser) System.JSON.deserialize(json, AB_UserJsonParser.class);
    }
}