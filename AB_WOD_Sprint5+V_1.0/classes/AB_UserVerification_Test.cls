@isTest
public class AB_UserVerification_Test implements HttpCalloutMock {
    private HttpResponse resp;
    private HttpResponse resps;
    
    public AB_UserVerification_Test(String testBody) {
        resp = new HttpResponse();
        ///resp.setBody(testBody);
        resp.setBody('<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"> <soap:Body> <PassThroughReqResponse xmlns=\"http://amsservices.com/\"> <PassThroughReqResult> <PickResponse> <Files> <File sagfile=\"WORK.7864470\"> <Item sagitem=\"WEBSERVICE.TAGS*WORK.7864470\"> <a1>POLICY.NUMBER</a1> <a2>CLIENT.CODE</a2> <a3>EFF.DATE</a3> <a4>EXP.DATE</a4> <a5>COV</a5> <a6>INS</a6> <a7>TERM</a7> <a8>POLICY.STATUS</a8> <a9>BILLING.METHOD</a9> <a10>31</a10> <a11>32</a11> <a12>33</a12> <a13>POLICY.STATUS</a13> <a14>NEW.REN</a14> <a15>CHG.TIME</a15> </Item> </File> <File sagfile=\"WORK.7864470\"> <Item sagitem=\"579615\"> <a1>TESTINGNEW</a1> <a2>ZIMJO1</a2> <a3>08/08/16</a3> <a4>08/08/17</a4> <a5>ARA</a5> <a6>CER</a6> <a7>A</a7> <a9>Agency Bill</a9> <a14>NEW</a14> <a15>12:06:46</a15> </Item> </File> </Files> </PickResponse></PassThroughReqResult> </PassThroughReqResponse> </soap:Body> </soap:Envelope>');
        resp.setStatusCode(500);
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        return resp;
    }
 
    public testmethod static void testSuccess() {
        String testBody = 'This is a test :-)';
        //String testBody = '{"username":"rajesh.kurumati@nuvemconsulting.com","password":"nuvem559"}';
        HttpCalloutMock mock = new AB_UserVerification_Test(testBody);
        Test.setMock(HttpCalloutMock.class, mock);
        String user = 'Test@tst.com';
        String password = 'tttt';
        AB_UserVerification callout = new AB_UserVerification();
        string resp = AB_UserVerification.checkUserCredentials(user,password);
        
       // System.assertEquals(500, resp.getStatusCode());        
        //System.assertEquals(resp.getBody(), testBody );
    }
    public testmethod static void testFailure() {
        String testBody = 'This is a test :-)';
        //String testBody = '{"username":"rajesh.kurumati@nuvemconsulting.com","password":"nuvem559"}';
        HttpCalloutMock mock = new AB_UserVerification_ImplementsMock2(testBody);//Refering external class
        Test.setMock(HttpCalloutMock.class, mock);
        String user = 'Test@tst.com';
        String password = 'tttt';
        AB_UserVerification callout = new AB_UserVerification();
        string resp = AB_UserVerification.checkUserCredentials(user,password);
        
        //System.assertEquals(200, resp.getStatusCode());        
        //System.assertEquals(resp.getBody(), testBody );
    }
 
    
}