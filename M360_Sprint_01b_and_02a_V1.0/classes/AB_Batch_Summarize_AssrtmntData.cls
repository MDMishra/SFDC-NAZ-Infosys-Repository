global class AB_Batch_Summarize_AssrtmntData implements Database.batchable<sObject>{ 
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator([select id,WSLRNbrRouteNbr__c,Route__c,Account__r.name,Account__c,Account__r.SAP_Color__c from RouteCust__c where Account__c != null and Route__c != null]);// or id in:accountId
   }

   global void execute(Database.BatchableContext BC, List<RouteCust__c> scope){
   system.debug('scope=='+scope);
   system.debug('scope=='+scope.SIZE());
       map<id,RouteCust__c > MapRtCsts = new map<id,RouteCust__c >();
        map<id,list<id>> MapRtes = new map<id,list<id>>();
        map<id,list<US_Account_Target_Program__c>> mapAccTgtPgms = new map<id,list<US_Account_Target_Program__c>>();
        set<id> setAids = new set<id>();
        for(RouteCust__c obj : scope){
            //system.debug(obj.Route__c);
            //system.debug(obj.Account__c);
            setAids.add(obj.Account__c);
            if(MapRtes.get(obj.Route__c)==null ){
                        
                list<id> lstAccs = new list<id>();
                lstAccs.add(obj.Account__c);
                MapRtes.put(obj.Route__c,lstAccs);
                //system.debug('=========mapAccTgtPgms');
            }else{
            
                list<id> lstAccs = new list<id>();
                lstAccs.addall(MapRtes.get(obj.Route__c));
                lstAccs.add(obj.Account__c);
                MapRtes.put(obj.Route__c,lstAccs);
                //system.debug('=========mapAccTgtPgms');
            }
            MapRtCsts.put(obj.Route__c,obj);
        } 
        
        /*START: Getting US_Account_Target_Program__c data*/
        
        list<US_Account_Target_Program__c> lstAccTgtPgms = new list<US_Account_Target_Program__c>();
        if(setAids != null)
            lstAccTgtPgms = [select id, Pannel_Color__c,Account__c,Account__r.SAP_Channel__c, Brand_Category__c,Achieved_Targets__c,Program_Target_Level__c from US_Account_Target_Program__c where Account__c in: setAids and Brand_Category__c != null];  
        if(lstAccTgtPgms != null && !lstAccTgtPgms.isEmpty())
        {
            for(US_Account_Target_Program__c objTgt : lstAccTgtPgms){
                if(mapAccTgtPgms.get(objTgt.Account__c)==null ){
                        
                   list<US_Account_Target_Program__c> lstTgts = new list<US_Account_Target_Program__c>();
                   lstTgts.add(objTgt);
                    mapAccTgtPgms.put(objTgt.Account__c,lstTgts);
                    //system.debug('=========mapAccTgtPgms');
                }else{
                
                    list<US_Account_Target_Program__c> lstTgts = new list<US_Account_Target_Program__c>();
                    lstTgts.addall(mapAccTgtPgms.get(objTgt.Account__c));
                    lstTgts.add(objTgt);
                    mapAccTgtPgms.put(objTgt.Account__c,lstTgts);
                    //system.debug('=========mapAccTgtPgms');
                }
            }
        }
        /*END: Getting US_Account_Target_Program__c data*/
        
        
        map<string,ABIQ_RouteAssortment__c> mapRAsrts = new map<string,ABIQ_RouteAssortment__c>();       
        ABS_SapScore newClass = new ABS_SapScore();
        list<ABIQ_RouteAssortment__c> lstRAsrtsToInsrt = new list<ABIQ_RouteAssortment__c>();
        list<ABIQ_RouteAssortment__c> lstRAsrtsToUpdt = new list<ABIQ_RouteAssortment__c>();
        list<id> Routeids = new list<id>();
        for(id Rid : MapRtes.keyset()){
            //ABIQ_RouteAssortment__c objRAsrt = new ABIQ_RouteAssortment__c();
            //objRAsrt.Route__c = Rid;
            
            for(id objACCid : MapRtes.get(Rid)){
                
                if(mapAccTgtPgms.get(objACCid) != null){
                    for(US_Account_Target_Program__c objTgtpgms : mapAccTgtPgms.get(objACCid)){
                    
                        /*Start: new code***********************************************************/
                        string str = Rid+'-=-'+objTgtpgms.Brand_Category__c+'-=-'+System.today().toStartOfMonth();
                        if(mapRAsrts.get(str) != null){
                            system.debug('mapRAsrts.get(str)=='+mapRAsrts.get(str));
                            if(objTgtpgms.Pannel_Color__c != null && objTgtpgms.Pannel_Color__c.equalsIgnoreCase('Redcircle'))
                                mapRAsrts.get(str).Compliant__c +=1;
                            if(objTgtpgms.Pannel_Color__c != null && objTgtpgms.Pannel_Color__c.equalsIgnoreCase('Greencircle'))
                                 mapRAsrts.get(str).Non_Compliant__c +=1;
                            mapRAsrts.get(str).ExternalId__c = str;
                            system.debug('Update=='+str);
                        }
                        else{
                            ABIQ_RouteAssortment__c ABIQ_Rasrt = new ABIQ_RouteAssortment__c();
                            ABIQ_Rasrt.Route__c = Rid;
                            ABIQ_Rasrt.Brand_Category__c = objTgtpgms.Brand_Category__c;
                            if(objTgtpgms.Pannel_Color__c != null && objTgtpgms.Pannel_Color__c.equalsIgnoreCase('Redcircle'))
                                ABIQ_Rasrt.Compliant__c = 1;
                            else
                                ABIQ_Rasrt.Compliant__c = 0;
                            if(objTgtpgms.Pannel_Color__c != null && objTgtpgms.Pannel_Color__c.equalsIgnoreCase('Greencircle'))
                                ABIQ_Rasrt.Non_Compliant__c = 1;
                            else
                                ABIQ_Rasrt.Non_Compliant__c = 0;
                            ABIQ_Rasrt.Month__c = System.today().toStartOfMonth();
                            ABIQ_Rasrt.ExternalId__c = str;
                            mapRAsrts.put(str,ABIQ_Rasrt);
                            system.debug('Insert=='+str);
                            
                        }
                        /*Stop: new code***********************************************************/
                        
                        
                        
                    }
                }
            }
        }    
        list<ABIQ_RouteAssortment__c> lstUpsert = new list<ABIQ_RouteAssortment__c>();
        if(mapRAsrts != null){
            for(ABIQ_RouteAssortment__c objRAsrt : mapRAsrts.values()){
                lstUpsert.add(objRAsrt);
            }
            
        }
        try{
            //insert lstRAsrtsToInsrt;
            //update lstRAsrtsToUpdt;
            //delete lstExistRAsrts;
            //insert lstUpsert;
            system.debug('lstUpsert=='+lstUpsert);    
            system.debug('lstUpsert=='+lstUpsert.size());
            if(lstUpsert != null && !lstUpsert.isEmpty())
           		upsert lstUpsert ExternalId__c;
           
               
        }
        catch(Exception e){
            system.debug('Dml Exception'+ e);
        }
   }

   global void finish(Database.BatchableContext BC){
   }
}