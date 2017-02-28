public class ABS_UserCreation_RestAPI_Mock {

public static HttpResponse mockAutheticate(){
	HttpResponse res = new HttpResponse();
	res.setBody('{"access_token":"00De0000005F0X2!ARsAQELDdXNgjOCb9Tx0Jrz1YygaUONXWV8Rh0nSd7X6rC3.frJfpsJPLsl6uoXpy9S50TtUC6DrPeLoxP9.yWKwtj.Q3HuM","instance_url":"https://abiglobal--GloSIT.cs15.my.salesforce.com","id":"https://test.salesforce.com/id/00De0000005F0X2EAK/005e0000003WsB5AAK","token_type":"Bearer","issued_at":"1487226099899","signature":"WCZQzq0Wyp0/GUZPyR3tOu56WpdIbgt2hYkMBq4PGBc="}');
	res.setStatusCode(200);
	res.setStatus('OK');
	return res;
}

}