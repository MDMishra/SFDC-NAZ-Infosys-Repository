/*Author: Bharat*/
/*Description: Sending AccountTeamMembers Details to the External system.*/
/*Created date: 30/8/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_AccountTeamMembsService/*')
   global with sharing class AB_AccountTeamMembsService{
       
     @HttpPost //Method name
     //Sending AccountTeamMembers Details and its key decision maker contact details to the External system.
      global static ResponseWrapper AB_AccountTeamMembsService(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        string strJSONBody='';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
        }
        else{
            AB_AccountTeamMembsService_Test testAB = new AB_AccountTeamMembsService_Test();
             string str = AB_AccountTeamMembsService_Test.accId;
             string strU = AB_AccountTeamMembsService_Test.UName;
            system.debug('str=='+str);
            //strJSONBody = '{\"AccountId\":\"001f000000pKybg\"}';
            strJSONBody = '{\"AccountId\":\"'+str+'\",\"UserName\":\"'+strU+'\"}';
        }
        string strReturn=''; //Holds the return message
        Integer isSuccessRes; //Holds the success status '1' or '0'
        list<AccountTeamMember> lstAccountTeam = new list<AccountTeamMember>();//Initializing List of AccountTeamMeambers
        List<TeamWrapper> lstTeamRecords = new List<TeamWrapper>();//Initializing Wrapper object list.
        string Accountid = '';
        string UsrName = '';
        
        try{     
            AccountIdWrapper deserializedAcc = (AccountIdWrapper)JSON.deserializeStrict(strJSONBody, AccountIdWrapper.class);//To get request body.
            //system.debug('deserializedAcc.AccountId=='+deserializedAcc.AccountId);
            
                Accountid = deserializedAcc.AccountId;
                UsrName = deserializedAcc.UserName;
            //Query to get AccountTeamMembers
            
            lstAccountTeam = [select TeamMemberRole,user.name, user.phone, user.MobilePhone,user.fullPhotoUrl from AccountTeamMember where AccountId=:Accountid and user.IsActive=true];
            
            if(lstAccountTeam.size()==0){
                strReturn = 'Sorry, There are no Team Members to display.';
                isSuccessRes = 1;
            }
            else{
                strReturn = 'Success. AccountTeamMember Records are queried successfully. Total of '+lstAccountTeam.size() +' team members';
                isSuccessRes = 1;
                for(AccountTeamMember objTeam : lstAccountTeam){
                    TeamWrapper TeamWrap = new TeamWrapper();
                    TeamWrap.PhotoUrl = objTeam.user.fullPhotoUrl;
                    TeamWrap.Name = objTeam.user.name;
                    TeamWrap.Mobile = objTeam.user.MobilePhone; 
                    TeamWrap.Phone = objTeam.user.phone;
                    TeamWrap.Role =objTeam.TeamMemberRole;
                    lstTeamRecords.add(TeamWrap);
                }
                
            }
            
        }
        catch(exception e) {
                strReturn = 'Sorry,Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                
                isSuccessRes = 0;
        }
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn, lstTeamRecords);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        return obj; 
      }
      //Wrapper class to serialize response
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}
          public list<TeamWrapper> listAccountTeam {get;set;}
                   
          public ResponseWrapper(integer isSuccess,String Message,List<TeamWrapper> listAccountTeam)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
              this.listAccountTeam = listAccountTeam;
          }
      }
      //Wrapper class to store list of team members.
      public class TeamWrapper
      {
          public String PhotoUrl {get;set;}//user.fullPhotoUrl
          public String Name {get;set;}//user.fullname
          public String Mobile {get;set;}//user.mobilephone
          public String Phone {get;set;}//user.phone
          public String Role {get;set;} //accountTeamMember.TeamMemberRole
          
      }
      // Wrapper class to deserialize Request body details.
      public class AccountIdWrapper {
          string AccountId;//accountTeamMember.accountid 
          string UserName; //Loggedin user     
          public AccountIdWrapper(string strId,string strUname)
          {
              this.AccountId = strId;  
              this.UserName = strUname;                      
          }
      }
   }