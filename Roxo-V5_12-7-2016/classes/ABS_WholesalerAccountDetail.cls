/*Apex class:ABS_WholesalerAccountDetail 
Description:This class is developed Poc's records on the ABS_WholesalerAccountDetail Page
This Controller is used in ABS_WholesalerAccountDetail Page
Created By :Deepthi Toranala
Created Date:5/30/2016
Modified Date:
Modified By:Deepthi
*/
global class ABS_WholesalerAccountDetail{
    
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
    public static string usrProfileName;
    public static boolean isMatch;
    public static boolean viewByProfile{get;set;}
    public datetime dataloaderDate{get;set;}
    public US_Account_Target_Program__c dataloader;
    public String pageName='';// holds the page name 
    public static string Filters='';
    public list<US_Account_Target_Program__c> lstAccTarget;// list hold US_Account_Target_Program__c records which displays on the page 
    public static pocAccountWrapper pocWrap{get;set;}
    public static string accountpocId{get;set;}
    public list<FAQ__c> lstFAQs{get;set;}
    public ONTAP__Case_Force__c sapCase{get;set;}
    public static boolean OnPremise{get;set;}
    public static boolean OffPremise{get;set;}
    public static boolean MyRetailersTeam{get;set;}
    public List<SelectOption> milesOptions{get;set;}
    public static integer miles{get;set;}
    public ABS_WholesalerAccountDetail ()
    {
        size=20;
        miles=100;
        isMatch=false;
        viewByProfile=false;
        OnPremise=false;
        OffPremise=false;
        MyRetailersTeam=false;
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
        
        milesOptions = new list<SelectOption>();
        milesOptions.add(new SelectOption('100','100'));
        milesOptions.add(new SelectOption('200','200'));
        milesOptions.add(new SelectOption('300','300'));
        
        usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
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
        if(!Test.isRunningTest())
        {
            pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
        }
        
        if(Test.isRunningTest())
        {
            pageName='ABS_WholesalerAccountDetail';
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
            
        }
        sapCase = new ONTAP__Case_Force__c();
        myfaqs();
    }
    
    //Select Option for displaying permise value
    public List<selectOption> getChannelOptions() 
    {
        List<selectOption> chanelOptions= new List<selectOption>();
        Schema.DescribeFieldResult field = Account.RTL_SEG_NM_US__c.getDescribe();
        List<Schema.PicklistEntry> ple = field.getPicklistValues();
        chanelOptions.add(new SelectOption('None','None'));
        for (Schema.PicklistEntry f : ple )
        {
            chanelOptions.add(new SelectOption(f.getLabel(),f.getvalue()));
        }
        return chanelOptions; //return the picklist options
    }
    
    @RemoteAction
    global static List<AccountTargetWrapper> findPocs(Decimal geolat, Decimal geolong,boolean retailersTeams,boolean OnPremises,boolean OffPremises,string myChannel,String recSize,string targetAchievements,boolean isFilteradded,string recMiles) 
    {
        usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        string ABS_Profiles=Label.ABS_Profiles;
        list<String> listProfiles = ABS_Profiles.split(',');
        list<string> premises = new list<string>();
        MyRetailersTeam=false;
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
        system.debug(retailersTeams );
        if(retailersTeams == true && isFilteradded == true)
        {
            retailer ='My Retailers';
        }else if(retailersTeams == false && isFilteradded == true){
            retailer ='All Retailers';
        }
        system.debug(retailer);
        if(OnPremises == true)
        {
            premises.add('On Premise');
        }
        if(OffPremises == true)
        {
            //premises.add('OFF-PREMISE');
            premises.add('Small Format');
        }
        system.debug(premises);
        if(channel !='')
            channel=myChannel;
        if(targetAchievements != '')
            ClosetoTargetAchievement=targetAchievements;
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
        system.debug(miles+'********miles*****');   
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
        system.debug(alat);
        system.debug(along);     
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
        system.debug('retailer=='+retailer);
        system.debug('Premise=='+Premise);
        system.debug('channel=='+channel);
        system.debug('ClosetoTargetAchievement=='+ClosetoTargetAchievement);
        system.debug('size=='+size);
        if(retailer =='My Retailers')
        {
            Filters='My Retailers';
            system.debug(retailer+'Entred test');
            queryParameters='SELECT Id,Name,BillingLatitude,BillingLongitude,SAP_Channel__c,RTL_SEG_NM_US__c'+
                            ' FROM Account WHERE Id IN :accountIds And (BillingLatitude!= null And BillingLatitude!= 0) AND recordtype.Name = \'Poc\''+ 
                            ' and Account_Targets_Count__c >0 and DISTANCE(Location__c, GEOLOCATION(:alat,:along), \'mi\') <';
        
        }else 
        {    
            Filters='All Retailers';
            system.debug(retailer+'Entred else====');
            queryParameters='SELECT Id,Name,BillingLongitude,SAP_Channel__c,RTL_SEG_NM_US__c,'+
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
                  relatedIds.add(rAcc.id);
                  mapAccount.put(rAcc.id,rAcc);
              }
        }
        // Mapping of accTarget
        list<US_Account_Target_Program__c> accTarget =[select Achieved_Targets__c,Panel_Display__c,Pannel_Color__c,Count_of_SKUs__c,Program_Target_Level__c,Account__c,Brand_Category__c from US_Account_Target_Program__c where Account__c In :relatedIds and Brand_Category__c  IN('CORE','HE','High End','AL-DR','FMB','FeaturesDisplays','PromOpti','Bud Club','3D')];
        
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
                        boolean iscore=false;
                        boolean isFMB=false;
                        boolean isHighEnd=false;
                        string core='';
                        string highEnd='';
                        string fmb='';
                        id accountId;
                        string colorCore;
                        string colorHighEnd;
                        string colorFmb;
                        string pgmCore;
                        string pgmHighEnd;
                        string pgmFmb;
                        account pocAccount;
                        string featureDisplay;
                        string colorFeatureDisplay;
                        string pgmFeatureDisplay;
                        string promOpti;
                        string colorPromOpti;
                        string pgmPromOpti;
                        string budlight;
                        string colorBudlight;
                        string pgmBudlight;
                        string three;
                        string colorThree;
                        string pgmThree;
                        boolean isfeatureDisplay=false;
                        boolean ispromOpti=false;
                        boolean isbudlight=false;
                        boolean is3d=false; 
                        for(US_Account_Target_Program__c objAccProgram:lstAccProgram)
                        {
                            if(objAccProgram.Brand_Category__c=='CORE')
                            {
                                //core=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                                //colorCore=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                                core=objAccProgram.Panel_Display__c;
                                colorCore=objAccProgram.Pannel_Color__c;
                                accountId=objAccProgram.Account__c;
                                iscore=true;
                                pgmCore=string.valueof(objAccProgram.Program_Target_Level__c);
                             }
                             if(objAccProgram.Brand_Category__c=='HE' || objAccProgram.Brand_Category__c=='High End')
                             {
                                 //highEnd=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                                 //colorHighEnd=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                                 highEnd=objAccProgram.Panel_Display__c;
                                 colorHighEnd=objAccProgram.Pannel_Color__c;
                                 accountId=objAccProgram.Account__c;
                                 isHighEnd=true;
                                 pgmHighEnd=string.valueof(objAccProgram.Program_Target_Level__c);
                             }
                             if(objAccProgram.Brand_Category__c=='FMB')
                             {
                                 //fmb=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                                 //colorFmb=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                                 fmb=objAccProgram.Panel_Display__c;
                                 colorFmb=objAccProgram.Pannel_Color__c;
                                 accountId=objAccProgram.Account__c;
                                 isFMB=true;
                                 pgmFmb=string.valueof(objAccProgram.Program_Target_Level__c);
                             }
                             if(objAccProgram.Brand_Category__c=='FeaturesDisplays')
                             {
                                //colorFeatureDisplay=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                                featureDisplay=objAccProgram.Panel_Display__c;
                                colorFeatureDisplay=objAccProgram.Pannel_Color__c;
                                isfeatureDisplay=true;
                                pgmFeatureDisplay=string.valueof(objAccProgram.Program_Target_Level__c);
                             }
                             if(objAccProgram.Brand_Category__c=='PromOpti')
                             {
                                promOpti=objAccProgram.Panel_Display__c;
                                colorPromOpti=objAccProgram.Pannel_Color__c;
                                ispromOpti=true;
                                pgmPromOpti=string.valueof(objAccProgram.Program_Target_Level__c);
                             }
                             if(objAccProgram.Brand_Category__c=='Bud Club')
                             {
                                budlight=objAccProgram.Panel_Display__c;
                                colorBudlight=objAccProgram.Pannel_Color__c;
                                isbudlight=true;
                                pgmBudlight=string.valueof(objAccProgram.Program_Target_Level__c);
                             }
                             if(objAccProgram.Brand_Category__c=='3D')
                             {
                                three=objAccProgram.Panel_Display__c;
                                colorThree=objAccProgram.Pannel_Color__c;
                                is3d=true;
                                pgmThree=string.valueof(objAccProgram.Program_Target_Level__c);
                             }
                        }
                        if((iscore || isHighEnd || isFMB) && lstAccProgram.size()>0 )
                        {
                            AccountTargetWrapper objTraWrap = new AccountTargetWrapper();
                            if(iscore)
                            {
                               objTraWrap.Core=Core;
                               objTraWrap.colorCore=colorCore;
                               objTraWrap.pgmCore=pgmCore;
                               objTraWrap.isCore =iscore;
                            }
                            if(isHighEnd)
                            {
                               objTraWrap.HighEnd=highEnd;
                               objTraWrap.colorHighEnd=colorHighEnd;
                               objTraWrap.pgmHighEnd=pgmHighEnd;
                               objTraWrap.isHighEnd=isHighEnd;
                            }
                            if(isFMB)
                            {
                               objTraWrap.FMB=FMB;
                               objTraWrap.colorFmb=colorFmb;
                               objTraWrap.pgmFmb=pgmFmb;
                               objTraWrap.isFMB=isFMB;
                            }
                            if(iscore && isHighEnd==false && isFMB== false)
                            {
                                if(objTraWrap.colorCore=='Greencircle')
                                {
                                    objTraWrap.mappinColor='green-dot.png';
                                }else if(objTraWrap.colorCore=='Redcircle')
                                {
                                    objTraWrap.mappinColor='red-dot.png';
                                }else
                                {
                                    objTraWrap.mappinColor='red-dot.png';
                                }
                           
                            }else if(iscore && isHighEnd && isFMB)
                            {
                                if(objTraWrap.colorCore=='Greencircle' &&  objTraWrap.colorFmb =='Greencircle' &&  objTraWrap.colorHighEnd == 'Greencircle' )
                                {
                                    objTraWrap.mappinColor='green-dot.png';
                        
                                }else if(objTraWrap.colorCore=='Redcircle' && objTraWrap.colorFmb=='Redcircle' && objTraWrap.colorHighEnd == 'Redcircle')
                                {
                                     objTraWrap.mappinColor='red-dot.png';
                                }else{
                                
                                      objTraWrap.mappinColor='red-dot.png';
                                }
                            
                            }
                            objTraWrap.id=recId;
                            objTraWrap.userName=currentuser.name;
                            objTraWrap.userlat=alat;
                            objTraWrap.userlong=along;
                            objTraWrap.mapUrl='/apex/ABS_PocAccountDetaiLPage?id='+recId;
                            objTraWrap.pocAccount=mapAccount.get(recId);
                            objTraWrap.Filter=Filters;
                            if(isfeatureDisplay)
                            {
                                objTraWrap.featureDisplay=featureDisplay;
                                objTraWrap.colorFeatureDisplay=colorFeatureDisplay;
                                objTraWrap.pgmFeatureDisplay=pgmFeatureDisplay;
                            }
                            if(ispromOpti)
                            {
                                objTraWrap.promOpti=promOpti;
                                objTraWrap.colorPromOpti=colorPromOpti;
                                objTraWrap.pgmPromOpti=pgmPromOpti;
                            }
                            if(isbudlight)
                            {
                                objTraWrap.budlight=budlight;
                                objTraWrap.colorBudlight=colorBudlight;
                                objTraWrap.pgmBudlight=pgmBudlight;
                            }
                            if(is3d)
                            {
                                objTraWrap.three=three;
                                objTraWrap.colorThree=colorThree;
                                objTraWrap.pgmThree=pgmThree;
                            }
                            system.debug(objTraWrap);
                            accountList.add(objTraWrap);
                            lstAccProgram.clear();
                             
                         }
                         
                       
                    } 
                } 
            }
        }
        
        return accountList;
    }
    public static string accountColor(Integer Achieved_Targets,Integer Program_Target_Level)
    {
         string color='';
         if((Achieved_Targets > 0 ) && (Achieved_Targets >=  Program_Target_Level))
         {
            color='Greencircle';
         }else if((Achieved_Targets > 0 ) &&  (Achieved_Targets  < Program_Target_Level))
         {
            color='Redcircle';
            //color='Yellowcircle';

         }else if(Achieved_Targets == 0)
         {
            color='Redcircle';
         }
         return color;
    }
    
    public static list<US_Account_Target_Program__c> lstPocAccTarget{get;set;}
    public static map<string,string> mapImages{get;set;}
    public static map<string,Integer> BrandSize{get;set;}
    public static string ChkMapKey{get;set;} //string to convert map key into string
    public static string userLats{get;set;}
    public static string userLongs{get;set;}
    public static list<US_Account_Target__c> lstAccountTarget{get;set;}//intialize
    public static list<string> assortmentList{get;set;}
    public static list<string> executionList{get;set;}
    public static map<string,string> mapdiv{get;set;}
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
                                    SAP_Channel__c,buzz_retail__lat__c FROM Account WHERE id=:accountpocId LIMIT 1];
        }
        // formating the string to display on the map to remove (')
        if(pocWrap.objPocAccount != null)
        
        {
            pocWrap.pocName=pocWrap.objPocAccount.name.replace('\'','\\\'');        
        }
        //query which gets Account Traget Programs
        if(pocWrap.objPocAccount != null)
        {
            lstPocAccTarget=[select Achieved_Targets__c,Program_Target_Level__c,Account__c,Brand_Category__c,GSC_Link__c,
                             Count_of_SKUs__c,Panel_Display__c,Pannel_Color__c,KPI_Group_Seq__c,Brand_Cat_Seq__c,GSC_Url__c from 
                             US_Account_Target_Program__c where Account__c =:pocWrap.objPocAccount.id and Brand_Category__c  
                             IN('CORE','HE','High End','FMB','FeaturesDisplays','PromOpti','Bud Club','3D')];
        }
        // query to retrive Account Targets
        if(pocWrap.objPocAccount != null)
        {
            lstAccountTarget=[select Brand_Package__c,Acheivement_Score__c,id,Account__c,Brand_Category__c,FULL_TXT__c,
                              SKU__c,Num__c,Denom__c from US_Account_Target__c where Account__c=:pocWrap.objPocAccount.id 
                              and Brand_Category__c  IN('CORE','HE','High End','FMB','FeaturesDisplays','PromOpti','Bud Club','3D')];
        }
        if(!lstAccountTarget.isEmpty())
        {
            for(US_Account_Target__c lstTargets:lstAccountTarget)
            {
                if(mapUsTarget.containsKey(lstTargets.Brand_Category__c))
                {
                    list<US_Account_Target__c > Target = mapUsTarget.get(lstTargets.Brand_Category__c);
                    Target.add(lstTargets);
                    mapUsTarget.put(lstTargets.Brand_Category__c,Target);
                }else{
                    mapUsTarget.put(lstTargets.Brand_Category__c,new list<US_Account_Target__c >{lstTargets});

                }
            }
        }
        
        BrandSize = new map<string,Integer>();
        BrandSize.put('CORE',0);
        BrandSize.put('HE',0);
        BrandSize.put('High End',0);
        BrandSize.put('FMB',0);
        BrandSize.put('FeaturesDisplays',0);
        BrandSize.put('PromOpti',0);
        BrandSize.put('Bud Club',0);
        BrandSize.put('3D',0);
        
        mapdiv.put('CORE','noneCore');
        mapdiv.put('High End','nonehighEnd');
        mapdiv.put('FMB','noneCore');
        mapdiv.put('FeaturesDisplays','noneFeaturesDisplays');
        mapdiv.put('PromOpti','nonePromOpti');
        mapdiv.put('Bud Club','noneBudClub');
        mapdiv.put('3D','none3d');
        if(!mapUsTarget.isEmpty())
        {
            for(string Brand:mapUsTarget.KeySet())
            {
                 list<US_Account_Target__c > Target = mapUsTarget.get(Brand);
                 BrandSize.put(Brand,Target.size());
            }
        }
         // to get the sku brand names
        if(lstAccountTarget.size() > 0)
        {
            for(US_Account_Target__c acctarget:lstAccountTarget)
            {
                setBrand.add(acctarget.SKU__c);
            }
        }
        // query which pulls sku brand Images
        if(!setBrand.isEmpty())
        {
            lstSkuBrand=[select Name,Sku_Image_Id__c from SKU_Brand_Image__c where name IN :setBrand];
        }
        
        if(!lstSkuBrand.isEmpty())
        {
            for(SKU_Brand_Image__c brand:lstSkuBrand)
            {
                string imageURL='/servlet/servlet.FileDownload?file=';
                mapImages.put(brand.Name,imageURL+brand.Sku_Image_Id__c);
                
            }
        }
        pocWrap.isPocCore=false;
        pocWrap.isPocHighEnd=false;
        pocWrap.isPocFmb=false;
        assortmentList = new list<string>();
        executionList= new list<string>();
       
        // Prepare Core,He,fmb,alnr and drft data to display on the page
        if(!lstPocAccTarget.isEmpty() && lstPocAccTarget.size()>0)
        {
            for(US_Account_Target_Program__c objAccProgram:lstPocAccTarget)
            {
                system.debug(objAccProgram);
                if(objAccProgram.Brand_Category__c=='CORE')
                {
                    //pocWrap.pocCore=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                    //pocWrap.colorPocCore=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                    pocWrap.pocCore=objAccProgram.Panel_Display__c;
                    pocWrap.colorPocCore=objAccProgram.Pannel_Color__c;
                    pocWrap.isPocCore=true;
                    integer seq1=0;
                    integer seq2=0;
                    integer seq3=0;
                    seq1=integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0);
                    seq2=integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                    seq3=seq1+seq2;
                    assortmentList.add('core'+pocWrap.objPocAccount.id+'poc'+seq3);
                    mapdiv.put('CORE','core'+pocWrap.objPocAccount.id+'poc'+seq3);
                }
                if(objAccProgram.Brand_Category__c=='HE' || objAccProgram.Brand_Category__c=='High End')
                {
                    //pocWrap.pocHighEnd=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                    //pocWrap.colorPocHighEnd=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                    pocWrap.pocHighEnd=objAccProgram.Panel_Display__c;
                    pocWrap.colorPocHighEnd=objAccProgram.Pannel_Color__c;
                    pocWrap.isPocHighEnd=true;
                    integer seq1=0;
                    integer seq2=0;
                    integer seq3=0;
                    seq1=integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0);
                    seq2=integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                    seq3=seq1+seq2;
                    assortmentList.add('he'+pocWrap.objPocAccount.id+'poc'+seq3);
                    mapdiv.put('High End','he'+pocWrap.objPocAccount.id+'poc'+seq3);
                }
                if(objAccProgram.Brand_Category__c=='FMB')
                {
                    //pocWrap.pocFmb=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                    //pocWrap.colorPocFmb=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                    pocWrap.pocFmb=objAccProgram.Panel_Display__c;
                    pocWrap.colorPocFmb=objAccProgram.Pannel_Color__c;
                    pocWrap.isPocFmb=true;
                    integer seq1=0;
                    integer seq2=0;
                    integer seq3=0;
                    seq1=integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0);
                    seq2=integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                    seq3=seq1+seq2;
                    assortmentList.add('fmb'+pocWrap.objPocAccount.id+'poc'+seq3);
                    mapdiv.put('FMB','fmb'+pocWrap.objPocAccount.id+'poc'+seq3);
                }
                if(objAccProgram.Brand_Category__c=='FeaturesDisplays')
                {
                    pocWrap.pocfeatureDisplay=objAccProgram.Panel_Display__c;
                    pocWrap.poccolorFeatureDisplay=objAccProgram.Pannel_Color__c;
                    pocWrap.ispocpromOpti=true;
                    integer seq1=0;
                    integer seq2=0;
                    integer seq3=0;
                    seq1=integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0);
                    seq2=integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                    seq3=seq1+seq2;
                    executionList.add('feat'+pocWrap.objPocAccount.id+'poc'+seq3);
                    mapdiv.put('FeaturesDisplays','feat'+pocWrap.objPocAccount.id+'poc'+seq3);
                    pocWrap.gscLinkfeat=objAccProgram.GSC_Link__c;
                    pocWrap.gscurlfeat=objAccProgram.GSC_Url__c;
                }
                if(objAccProgram.Brand_Category__c=='PromOpti')
                {
                    pocWrap.pocpromOpti=objAccProgram.Panel_Display__c;
                    pocWrap.poccolorPromOpti=objAccProgram.Pannel_Color__c;
                    pocWrap.ispocbudlight=true;
                    integer seq1=0;
                    integer seq2=0;
                    integer seq3=0;
                    seq1=integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0);
                    seq2=integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                    seq3=seq1+seq2;
                    executionList.add('promopti'+pocWrap.objPocAccount.id+'poc'+seq3);
                    mapdiv.put('PromOpti','promopti'+pocWrap.objPocAccount.id+'poc'+seq3);
                    pocWrap.gscLinkpromopt=objAccProgram.GSC_Link__c;
                    pocWrap.gscurlpromopt=objAccProgram.GSC_Url__c;
                    
                }
                if(objAccProgram.Brand_Category__c=='Bud Club')
                {
                    pocWrap.pocbudlight=objAccProgram.Panel_Display__c;
                    pocWrap.poccolorBudlight=objAccProgram.Pannel_Color__c;
                    pocWrap.ispocbudlight=true;
                    integer seq1=0;
                    integer seq2=0;
                    integer seq3=0;
                    seq1=integer.valueof(objAccProgram.KPI_Group_Seq__c != null ?objAccProgram.KPI_Group_Seq__c:0);
                    seq2=integer.valueof(objAccProgram.Brand_Cat_Seq__c!= null?objAccProgram.Brand_Cat_Seq__c:0);
                    seq3=seq1+seq2;
                    executionList.add('bud'+pocWrap.objPocAccount.id+'poc'+seq3);
                    mapdiv.put('Bud Club','bud'+pocWrap.objPocAccount.id+'poc'+seq3);
                    pocWrap.gscLinkbud=objAccProgram.GSC_Link__c;
                    pocWrap.gscurlbud=objAccProgram.GSC_Url__c;
                }
                if(objAccProgram.Brand_Category__c=='3D')
                {
                    pocWrap.pocFmb=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                    pocWrap.colorPocFmb=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                    pocWrap.ispocthree=true;
                    pocWrap.gscLinkthree=objAccProgram.GSC_Link__c;
                    pocWrap.gscurlthree=objAccProgram.GSC_Url__c;
                   
                }
             
            }
            if(pocWrap.isPocCore && pocWrap.isPocHighEnd && pocWrap.isPocFmb)
            {
                if(pocWrap.colorPocCore== 'Greencircle' && pocWrap.colorPocHighEnd =='Greencircle' &&  pocWrap.colorPocFmb=='Greencircle')
                {
                    pocWrap.mapPocPinColor='green-dot.png';
                    
                }else if(pocWrap.colorPocCore== 'Redcircle' && pocWrap.colorPocHighEnd =='Redcircle' &&  pocWrap.colorPocFmb=='Redcircle'){
                    
                    pocWrap.mapPocPinColor='red-dot.png';
                    
                }else{
                    //pocWrap.mapPocPinColor='yellow-dot.png';
                     pocWrap.mapPocPinColor='red-dot.png';
                }
            }
            if(pocWrap.isPocCore && pocWrap.isPocHighEnd==false && pocWrap.isPocFmb==false)
            {
                if(pocWrap.colorPocCore=='Greencircle')
                {
                    pocWrap.mapPocPinColor='green-dot.png';
                    
                }else if(pocWrap.colorPocCore=='Redcircle'){
                    
                    pocWrap.mapPocPinColor='red-dot.png';
                    
                }else{
                    //pocWrap.mapPocPinColor='yellow-dot.png';
                    pocWrap.mapPocPinColor='red-dot.png';
                }
             }
        }
       
       // Converting a map keyvalue into a string.
       ChkMapKey = ''; 
       if(mapImages.size() > 0)
       {    
            for(string strKey : mapImages.keyset())
            {
                ChkMapKey+=strKey;
            }
       }
       
    }
    
    // Sap score wrapper class.
    global class AccountTargetWrapper
    {
       public boolean isCore {get;set;}
       public boolean isFMB{get;set;}
       public boolean isHighEnd{get;set;}
       public string  id {get;set;}
       public string Core {get;set;}
       public string HighEnd {get;set;}
       public string FMB {get;set;}
       public string colorCore{get;set;}
       public string colorHighEnd{get;set;}
       public string colorFmb{get;set;}
       public string pgmCore{get;set;}
       public string pgmHighEnd{get;set;}
       public string pgmFmb{get;set;}
       public account pocAccount{get;set;}
       public string mappinColor{get;set;}
       public string mapUrl{get;set;}
       public string userName{get;set;}
       public Decimal userlat{get;set;}
       public Decimal userlong{get;set;}
       public string Filter{get;set;}
       public string featureDisplay{get;set;}
       public string colorFeatureDisplay{get;set;}
       public string pgmFeatureDisplay{get;set;}
       public string promOpti{get;set;}
       public string colorPromOpti{get;set;}
       public string pgmPromOpti{get;set;}
       public string budlight{get;set;}
       public string colorBudlight{get;set;}
       public string pgmBudlight{get;set;}
       public string three{get;set;}
       public string colorThree{get;set;}
       public string pgmThree{get;set;}
    }
    
    global class pocAccountWrapper
    {
        public string pocName{get;set;}
        
        public Account objPocAccount{get;set;}
        public string pocCore{get;set;}     
        public string pocHighEnd{get;set;}
        public string pocFmb{get;set;}
        public boolean isPocCore{get;set;}
        public boolean isPocHighEnd{get;set;}
        public boolean isPocFmb{get;set;}
        public string colorPocCore{get;set;}
        public string colorPocHighEnd{get;set;}
        public string colorPocFmb{get;set;}
        public string mapPocPinColor{get;set;}
        public decimal palat{get;set;}
        public decimal palon{get;set;}
        public string pocfeatureDisplay{get;set;}
        public string poccolorFeatureDisplay{get;set;}
        public boolean ispoccolorFeatureDisplay{get;set;}
        public string pocpromOpti{get;set;}
        public string poccolorPromOpti{get;set;}
        public boolean ispocpromOpti{get;set;}
        public string pocbudlight{get;set;}
        public string poccolorBudlight{get;set;}
        public boolean ispocbudlight{get;set;}
        public string pocthree{get;set;}
        public string poccolorThree{get;set;}
        public boolean ispocthree{get;set;}
        public integer pocseqcore{get;set;}
        public boolean gscLinkfeat{get;set;}
        public boolean gscLinkbud{get;set;}
        public boolean gscLinkpromopt{get;set;}
        public boolean gscLinkthree{get;set;}
        public string gscurlfeat{get;set;}
        public string gscurlbud{get;set;}
        public string gscurlpromopt{get;set;}
        public string gscurlthree{get;set;}


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
        insert sapCase;
        string url=ApexPages.currentPage().getUrl();
        String appendUrl =url.removeStart('/apex/ABS_FAQs');
        PageReference pageRef = new PageReference('/apex/ABS_WholesalerAccountDetail'+appendUrl);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
}