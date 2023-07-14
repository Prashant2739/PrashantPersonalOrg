/**
* **********************************************************************************************************
* Class         :   AWSServices
* Test Classes  :   PhotoGalleryUtilityTest
* ***********************************************************************************************************
* @author       Extentia Information Technology
* @created      2020-Aug-07
* @version      1.0
* @description  The class "AWSServices" provide utility methods to consume AWS services. Like generating temporary credentials from AWS STS. 
*/
public with sharing class AWSServices {
    /**
    * @description  The method "getAWSCredentials" perform retrieves temporary credentials from AWS STS.
    * @param        validityInSeconds - The duration, in seconds, that the credentials should remain valid. Min is 900, Max is 129600 seconds.
    * @param        namedCredentialName - Named credentials for request authentication and endpoint details.
    * @return       AWSWrappers.AWSCredentials - AWS temporary credentials mapped in wrapper.
    */
    public static AWSWrappers.AWSCredentials getAWSCredentials(Integer validityInSeconds, String namedCredentialName){
        try{
            validityInSeconds = String.isNotBlank(String.valueOf(validityInSeconds))?validityInSeconds:900;  //Verify duration value
            if (String.isNotBlank(namedCredentialName)) {
                HTTPCalloutRequestWrapper request = new HTTPCalloutRequestWrapper();
                request.method = 'GET';
                request.urlParameters = String.join(new List<String>{'Action:GetSessionToken', 'DurationSeconds:'+validityInSeconds, 'Version:2011-06-15'}, '\n');
                request.endpoint = 'callout:'+namedCredentialName;
                request.timeout = '120000';
                HTTPCalloutService service = new HTTPCalloutService(request);
                HttpResponse response = service.sendRequest();
				System.debug('response body => '+response.getBody());
                if(response.getStatus() == 'OK' && response.getStatusCode() == 200){
                    return AWSServices.parseXMLSessionTokenResponse(response.getBody());  // parse the XML body of AWS response to retrieve credentials in wrapper
                }
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            System.debug('AWS_TEMP_CREDS_ERROR' +' Exception =>'+exp.getMessage());
        }

        return null;
    }

    /**
    * @description  The method "deleteAWSObject" perform delete operation for the given AWS S3 object key.
    * @param        key - Object key to be deleted from AWS S3 bucket.
    * @param        namedCredentialName - Named credentials for request authentication and endpoint details.
    * @return       Boolean - True if delete object callout is successful.
    */
    public static Boolean deleteAWSObject(String key, String namedCredentialName){
        try{
            if (String.isNotBlank(key) && String.isNotBlank(namedCredentialName)) {
                HTTPCalloutRequestWrapper request = new HTTPCalloutRequestWrapper();
                request.method = 'DELETE';
                request.endpoint = 'callout:'+namedCredentialName+'/'+key;
                HTTPCalloutService service = new HTTPCalloutService(request);
                HttpResponse response = service.sendRequest();
                if(response.getStatus() == 'No Content' && response.getStatusCode() == 204){
                    return true;    //response.getHeader('x-amz-delete-marker');  // parse the XML body of AWS response to retrieve credentials in wrapper
                }
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            System.debug('AWS_TEMP_CREDS_ERROR' +' Exception =>'+exp.getMessage());
        }

        return false;
    }

    /**
    * @description  The method "deleteAWSObject" perform delete operation for the given AWS S3 object key.
    * @param        key - Object key to be deleted from AWS S3 bucket.
    * @param        namedCredentialName - Named credentials for request authentication and endpoint details.
    * @return       Boolean - True if delete object callout is successful.
    */
    public static Boolean deleteAWSObjects(String key, String namedCredentialName){
        try{
            if (String.isNotBlank(key) && String.isNotBlank(namedCredentialName)) {
                HTTPCalloutRequestWrapper request = new HTTPCalloutRequestWrapper();
                request.method = 'POST';
                request.urlParameters = String.join(new List<String>{'delete:true'}, '\n');
                request.endpoint = 'callout:'+namedCredentialName;
                HTTPCalloutService service = new HTTPCalloutService(request);
                HttpResponse response = service.sendRequest();
                System.debug('request => '+request);
                System.debug('response => '+response);
                System.debug('response body => '+response.getBody());
                if(response.getStatus() == 'Ok' && response.getStatusCode() == 200){
                    return true;    //response.getHeader('x-amz-delete-marker');  // parse the XML body of AWS response to retrieve credentials in wrapper
                }
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            System.debug('AWS_TEMP_CREDS_ERROR' +' Exception =>'+exp.getMessage());
        }

        return false;
    }

    /**
    * @description  The method "parseXMLSessionTokenResponse" parse XML document return from AWS callout response. Keys are specific to 
    *               GetSessionToken method of AWS STS.
    * @param        responseBody - Stringified response body from request object which contains XML structure.
    * @return       AWSWrappers.AWSCredentials - AWS temporary credentials mapped in wrapper.
    */
    private static AWSWrappers.AWSCredentials parseXMLSessionTokenResponse(String responseBody){
        AWSWrappers.AWSCredentials parsedCredential;
        string resp = responseBody;
        system.debug('resp'+resp);
        try{
            if(String.isNotBlank(responseBody)){
                parsedCredential = new AWSWrappers.AWSCredentials();
                Dom.Document doc = new Dom.Document();
                doc.load(responseBody);
                Dom.XMLNode root = doc.getRootElement();
                Dom.XmlNode fetchData = root.getChildElement('GetSessionTokenResult','https://sts.amazonaws.com/doc/2011-06-15/').getChildElement('Credentials','https://sts.amazonaws.com/doc/2011-06-15/');
                parsedCredential.accessKeyId = fetchData.getChildElement('AccessKeyId', 'https://sts.amazonaws.com/doc/2011-06-15/').getText().trim();  
                parsedCredential.secretAccessKey = fetchData.getChildElement('SecretAccessKey', 'https://sts.amazonaws.com/doc/2011-06-15/').getText().trim(); 
                parsedCredential.sessionToken = fetchData.getChildElement('SessionToken', 'https://sts.amazonaws.com/doc/2011-06-15/').getText().trim(); 
                parsedCredential.expiration = (Datetime) JSON.deserialize(JSON.serialize(fetchData.getChildElement('Expiration', 'https://sts.amazonaws.com/doc/2011-06-15/').getText().trim()), Datetime.class);
            }
        }catch(Exception exp){
            /*FALSE POSITIVE: This is implemented for exception handling so that debugging gets easier. There isn’t any sensitive information.*/
            System.debug('AWS_RESPONSE_MISMATCH' +' Exception =>'+exp.getMessage());
            parsedCredential = null;
        }
        system.debug('parsedCredential'+parsedCredential);
        return parsedCredential;
    }
}