public with sharing class SimpleServerSideController {
	
    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    
    public static string serverEcho(string FirstName){
        return('Hello From the Server  :'+ FirstName);
    }
}