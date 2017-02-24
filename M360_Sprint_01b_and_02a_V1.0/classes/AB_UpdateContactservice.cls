/*Author: Bharat*/
/*Description: To Update or create contact(Key decision maker) .*/
/*Created date: 23/12/2016*/
/*Test class: AB_AccountDetailsService_Test*/
/*Modification History: */

@RestResource(urlMapping='/AB_UpdateContactservice/*')
   global with sharing class AB_UpdateContactservice{
     @HttpPost //Method name
     //To send Response to the external IOS system about visit start and end status.
      global static ResponseWrapper AB_UpdateContactservice(string firstname,string lastname,string email,string title,string MobilePhone,string Phone,string accountId,string OfficeHrs,string DeliveryHrs){
        
        string strReturn=''; //Holds the Status message.
        Integer isSuccessRes; //Holds the success status '0' or '1'
        list<contact> lstCon = new list<contact>();
        string ContactName = '';
        AB_AccountDetailsService2.ContactDetailWrapper objConWrap = new AB_AccountDetailsService2.ContactDetailWrapper();
        try{     
            
            list<contact> oldKeyContact = new list<contact>();//holds Key decision maker
            list<contact> lstKeysToUpdate = new list<contact>();//holds contacts to update
            list<contact> ConToUpdate = new list<contact>();//holds contacts to update ONTAP__Decision_Maker__c as true
            list<account> AccToUpdate = new list<account>();
            if(firstname != null && lastname != null){
                if(accountid != null && accountid != ''){
                    lstCon = [select id,title,name,firstname,ONTAP__Decision_Maker__c,lastname,email,mobilephone,phone from contact where accountid =: accountid];
                    AccToUpdate = [select Office_Hours_and_Days__c,Delivery_Hours_and_Days__c from account where id =: accountId];
                    system.debug('lstCon=='+lstCon);
                    if(lstCon != null && !lstCon.isEmpty()){
                        for(contact objCon : lstCon){
                            if(objCon.firstname == firstname && objCon.lastname == lastname && objCon.email == email)
                                ConToUpdate.add(objCon);
                            if(objCon.ONTAP__Decision_Maker__c == true)
                                oldKeyContact.add(objCon);
                        }
                    }
                }
                //system.debug('ConToUpdate=='+ConToUpdate);
                //system.debug('oldKeyContact=='+oldKeyContact);
                //To remove old decision maker
                if(oldKeyContact != null && !oldKeyContact.isEmpty()){
                    for(contact objCon : oldKeyContact){
                        objCon.ONTAP__Decision_Maker__c = false;
                        lstKeysToUpdate.add(objCon);
                    }
                    update lstKeysToUpdate;
                }
                
                
                //To add new decision maker
                if(ConToUpdate != null && !ConToUpdate.isEmpty()){
                    ConToUpdate[0].title = title;
                    ConToUpdate[0].email = email;
                    ConToUpdate[0].MobilePhone= MobilePhone;
                    ConToUpdate[0].Phone= Phone;
                    ConToUpdate[0].ONTAP__Decision_Maker__c= true;
                    ConToUpdate[0].accountid= accountId;
                    update ConToUpdate[0];
                    ContactName = ConToUpdate[0].firstname+' '+ ConToUpdate[0].lastname;
                    objConWrap = AB_AccountDetailsService2.PrepareContactData(ConToUpdate[0]);//preparing contact data
                }
                else
                {
                    contact objCntct = new contact(firstname= firstname,lastname = lastname,
                                                    title = title,email = email,
                                                    MobilePhone= MobilePhone,ONTAP__Decision_Maker__c = true,Phone= Phone,
                                                    accountid = accountid);
                                                    
                    insert objCntct;
                    system.debug('objCntct.name =='+objCntct.name);
                    ContactName = objCntct.firstname+' '+ objCntct.lastname;
                    objConWrap = AB_AccountDetailsService2.PrepareContactData(objCntct);//preparing contact data
                }
                
                if(AccToUpdate != null && !AccToUpdate.isEmpty()){
                    if(OfficeHrs != null && OfficeHrs != '')
                        AccToUpdate[0].Office_Hours_and_Days__c = OfficeHrs;
                    if(DeliveryHrs != null && DeliveryHrs != '')
                        AccToUpdate[0].Delivery_Hours_and_Days__c = DeliveryHrs;
                }
                update AccToUpdate[0];
                
            }
            strReturn = 'Success.';
            isSuccessRes = 1;
            
            
        }
         catch(exception e) {strReturn = AB_M360.EventLog(e);isSuccessRes = 0;}
        
        ResponseWrapper obj = new ResponseWrapper(isSuccessRes , strReturn,ContactName,objConWrap);//Initialising the object for wrapper class. This object can be returned as response to the external system.
        //system.debug('obj=='+obj);
        return obj; 
      }
      //Wrapper class to serialize response
      global class ResponseWrapper
      {
          public integer isSuccess {get;set;}
          public String Message {get;set;}  
          public string ContactName {get;set;}    
          public AB_AccountDetailsService2.ContactDetailWrapper contactInfo {get;set;}
          public ResponseWrapper(integer isSuccess,String Message,string ContactName,AB_AccountDetailsService2.ContactDetailWrapper contactInfo)
          {
              this.isSuccess =isSuccess;
              this.Message = Message;
              this.ContactName= ContactName;
              this.contactInfo = contactInfo;
          }
      }
      
   }