@RestResource(urlMapping='/getSpecificAccount/*')
global class RestgetAccount {
    
    @HTTPGet
    global static account doGet(){
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        string accountID1 = req.requestURI.substring(req.requestURI.lastIndexof('/')+1);
        account acc =[SELECT PHONE,website FROM account WHERE id=:accountID1];
        return acc;    
        
    }
    
    @HTTPPost
    global static string doPost(string name, string phone, string accountNumber,decimal ShippingPostalCode){
        account acc = new account();
        acc.Name = name;
        acc.Phone = phone;
        acc.AccountNumber = accountNumber;
        acc.ShippingPostalCode__c = ShippingPostalCode;
        insert acc;
        return acc.Id;
    }
    
}