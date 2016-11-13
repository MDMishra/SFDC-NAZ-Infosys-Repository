public class ABS_SapScore{

    public list<AccountTargetWrapper> TargetWrapperRecords;
    public list<ProductImagesWrapper> ProductRecords;
    public map<string,string> mapImages{get;set;} // map to display images on vf page
    public string sapScore(list<string> accountIds)
    {
        TargetWrapperRecords = new list<AccountTargetWrapper>();
        ProductRecords = new list<ProductImagesWrapper>();
        //map<id,string> mapSapColor = new map<id,string>();//Holds US_Account_Target_Program__c.Account__c and US_Account_Target_Program__c.Account__r.SAP_Color__c
        map<id,list<US_Account_Target_Program__c>> mapUsTarget = new map<id,list<US_Account_Target_Program__c>>();
        map<id,list<US_Account_Target__c>> mapUsAccTarget = new map<id,list<US_Account_Target__c>>();

        // Mapping of accTarget
        system.debug(accountIds.size());
        list<US_Account_Target_Program__c> accTarget =[select Achieved_Targets__c,Count_of_SKUs__c,Program_Target_Level__c,
                                                       Account__c,Brand_Category__c,Account__r.CORP_ON_OFF_PREMIS_CD_US__c,
                                                       Account__r.RTL_SEG_NM_US__c,Account__r.Name,Account__r.SAP_Color__c,
                                                       Account__r.SAP_Channel__c from US_Account_Target_Program__c                                                      
                                                       where Account__c In :accountIds and Brand_Category__c  
                                                       IN('CORE','HE','High End','FMB') order by Account__r.Name asc];
        
        list<US_Account_Target__c> lstAccountTarget=[select Brand_Package__c,Acheivement_Score__c,id,Account__c,
                                                     Brand_Category__c,SKU__c from US_Account_Target__c 
                                                     where Account__c In :accountIds and Brand_Category__c  
                                                     IN('CORE','HE','High End','FMB')];
        
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
                /*if(!mapSapColor.containsKey(us.Account__c)){
                    mapSapColor.put(us.Account__c,us.Account__r.SAP_Color__c);
                }*/
            }
        }
        //system.debug(mapSapColor.size());
        // Creating Map for  US_Account_Target_Program__c===========================================
        if(lstAccountTarget.size() > 0) 
        {
            for(US_Account_Target__c us:lstAccountTarget )
            {
                if(mapUsAccTarget.containsKey(us.Account__c)) 
                {
                    List<US_Account_Target__c> accProgram= mapUsAccTarget.get(us.Account__c);
                    accProgram.add(us);
                    mapUsAccTarget.put(us.Account__c, accProgram);
                }else {
                    mapUsAccTarget.put(us.Account__c, new List<US_Account_Target__c> {us});
                }
            }
        }
        
        system.debug('mapUsAccTarget====================='+mapUsAccTarget);
        //system.debug('accTarget.size()=='+accTarget.size()); 
         
         
                           
         // to get the sku brand names start***************************************************************************************
        set<string> setBrand = new set<string>();// hold brand name to map images
        list<SKU_Brand_Image__c> lstSkuBrand =new list<SKU_Brand_Image__c>();
         mapImages = new map<string,string>();//intialize
        if(lstAccountTarget.size() > 0)
        {
            for(US_Account_Target__c acctargt:lstAccountTarget)
            {
                setBrand.add(acctargt.SKU__c);
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
                //https://naz--nazsapapp1--c.cs16.content.force.com/servlet/servlet.ImageServer?id=015f0000000Gp4X&oid=00Df0000003aGvnEAE                
                //string imageURL='/servlet/servlet.FileDownload?file=';
                //mapImages.put(brand.Name,imageURL+brand.Sku_Image_Id__c);
                String orgId = UserInfo.getOrganizationId();
                string imageURL='https://naz--nazsapapp1--c.cs16.content.force.com/servlet/servlet.ImageServer?id='+brand.Sku_Image_Id__c+'&oid='+orgId;               
                mapImages.put(brand.Name,imageURL);
            }
        }
        system.debug('lstAccountTarget=='+lstAccountTarget);
        system.debug('mapImages=='+mapImages);        
        // geting the sku brand names finish********************************************************************************************
        
        
               
        list<ProductImagesWrapper> lstProducts = new list<ProductImagesWrapper>();
        if(mapUsTarget.size() >0)
        {
            
            /*integer RedColorCount = 0;
            integer YellowColorCount = 0;
            integer GreenColorCount = 0;*/
            for(id recId:mapUsTarget.keyset())
            {
                List<US_Account_Target_Program__c> lstAccProgram = new List<US_Account_Target_Program__c>();
                List<US_Account_Target__c> lstAccTarget = new List<US_Account_Target__c>();
                //system.debug('mapUsAccTarget.get(recId)===================='+mapUsAccTarget.get(recId));
                if(!mapUsAccTarget.isEmpty() && mapUsAccTarget.get(recId) != null)
                {                                      
                    lstAccTarget =mapUsAccTarget.get(recId);
                    //system.debug('+++++++++++++++++++++++++++++'+lstAccTarget);
                    for(US_Account_Target__c objAcTrgt : lstAccTarget){
                        ProductImagesWrapper objProductWrap = new ProductImagesWrapper();
                        //system.debug('objAcTrgt.SKU__c=='+objAcTrgt.SKU__c);
                        if(!mapImages.isEmpty() && mapImages.get(objAcTrgt.SKU__c) != null)
                            objProductWrap.ProductImage = mapImages.get(objAcTrgt.SKU__c);
                        else
                            objProductWrap.ProductImage = '';
                        if(objAcTrgt.SKU__c != null)
                            objProductWrap.ProductName = objAcTrgt.SKU__c;
                        else
                            objProductWrap.ProductName = '';
                        if(objAcTrgt.Brand_Category__c != null)
                            objProductWrap.BrandCategory = objAcTrgt.Brand_Category__c;
                        else
                            objProductWrap.BrandCategory = '';
                        if(objAcTrgt.Brand_Package__c != null)
                            objProductWrap.BrandPackage = objAcTrgt.Brand_Package__c;
                        else
                            objProductWrap.BrandPackage = '';
                            
                        if(objAcTrgt.Acheivement_Score__c != null){
                            //system.debug('Acheivement_Score__c=='+objAcTrgt.Acheivement_Score__c);
                            if(objAcTrgt.Acheivement_Score__c >= 2)
                                objProductWrap.ColorCode = 'Green';
                            if(objAcTrgt.Acheivement_Score__c == 1)
                                objProductWrap.ColorCode = 'Yellow';
                            if(objAcTrgt.Acheivement_Score__c == 0)
                                objProductWrap.ColorCode = 'Red';                            
                        }
                        else
                            objProductWrap.ColorCode = 'No Color';
                        if(objAcTrgt.Account__c != null)
                            objProductWrap.AccountId = objAcTrgt.Account__c;
                        else
                            objProductWrap.AccountId = '';
                                                
                        ProductRecords.add(objProductWrap);
                    }
                    //system.debug('ProductRecords=='+ProductRecords);
                }
                //system.debug('objTraWrap.usTargetRecords=='+objTraWrap.usTargetRecords);
                if(!mapUsTarget.isEmpty() && mapUsTarget.get(recId) != null)
                {
                    lstAccProgram =mapUsTarget.get(recId);
                    if(!lstAccProgram.isEmpty() && lstAccProgram.size()>0)
                    {
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
                        string strName='';
                        string strPremise ='';
                        string strChannel ='';
                        string strSAPChannel ='';
                        string strSAPColor = '';
                        
                        for(US_Account_Target_Program__c objAccProgram:lstAccProgram)
                        {
                            if(objAccProgram.Brand_Category__c=='CORE')
                            {
                                core=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                                accountId=objAccProgram.Account__c;
                                colorCore=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                                pgmCore=string.valueof(objAccProgram.Program_Target_Level__c);
                              
                             }
                             if(objAccProgram.Brand_Category__c=='HE' || objAccProgram.Brand_Category__c=='High End')
                             {
                                 if(objAccProgram.Achieved_Targets__c != null && objAccProgram.Count_of_SKUs__c != null)
                                     highEnd=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                                 accountId=objAccProgram.Account__c;
                                 colorHighEnd=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                                 pgmHighEnd=string.valueof(objAccProgram.Program_Target_Level__c);
                              
                             }
                             if(objAccProgram.Brand_Category__c=='FMB')
                             {
                                 fmb=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                                 accountId=objAccProgram.Account__c;
                                 colorFmb=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                                 pgmFmb=string.valueof(objAccProgram.Program_Target_Level__c);
                              
                             }
                             
                             strName = objAccProgram.Account__r.name;
                             strPremise = objAccProgram.Account__r.CORP_ON_OFF_PREMIS_CD_US__c;
                             strChannel = objAccProgram.Account__r.RTL_SEG_NM_US__c;
                             if(objAccProgram.Account__r.SAP_Channel__c != null && objAccProgram.Account__r.SAP_Channel__c !='')
                                 strSAPChannel = objAccProgram.Account__r.SAP_Channel__c;  
                             else
                                 strSAPChannel = '';
                             if(objAccProgram.Account__r.SAP_Color__c != null){
                                 strSAPColor = objAccProgram.Account__r.SAP_Color__c;
                                 /*if(objAccProgram.Account__r.SAP_Color__c == 'Red'){
                                     RedColorCount++;
                                 }
                                 if(objAccProgram.Account__r.SAP_Color__c == 'Yellow'){
                                     YellowColorCount++;
                                 }
                                 if(objAccProgram.Account__r.SAP_Color__c == 'Green'){
                                     GreenColorCount++;
                                 }*/
                             }
                             
                        }
                        
                        if(lstAccProgram.size()>0 )
                        {
                            AccountTargetWrapper objTraWrap = new AccountTargetWrapper();
                            
                                if(highEnd=='')
                                {
                                    objTraWrap.HighEnd ='0/0';
                                    objTraWrap.colorHighEnd='Redcircle';
                                    objTraWrap.pgmHighEnd='0';
                                }else{
                                    objTraWrap.HighEnd=highEnd;
                                    objTraWrap.colorHighEnd=colorHighEnd;
                                    objTraWrap.pgmHighEnd=pgmHighEnd;
                                }
                                if(FMB==''){
                                    objTraWrap.FMB ='0/0';
                                    objTraWrap.colorFmb='Redcircle';
                                    objTraWrap.pgmFmb='0';
                                }else{
                                    objTraWrap.FMB=FMB;
                                    objTraWrap.colorFmb=colorFmb;
                                    objTraWrap.pgmFmb=pgmFmb;
                                }
                                if(Core==''){
                                    objTraWrap.Core ='0/0';
                                    objTraWrap.colorCore='Redcircle';
                                    objTraWrap.pgmCore='0';
                                }else{
                                    objTraWrap.Core=Core;
                                    objTraWrap.colorCore=colorCore;
                                    objTraWrap.pgmCore=pgmCore;

                                }
                                
                             
                            objTraWrap.id=recId;
                            objTraWrap.AccountName=strName;
                            objTraWrap.PremiseFlag=strPremise;
                            objTraWrap.Channel=strChannel;
                            objTraWrap.SAPChannel=strSAPChannel;
                            objTraWrap.SAPColor=strSAPColor;
                            
                            TargetWrapperRecords.add(objTraWrap);
                            
                            //system.debug(TargetWrapperRecords+'TargetWrapperRecords');
                            //system.debug(ProductRecords+'ProductRecords');
                            lstAccProgram.clear();
                       }
                        
                    }
                }
                
            }
                 
       }
       String JSONData = JSON.serialize(TargetWrapperRecords);
       string JSONDataProducts = JSON.serialize(ProductRecords);
       //system.debug('JSONDataProducts=='+JSONDataProducts);                
       return JSONData + '##Json#####' + JSONDataProducts;
       //return JSONData + JSONDataProducts;
    }
       
 // Sap score wrapper class.
    public class AccountTargetWrapper
    {
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
       public string AccountName{get;set;}
       public string PremiseFlag{get;set;}
       public string Channel{get;set;}
       public string SAPChannel{get;set;}
       public string SAPColor{get;set;}
       //public datetime dataloaderDate{get;set;}
       //public list<ProductImagesWrapper> usTargetRecords{get;set;}//US_Account_Target__c
    }
    public class ProductImagesWrapper
    {
        public string ProductImage{get;set;}
        public string ProductName{get;set;}
        public string BrandCategory{get;set;}
        public string ColorCode{get;set;}
        public string AccountId{get;set;}
        public string BrandPackage{get;set;}
    }
    
    public string accountColor(Integer Achieved_Targets,Integer Program_Target_Level)
    {
         string color='';
         if(Achieved_Targets > 0  && Achieved_Targets >=  Program_Target_Level)
         {
            color='Greencircle';
         }else if((Achieved_Targets > 0 ) &&  (Achieved_Targets  < Program_Target_Level))
         {
            color='Redcircle';
         }else if(Achieved_Targets == 0)
         {
            color='Redcircle';
         }
         return color;
    }
   
}