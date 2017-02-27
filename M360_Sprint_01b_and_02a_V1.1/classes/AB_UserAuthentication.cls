/*Author: Bharat*/
/*Description: Check for User Authentication based on UserName and Password from external system 
/*Created date: 23/8/2016*/
/*Modification history: 24/1/2017 added tile selecting preferences for user and ordering interface checkbox feature*/

@RestResource(urlMapping='/UserAuthentication/*')
    global with sharing class AB_UserAuthentication{
        
        @HttpPost //Method name
        //Check for User Authentication based on UserName and Password from external system 
        global static ResponseWrapper AB_UserAuthentication(){
            RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
            //system.debug('Name=='+request.requestBody.toString());
            
            string strJSONBody = '';
            if(!test.isRunningTest()){
                strJSONBody = request.requestBody.toString();
            }
            else{
                
                strJSONBody = AB_UserAuthentication_Test.strJSONBody;
            }
            System.debug('strJSONBody::'+strJSONBody);
            String strStatusMsg = '';//Holds the status message
            //string imageEncoded ='';//Holds the encoded image string
            Integer isSuccessRes;//Holds the success response '1' or '0'
            string profileImageUrl = '';//Holds the User Profile pic url.
            string userFullName = '';//Holds the user name
            boolean ordrIntrface = false;
            list<string> BAMUsrOptions = new list<string>();//holds BAM user picklist options
            boolean isBamUser = false;
            boolean isRouteAssigned = false;
            DashboardTilesWrapper dtWrap = new DashboardTilesWrapper();//holds user selected tiles
            string EndDayDate= '';
            try{       
                UserDetailsWrapper deserializedUser = 
                (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//getting request body
                System.debug('deserializedUser::'+deserializedUser);
                
                //strStatusMsg = AB_UserVerification.checkUserCredentials(deserializedUser.username,deserializedUser.password);// To know the provided username and password are matched or not.                       
                                                
                //Query user to get PhotoUrl and FullName
                list<user> objUser = [select name,M360_EndDayDate__c,WSLRNbrRouteNbr__c,FullPhotoUrl,IsProfilePhotoActive,M360_Dashboards__c,Ordering_interface__c,profile.name from User where username =: deserializedUser.username limit 1];
                list<Route__c> routeList = new list<Route__c>();
                if(objUser != null && objUser.size() != 0){
                    profileImageUrl=objUser[0].FullPhotoUrl; 
                    userFullName = objUser[0].name; 
                    if(objUser[0].WSLRNbrRouteNbr__c != null)
                        routeList = [select id from Route__c where WSLRNbrRouteNbr__c = :objUser[0].WSLRNbrRouteNbr__c];
                    if(routeList != null && !routeList.isEmpty())
                        isRouteAssigned = true;
                    strStatusMsg = 'Success';
                    if(objUser[0].M360_Dashboards__c != null && objUser[0].M360_Dashboards__c.contains(',')){
                        list<string> tilesList = objUser[0].M360_Dashboards__c.split(',');
                        system.debug('tilesList=='+tilesList);
                        system.debug('tilesList size=='+tilesList.size());
                        if(tilesList != null && !tilesList.isEmpty()){
                            if(tilesList.size() == 1)                     
                                dtWrap.tile1 = tilesList[0];
                            if(tilesList.size() == 2)
                                dtWrap.tile1 = tilesList[0];
                                dtWrap.tile2 = tilesList[1];
                            if(tilesList.size() == 3)
                                dtWrap.tile1 = tilesList[0];
                                dtWrap.tile2 = tilesList[1];
                                dtWrap.tile3 = tilesList[2];
                            if(tilesList.size() == 4)
                                dtWrap.tile1 = tilesList[0];
                                dtWrap.tile2 = tilesList[1];
                                dtWrap.tile3 = tilesList[2];
                                dtWrap.tile4 = tilesList[3];
                        }
                        ordrIntrface = objUser[0].Ordering_interface__c;
                                             
                    }
                    else{
                        dtWrap.tile1 = 'Sales Volume Coming Soon';
                        dtWrap.tile2 = 'SAP Account Status';
                        dtWrap.tile3 = 'Sales Excellence';
                        dtWrap.tile4 = 'Task View';
                    }
                    if(objUser[0].M360_EndDayDate__c != null)
                        EndDayDate = string.valueOf(objUser[0].M360_EndDayDate__c);
                    /*BAMUsrOptions= AB_M360.getPickListLabels(task.status);    
                    system.debug(BAMUsrOptions);*/
                    if(objUser[0].profile.name == 'BAM Manager Platform User' || objUser[0].profile.name == 'BAM Platform User'){
                        list<string> lststr = new list<string>{'Activation Call','Sales Call'};
                        BAMUsrOptions=lststr;
                        isBamUser = true;
                    }
                    else{
                        list<string> lststr = new list<string>{'',''};
                        BAMUsrOptions = lststr;
                    }
                }
                else
                    strStatusMsg = 'Sorry. There is no user found';
                system.debug(profileImageUrl);
                /*blob b = Blob.valueOf(profileImageUrl);//to encode the PhotoUrl.
                system.debug(EncodingUtil.base64Encode(b));
                imageEncoded = EncodingUtil.base64Encode(b);*/
                                           
                if(strStatusMsg == 'Success'){
                    isSuccessRes = 1;
                    
                }
                else{
                    isSuccessRes = 0;
                }
            }
             catch(exception e) {strStatusMsg = AB_M360.EventLog(e);isSuccessRes = 0;}
            //system.debug('isSuccessRes=='+isSuccessRes);
            ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strStatusMsg , profileImageUrl, userFullName,ordrIntrface,dtWrap,BAMUsrOptions,isBamUser,isRouteAssigned,EndDayDate);//Initialising the object for wrapper class. This object can be returned as response to the external system.
            system.debug('obj=='+obj);
             
            return obj;      
        }
        //Wrapper class to serialize response
        global class ResponseWrapper
        {
            public integer isSuccess {get;set;}//Holds success or failure status.
            public String Message {get;set;}//Status message to be sent as response 
            public String PhotoUrl {get;set;}//user.FullPhotoUrl  
            public string FullName {get;set;}//user.fullname
            public boolean OrderingInterface {get;set;}//user.Ordering_interface__c
            public DashboardTilesWrapper DashboardTiles{get;set;} 
            public list<string> BAMUsrOptions {get;set;}   
            public boolean isBamUser {get;set;} 
            public boolean isRouteAssigned {get;set;} 
            public string EndDayDate {get;set;}
            public ResponseWrapper(integer isSuccess,String Message,string PhotoUrl,string FullName,boolean OrderingInterface,DashboardTilesWrapper DashboardTiles,list<string> BAMUsrOptions,boolean isBamUser,boolean isRouteAssigned,string EndDayDate)
            {
                this.isSuccess =isSuccess;
                this.Message = Message;
                this.PhotoUrl = PhotoUrl;
                this.FullName = FullName;
                this.OrderingInterface = OrderingInterface;
                this.DashboardTiles = DashboardTiles;
                this.BAMUsrOptions = BAMUsrOptions;
                this.isBamUser = isBamUser;
                this.isRouteAssigned = isRouteAssigned;
                this.EndDayDate = EndDayDate;
            }
        }
        //holds user selected dashboard tiles
        public class DashboardTilesWrapper
        {
            string tile1 = '';
            string tile2 = '';
            string tile3 = '';
            string tile4 = '';
        }
        // Wrapper class to deserialize user details.
        public class UserDetailsWrapper 
        {
            public string username;
        }
    }