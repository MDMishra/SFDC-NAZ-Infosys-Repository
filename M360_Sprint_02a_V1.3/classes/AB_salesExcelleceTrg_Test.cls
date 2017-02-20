@isTest
public class AB_salesExcelleceTrg_Test {
     static testMethod void UnitTest() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User usr1 = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '10500',
             WSLRNbrRouteNbr__c = '0D010093143'
             );
             insert usr1;
         
        Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
        account objAc = new account();
       objAc.name = 'Test Account';       
       objAc.recordtypeid = POCRtype.id;
       //objAc.billingCity = '';
       objAc.billingstate = 'THyderabad';
       //objAc.billingCountry = 'Hyderabad';
       //objAc.billingPostalCode = '500459';
       objAc.Trade_Program_NM__c = 'MACRO';
       //objAc.Wholesaler__c = objAcWhole.id;
       objAc.INDUS_VOL_CLASS_CD_US__c = '20';
       insert objAc;
        
        event objEve  =  new event();
        objEve.subject = 'Test Event';
        objEve.Visit_in_Progress__c = false;
        objEve.Visit_Completed__c = true;
        objEve.OwnerId = usr1.id;
        objEve.Whatid = objAc.id;
        objEve.ActivityDateTime = system.today();
        objEve.DurationInMinutes = 30;
        objEve.Out_of_Range_on_End__c = true;
        //objEve.Out_of_Range_on_Start__c = false;
        //objEve.createddate = system.today();
        insert objEve;  
        
        objEve.Out_of_Range_on_Start__c = true;
        //objEve.createddate = system.today();
        //update objEve; 
        
        Route__c objRte = new Route__c();
        objRte.WSLRNbrRouteNbr__c = '0D010093143';      
        insert objRte; 
        
        Route_Schedule__c route = new Route_Schedule__c();
        route.Route__c = objRte.id;
        route.SeqNbr__c = 1;
        route.Account__C = objAc.id;
        //route.Schedule_Date__c = system.today();
        route.StopDate__c = System.today();
        // route.Sales_Rep__c = usr;
        insert route;  
        system.debug('route.Route__c.WSLRNbrRouteNbr__c=='+route.Route__r.WSLRNbrRouteNbr__c);
        system.debug('route=='+route);
         update objEve; 
     }
     
     static testMethod void UnitTest2() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User usr1 = new User(LastName = 'LIVESTON',
             FirstName='JASON',
             Alias = 'jliv',
             Email = 'jason.liveston@asdf.com',
             Username = 'jason.lieston@as.com',
             ProfileId = profileId.id,
             TimeZoneSidKey = 'GMT',
             LanguageLocaleKey = 'en_US',
             EmailEncodingKey = 'UTF-8',
             LocaleSidKey = 'en_US',
             Wholesaler_Number__c = '10500',
             WSLRNbrRouteNbr__c = '0D010093143'
             );
             insert usr1;
         
        Recordtype POCRtype = [select id,name from Recordtype where SobjectType = 'Account' and name ='POC'];
        account objAc = new account();
        objAc.name = 'Test Account';       
        objAc.recordtypeid = POCRtype.id;
        //objAc.billingCity = '';
        objAc.billingstate = 'THyderabad';
        //objAc.billingCountry = 'Hyderabad';
        //objAc.billingPostalCode = '500459';
        objAc.Trade_Program_NM__c = 'MACRO';
        //objAc.Wholesaler__c = objAcWhole.id;
        objAc.INDUS_VOL_CLASS_CD_US__c = '20';
        insert objAc;
        
        system.debug('objAc=='+objAc);
        
        event objEve  =  new event();
        objEve.subject = 'Test Event';
        objEve.Visit_in_Progress__c = false;
        objEve.Visit_Completed__c = true;
        objEve.OwnerId = usr1.id;
        objEve.Whatid = objAc.id;
        objEve.ActivityDateTime = system.today();
        objEve.DurationInMinutes = 30;
        objEve.Out_of_Range_on_End__c = false;
        //objEve.Out_of_Range_on_Start__c = true;
        //objEve.createddate = system.today();
        insert objEve;  
        
        objEve.Out_of_Range_on_Start__c = false;
        //objEve.createddate = system.today();
        //update objEve;
        
        string str = '0D010093143';
        Route__c objRte = new Route__c();
        objRte.WSLRNbrRouteNbr__c = str;      
        insert objRte; 
        
        system.debug('objRte=='+objRte);
        Route__c objRte3 = [select id,WSLRNbrRouteNbr__c from Route__c  where id =: objRte.id];
        system.debug('objRte3=='+objRte3);
        
        Route_Schedule__c route = new Route_Schedule__c();
        route.Route__c = objRte3.id;
        route.SeqNbr__c = 1;
        route.Account__C = objAc.id;
        //route.Schedule_Date__c = system.today();
        route.StopDate__c = System.today();
        // route.Sales_Rep__c = usr;
        insert route; 
        system.debug('route.Route__c.WSLRNbrRouteNbr__c=='+route.Route__r.WSLRNbrRouteNbr__c);
        system.debug('route=='+route);
        
        Route_Schedule__c rte2 = [select id,Route__c ,Route__r.WSLRNbrRouteNbr__c, Account__C from Route_Schedule__c where id =: route.id];
        system.debug('rte2 =='+rte2);
        system.debug('rte2route nbr =='+rte2.Route__r.WSLRNbrRouteNbr__c);
         System.debug('rte2 account =='+rte2.Account__c);
         update objEve;
     }
}