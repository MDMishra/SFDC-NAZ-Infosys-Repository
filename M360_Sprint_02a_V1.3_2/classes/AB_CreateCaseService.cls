/*Author: Suresh
  Description: To log a Case from Mibility360 and send mail to support team.
  Created date: 07/11/2016
  Modification History: 12/6/2016 added single email message functionality*/

@RestResource(urlMapping='/AB_CreateCaseService/*')
   global with sharing class AB_CreateCaseService {
      
      @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper Post(string username,string Subject, string Description, string Priority, string ContentFileName1, string ContentData1, string ContentFileName2,string ContentData2,string ContentFileName3,string ContentData3){
       
                
      
        ResponseWrapper objResp = new ResponseWrapper(1,'Success.');//Initialising the object for wrapper class. This object can be returned as response to the external system.
        ONTAP__Case_Force__c objCase;
        
        try{
            if(username!='')
            {
                user usrDetail = [select id, email from user where username =: username];
                //create ONTAP__Case_Force record
                Recordtype rtype = [select id from recordtype where name = 'Mobility360_Cases'];
                objCase =new ONTAP__Case_Force__c();
                if(rtype != null)
                    objCase.RecordTypeId = rtype.id;
                objCase.ONTAP__Subject__c= Subject;//subject texted in ios
                objCase.ONTAP__Description__c=Description;  //description texted in ios          
                objCase.ONTAP__Priority__c=Priority;// priority value selected in ios
                objCase.Ownerid = usrDetail.id;
                
                //DML operation
                insert objCase;
                objResp.CaseId=objCase.Id;//Return case Id 
                           
                //Do attachements here if exists.    
                List<Attachment> lstFiles =new List<Attachment>();        
                
                //Attachement 1
                if(ContentFileName1 != null && ContentFileName1 != '')
                    lstFiles.add(PrepareAttachment(objCase.id,ContentFileName1,ContentData1));    
                
                //Attachement 2            
                if(ContentFileName2 != null && ContentFileName2 != '')
                    lstFiles.add(PrepareAttachment(objCase.id,ContentFileName2,ContentData2));    
                
                //Attachement 1            
                if(ContentFileName3 != null && ContentFileName3 != '')
                    lstFiles.add(PrepareAttachment(objCase.id,ContentFileName3,ContentData3));    
                insert lstFiles;
                
               sendEmailFunction(Subject,Description,lstFiles,objCase.id,usrDetail.email);
               
            
            }else{
                objResp.Message = 'Subject not provided!';
                objResp.isSuccess = 0;
            }
            
        }
         
         catch(exception e) {objResp.Message = AB_M360.EventLog(e);objResp.isSuccess = 0;}
        return objResp; 
      }
      
      Public static string sendEmailFunction(string Subject,string Description,list<Attachment> ListAtts,id caseId,string UserEmail){
        //String toaddress = 'brianna.billings@daugherty.com';
        ONTAP__Case_Force__c cases = [select id,name,createdby.name,owner.name,owner.email,createddate,ONTAP__Priority__c,ONTAP__Subject__c,ONTAP__Description__c from ONTAP__Case_Force__c where id =: caseId];
        list<string> lstEmails = new list<string>();
        lstEmails.add(UserEmail);
        lstEmails.add('brianna.billings@daugherty.com');
        
        //String toaddress = 'ramakrishna.chelikani@nuvemconsulting.com';
        try {
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            for(Attachment a : ListAtts){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                fileAttachments.add(efa);
            }
            system.debug('fileAttachments=='+fileAttachments);
            string strDate = cases.createddate.format('MM/dd/yyyy HH:mm:ss');
            /*integer hh = cases.createddate.getHours();
            string strHH = '';
            if(hh>12)
               strHH = string.valueOf(hh-12); */
            for(string strmail:lstEmails){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {strmail};
                //String[] ccAddresses = new String[] {'sfdcsrini@gmail.com'};
                mail.setToAddresses(toAddresses);
                //mail.setCcAddresses(ccAddresses);
                mail.setReplyTo(userinfo.getUserEmail());
                mail.setSenderDisplayName(userinfo.getFirstName()+userinfo.getLastName());
                mail.setSubject(Subject);
                //mail.setPlainTextBody(Description);
                mail.setHtmlBody('Ticket #: <b> ' + cases.name +' </b><br/>Created By: <b> ' + cases.createdby.name +' </b><br/>'+
                                  'Owner: <b> ' + cases.owner.name +' </b><br/>Issue Submission Date and time: <b> ' + strDate +' </b><br/>'+
                                  'User ID: <b> ' + UserEmail +' </b><br/><br/>Priority: <b> ' + cases.ONTAP__Priority__c +' </b><br/>'+
                                  'Subject: <b> ' + cases.ONTAP__Subject__c +' </b><br/>Description: <b> ' + cases.ONTAP__Description__c +' </b><br/>');
                mail.setBccSender(false);
                mail.setUseSignature(false);           
                                
                mail.setFileAttachments(fileAttachments);
               mail.setSaveAsActivity(false); 
    
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                system.debug('r=='+r);
           } 
   
        } 
        catch(Exception e) {
            system.debug(e.getMessage());
            system.debug(e.getLineNumber());
        }
        return 'Success';
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