global class AB_BatchSku implements Database.Batchable<sObject>,Database.Stateful 
{
    global list<US_Account_Target__c> usTarget;
    
    global AB_batchSku ()
    {
        usTarget=new list<US_Account_Target__c>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        String query = 'Select  SKU__c FROM US_Account_Target__c where SKU__c!=null';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<US_Account_Target__c> scope) 
    {
        system.debug(scope);
        for(US_Account_Target__c target :scope)
        {
            usTarget.add(target);
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
         set<string> skuNames = new set<string>();
         list<SKU_Brand_Image__c> insBrand = new list<SKU_Brand_Image__c>();
         system.debug('usTarget'+usTarget);
         for(US_Account_Target__c  a : usTarget)
         {
             skuNames.add(a.SKU__c);  
         }
         list<SKU_Brand_Image__c> skuBrand = new list<SKU_Brand_Image__c>();
         system.debug(skuNames);
         skuBrand =[select name from SKU_Brand_Image__c where name IN  :skuNames];
         system.debug(skuBrand);
         map<string,string> ImageMap = new map<string,string>();
         if(!skuBrand.isEmpty())
         {
             for(SKU_Brand_Image__c brand:skuBrand){
                 ImageMap.put(brand.name,brand.name);
             }
             system.debug(ImageMap);
         }
         for(string sku:skuNames)
         {
            SKU_Brand_Image__c brandImage =new SKU_Brand_Image__c();
            if(!ImageMap.isEmpty())
            {
                string Image='';
                Image=ImageMap.get(sku);
                system.debug(Image);
                if(Image ==null){
                    system.debug('enetred');
                    brandImage.Name = sku;
                    brandImage.Sku_Image_Id__c=label.Generic_Brand_image;
                    insBrand.add(brandImage);
                }
            }else{
                brandImage.Name=sku;
                brandImage.Sku_Image_Id__c=label.Generic_Brand_image;
                insBrand.add(brandImage);
            }
            
         }
         system.debug(insBrand);
         if(!insBrand.isEmpty()){
             try{
                 insert insBrand;
             }catch(exception e){
                 system.debug('Dml Exception');
             }
         }
    }
}