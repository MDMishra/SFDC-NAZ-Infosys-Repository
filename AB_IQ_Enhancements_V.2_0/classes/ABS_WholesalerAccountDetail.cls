/*Apex class:ABS_WholesalerAccountDetail 
Description:This class is developed Poc's records on the ABS_WholesalerAccountDetail Page
This Controller is used in ABS_WholesalerAccountDetail Page
Created By :Deepthi Toranala
Created Date:5/30/2016
Modified Date:
Modified By:Deepthi
*/
global with sharing class ABS_WholesalerAccountDetail{
    
    public static user currentuser;// holds the current user 
    public static decimal alat;//holds the navigation lat 
    public static decimal along;//holds the navigation long 
    public static decimal lat;//holds the navigation lat 
    public static decimal lon;//holds the navigation long
    public static list<Account> myRetailers;//holds Accounts of with poc recordtype where logged in user is an account Team member
    public static string retailer{get;set;}// holds all retailers and myretailers values
    public static string Premise{get;set;}//holds peremise flag
    public static string channel{get;set;}//holds channel flag
    public static string ClosetoTargetAchievement{get;set;}
    public static integer size{get;set;} // size hold the records to display
    public static integer awayValue{get;set;}//Holds the away Value
    public static string queryParameters;//Holds the query String
    public static integer recordsize;// Holds the record size
    public static Set<Id> accountIds = new Set<Id>();// holds account Id
    public static list<Account> relatesPOCAccounts= new list<account>();
    public List<SelectOption> paginationSizeOptions{get;set;} // Option which toggles between the 10 and 20
    public List<SelectOption> retailerOptions{get;set;} // holds retailers options
    public List<SelectOption> PremiseOptions{get;set;} // holds retailers options
    Public List<SelectOption> ClosetoTarget{get;set;} //holds the picklist value of closetoTarget   
    public static string usrProfileName;// hold user profile name for wod profiles
    public static boolean isMatch;// verify myretailers match
    public static boolean viewByProfile{get;set;}//holds for profiles Wod match
    public datetime dataloaderDate{get;set;}// hold the data load date
    public US_Account_Target_Program__c dataloader;// query to retrive the latest modified date
    public String pageName='';// holds the page name 
    public static string Filters='';// Filter value of my retailers
    public list<US_Account_Target_Program__c> lstAccTarget;// list hold US_Account_Target_Program__c records which displays on the page 
    public static pocAccountWrapper pocWrap{get;set;} // hold the records of pocAccountWrapper Wrapper class
    public static string accountpocId{get;set;}// holds the accountId which has to displayed in Poc Pannel
    public list<FAQ__c> lstFAQs{get;set;}//Holds the faq's records to displayed on the help page
    public ONTAP__Case_Force__c sapCase{get;set;}// holds the ontapcase force record
    public static boolean OnPremise{get;set;}// boolean value of onPremise for filter Pannel
    public static boolean OffPremise{get;set;}//boolean value of OffPremise for filter Pannel
    public static boolean MyRetailersTeam{get;set;}//boolean value of MyRetailersTeam for filter Pannel
    public List<SelectOption> milesOptions{get;set;}// options list for miles Feature
    public static integer miles{get;set;}// Holds the miles value 
    public static list<string> assortmentList{get;set;} // pannel display List assorment
    public static list<string> executionList{get;set;} // pannel display list execution
    public static map<string,string> mapdiv{get;set;} //
    public static boolean largeformat{get;set;}// holds large format records
    public static string recColor{get;set;}// holds the sap color records
    public List<SelectOption> recColorOptions{get;set;}
    public static list<wrapAtrec> wraptarget{get;set;}
    // Constructor
    public ABS_WholesalerAccountDetail()
    {
        size=20;// default value
        miles=100;// default value
        isMatch=false;
        viewByProfile=false;
        OnPremise=false;
        OffPremise=false;
        MyRetailersTeam=false;
        
        recColorOptions = new list<SelectOption>();
        recColorOptions.add(new selectOption('None','None'));
        recColorOptions.add(new selectOption('Red','Red'));
        recColorOptions.add(new selectOption('Green','Green'));
        
        //adding values to select option for size
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        
        //adding values to select option for retailers
        retailerOptions=new List<SelectOption>();
        retailerOptions.add(new SelectOption('None','None')); 
        retailerOptions.add(new SelectOption('My Retailers','My Retailers'));
        retailerOptions.add(new SelectOption('All Retailers','All Retailers'));
        
        //adding values to select option for premise
        PremiseOptions=new List<SelectOption>();
        PremiseOptions.add(new SelectOption('None','None'));
        PremiseOptions.add(new SelectOption('Package Liquor','Package Liquor'));
        PremiseOptions.add(new SelectOption('Large Format','Large Format'));
        PremiseOptions.add(new SelectOption('Convenience','Convenience'));
        PremiseOptions.add(new SelectOption('On Premise','On Premise'));
        PremiseOptions.add(new SelectOption('Small Format','Small Format'));
        
        //adding values to select option close to achivement
        ClosetoTarget = new list<SelectOption>();
        ClosetoTarget.add(new SelectOption('None','None'));
        ClosetoTarget.add(new SelectOption('1','1 Sku'));
        ClosetoTarget.add(new SelectOption('2','2 Sku'));
        
        //adding values to select option miles
        milesOptions = new list<SelectOption>();
        milesOptions.add(new SelectOption('100','100 miles'));
        milesOptions.add(new SelectOption('200','200 miles'));
        milesOptions.add(new SelectOption('300','300 miles'));
        milesOptions.add(new SelectOption('3000','3000 miles'));
        
        // query to get logged user's Profile
        usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        // label to which default my retailers profiles
        string ABS_Profiles=Label.ABS_Profiles;
        list<String> listProfiles = ABS_Profiles.split(',');
        for(string p:listProfiles)
        {
            if(p==usrProfileName)
            {
                isMatch=true;
                retailer='My Retailers';  
                viewByProfile=true; 
                break;
            }else{
                viewByProfile=false;
            }
        }
        dataloader=[Select LastModifiedDate from US_Account_Target_Program__c order By LastModifiedDate DESC Limit 1];
        if(dataloader != null)
        {
            dataloaderDate=dataloader.LastModifiedDate;
        }       
              
        pageName='ABS_WholesalerAccountDetail';
       
        if(!Test.isRunningTest())
        {
            pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        }
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        if(pageName =='ABS_WholesalerAccountDetail')
        {
            if(Apexpages.currentPage().getParameters().get('retailersTeam') !='undefined' && Apexpages.currentPage().getParameters().get('retailersTeam') != null)
            {
                MyRetailersTeam=boolean.valueof(Apexpages.currentPage().getParameters().get('retailersTeam'));
                //retailer=retailer.replace('%20', ' ');
            }
            if(Apexpages.currentPage().getParameters().get('OnPremise') !='undefined' && Apexpages.currentPage().getParameters().get('OnPremise') != null)
            {
                OnPremise=boolean.valueof(Apexpages.currentPage().getParameters().get('OnPremise'));
                //retailer=retailer.replace('%20', ' ');
            }
            if(Apexpages.currentPage().getParameters().get('OffPremise') !='undefined' && Apexpages.currentPage().getParameters().get('OffPremise') != null)
            {
                OffPremise=boolean.valueof(Apexpages.currentPage().getParameters().get('OffPremise'));
                //retailer=retailer.replace('%20', ' ');
            }
            if(Apexpages.currentPage().getParameters().get('Premise') !=null)
            {
                Premise=Apexpages.currentPage().getParameters().get('Premise');
            }
            if(Apexpages.currentPage().getParameters().get('Channel') !=null)
            {
                channel=Apexpages.currentPage().getParameters().get('Channel');
                channel=channel.replace('%20', ' ');
            }
            if(Apexpages.currentPage().getParameters().get('size') !=null)
            {
                size=integer.valueof(Apexpages.currentPage().getParameters().get('size'));
                system.debug(size);
            }
            if(Apexpages.currentPage().getParameters().get('ClosetoTargetAchievement') !=null)
            {
                ClosetoTargetAchievement=string.valueof(Apexpages.currentPage().getParameters().get('ClosetoTargetAchievement'));
            }
            if(Apexpages.currentPage().getParameters().get('miles') !=null)
            {
                miles=integer.valueof(string.valueof(Apexpages.currentPage().getParameters().get('miles')));
            }
            if(Apexpages.currentPage().getParameters().get('LargeFormat') !=null)
            {
                largeformat=boolean.valueof(string.valueof(Apexpages.currentPage().getParameters().get('LargeFormat')));
            }
            if(Apexpages.currentPage().getParameters().get('sapcolor') !=null)
            {
                recColor=string.valueof(Apexpages.currentPage().getParameters().get('sapcolor'));
            }
            
        }
        sapCase = new ONTAP__Case_Force__c();
        myfaqs();
    }
    
    //Select Option for displaying permise value
    public List<selectOption> getChannelOptions() 
    {
       return getPickListVal(Account.RTL_SEG_NM_US__c);
    }
    
    public List<selectOption> getPickListVal(SObjectField fieldName)
    {
        Schema.DescribeFieldResult field = fieldName.getDescribe();
        List<Schema.PicklistEntry> ple = field.getPicklistValues();
        List<selectOption> defaultOption = new  List<selectOption>();
        DefaultOption.add(new SelectOption('None','None'));
        for (Schema.PicklistEntry f : ple )
        {
            defaultOption.add(new SelectOption(f.getLabel(),f.getvalue()));
        }
        return defaultOption;
    }
    
    
    public static void EvntLgTrack() 
    {
        try
        {
            system.debug('Start : EvntLgTrack');
            string type='';
            EventLog__c objEvnt = new EventLog__c();
            /*if(Apexpages.currentPage().getParameters().get('paramEventType') !='undefined' && Apexpages.currentPage().getParameters().get('paramEventType') != null)
                objEvnt.Application__c = Apexpages.currentPage().getParameters().get('paramEventType');
            else
                objEvnt.Application__c = 'AB-IQ';*/
            objEvnt.Application__c = 'AB-IQ'; 
            if(Apexpages.currentPage().getParameters().get('paramEventType') !='undefined' && Apexpages.currentPage().getParameters().get('paramEventType') != null)
            {    
                type=Apexpages.currentPage().getParameters().get('paramEventType');
                objEvnt.Type__c=Apexpages.currentPage().getParameters().get('paramEventType');  
                system.debug(objEvnt.Event__c);
            }
            if(type=='AB-IQ Survey Link'){
                objEvnt.Event__c='Survey Launch';
            }else{
                objEvnt.Event__c='Survey Launched';
            }
            if(Apexpages.currentPage().getParameters().get('pocAccId') !='undefined' && Apexpages.currentPage().getParameters().get('pocAccId') != '')
            {
                objEvnt.Account__c=Apexpages.currentPage().getParameters().get('pocAccId');
                system.debug(objEvnt.Account__c);
            }
            if(Apexpages.currentPage().getParameters().get('paramEvent') !='undefined' && Apexpages.currentPage().getParameters().get('paramEvent') != null)
            {
                //TODO : URL parsing for Mission ID and Place ID
                string event = Apexpages.currentPage().getParameters().get('paramEvent');
                if (event != null && event != '')
                {
                    List<String> lstUrls=new List<String>();
                    String placeId = '';
                    String MissionId = '';
                    String UserID = '';
                    lstUrls.addAll(event.split('/'));
                    if (!lstUrls.isEmpty() &&  lstUrls.size() > 0)
                    {
                        //system.debug(lstUrls);
                        If (lstUrls.size() >= 3)
                        placeId = lstUrls[3];
                        If (lstUrls.size() >= 5)
                        MissionId = lstUrls[5].replace('?user_id','/').split('/')[0];
                        UserID  = lstUrls[5].replace('?user_id','/').split('/')[1];
                        objEvnt.Event__c = 'Place ID :' + placeId  + ' Mission ID: '  + MissionId + ' User ID: ' + UserID;
                    }
                }
            }
            objEvnt.User__c = Userinfo.getUserId();
            objEvnt.Timestamp__c=system.now();
            insert objEvnt;
            objEvnt = new EventLog__c();
        }
        catch(exception e)
        {
            system.debug('exception' + e.getMessage() +  e.getLineNumber());
        }
        system.debug('End : EvntLgTrack');
    }
    
    @RemoteAction
    global static List<AccountTargetWrapper> findPocs(Decimal geolat, Decimal geolong,boolean retailersTeams,boolean OnPremises,boolean OffPremises,string myChannel,String recSize,string targetAchievements,boolean isFilteradded,string recMiles,boolean largeFormats,string SapColor) 
    {
        system.debug(geolat+'+++++++++++++++++'+geolong);
        usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        string ABS_Profiles=Label.ABS_Profiles;
        list<String> listProfiles = ABS_Profiles.split(',');
        list<string> premises = new list<string>();
        MyRetailersTeam=false;
        //list<AccountTargetBrandWrapper> lstATBrand;
        for(string p:listProfiles)
        {
            if(p==usrProfileName)
            {
                isMatch=true;
                retailer='My Retailers';  
                viewByProfile=true; 
                break;
            }else{
                viewByProfile=false;
            }
        }
        //filters
        if(retailersTeams == true && isFilteradded == true)
        {
            retailer ='My Retailers';
        }else if(retailersTeams == false && isFilteradded == true){
            retailer ='All Retailers';
        }
        if(OnPremises == true)
            premises.add('On Premise');
        if(OffPremises == true)
            premises.add('Small Format');
        if(largeFormats == true)
            premises.add('Large Format');
        if(channel !='')
            channel=myChannel;
        if(targetAchievements != '')
            ClosetoTargetAchievement=targetAchievements;
        if(SapColor != '')
            recColor=SapColor;
        If(recSize !='')
        {
            size=Integer.valueof(recSize);
        }else{
            size=20;
        }
        if(recMiles !='')
        {
            miles=Integer.valueof(recMiles);
        }else{
            miles=100;
        }    
        map<id,list<US_Account_Target_Program__c>> mapUsTarget = new map<id,list<US_Account_Target_Program__c>>();
        map<id,account> mapAccount = new map<id,account>();
        List<AccountTargetWrapper> accountList = new List<AccountTargetWrapper>();
          
        currentuser=new User();// intialize
        lat=0;// intialize
        lon=0;//intialize
        alat=0;//intialize
        along=0;//intialize
        
        // query to the get logged in user's latitude and longtitude.
        currentuser=[Select Id,Name,Email,Latitude,Longitude from User where Id=:userinfo.getuserId()];
        
        // Assign the lat and long values
        if(currentuser != null)
        {
            if(currentuser.Latitude != null)
            {
                lat=currentuser.Latitude;
                lon=currentuser.Longitude;
            }
        }
        
        // assigning geo locations
        if(viewByProfile == false)
        {
            system.debug(geolat);
            system.debug(geolong);
            if(geolat !=null && geolong !=null && (geolat !=0 && geolong !=0))
            {
                alat=geolat;
                along=geolong;
            }else 
            {
                alat=lat;
                along=lon;
            }
        }else{
            if(lat !=null && lon !=null && (lat !=0 && lon !=0))
            {
                alat=lat;
                along=lon;
            }else{
                alat=geolat;
                along=geolong;
            }
        }
        myRetailers= new list<Account>();     
        List<AccountTeamMember> accMembers = new List<AccountTeamMember>();
        accMembers = [SELECT Id,AccountId FROM AccountTeamMember WHERE  UserId = :userinfo.getuserId() 
                      and AccountTeamMember.Account.Type = 'POC'];
        if(!accMembers.isEmpty())
        {
            for(AccountTeamMember member : accMembers) 
            {
                accountIds.add(member.AccountId);
            }
        }
       
        if(retailer =='My Retailers')
        {
            Filters='My Retailers';
            system.debug(retailer+'Entred test');
            queryParameters='SELECT Id,Name,BillingLatitude,BillingLongitude,SAP_Channel__c,RTL_SEG_NM_US__c,SAP_Color__c '+
                            ' FROM Account WHERE Id IN :accountIds And (BillingLatitude!= null And BillingLatitude!= 0) AND recordtype.Name = \'Poc\''+ 
                            ' and Account_Targets_Count__c >0 and DISTANCE(Location__c, GEOLOCATION(:alat,:along), \'mi\') <';
        
        }else 
        {    
            Filters='All Retailers';
            system.debug(retailer+'Entred else====');
            queryParameters='SELECT Id,Name,BillingLongitude,SAP_Channel__c,RTL_SEG_NM_US__c,SAP_Color__c,'+
                            ' BillingLatitude FROM Account WHERE'+
                            ' (BillingLatitude!= null And BillingLatitude!= 0) AND recordtype.Name = \'Poc\''+ 
                            ' and Account_Targets_Count__c >0 and DISTANCE(Location__c, GEOLOCATION(:alat,:along), \'mi\') <';
        }
        if(miles != null){
        
            queryParameters+=' :miles';
        }
        if(!premises.isEmpty())
        {
            queryParameters+=' and SAP_Channel__c IN :premises';
        }if(channel !=null && channel !='None' && channel !='')
        {
            queryParameters+=' and RTL_SEG_NM_US__c LIKE :channel';
        }
        if(recColor !=null && recColor !='None' && recColor !='')
        {
            queryParameters+=' and SAP_Color__c LIKE :recColor';
        }
        if(ClosetoTargetAchievement !='' && ClosetoTargetAchievement !='None' && ClosetoTargetAchievement !=null)
        {
            awayValue =Integer.valueof(ClosetoTargetAchievement);
            system.debug(awayValue +'awayValue');
            queryParameters+=' and (FMB_Away__c = :awayValue OR Core_Away__c = :awayValue OR HE_Away__c = :awayValue)';
        }if(size !=null){
            recordsize=size;
            queryParameters+=' ORDER BY DISTANCE(Location__c, GEOLOCATION(:alat,:along), \'mi\') ASC LIMIT :recordsize';
        }
        system.debug(queryParameters);
        relatesPOCAccounts = Database.query(queryParameters);
        system.debug(relatesPOCAccounts );
        set<id> relatedIds = new set<id>();// holds related ids
        if(relatesPOCAccounts.size() >0)
        {
              for(Account rAcc:relatesPOCAccounts)
              {
                  system.debug(rAcc.name);
                  relatedIds.add(rAcc.id);
                  mapAccount.put(rAcc.id,rAcc);
              }
        }
        system.debug(relatedIds);
        system.debug(mapAccount);
        // Mapping of accTarget
      
        list<US_Account_Target_Program__c> accTarget =[select Achieved_Targets__c,Panel_Display__c,Pannel_Color__c,KPI_Group_Seq__c,KPI_Measurement__c,
                                                       Count_of_SKUs__c,Program_Target_Level__c,Account__c,Brand_Category__c,Brand_Cat_Seq__c,
                                                       KPI_Group__c,Brand_Category_Text__c,id,KPI_Group_Text__c,Program_Target_Pop_Up__c
                                                       from US_Account_Target_Program__c where Account__c In :relatedIds  ];
        
        
        // Creating Map for  US_Account_Target_Program__c
        if(accTarget.size() > 0) 
        {
            for(US_Account_Target_Program__c us:accTarget )
            {
                if(mapUsTarget.containsKey(us.Account__c)) 
                {
                    List<US_Account_Target_Program__c> accProgram= mapUsTarget.get(us.Account__c);
                    accProgram.add(us);
                    mapUsTarget.put(us.Account__c, accProgram);
                }else {
                    mapUsTarget.put(us.Account__c, new List<US_Account_Target_Program__c> {us});
                }
            }
        }
        system.debug(mapUsTarget);
        map<string,AccountTargetWrapper > mapAccList= new map<string,AccountTargetWrapper >();

        // building up sap score functionality
        if(mapUsTarget.size() >0)
        {
            for(id recId:mapUsTarget.keyset())
            {
                List<US_Account_Target_Program__c> lstAccProgram = new List<US_Account_Target_Program__c>();
                if(!mapUsTarget.isEmpty() && mapUsTarget.get(recId) != null)
                {
                    lstAccProgram =mapUsTarget.get(recId);
                    if(!lstAccProgram.isEmpty() && lstAccProgram.size()>0)
                    {
                        system.debug('lstAccProgram ' + lstAccProgram);
                        list<AccountTargetBrandWrapper> lstATseq1 = new list<AccountTargetBrandWrapper>();
                        list<AccountTargetBrandWrapper> lstATseq2 = new list<AccountTargetBrandWrapper>();
                        for(US_Account_Target_Program__c objAccProgram:lstAccProgram)
                        {
                            //TODO: Brand groups assign to map 
                            AccountTargetBrandWrapper  obj = new AccountTargetBrandWrapper();
                            obj.pannelColor =objAccProgram.Pannel_Color__c;
                            obj.panelDisplay =objAccProgram.Panel_Display__c==null?'':objAccProgram.Panel_Display__c;
                             system.debug('panelDisplay ' + obj.panelDisplay);
                            obj.brandcat = objAccProgram.Brand_Category_Text__c==null?'':objAccProgram.Brand_Category_Text__c;
                            system.debug('brandcat ' +objAccProgram.Brand_Category_Text__c);
                            obj.brandGrp = objAccProgram.KPI_Group_Text__c;
                            //system.debug('objAccProgram.KPI_Group_Seq__c' + objAccProgram.KPI_Group_Seq__c);
                            obj.grpSeq = integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0) ;
                            //system.debug('.grpSeq' + obj.grpSeq);
                            obj.catSeq =  integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                            obj.accountId = objAccProgram.Account__c;
                            obj.pgmTrgtLvl =string.valueof(objAccProgram.Program_Target_Pop_Up__c);
                            obj.AtpId=objAccProgram.id;
                            if (obj.grpSeq  == 1)
                            lstATseq1.add(obj);
                            if (obj.grpSeq  == 2)
                            lstATseq2.add(obj);
                        }
                        lstATseq1.sort();
                        lstATseq2.sort();
                        AccountTargetWrapper objTraWrap = new AccountTargetWrapper();
                        objTraWrap.id=recId;
                        objTraWrap.userName=currentuser.name;
                        objTraWrap.userlat=alat;
                        objTraWrap.userlong=along;
                        objTraWrap.mapUrl='/apex/ABS_PocAccountDetaiLPage?id='+recId;
                        objTraWrap.pocAccount=mapAccount.get(recId);
                        objTraWrap.Filter=Filters;
                        objTraWrap.lstSeq1 = lstATseq1;
                        objTraWrap.lstSeq2 = lstATseq2;
                        accountList.add(objTraWrap);
                        system.debug(objTraWrap.pocAccount);
                        mapAccList.put(recId,objTraWrap);
                    } 
                } 
            }
        }
        system.debug('Account List' + accountList);
        map<integer,AccountTargetWrapper> sortList= new map<integer,AccountTargetWrapper>();
        if(relatesPOCAccounts.size() >0)
        {
              integer i=1;
              for(Account rAcc:relatesPOCAccounts)
              {
                  if(!mapAccList.isEmpty())
                  {
                      sortList.put(i,mapAccList.get(rAcc.id));
                      i++;
                  }
              }
        }
        system.debug(sortList.values());        
        //return accountList;
        return sortList.values();
    }
    
    public static list<US_Account_Target_Program__c> lstPocAccTarget{get;set;}
    public static map<string,string> mapImages{get;set;}
    public static map<string,Integer> BrandSize{get;set;}
    public static list<US_Account_Target__c> lstAccountTarget{get;set;}//intialize
   
    public static void pocdetails()
    {
        decimal geolat=0.0;
        decimal geolong=0.0;
        pocWrap= new pocAccountWrapper();
        lstAccountTarget = new list<US_Account_Target__c>();//intialize
        mapdiv = new map<string,string>();
        if(Apexpages.currentPage().getParameters().get('accParam') != null)
        {
            if(!test.isRunningTest())
                accountpocId=Apexpages.currentPage().getParameters().get('accParam');// get's the accountId value from the page
        }
        if(Apexpages.currentPage().getParameters().get('firstParam') != null)
        {
            system.debug(Apexpages.currentPage().getParameters().get('firstParam')+'***********' );
            geolat=decimal.valueof(Apexpages.currentPage().getParameters().get('firstParam'));// getting lat values from vf page
        }
        if(Apexpages.currentPage().getParameters().get('secondParam') != null)
        {
            geolong=decimal.valueof(Apexpages.currentPage().getParameters().get('secondParam'));// getting long values from vf page
        }
        user poccurrentuser=[Select Id,Name,Email,Latitude,Longitude from User where Id=:userinfo.getuserId()];
        if(geolat !=null && geolong !=null && (geolat !=0 && geolong !=0)){
            pocWrap.palat=geolat;
            pocWrap.palon=geolong;
        }else{
            if(poccurrentuser!= null && poccurrentuser.Latitude != null)
            {
                pocWrap.palat=poccurrentuser.Latitude;
                pocWrap.palon=poccurrentuser.Longitude;
            }
        }
        lstPocAccTarget= new list<US_Account_Target_Program__c>();//intialize
        mapImages = new map<string,string>();//intialize
        set<string> setBrand = new set<string>();// hold brand name to map images
        list<SKU_Brand_Image__c> lstSkuBrand =new list<SKU_Brand_Image__c>();
        map<string,list<US_Account_Target__c >> mapUsTarget = new  map<string,list<US_Account_Target__c >>();
        
        
        // query which gets the poc record from the url parameter id.
        if(accountpocId!='')
        {   
            
            pocWrap.objPocAccount =[SELECT Id,Name,BillingLongitude,BillingLatitude,BillingStreet,BillingState,WSLR_NBR_US__c,
                                    Wholesaler__r.name,Phone,BillingCity,BillingCountry,BillingPostalCode,buzz_retail__lon__c,
                                    SAP_Channel__c,SAP_Color__c,buzz_retail__lat__c FROM Account WHERE id=:accountpocId LIMIT 1];
        }
        pocWrap.mapPocPinColor=pocWrap.objPocAccount.SAP_Color__c;
        // formating the string to display on the map to remove (')
        if(pocWrap.objPocAccount != null)
        
        {
            pocWrap.pocName=pocWrap.objPocAccount.name.replace('\'','\\\'');        
        }
        //query which gets Account Traget Programs
        if(pocWrap.objPocAccount != null)
        {
            lstPocAccTarget=[select id,Achieved_Targets__c,KPI_Group__c,Pannel_Value__c,Program_Target_Level__c,Account__c,Brand_Category__c,GSC_Link__c,Program_Target_Pop_Up__c,  
                             Count_of_SKUs__c,Panel_Display__c,Pannel_Color__c,KPI_Group_Seq__c,Brand_Cat_Seq__c,GSC_Url__c,Brand_Category_Text__c,KPI_Group_Text__c, 
                             KPI_Measurement__c from US_Account_Target_Program__c where Account__c =:pocWrap.objPocAccount.id ];
        }
        system.debug(lstPocAccTarget);
        // query to retrive Account Targets
        if(pocWrap.objPocAccount != null)
        {
            lstAccountTarget=[select Brand_Package__c,Acheivement_Score__c,id,Account__c,Brand_Category__c,FULL_TXT__c,
                              SKU__c,Num__c,Denom__c,Bonus__c,Sap_color__c from US_Account_Target__c where Account__c=:pocWrap.objPocAccount.id and Brand_Category__c !=null];
                             
        }
        set<US_Account_Target__c> lstAccTarget = new set<US_Account_Target__c>(); 
        for(US_Account_Target__c u:lstAccountTarget)
        {
            lstAccTarget.add(u);
        }
        if(!lstAccTarget.isEmpty())
        {
            for(US_Account_Target__c lstTargets:lstAccTarget)
            {
                if(mapUsTarget.containsKey(lstTargets.Brand_Category__c))
                {
                    list<US_Account_Target__c > Target = mapUsTarget.get(lstTargets.Brand_Category__c);
                    Target.add(lstTargets);
                    mapUsTarget.put(lstTargets.Brand_Category__c,Target);
                }else
                {
                    mapUsTarget.put(lstTargets.Brand_Category__c,new list<US_Account_Target__c >{lstTargets});

                }
            }
        }
    
        system.debug(lstAccountTarget);
         // to get the sku brand names
        if(lstAccountTarget.size() > 0)
        {
            for(US_Account_Target__c acctarget:lstAccountTarget)
            {
                setBrand.add(acctarget.SKU__c);
            }
        }
        system.debug(setBrand);
        // query which pulls sku brand Images
        if(!setBrand.isEmpty())
        {
            lstSkuBrand=[select Name,Sku_Image_Id__c from SKU_Brand_Image__c where name IN :setBrand];
        }
        system.debug(lstSkuBrand);
        if(!lstSkuBrand.isEmpty())
        {
            for(SKU_Brand_Image__c brand:lstSkuBrand)
            {
                string imageURL='/servlet/servlet.FileDownload?file=';
                mapImages.put(brand.Name,imageURL+brand.Sku_Image_Id__c);
            }
        }
        
        map<string,datetime> mapDataLoad = new  map<string,datetime>();
        AggregateResult[] groupedResult =[Select Brand_Category_Text__c,max(lastmodifieddate) 
                                          from US_Account_Target_Program__c where Brand_Category_Text__c != null and  Account__c=:accountpocId group by Brand_Category_Text__c];
        for(AggregateResult d:groupedResult){
            string bCat=(string)d.get('Brand_Category_Text__c');
            mapDataLoad.put(bCat.toLowerCase(),(datetime)d.get('expr0'));
        }
        system.debug(mapDataLoad);
        // Prepare Core,He,fmb,alnr and drft data to display on the page
        
        list<AccountTargetBrandWrapper> lstATseq3 = new list<AccountTargetBrandWrapper>();
        list<AccountTargetBrandWrapper> lstATseq4 = new list<AccountTargetBrandWrapper>();
        
        if(!lstPocAccTarget.isEmpty() && lstPocAccTarget.size()>0)
        {
            for(US_Account_Target_Program__c objAccProgram:lstPocAccTarget)
            {
                system.debug(objAccProgram);
                AccountTargetBrandWrapper  obj = new AccountTargetBrandWrapper();
                obj.pannelColor =objAccProgram.Pannel_Color__c;
                obj.panelDisplay =objAccProgram.Panel_Display__c;
                obj.brandcat = objAccProgram.Brand_Category_Text__c;
                obj.brandGrp = objAccProgram.KPI_Group_Text__c;
                obj.grpSeq = integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0) ;
                obj.catSeq =  integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                obj.accountId = objAccProgram.Account__c;
                obj.pgmTrgtLvl =string.valueof(objAccProgram.Program_Target_Pop_Up__c);
                obj.Pannelvalue=objAccProgram.Pannel_Value__c;
                obj.AtpId=objAccProgram.id;
                obj.gscChecked=objAccProgram.GSC_Link__c;
                obj.gscurl=objAccProgram.GSC_Url__c;
                obj.brandCategory=objAccProgram.Brand_Category__c;
                obj.KpiMeasurment=objAccProgram.KPI_Measurement__c !=''?objAccProgram.KPI_Measurement__c:'';
                if(!mapDataLoad.isEmpty()){
                    if(objAccProgram.Brand_Category_Text__c != null){
                        datetime loadDate=mapDataLoad.get(objAccProgram.Brand_Category_Text__c.toLowerCase());
                        TimeZone tz = UserInfo.getTimeZone();
                        string DisplayTime=tz.getDisplayName();
                        string DisplayID=tz.getID();
                        string[] SplitDisplayName =DisplayTime.split(' ');
                        String disp='('+SplitDisplayName[0].SubString(0,1)+SplitDisplayName[1].SubString(0,1)+SplitDisplayName[2].SubString(0,1)+')';
                        system.debug(loadDate);
                        if(loadDate != null)
                        {
                            obj.dataLoaddate=loadDate.format('MM/dd/yyyy hh:mm a')+' '+disp;
                        }
                    }
                }
                
                if (obj.grpSeq  == 1)
                    lstATseq3.add(obj);
                if (obj.grpSeq  == 2)
                    lstATseq4.add(obj);
            }
        }
        lstATseq3.sort();
        lstATseq4.sort();
       
        pocWrap.lstSeq3=lstATseq3;
        pocWrap.lstSeq4=lstATseq4;
        system.debug(pocWrap);
        wraptarget = new list<wrapAtrec>();
        for(US_Account_Target__c at:lstAccountTarget)
        {
            wrapAtrec ats= new wrapAtrec();
            ats.achivemnetScore=string.valueof(at.Acheivement_Score__c);
            ats.fulltext=at.FULL_TXT__c;
            if(!mapImages.isEmpty())
            {
                string image='';
                image=mapImages.get(at.SKU__c);
                ats.Imageurl=image;
            }
            ats.bonus=at.Bonus__c;
            ats.brandCat=at.Brand_Category__c;
            ats.Num=string.valueof(at.Num__c);
            ats.Denom=string.valueof(at.Denom__c);
            ats.SapColor=at.Sap_color__c;
            wraptarget.add(ats);
        }
        system.debug(wraptarget);
       
    }
    // Sap score wrapper class.
    global class AccountTargetBrandWrapper implements Comparable
    {
        public string brandGrp {get;set;}
        public string brandcat {get;set;}
        public integer grpSeq {get;set;}
        public integer catSeq {get;set;}
        public string pannelColor {get;set;}
        public string panelDisplay {get;set;}
        public string accountId {get;set;}
        public string pgmTrgtLvl {get;set;}
        public integer KPIGrpSeq {get;set;}
        public integer brandCatSeq {get;set;}
        public string mappinColor {get;set;}
        public string userName {get;set;}
        public string userlat {get;set;}
        public string userlong {get;set;}
        public string mapUrl {get;set;}
        public account pocAccount{get;set;}
        public string ATBcolor {get;set;}
        public String recId {get;set;}
        public string Filter{get;set;}
        public string Pannelvalue{get;set;}
        public string AtpId{get;set;}
        public string gscurl{get;set;}
        public boolean gscChecked{get;set;}
        public string brandCategory{get;set;}
        public string KpiMeasurment{get;set;}
        public string dataLoaddate{get;set;}
       
        public  Integer compareTo(Object compareTo) 
        {
            AccountTargetBrandWrapper compareToBrand = (AccountTargetBrandWrapper)compareTo;
            if(grpSeq == compareToBrand.grpSeq)
            {
               if (catSeq == compareToBrand.catSeq ) return 0;
               if (catSeq > compareToBrand.catSeq) return 1;
                return -1;  
            }
            if (grpSeq > compareToBrand.grpSeq) return 1;
                return -1; 
        }
    }
    global class AccountTargetWrapper
    {
       public string  id {get;set;}
       public account pocAccount{get;set;}
       public string mappinColor{get;set;}
       public string mapUrl{get;set;}
       public string userName{get;set;}
       public Decimal userlat{get;set;}
       public Decimal userlong{get;set;}
       public string Filter{get;set;}
       public integer brandSeq {get;set;}
       public integer catSeq {get;set;}
       public list<AccountTargetBrandWrapper> lstSeq1{get;set;}
       public list<AccountTargetBrandWrapper> lstSeq2{get;set;}
    }
    global class pocAccountWrapper
    {
        public string pocName{get;set;}
        public Account objPocAccount{get;set;}
        public string mapPocPinColor{get;set;}
        public decimal palat{get;set;}
        public decimal palon{get;set;}
        public list<AccountTargetBrandWrapper> lstSeq3{get;set;}
        public list<AccountTargetBrandWrapper> lstSeq4{get;set;}
    }
    global class wrapAtrec{
        public string achivemnetScore{get;set;}
        public string fulltext{get;set;}
        public string Imageurl{get;set;}
        public string bonus{get;set;}
        public string brandCat{get;set;}
        public string Num{get;set;}
        public string Denom{get;set;}
        public string SapColor{get;set;}
    } 
    public void myfaqs()
    {
        lstFAQs= new list<FAQ__c>(); 
        lstFAQs=[select id,Topic__c,Answer__c,SortOrder__c,name from FAQ__c where Topic__c='SAP Application' ORDER BY SortOrder__c ASC];
    }
    
    public PageReference submitCase()
    {
        String recordType = Label.SAP_Case_Record_Type;
        sapCase.RecordTypeId =Schema.Sobjecttype.ONTAP__Case_Force__c.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        try{
            insert sapCase;
        }catch(Exception e){
            system.debug('Dml Exception');
        }
        system.debug(sapCase+'sapCase');
        sapCase = new ONTAP__Case_Force__c();
        return null;
    }
}