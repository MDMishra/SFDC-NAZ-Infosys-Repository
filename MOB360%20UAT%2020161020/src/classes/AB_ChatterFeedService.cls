/*Author: Appshark*/
/*Description: To save feedItem records .*/
/*Created date: 13/9/2016*/
/*Modification History: */

@RestResource(urlMapping='/AB_ChatterFeedService/*')
   global with sharing class AB_ChatterFeedService{
     @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper AB_ChatterFeedService(){
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        
        string JSONString = '';
        if(!test.isRunningTest()){
            JSONString = request.requestBody.toString();// Holds the request body
            system.debug('######'+Limits.getHeapSize());
        }
        else{
            AB_ChatterFeedService_Test testAB = new AB_ChatterFeedService_Test();
            string strUsr = AB_ChatterFeedService_Test.Uname;
            string strAid = AB_ChatterFeedService_Test.aId;                
            system.debug('strUsr=='+strUsr);               
            JSONString = '{\"username\":\"'+strUsr+'\",\"title\":\"TestFile From PostMan\",\"body\":\"This is Test Link From PostMan\",\"type\":\"ContentPost\",\"parentid\":\"'+strAid+'\",\"linkUrl\":\"www.google.co.in\",\"ContentFileName\":\"ContentFile.txt\",\"ContentData\":\"iVBORw0KGgoAAAANSUhEUgAAANgAAAAuCAMAAAB9NSfbAAAAKlBMVEX/uQOAuwPzUCJ0dHR2dnZ0dHR0dHR0dHR0dHQDpfBnZ110dHRzc3O5uQReCoL9AAAADnRSTlP6/Pvf/cmvjWX9ADcWOkAIBzkAAANISURBVHja7ZjbdtwwCEXbIi415P9/t7EwRmbsPiRW1krr8zSGiWALjDT58etUy/LzVG/Ld9ED9oA9YA/YA/YPgikTAsoXgimLzefi1oU3gRl2UcncyM0REaeTUXPRTWDaXHIMI26FlbF/4slc0jbhzWB4jIMJprGRs5QBUVRkDSkod4E1LdasGHhFp0qHHGSFvA+MRysPYIsigHNNBqMIfisYWBoNwrg92/JNwUqzSUuw1HQwvh2MyvjA1QYBZqvSqcLMoja6VETda90dT4NNRpvJ+C0z30ru6wWYmX0aTDqZHm07GDXIc0wwiinbDsBiGPuiDOFm2+sP5TVW2me7eIku9Hkw2ePmidx2sHwDLbA2kg6vEI+S3jzTnaK8Q2mzqWCeocXo6KYK5p4URcUwOEuCYAWDE3TknwrmfZ2jA6xWLOsFxEwQYG6ChlEvZGbYa6qOpCrUaABd1whcAYS+Cnbl5xvAxnGLPVoF23NiLx4nGIiZinlC6t4YtJI7prKDkg2NrddT8bNzVrYUdbfoCZjB4U20HUz3QucEomjPNGbWeDgveSpYjg/yyK9gEjmlcMiHjtgd0xYuF83xfhZLXoP9PtW741RvZ2AGUZcwFLAMWMF0SFmPLtnqiDKGAzvgg00Ey+U4AQsYReYpdFe2lX/O9PZBCtJdkgXMt0xngsX4MPAIr2DmFFdg6iUvYONlVBJsF80Gixjmo+MUDD4EtigGmryCza9YjI9tdJy1In6kFVcJNZfVAeSbNREsg8Tj1TsmfwfTUovj7VC+fnjEghHociriBVgd905Qzi8uP8ejMyeDaV7pTsDCn6kn2MsBnZjavZk5DyULzLlgeT3Vc7Dws3lzUYBlltnHFPkziGXFYnewx1D0HihgsvfnXWDSPNAVWJxJxIStJVj5lx0xtZ2Ru2GzaDY8EmNzYwXTbRlst4BlZ5yDZUhXBYucUzzYrn+2yNipLgjfHWCZmY1g9bDCI1g5u+SQcYWlE37Q5RVM7wAzfFeAKSJyOOBd2BMBRApcwWi4NSVCd4WMwd3IkTGFxYMUmw2RQZb9yd2fAbuWrTqxq4qI2tVfrW4d3ZbfLza9Dq6rPjAVv4cesAfsAXvAHrD/A+wPe9UlrcdA7u4AAAAASUVORK5CYII=\"}';
        }
        system.debug('JSONString=='+JSONString);
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        list<user> objUsr;
        //try{     
            ChatterFeedWrapper deserializedRequest = 
              (ChatterFeedWrapper)JSON.deserializeStrict(JSONString, ChatterFeedWrapper.class);//To deserialze request body.
            system.debug('deserializedRequest.username=='+deserializedRequest.username);
            if(deserializedRequest.username != null)
                objUsr = [select id from user where username =: deserializedRequest.username limit 1];
            system.debug('objUsr =='+objUsr); 
            
            system.debug('deserializedRequest.ContentFileName=='+deserializedRequest.ContentFileName);
            
            string[] strArray;
            string strContentFileName='';
            if(deserializedRequest.ContentFileName != null && deserializedRequest.ContentFileName != '')
                strContentFileName = deserializedRequest.ContentFileName;
            system.debug('strContentFileName=='+strContentFileName);
            if(strContentFileName.contains('.'))
            {
                
               strArray = strContentFileName.split('\\.');
               //string strExtension = strArray[1];
               system.debug('strArray=='+strArray[1]);
            }
            ContentVersion v = new ContentVersion();
            if(deserializedRequest.type=='ContentPost'){
            system.debug('deserializedRequest.ContentData=='+deserializedRequest.ContentData);
            v.versionData = deserializedRequest.ContentData;
            v.title = deserializedRequest.ContentFileName;
            //v.SharingOption = 'v';
            //v.pathOnClient ='/foo.'+deserializedRequest.Extension;
            if(strArray != null)
                v.pathOnClient ='/foo.'+strArray[1];
            insert v;
            }
            //create and insert post
            FeedItem post = new FeedItem();
            if(deserializedRequest.body!=null)
                post.Body = deserializedRequest.body;
            if(deserializedRequest.parentid!=null)  
                post.ParentId = deserializedRequest.parentid;
            /*if(deserializedRequest.title!=null)//file name
                post.Title = deserializedRequest.title;*/
            if(deserializedRequest.linkUrl!=null)
                post.linkUrl = deserializedRequest.linkUrl;
            if(objUsr!=null)
                post.createdbyid = objUsr[0].id;               
                //post.Insertedbyid = objUsr[0].id;
            if(deserializedRequest.type=='ContentPost'){
                if(deserializedRequest.ContentData!=null)
                    system.debug('deserializedRequest.ContentData=='+deserializedRequest.ContentData);
                    //post.ContentData = deserializedRequest.ContentData;
                    //post.ContentData = EncodingUtil.base64Decode(deserializedRequest.ContentData);no need
                if(deserializedRequest.ContentFileName!=null)
                    //post.ContentFileName = deserializedRequest.ContentFileName;
                    post.Title = deserializedRequest.ContentFileName;
                    if(!test.isrunningtest())
                        post.RelatedRecordId = v.id;
            }
            //post.Visibility = 'AllUsers';
            insert post;
            /*string muteValues;
            muteValues = post.id + 'false';
            list<user> lstUsr = [select id,muteFeeds__c from user limit 100 ];
            for(user objuser : lstUsr )
            {
                objuser.muteFeeds__c  = objuser.muteFeeds__c + muteValues;
            }
            update lstUsr ;*/
            
            system.debug('post.id=='+post);
            system.debug('post.parentid=='+post.parentid);
                        
            system.debug(post.id);                     
            strReturn='Success.'; 
            isSuccessRes = 1;
            
        //}
        /*catch(exception e) {
                strReturn = 'Sorry, Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                System.debug('Exception e '+e.getLineNumber());
                isSuccessRes = 0;
        }*/
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        //system.debug('obj=='+obj);
        return obj; 
      }
      //Wrapper class to serialize response
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
      // Wrapper class to deserialize user details.     
      public class ChatterFeedWrapper {
          string username;
          string title; 
          string body;
          string type;
          string parentid;
          string linkUrl;
          string ContentFileName;
          //string ContentData;
          blob ContentData;
          string Extension;
                        
          public ChatterFeedWrapper(string username,string title,string body,string type,string parentid,string linkUrl,string ContentFileName,blob ContentData,string Extension)
          {
              this.username= username; 
              this.title= title; 
              this.body= body;
              this.type= type;
              this.parentid = parentid;
              this.linkUrl= linkUrl;
              this.ContentFileName = ContentFileName;
              this.ContentData = ContentData;
              this.Extension = Extension;
              //testBlob = blob.valueof(ContentData);                 
          }
      }
   }