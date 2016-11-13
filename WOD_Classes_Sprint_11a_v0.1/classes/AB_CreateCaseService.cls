/*Author: Suresh
  Description: To log a Case from Mibility360.
  Created date: 07/11/2016
  Modification History: */

@RestResource(urlMapping='/AB_CreateCaseService/*')
   global with sharing class AB_CreateCaseService {
      
      @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper Post(string Subject, string Description, string Priority, string ContentFileName1, string ContentData1, string ContentFileName2,string ContentData2,string ContentFileName3,string ContentData3){
       
                
      
        ResponseWrapper objResp = new ResponseWrapper(1,'Success.');//Initialising the object for wrapper class. This object can be returned as response to the external system.
        ONTAP__Case_Force__c objCase;
        
        try{
            if(Subject!='')
            {
                
                //create ONTAP__Case_Force record
                Recordtype rtype = [select id from recordtype where name = 'Mobility360_Cases'];
                objCase =new ONTAP__Case_Force__c();
                objCase.RecordTypeId = rtype.id;
                objCase.ONTAP__Subject__c= Subject;//subject texted in ios
                objCase.ONTAP__Description__c=Description;  //description texted in ios          
                objCase.ONTAP__Priority__c=Priority;// priority value selected in ios
                
                //DML operation
                insert objCase;
                objResp.CaseId=objCase.Id;//Return case Id 
                system.debug('##objCase: ' + objCase);            
                           
                //Do attachements here if exists.    
                List<Attachment> lstFiles =new List<Attachment>();        
                
                //Attachement 1
                system.debug('strContentFileName=='+ContentFileName1);            
                if(ContentFileName1 != null && ContentFileName1 != '')
                    lstFiles.add(PrepareAttachment(objCase.id,ContentFileName1,ContentData1));    
                
                //Attachement 2            
                system.debug('strContentFileName=='+ContentFileName2);
                if(ContentFileName2 != null && ContentFileName2 != '')
                    lstFiles.add(PrepareAttachment(objCase.id,ContentFileName2,ContentData2));    
                
                //Attachement 1            
                system.debug('strContentFileName=='+ContentFileName3);
                if(ContentFileName3 != null && ContentFileName3 != '')
                    lstFiles.add(PrepareAttachment(objCase.id,ContentFileName3,ContentData3));    
                system.debug('###lstFiles==' + lstFiles);
                insert lstFiles;
               
               
            
            }else{
                objResp.Message = 'Subject not provided!';
                objResp.isSuccess = 0;
            }
            
        }
        catch(exception e) {
                objResp.Message = 'Sorry, Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                System.debug('Exception e '+e.getLineNumber());
               objResp.isSuccess = 0;
        }   
        return objResp; 
      }
      
        /*Author: Suresh*/
        /*Description: To preapare Attachment object.*/
        /*Created date: 08/11/2016*/
        /*Modification History: */
      private static Attachment PrepareAttachment(string parent, string contentFileName,string contentData)
      {
            //Prepare Attachment object 
            Attachment objFile=new Attachment();            
            objFile.Name  = contentFileName;//name of the file inserted from ios
            objFile.ParentId=  parent;//id of case record
            if(!test.isRunningTest()){objFile.Body = EncodingUtil.base64Decode(contentData);} //FileData            
           return objFile;
      }
      
      //Wrapper class to serialize response
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}
          public String CaseId {get;set;}
          public ResponseWrapper(integer isSuccess,String Message)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
          }
      } 
}