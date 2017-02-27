global class AB_M360 {
    
    //######--Enable/Disable Logs--#####
    public static Boolean WriteLog=true;

    public static Void debug(string Label,Object msg){
        
        if (WriteLog) {
            debug(LoggingLevel.DEBUG,Label,msg);
        }
    }
    
    public static Void debug(LoggingLevel logLevel,string Label, Object msg){
        
        if (WriteLog) {
            System.Debug(logLevel,'>>>> '  + Label + ': ' + msg);
        }
    }
        
        
    
    //######--END--Enable/Disable Logs--#####
    
    //######--Exception Handling--##### 
    public static string EventLog(Exception e)
    {
        
        string strReturn = 'Sorry, Something went wrong.'+e.getMessage()+e.getlinenumber();
        system.debug('e.getMessage()=='+e.getMessage()+e.getlinenumber());
        
        return strReturn;
    }
    //######--END--Exception Handling--#####
    
    
    public static List<selectOption> getPickListselectOptions(SObjectField fieldName)
    {     
	     List<selectOption> defaultOption = new  List<selectOption>();
	     DefaultOption.add(new SelectOption('None','None'));
	     for (Schema.PicklistEntry f : getPickListEntries(fieldName) )
	     {
	            defaultOption.add(new SelectOption(f.getLabel(),f.getvalue()));
	     }  
        return defaultOption;
    }
    
    public static List<string> getPickListLabels(SObjectField fieldName)
    {     
	      return getPickLists(fieldName,false);
    }
    
     public static List<string> getPickListValues(SObjectField fieldName)
    {    
        return getPickLists(fieldName,true);
    }
    
    public static List<string> getPickLists(SObjectField fieldName,boolean isValues)
    {     
	     List<string> listReturn = new  List<string>();
	     for (Schema.PicklistEntry f : getPickListEntries(fieldName) )
	     {
	            listReturn.add(isValues == true ?f.getvalue() : f.getLabel());
	     }  
        return listReturn;
    }
    
    public static List<Schema.PicklistEntry> getPickListEntries(SObjectField fieldName)
    {
	     Schema.DescribeFieldResult field = fieldName.getDescribe();
	     return field.getPicklistValues();	     
    }
    
}