/*Apex class:ABS_PocAccountDetailcls 
Description:This class is developed for ABS_PocAccountDetailPage VisualforcePage.
This Page display the details of the POC Account record.
Created By :Deepthi Toranala
Created Date:6/22/2016
Modified Date:
Modified By:
*/
public class ABS_PocAccountDetailcls {
    
    public string pocId {get;set;} // Hold the pocId retervied from the url parameter
    public Account objPocAccount{get;set;}// Hold the details of the Poc record
    public list<US_Account_Target_Program__c> lstAccTarget;// list hold US_Account_Target_Program__c records which displays on the page 
    public string core{get;set;} // holds core value
    public string highEnd{get;set;}// holds highend value
    public string fmb{get;set;}// holds fmb value
    public boolean iscore{get;set;} // boolean value which is true if core,fmb and he
    public boolean ishighEnd{get;set;} // boolean value which is true if alnr,drft
    public boolean isfmb{get;set;} // boolean value which is true if alnr,drft
    public Contact primaryContact{get;set;}// poc primary contact details
    public string pocName{get;set;} // holds poc name
    public list<US_Account_Target__c> lstAccountTarget{get;set;} // list holds lstAccountTarget records 
    public map<string,string> mapImages{get;set;} // map to display images on vf page
    public string ChkMapKey{get;set;} //string to convert map key into string
    public string colorCore{get;set;}
    public string colorHighEnd{get;set;}
    public string colorFmb{get;set;}
    public map<string,Integer> BrandSize{get;set;}
    public string mapPinColor{get;set;}
    public decimal navlat{get;set;}
    public decimal navlong{get;set;}
    public user currentuser;
    public decimal userlat;
    public decimal userlon;
    public decimal palat{get;set;}
    public decimal palon{get;set;}
    
    //constructor
    public ABS_PocAccountDetailcls()
    {
        // retriving the parameter from the page.
        pocId=ApexPages.currentPage().getParameters().get('id');
        navlat=decimal.valueof(Apexpages.currentPage().getParameters().get('lat'));
        navlong=decimal.valueof(Apexpages.currentPage().getParameters().get('lon'));
        currentuser=[Select Id,Name,Email,Latitude,Longitude from User where Id=:userinfo.getuserId()];
        
        // Assign the lat and long values
        if(currentuser != null)
        {
            if(currentuser.Latitude != null)
            {
                userlat=currentuser.Latitude;
                userlon=currentuser.Longitude;
            }
        }
        if(navlat !=null && navlong!=null && (navlat!=0 && navlong!=0)){
            palat=navlat;
            palon=navlong;
        }else{
            palat=userlat;
            palon=userlon;
        }
        pocdetails();
    }
    
