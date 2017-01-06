/*Author: Bharat*/
/*Description: Sending User Notes Details to the External system.*/
/*Created date: 30/9/2016*/
/*Modification History:*/

@RestResource(urlMapping='/AB_UserNotesDetailsService/*')
global with sharing class AB_UserNotesDetailsService{
    
    @HttpPost //Method name
          
    global static ResponseWrapper AB_UserNotesDetailsService()
    {
        RestRequest request = RestContext.request;// Here we can get the body sent from IOS application through Callout
        //system.debug('Name=='+request.requestBody.toString());
        string strJSONBody = '';
        if(!test.isRunningTest()){
            strJSONBody = request.requestBody.toString();// Holds the request body
        }
        else{
             
            strJSONBody = AB_UserNotesDetailsService_Test.strJSONBody;
        }
        list<UserNotesWrapper> listUserNotes = new list<UserNotesWrapper>();
        integer isSuccess = 0;
        string Message = '';
        try{
        UserDetailsWrapper deserializedUser = (UserDetailsWrapper)JSON.deserializeStrict(strJSONBody, UserDetailsWrapper.class);//To get request body.
        
        list<note> lstNotes = new list<note>();
        lstNotes = [select id,parentid,createdby.name,CreatedDate,title,body,lastmodifiedby.name,lastmodifieddate from note where parentid =: deserializedUser.accountId];
        if(lstNotes != null){
            for(note objNote : lstNotes){
                UserNotesWrapper objUsrNteWrap = new UserNotesWrapper();
                objUsrNteWrap = PrepareNoteData(objNote);
                listUserNotes.add(objUsrNteWrap);
            }
        }
        isSuccess = 1;
        Message = 'Success.';
        }
         catch(exception e) {Message = AB_M360.EventLog(e);isSuccess = 0;}
        
        ResponseWrapper obj = new ResponseWrapper(listUserNotes,isSuccess,Message);
        return obj;
    }
    /*Description: if User note fields value is null, We are assigning to empty string*/
    public static UserNotesWrapper PrepareNoteData(note objNote){
        UserNotesWrapper objNoteWrap = new UserNotesWrapper();
        if(objNote.id !=null)
            objNoteWrap.id = objNote.id; 
        
        if(objNote.Title !=null)
            objNoteWrap.Title = objNote.Title; 
        
        if(objNote.body !=null)
            objNoteWrap.TextPreview = objNote.body; 
        else
            objNoteWrap.TextPreview = '';
        if(objNote.CreatedDate !=null){
            DateTime dT = objNote.CreatedDate;
            //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            //objNoteWrap.CreatedDate= string.valueOf(myDate);
            objNoteWrap.CreatedDate= string.valueOf(dT.month())+'/'+string.valueOf(dT.day())+'/'+string.valueOf(dT.year());
        }    
        
        if(objNote.lastmodifieddate !=null){
            DateTime dT = objNote.lastmodifieddate;
            //Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());            
            //objNoteWrap.ModifiedDate= string.valueOf(myDate);
            objNoteWrap.ModifiedDate= string.valueOf(dT.month())+'/'+string.valueOf(dT.day())+'/'+string.valueOf(dT.year())+' '+dT.format('hh:mm a');
        }    
        
        if(objNote.Createdby.name !=null)
            objNoteWrap.CreatedBy= objNote.Createdby.name; 
        
        if(objNote.lastModifiedby.name !=null)
            objNoteWrap.ModifiedBy= objNote.lastModifiedby.name; 
        
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
        string ModifiedDate;
        string ModifiedBy;
        string CreatedBy;
        
    }
    // Wrapper class to deserialize user details.
    public class UserDetailsWrapper 
    {
        //string username; //holds the logedin username   
        string accountid;    
        public UserDetailsWrapper(string accountid)
        {
            //this.username = u;  
            this.accountid = accountid;                       
        }
    }
 }