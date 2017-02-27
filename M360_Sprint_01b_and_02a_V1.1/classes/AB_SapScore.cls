/*Author: Deepthi*/
/*this class is Support class for */
/*test class: Test_ABS_SAP_Score*/
@RestResource(urlMapping='/AB_SapScore/*')
global with sharing class AB_SapScore{
    
    @HttpPost //Method name
     // Sending Account Details and its key decision maker contact details to the External system.
     
    global static ResponseWrapper AB_SapScore(string accountId)
    {

        string strReturn=''; //Holds the return message to be sent as response
        Integer isSuccessRes; //Holds success status '0' or '1'
        list<wrapAtrec> wraptarget = new list<wrapAtrec>();
        pocAccountWrapper pocWrap= new pocAccountWrapper();
        try
        {
            //decimal geolat=0.0;
            //decimal geolong=0.0;
            
            list<US_Account_Target__c> lstAccountTarget = new list<US_Account_Target__c>();//intialize
            map<string,string> mapdiv = new map<string,string>();
            
            user poccurrentuser=[Select Id,Name,Email,Latitude,Longitude from User where Id=:userinfo.getuserId()];
            /*if(geolat !=null && geolong !=null && (geolat !=0 && geolong !=0)){
                pocWrap.palat=geolat;
                pocWrap.palon=geolong;
            }else{
                if(poccurrentuser!= null && poccurrentuser.Latitude != null)
                {
                    pocWrap.palat=poccurrentuser.Latitude;
                    pocWrap.palon=poccurrentuser.Longitude;
                }
            }*/
            list<US_Account_Target_Program__c> lstPocAccTarget= new list<US_Account_Target_Program__c>();//intialize
            map<string,string> mapImages = new map<string,string>();//intialize
            set<string> setBrand = new set<string>();// hold brand name to map images
            list<SKU_Brand_Image__c> lstSkuBrand =new list<SKU_Brand_Image__c>();
            map<string,list<US_Account_Target__c >> mapUsTarget = new  map<string,list<US_Account_Target__c >>();
            
            
            // query which gets the poc record from the url parameter id.
            if(accountId!='')
            {   
                
                pocWrap.objPocAccount =[SELECT Id,Name,BillingLongitude,BillingLatitude,BillingStreet,BillingState,WSLR_NBR_US__c,
                                        Wholesaler__r.name,Phone,BillingCity,BillingCountry,BillingPostalCode,buzz_retail__lon__c,
                                        SAP_Channel__c,SAP_Color__c,buzz_retail__lat__c FROM Account WHERE id=:accountId LIMIT 1];
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
                                 KPI_Measurement__c from US_Account_Target_Program__c where Account__c =:pocWrap.objPocAccount.id and Brand_Category__c !=null];
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
                    //string imageURL='/servlet/servlet.FileDownload?file=';
                    string imageURL = label.AB_Brand_Image_Url+'?id=';
                    String orgId = UserInfo.getOrganizationId();
                    mapImages.put(brand.Name,imageURL+brand.Sku_Image_Id__c+'&oid='+orgId);
                }
            }
            
            map<string,datetime> mapDataLoad = new  map<string,datetime>();
            AggregateResult[] groupedResult =[Select Brand_Category_Text__c,max(lastmodifieddate) 
                                              from US_Account_Target_Program__c where Brand_Category_Text__c != null and  Account__c=:accountId group by Brand_Category_Text__c];
            for(AggregateResult d:groupedResult){
                string bCat=(string)d.get('Brand_Category_Text__c');
                mapDataLoad.put(bCat.toLowerCase(),(datetime)d.get('expr0'));
            }
            system.debug(mapDataLoad);
            // Prepare Core,He,fmb,alnr and drft data to display on the page
            
            list<AccountTargetBrandWrapper> lstATseq1 = new list<AccountTargetBrandWrapper>();
            list<AccountTargetBrandWrapper> lstATseq2 = new list<AccountTargetBrandWrapper>();
            
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
                    //obj.pgmTrgtLvl =string.valueof(objAccProgram.Program_Target_Pop_Up__c);
                    obj.Pannelvalue=objAccProgram.Pannel_Value__c;
                    obj.AtpId=objAccProgram.id;
                    obj.gscChecked=objAccProgram.GSC_Link__c;
                    obj.gscurl=objAccProgram.GSC_Url__c;
                    if(objAccProgram.Brand_Category__c != null)
                        obj.brandCategory=objAccProgram.Brand_Category__c;
                    //obj.KpiMeasurment=objAccProgram.KPI_Measurement__c !=''?objAccProgram.KPI_Measurement__c:'';
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
                        lstATseq1.add(obj);
                    if (obj.grpSeq  == 2)
                        lstATseq2.add(obj);
                }
            }
            lstATseq1.sort();
            lstATseq2.sort();
           
            pocWrap.lstSeq1=lstATseq1;
            pocWrap.lstSeq2=lstATseq2;
            system.debug(pocWrap);
            //list<wrapAtrec> wraptarget = new list<wrapAtrec>();
            for(US_Account_Target__c at:lstAccountTarget)
            {
                wrapAtrec ats= new wrapAtrec();
                if(at.Acheivement_Score__c != null)
                    ats.achivemnetScore=string.valueof(at.Acheivement_Score__c);
                if(at.FULL_TXT__c != null)
                    ats.fulltext=at.FULL_TXT__c;
                if(!mapImages.isEmpty())
                {
                    string image='';
                    if(mapImages.get(at.SKU__c) != null)
                        image=mapImages.get(at.SKU__c);
                    ats.Imageurl=image;
                }
                if(at.Bonus__c != null)
                    ats.bonus=at.Bonus__c;
                if(at.Brand_Category__c != null)
                    ats.brandCat=at.Brand_Category__c;
                if(at.Num__c != null)
                    ats.Num=string.valueof(at.Num__c);
                if(at.Denom__c != null)
                    ats.Denom=string.valueof(at.Denom__c);
                if(at.Sap_color__c != null)
                    ats.SapColor=at.Sap_color__c;
                wraptarget.add(ats);
            }
            system.debug(wraptarget);
            strReturn = 'Success';
            isSuccessRes = 1;
        }
        catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,wraptarget,pocWrap);
        return obj;
    }
    
    // Sap score wrapper class.
    public class AccountTargetBrandWrapper implements Comparable
    {
        public string brandGrp = '';
        public string brandcat = '';
        public integer grpSeq = 0;
        public integer catSeq = 0;
        public string pannelColor = '';
        public string panelDisplay = '';
        public string accountId = '';
        //public string pgmTrgtLvl = '';
        public integer KPIGrpSeq = 0;
        public integer brandCatSeq = 0;
        //public string mappinColor = '';
        //public string userName = '';
        //public string userlat = '';
        //public string userlong = '';
        //public string mapUrl = '';
        //public account pocAccount{get;set;}
        //public string ATBcolor = '';
        //public String recId = '';
        //public string Filter = '';
        public string Pannelvalue = '';
        public string AtpId = '';
        public string gscurl = '';
        public boolean gscChecked;
        public string brandCategory = '';
        //public string KpiMeasurment = '';
        public string dataLoaddate = '';
       
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
    
    public class pocAccountWrapper
    {
        public string pocName{get;set;}
        public Account objPocAccount{get;set;}
        public string mapPocPinColor{get;set;}
        //public decimal palat{get;set;}
        //public decimal palon{get;set;}
        public list<AccountTargetBrandWrapper> lstSeq1{get;set;}
        public list<AccountTargetBrandWrapper> lstSeq2{get;set;}
    }
    public class wrapAtrec{
        public string achivemnetScore = '';
        public string fulltext = '';
        public string Imageurl = '';
        public string bonus = '';
        public string brandCat = '';
        public string Num = '';
        public string Denom = '';
        public string SapColor = '';
    } 
    
    global class ResponseWrapper
    {
        public integer isSuccess {get;set;}//Holds the success status 0 or 1
        public String Message {get;set;}//Holds the return message
        public list<wrapAtrec> Scores {get;set;}
        public pocAccountWrapper PocAccount {get;set;} 
        public ResponseWrapper(integer isSuccess,String Message,list<wrapAtrec> Scores,pocAccountWrapper PocAccount)
        {
            this.isSuccess =isSuccess;
            this.Message = Message;
            this.Scores = Scores;
            this.PocAccount = PocAccount;
        }
    }
}