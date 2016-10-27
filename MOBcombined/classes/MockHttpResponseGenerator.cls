@isTest

global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://example.com/study/GA00806', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"study":{"moleculeDescription":"RONTALIZUMAB","protocolTitle":"IMM","protocolNumber":"GA00806","studyName":"Interferon alpha in SLE Phase II LCM Option","therapeuticArea":"INFLAMMATORY,AUTOIMMUNE&BONE","startDate":"2009-03-25","endDate":"2013-08-22"}}');
        res.setStatusCode(200);
        return res;
    }
}