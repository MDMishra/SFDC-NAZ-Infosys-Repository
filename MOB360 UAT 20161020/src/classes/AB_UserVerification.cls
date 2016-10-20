/*Author: Appshark*/
/*Description: To verify the provided Logedin username and password from external system*/
/*Dependent Class: UserAuthentication*/
/*Created date: 23/8/2016*/
/*Modification History: */

public with sharing class AB_UserVerification{
private static final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
private static final String NS_SF = 'urn:partner.soap.sforce.com';
    //To verify the provided Logedin username and password from external system
    public static String checkUserCredentials(String user, String password)
    {
        string returnStr = '';
        try{
            system.debug(user);
            system.debug(password);
            // As per http://wiki.developerforce.com/page/Enterprise_Login
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');   
            req.setTimeout(60000);// Setting callout time
            req.setEndpoint('https://test.salesforce.com/services/Soap/u/29.0');// Setting Endpoint Url
            req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
            req.setHeader('SOAPAction', '""');
            req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +user+ '</username><password>' + password + '</password></login></Body></Envelope>');        
            HttpResponse res =  new Http().send(req);
            System.debug(res);
            system.debug(res.getStatusCode());
            system.debug(res.getBodyDocument());
            
            //If error or any exception occur
            if(res.getStatusCode() != 200)
            {
                system.debug(res.getStatusCode());
                Dom.Document responseDocument = res.getBodyDocument();
                Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
                Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
                Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); // soapenv:Fault
                Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); // faultstring          
                //throw new LoginException(faultStringElm.getText()); 
                returnStr = faultStringElm.getText();
            }
            //if no error occurs
            else
            {
                Dom.Document responseDocument = res.getBodyDocument();
                Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
                Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
                //Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
                //Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result
                //Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
                Boolean verified = res.getBodyDocument().getRootElement()
                      .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
                      .getChildElement('loginResponse','urn:partner.soap.sforce.com') != null;
                System.debug(verified);
                returnStr = 'Success';
            }
        }
        catch(exception e) {
            returnStr = e.getMessage();
            system.debug('returnStr=='+returnStr);
        }
        return returnStr;
    }
    
public class LoginException extends Exception {}
}