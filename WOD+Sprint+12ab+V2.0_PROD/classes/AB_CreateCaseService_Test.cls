/**
  Author: Suresh
  Description: This class contains unit tests for validating the behavior of AB_CreateCaseService apex classes
  Created date: 09/11/2016
  Modification History: 
*/
    
@isTest
private class AB_CreateCaseService_Test {

  static testMethod void myEmptyUnitTest() { 
        AB_CreateCaseService.Post('','','','','','','','','',''); 
    } 

    static testMethod void myUnitTest1() {
        
       Recordtype rtype = [select id from recordtype where name = 'Mobility360_Cases'];
                ONTAP__Case_Force__c objCase =new ONTAP__Case_Force__c();
                objCase.RecordTypeId = rtype.id;
                objCase.ONTAP__Subject__c= 'Subject';//subject texted in ios
                objCase.ONTAP__Description__c='Description';  //description texted in ios          
                objCase.ONTAP__Priority__c='High';// priority value selected in ios
                //DML operation
                insert objCase;  
       attachment a = new attachment();
       a.body = blob.valueOf('test body');      
       a.name = 'test file';
       a.ParentId = objCase.id;
       insert a;
       list<attachment> att = new list<attachment>();
       att.add(a);
       string blobVal=EncodingUtil.base64Encode(blob.valueOf('Name,Country,Mobile\nSuresh,IN,1234\nRamesh,IN,1234\nRitesh,IN,1234'));
       AB_CreateCaseService.Post(userinfo.getusername(),'Test subject','Test Description','High','testfile.txt',blobVal,'testfile.txt',blobVal,'testfile.txt',blobVal);
       AB_CreateCaseService.sendEmailFunction('Subject','Description',att,objCase.id,'test@test.com'); 
    }
    
    static testMethod void myUnitTest2() {
       //Throwing Error
       string blobVal=blob.valueof('Name,Country,Mobile\nSuresh,IN,1234\nRamesh,IN,1234\nRitesh,IN,1234').toString();
       AB_CreateCaseService.Post(userinfo.getusername(),'Test subject','Test Description','High','testfile.txt',blobVal,'testfile.txt',blobVal,'testfile.txt',blobVal);
        
    }
}