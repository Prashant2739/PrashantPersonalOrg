@RestResource(urlMapping = '/showAccounts/')

global class ApexRestIntegration {
    
    @HTTPGet
    global static list<account> getAccount(){
        list<account> acc;
        try{
            acc = [SELECT Name, phone from Account limit 15]; 
            return acc;
        }
        catch(exception ex){
            system.debug('error'+ex.getMessage());
        }
        return acc;
    }
    
}