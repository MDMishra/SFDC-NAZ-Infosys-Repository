/*Author: Bharat*/
/*Description: service to send route numbers to external system if the user dont have any route assigned */
/*Created date: 9/feb/2016*/
/*test class: AB_AccountDetailsService_Test*/
/*Modification history:*/

@RestResource(urlMapping='/AB_Routes/*')
    global with sharing class AB_Routes{
        
        @HttpPost //Method name
        //Check for User Authentication based on UserName and Password from external system 
        global static ResponseWrapper AB_Routes(string username){
            
            String strStatusMsg = '';//Holds the status message
            Integer isSuccessRes;//Holds the success response '1' or '0'
            list<Routewrapper> lstRteWrap = new list<Routewrapper>();
            list<personRoutesWrapper> lstPrsnWrap = new list<personRoutesWrapper>();
            //list<string> lstRouteNmbers = new list<string>();
            try{     
                set<string> strWsrnmbrs = new set<string>();  
                list<Route__c> listRoutes = new list<Route__c>();
                list<Route__c> listPrsnRoutes = new list<Route__c>();
                list<user> listUsers = new list<user>(); 
                map<string,list<Route__c>> mapUsrRoutes = new map<string,list<Route__c>>();//holds username and list of routes assigned to that user
                list<user> objUser = [select id,WSLRNbrRouteNbr__c,Wholesaler_Number__c from User where username =: username and IsActive =true limit 1];
                if(objUser != null && objUser.size() != 0){
                    if(objUser[0].Wholesaler_Number__c != null){//objUser[0].WSLRNbrRouteNbr__c == null && 
                        listRoutes = [select id,RouteNbr__c from Route__c where WSLRNbrRouteNbr__c like :objUser[0].Wholesaler_Number__c+'%' and RouteNbr__c != null];
                        
                        if(listRoutes != null && !listRoutes.isEmpty()){
                            for(Route__c rte : listRoutes){
                                Routewrapper rwrap = new Routewrapper();
                                rwrap.id = rte.id;
                                rwrap.RouteNmbr = rte.RouteNbr__c;
                                lstRteWrap.add(rwrap);
                                //lstRouteNmbers.add(rte.RouteNbr__c);
                            }
                        }
                        //Start: Person routes
                        listUsers = [select id,username,name, WSLRNbrRouteNbr__c from user where WSLRNbrRouteNbr__c != null and Wholesaler_Number__c = :objUser[0].Wholesaler_Number__c and IsActive = true];
                        if(listUsers != null && !listUsers.isEmpty()){
                            for(user usr : listUsers){
                                strWsrnmbrs.add(usr.WSLRNbrRouteNbr__c);
                            }
                        }
                        listPrsnRoutes = [select id,RouteNbr__c ,WSLRNbrRouteNbr__c from Route__c where WSLRNbrRouteNbr__c in :strWsrnmbrs and RouteNbr__c != null];
                        for(user usr : listUsers){
                            if(!listPrsnRoutes.isEmpty()){
                                for(Route__c rte : listPrsnRoutes){
                                    if(usr.WSLRNbrRouteNbr__c == rte.WSLRNbrRouteNbr__c){
                                        if(mapUsrRoutes.get(usr.username+'==='+usr.name) == null){
                                            list<Route__c> objlst = new list<Route__c>();
                                            objlst.add(rte);
                                            mapUsrRoutes.put(usr.username+'==='+usr.name,objlst);
                                        }
                                        else{
                                            list<Route__c> objlst = new list<Route__c>();
                                            objlst.addAll(mapUsrRoutes.get(usr.username+'==='+usr.name));
                                            objlst.add(rte);
                                            mapUsrRoutes.put(usr.username+'==='+usr.name,objlst);
                                        }
                                                                                
                                    }
                                }
                            }
                            
                        }
                        system.debug('mapUsrRoutes=='+mapUsrRoutes);
                        
                        if(!mapUsrRoutes.isEmpty()){
                            for(string uName : mapUsrRoutes.keyset()){
                                personRoutesWrapper prsnWrap = new personRoutesWrapper();
                                prsnWrap.person = uName.substringAfter('===');
                                list<Routewrapper> lstPrsonRoutesWrap = new list<Routewrapper>();
                                if(mapUsrRoutes.get(uName) != null){
                                    
                                    for(Route__c objRte : mapUsrRoutes.get(uName)){
                                        Routewrapper rwrap = new Routewrapper();
                                        rwrap.id = objRte.id;
                                        rwrap.RouteNmbr = objRte.RouteNbr__c;
                                        lstPrsonRoutesWrap.add(rwrap);
                                    }
                                }
                                prsnWrap.Routes = lstPrsonRoutesWrap;
                                if(prsnWrap != null)
                                    lstPrsnWrap.add(prsnWrap);
                            }
                        }
                        //end:
                        
                        strStatusMsg = 'Success';
                    }
                    else
                        strStatusMsg = 'Sorry. No routes found.';
                }
                else
                    strStatusMsg = 'Sorry. There is no user found.';                
                        
                                           
                if(strStatusMsg == 'Success'){
                    isSuccessRes = 1;
                    
                }
                else{
                    isSuccessRes = 0;
                }
            }
             catch(exception e) {strStatusMsg = AB_M360.EventLog(e);isSuccessRes = 0;}
            //system.debug('isSuccessRes=='+isSuccessRes);
            ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strStatusMsg ,lstPrsnWrap, lstRteWrap);
            system.debug('obj=='+obj);
             
            return obj;      
        }
        //Wrapper class to serialize response
        global class ResponseWrapper
        {
            public integer isSuccess {get;set;}//Holds success or failure status.
            public String Message {get;set;}//Status message to be sent as response 
            public list<personRoutesWrapper> personRoutes {get;set;}
            public list<Routewrapper> listRoutes {get;set;}   
            public ResponseWrapper(integer isSuccess,String Message,list<personRoutesWrapper> personRoutes,list<Routewrapper> listRoutes)
            {
                this.isSuccess =isSuccess;
                this.Message = Message;
                this.personRoutes = personRoutes;
                this.listRoutes = listRoutes;
            }
        }
        public class personRoutesWrapper 
        {
            string person;
            list<Routewrapper> Routes; 
        }
        public class Routewrapper
        {
            string RouteNmbr;
            string id;
        }
    }