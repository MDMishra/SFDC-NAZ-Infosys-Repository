/**
  Author: Suresh
  Description: This class contains unit tests for validating the behavior of AB_CreateCaseService apex classes
  Created date: 09/11/2016
  Modification History: 
*/
    
@isTest
private class AB_CreateCaseService_Test {

  static testMethod void myEmptyUnitTest() { 
        AB_CreateCaseService.Post('','','','','','','','',''); 
    } 

    static testMethod void myUnitTest1() {
               
       string blobVal=EncodingUtil.base64Encode(blob.valueOf('Name,Country,Mobile\nSuresh,IN,1234\nRamesh,IN,1234\nRitesh,IN,1234'));
       AB_CreateCaseService.Post('Test subject','Test Description','2','testfile.txt',blobVal,'testfile.txt',blobVal,'testfile.txt',blobVal);
        
    }
    
    static testMethod void myUnitTest2() {
       //Throwing Error
       string blobVal=blob.valueof('Name,Country,Mobile\nSuresh,IN,1234\nRamesh,IN,1234\nRitesh,IN,1234').toString();
       AB_CreateCaseService.Post('Test subject','Test Description','2','testfile.txt',blobVal,'testfile.txt',blobVal,'testfile.txt',blobVal);
        
    }
}