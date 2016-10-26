/*Author: Appshark*/
/*Description: Sending User Notes Details to the External system.*/
/*Created date: 30/9/2016*/
/*Modification History:*/

@RestResource(urlMapping='/AB_UserNotesDetailsService/*')
global with sharing class AB_UserNotesDetailsService{
    
    @HttpPost //Method name
     // Sending Account Details and its key decision maker contact details to the External system.
     
    global static ResponseWrapper AB_UserNotesDetailsService()
    {
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        string strJSONBody = '';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
        }
        else{
             AB_UserNotesDetailsService_Test testAB = new  AB_UserNotesDetailsService_Test();
             string str =  AB_UserNotesDetailsService_Test.Uname;
            system.debug('str=='+str);
            //strJSONBody = '{\"AccountId\":\"001f000000pKybg\"}';
            strJSONBody = '{\"username\":\"'+str+'\"}';
        }
        list<UserNotesWrapper> listUserNotes = new list<UserNotesWrapper>();
        integer isSuccess = 0;
        string Message = '';
        try{
        UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
        system.debug('deserializedUser.uName=='+deserializedUser.username);
        list<user> logedinUser = new list<user>();
        if(deserializedUser.username != null && deserializedUser.username != ''){   
            logedinUser = [select id, Wholesaler_Number__c from user where username =: deserializedUser.username limit 1];//To get wholesaler Number of loged in user
        }
        list<ContentNote> listContentNotes = new list<ContentNote>();
        if(logedinUser != null && logedinUser.size() != 0){ 
            listContentNotes = [select id,content, title,CreatedDate,TextPreview,ownerid,createdbyid from contentnote where createdbyid =: logedinUser[0].id order by createddate desc];
        }
        if(listContentNotes != null){
            for(contentnote objNote : listContentNotes){
                UserNotesWrapper objUsrNteWrap = new UserNotesWrapper();
                objUsrNteWrap = PrepareNoteData(objNote);
                listUserNotes.add(objUsrNteWrap);
            }
        }
        isSuccess = 1;
        Message = 'Success.';
        }
        catch(exception e) {
                Message = 'Sorry, Something went wrong.';
                system.debug('e.getMessage()=='+e.getMessage());
                System.debug('Exception e '+e.getLineNumber());
                isSuccess = 0;
        }
        ResponseWrapper obj = new ResponseWrapper(listUserNotes,isSuccess,Message);
        return obj;
    }
    /*Description: if User note fields value is null, We are assigning to empty string*/
    public static UserNotesWrapper PrepareNoteData(contentnote objNote){
        UserNotesWrapper objNoteWrap = new UserNotesWrapper();
        if(objNote.id !=null)
            objNoteWrap.id = objNote.id; 
        else
            objNoteWrap.id = '';
        if(objNote.Title !=null)
            objNoteWrap.Title = objNote.Title; 
        else
            objNoteWrap.Title = ''; 
        /*if(objNote.TextPreview !=null)
            objNoteWrap.TextPreview = objNote.TextPreview; 
        else
            objNoteWrap.TextPreview = '';*/
        if(objNote.content !=null)
            objNoteWrap.TextPreview = objNote.content.toString().unescapeHTML4(); 
        else
            objNoteWrap.TextPreview = '';
        if(objNote.CreatedDate !=null){
            DateTime dT = objNote.CreatedDate;
            Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            //objNoteWrap.CreatedDate= string.valueOf(objNote.CreatedDate); 
            objNoteWrap.CreatedDate= string.valueOf(myDate);
        }    
        else
            objNoteWrap.CreatedDate= ''; 
        return objNoteWrap;
    }
    global class ResponseWrapper
    {
        public list<UserNotesWrapper> listUserNotes{get;set;}
        public integer isSuccess{get;set;}
        public string Message{get;set;}
        public ResponseWrapper(list<UserNotesWrapper> listUserNotes,integer isSuccess,string Message)
        {
            this.listUserNotes = listUserNotes;
            this.isSuccess = isSuccess;
            this.Message = Message;
        }
    }
    //Wrapper class for User notes on feeditem objectName=ContentNotes
    public class UserNotesWrapper
    {
        string id;        
        string Title;
        string TextPreview;
        string CreatedDate;
        
        
    }
    // Wrapper class to deserialize user details.
    public class UserDetailsWrapper 
    {
        string username; //holds the logedin username   
        //string accountid;    
        public UserDetailsWrapper(string u)
        {
            this.username = u;  
            //this.accountid = accountid;                       
        }
    }
 }