    // This method is written to retrive the poc details
    // This method is used display related Account Traget Programs.
    public void pocdetails()
    {
        lstAccTarget = new list<US_Account_Target_Program__c>();//intialize
        lstAccountTarget = new list<US_Account_Target__c>();//intialize
        mapImages = new map<string,string>();//intialize
        set<string> setBrand = new set<string>();// hold brand name to map images
        list<SKU_Brand_Image__c> lstSkuBrand =new list<SKU_Brand_Image__c>();
        
        // query which gets the poc record from the url parameter id.
        if(pocId !='')
        {   
            objPocAccount =[SELECT Id,Name,BillingLongitude,BillingLatitude,BillingStreet,BillingState,WSLR_NBR_US__c,
                            Wholesaler__r.name,Phone,BillingCity,BillingCountry,BillingPostalCode,buzz_retail__lon__c,buzz_retail__lat__c
                            FROM Account WHERE id=:pocId LIMIT 1];
        }
        // formating the string to display on the map to remove (')
        if(objPocAccount != null)
        {
            pocName=objPocAccount.name.replace('\'','\\\'');        
        }
        //query which gets Account Traget Programs
        if(objPocAccount != null)
        {
            lstAccTarget =[select Achieved_Targets__c,Program_Target_Level__c,Account__c,Brand_Category__c,Count_of_SKUs__c from 
                        US_Account_Target_Program__c where Account__c =:objPocAccount.id and Brand_Category__c  
                        IN('CORE','HE','High End','FMB')];
        }
        // query to retrive Account Targets
        if(objPocAccount != null)
        {
            lstAccountTarget=[select Brand_Package__c,Acheivement_Score__c,id,Account__c,Brand_Category__c,SKU__c from 
                              US_Account_Target__c where Account__c=:objPocAccount.id and Brand_Category__c  
                              IN('CORE','HE','High End','FMB')];
        }
        system.debug(lstAccountTarget+'lstAccountTarget');
        map<string,list<US_Account_Target__c >> mapUsTarget = new  map<string,list<US_Account_Target__c >>();
        if(!lstAccountTarget.isEmpty())
        {
            for(US_Account_Target__c lstTargets:lstAccountTarget){
                if(mapUsTarget.containsKey(lstTargets.Brand_Category__c)){
                    list<US_Account_Target__c > Target = mapUsTarget.get(lstTargets.Brand_Category__c);
                    Target.add(lstTargets);
                    mapUsTarget.put(lstTargets.Brand_Category__c,Target);
                }else{
                    mapUsTarget.put(lstTargets.Brand_Category__c,new list<US_Account_Target__c >{lstTargets});

                }
            
            }
        
        }
        
        BrandSize = new map<string,Integer>();
        if(!mapUsTarget.isEmpty())
        {
            BrandSize.put('CORE',0);
            BrandSize.put('HE',0);
            BrandSize.put('High End',0);
            BrandSize.put('FMB',0);
            
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
        iscore=false;
        isHighEnd=false;
        isFmb=false;
        
        // Prepare Core,He,fmb,alnr and drft data to display on the page
        if(!lstAccTarget.isEmpty() && lstAccTarget.size()>0)
        {
            for(US_Account_Target_Program__c objAccProgram:lstAccTarget)
            {
                if(objAccProgram.Brand_Category__c=='CORE')
                {
                    core=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                    iscore=true;
                    colorCore=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                }
                if(objAccProgram.Brand_Category__c=='HE' || objAccProgram.Brand_Category__c=='High End')
                {
                    highEnd=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                    colorHighEnd=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                    ishighEnd=true;

                }
                if(objAccProgram.Brand_Category__c=='FMB')
                {
                    fmb=objAccProgram.Achieved_Targets__c+'/'+objAccProgram.Count_of_SKUs__c;
                    colorFmb=accountColor(integer.valueof(objAccProgram.Achieved_Targets__c),integer.valueof(objAccProgram.Program_Target_Level__c));
                    isfmb=true;
                }
                
                
            }
            system.debug(iscore );
            system.debug(ishighEnd );
            system.debug(isfmb);
            if(iscore && ishighEnd && isfmb)
            {
                if(colorCore == 'plus_symbolcoregreen' && colorHighEnd =='plus_symbolcoregreen' && colorFmb =='plus_symbolcoregreen')
                {
                    mapPinColor='green-dot.png';
                    
                }else if(colorCore == 'plus_symbolcorered' && colorHighEnd =='plus_symbolcorered' && colorFmb =='plus_symbolcorered'){
                    
                    mapPinColor='red-dot.png';
                    
                }else{
                    mapPinColor='yellow-dot.png';
                }
            }
            if(iscore && ishighEnd==false && isfmb==false)
            {
                if(colorCore  =='plus_symbolcoregreen')
                {
                    mapPinColor='green-dot.png';
                    
                }else if(colorCore =='plus_symbolcorered'){
                    
                    mapPinColor='red-dot.png';
                    
                }else{
                    mapPinColor='yellow-dot.png';
                }
             }
        }
        // Assigning the related primary contact
        if(objPocAccount != null)
        {
            list<Contact> Con=[Select Id, FirstName, LastName, Name,Email, Title,Phone, Account.Name from contact
                               where Id in (SELECT ContactId from AccountContactRole where AccountId=:pocId) 
                               limit 1];
            if(!con.isEmpty() && Con!= null)
            {
                primaryContact =Con[0];
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
    
    public string accountColor(Integer Achieved_Targets,Integer Program_Target_Level)
    {
         string color='';
         if(Achieved_Targets >=  Program_Target_Level)
         {
            color='plus_symbolcoregreen';
         }else if((Achieved_Targets > 0 ) &&  (Achieved_Targets  < Program_Target_Level))
         {
            color='plus_symbolcoreyellow';
         }else if(Achieved_Targets == 0)
         {
            color='plus_symbolcorered';
         }
         return color;
    }
    
}