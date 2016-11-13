/*Author: Bharat*/
/*Description: To Unlike a feed.*/
/*Created date: 09/11/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_UnlikeFeed_Service/*')
   global with sharing class AB_UnlikeFeed_Service{
      
      @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper AB_UnlikeFeed_Service(string UserName, string FeedId){
       
                
        string strReturn='Success.'; //Holds the Status message.
        Integer isSuccessRes = 1; //Holds the success status '0' or '1'
        
        try{
            feeditem ft =[select id, (select id from feedlikes where createdby.username =: UserName) from feeditem where id =: FeedId];
            delete ft.feedlikes;
        }
        catch(exception e) {
                strReturn = 'Sorry, Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                System.debug('Exception e '+e.getLineNumber());
                isSuccessRes = 0;
        }
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        
        return obj; 
      }
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}         
          public ResponseWrapper(integer isSuccess,String Message)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
          }
      } 
}