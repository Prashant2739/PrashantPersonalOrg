public class AnimalLocator {
    
    public static String getAnimalNameById(Integer AnimalId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+AnimalId);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        AnimalResult result = (AnimalResult) JSON.deserialize(response.getBody(), AnimalResult.class);
        system.debug('name'+result.animal.name);
        return result.animal.name;
    }
}