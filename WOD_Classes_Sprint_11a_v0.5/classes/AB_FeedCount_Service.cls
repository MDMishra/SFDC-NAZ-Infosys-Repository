/*Author: Bharat*/
/*Description: To send priority and unpriority feeds count to ios*/
/*Created date: 11/11/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_FeedCount_Service/*')
   global with sharing class AB_FeedCount_Service{
      
      @HttpPost //Method name
      global static ResponseWrapper AB_FeedCount_Service(string UserName, string AccountId){
       
                
        string strReturn='Success.'; //Holds the Status message.
        Integer isSuccessRes = 1; //Holds the success status '0' or '1'
        list<string> MutedFeeds = new list<string>();//holds muted feeds of the user
        list<feeditem> UnmutedFeedsList = new list<feeditem>();//holds unmuted feeds ogf the account for the user
        integer PriorityCount = 0;
        integer NoPriorityCount = 0;
        try{
            //query to get muteFeeds__c from logged in user from ios 
            list<user> lstUsers = [select id, muteFeeds__c from user where username =: UserName];
            if(lstUsers.size()==0){
                strReturn = 'Sorry, There are records';
                isSuccessRes = 0;
            }
            else
            {
                strReturn = 'Success.';
                isSuccessRes = 1;
                if(lstUsers[0].muteFeeds__c != null && lstUsers[0].muteFeeds__c != ''){
                    string str = lstUsers[0].muteFeeds__c;
                    if(str != ''){
                        if(str.contains(',')){
                            MutedFeeds = str.split(',');
                        }
                        else
                            MutedFeeds.add(lstUsers[0].muteFeeds__c);
                    }
                }
            }
            if(MutedFeeds != null && !MutedFeeds.isEmpty()){
                //query to get feeds of an account clicked on ios mobile
                UnmutedFeedsList =[SELECT id,parentid, Body from feeditem where parentid =: AccountId and id not in :MutedFeeds];// 
            }
            for(feeditem fItem : UnmutedFeedsList){
                if(fItem.body != '' && fItem.body != null && fItem.body.toLowerCase().contains('#priority'))
                        {
                            
                            PriorityCount++; //if the feed is priority                        
                        }
                        else{
                            
                            NoPriorityCount++;  //if the feed is nor priority                      
                        }
                
            }
            
        }
        catch(exception e) {
                strReturn = 'Sorry, Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                System.debug('Exception e '+e.getLineNumber());
                isSuccessRes = 0;
        }
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,PriorityCount,NoPriorityCount);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        
        return obj; 
      }
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}
          public integer PriorityCount {get;set;}
          public integer NoPriorityCount {get;set;}        
          public ResponseWrapper(integer isSuccess,String Message,integer PriorityCount,integer NoPriorityCount)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
              this.PriorityCount =PriorityCount;
              this.NoPriorityCount = NoPriorityCount;
          }
      } 
}