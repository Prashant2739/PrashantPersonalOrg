public with sharing class TestOpenWeather {
    
    public string city{get;set;}
    public string temp{get;set;}
    public string pressure{get;set;}
    public string humidity{get;set;}
    public string temp_min{get;set;}
    public string temp_max{get;set;}
    public string Windspeed{get;set;}
    public string Winddegree{get;set;}
    
    public TestOpenWeather(ApexPages.StandardController stdcontroller) {
        Account acc = (account)stdcontroller.getRecord();
        acc = [SELECT Id, ShippingCity from Account where Id =:acc.id];
        
        string Accountcity = acc.ShippingCity;
        string apiKey = '08d904561c401e6d36053a13ef6cabb2';
        
        string requestEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
        requestEndPoint += '?q='+Accountcity;
        requestEndPoint += '&units=metric';
        requestEndPoint += '&APPID='+apiKey;
        
        Http http = new Http();
        HTTPRequest request = new HTTPRequest();
        request.setEndPoint (requestEndPoint);
        request.setMethod('GET');
        HTTPResponse response = http.send(request);
        
        if (response.getStatusCode()== 200){
            map<string,object> results = (map<string,object>)JSON.deserializeUntyped(response.getBody());
            city = string.valueOf(results.get('name'));
            map<string,object> mainresults = (map<string,object>)(results.get('main'));
            map<string,object> windresults = (map<string,object>)(results.get('wind'));
            temp = string.valueOf(mainresults.get('temp'));
            pressure = string.valueOf(mainresults.get('pressure'));
            humidity = string.valueOf(mainresults.get('humidity'));
            temp_min = string.valueOf(mainresults.get('temp_min'));
            temp_max = string.valueOf(mainresults.get('temp_max'));
            Windspeed = string.valueOf(windresults.get('speed'));
            Winddegree = string.valueOf(windresults.get('deg'));
        }
        else{
            apexpages.Message Mymsg = new apexpages.Message(apexpages.Severity.ERROR, 'There was an error in reading data');
            apexpages.addMessage(Mymsg);
        } 
    }
}