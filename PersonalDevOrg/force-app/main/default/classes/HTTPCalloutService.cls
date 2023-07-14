/**
* **********************************************************************************************************
* Class         :   HTTPCalloutService
* Test Classes  :   PhotoGalleryUtilityTest
* ***********************************************************************************************************
* @author       Extentia Information Technology
* @created      2020-Aug-18
* @version      1.0
* @description  The class "HTTPCalloutService" is a generic framework and can be used to perform apex callouts to external systems.
*/
public class HTTPCalloutService {
    HTTPCalloutRequestWrapper calloutMetadata;
    String endpointURL;
    String requestMethod;
    String requestBody;
    Blob requestBodyAsBlob;
    Dom.Document requestBodyAsDocument;
    Integer requestTimeout;
    Map<String, String> urlParametersMap;
    Map<String, String> headerParametersMap;
    static final String TYPE_URL_PARAMETERS = 'URL_PARAMETERS';
    static final String TYPE_HEADER_PARAMETERS = 'HEADER_PARAMETERS';
    HTTPRequest request;

    /**
    * @description  Constructor to initilize request parrameters from request wrapper object.
    * @param        calloutRequestConfig - Request parameters wrapped in HTTPCalloutRequestWrapper object.
    */
    public HTTPCalloutService(HTTPCalloutRequestWrapper calloutRequestConfig) {
        try {
            calloutMetadata = calloutRequestConfig;
        } catch (Exception exp) {
            throw new CustomException('Invalid Callout Request.');
        }
        initialize();
    }

    /**
    * @description  Initialization of class variables.
    */
    private void initialize() {
        urlParametersMap = new Map<String, String>();
        headerParametersMap = new Map<String, String>();
        if(calloutMetadata != null) {
            endpointURL = calloutMetadata.endpoint;
            requestMethod = calloutMetadata.method;
            requestBody = calloutMetadata.body;
            requestTimeout = Integer.valueOf(calloutMetadata.timeout);
            setUrlOrHeaderParameters(TYPE_URL_PARAMETERS, calloutMetadata.urlParameters);
            setUrlOrHeaderParameters(TYPE_HEADER_PARAMETERS, calloutMetadata.headerParameters);
        }
    }

    /**
    * @description  This method is used to set URL or Header parameters from request wrapper.
    * @param        parameterType - Type of parameters for constructing callout request. Either TYPE_URL_PARAMETERS or TYPE_HEADER_PARAMETERS
    * @param        parameterInfo - Stringified parameters.  
    *               Example parameterInfo: String.join(new List<String>{'Key1:Value1', 'Key2:Value2', 'Key3:Value3'}, '\n');
    * @return       AWSWrappers.AWSCredentials - AWS temporary credentials mapped in wrapper.
    */
    private void setUrlOrHeaderParameters(String parameterType, String parameterInfo) {
        if(String.isNotEmpty(parameterInfo)) {
            Map<String, String> parametersMap = new Map<String, String>();
            List<String> parameters = parameterInfo.split('\n');
            for(String urlParam : parameters) {
                List<String> keyValuePair = urlParam.trim().split(':');
                if(!keyValuePair.isEmpty()) {
                    if(keyValuePair.size() == 2) {
                        if(String.isNotEmpty(keyValuePair[0]) && String.isNotEmpty(keyValuePair[1])) {
                            parametersMap.put(keyValuePair[0], keyValuePair[1]);
                        }
                    } else if(
                        (keyValuePair.size() == 1) &&
                        (parameterType != TYPE_HEADER_PARAMETERS)
                    ) {
                        if(String.isNotEmpty(keyValuePair[0])) {
                            parametersMap.put(keyValuePair[0], '');
                        }
                    }
                }
            }
            if(parameterType == TYPE_URL_PARAMETERS) {
                urlParametersMap.putAll(parametersMap);
            } else if(parameterType == TYPE_HEADER_PARAMETERS) {
                headerParametersMap.putAll(parametersMap);
            }
        }
    }

    /**
    * @description  This method is used to append the URL parameters stored in urlParametersMap class variable to the end of URL.
    */
    private void appendURLParameters() {
        Set<String> urlParamKeys = urlParametersMap.keySet();
        if(!urlParamKeys.isEmpty()) {
            endpointURL += '?';
            for(String urlParamKey : urlParamKeys) {
                endpointURL += urlParamKey + '=' + urlParametersMap.get(urlParamKey) + '&';
            }
            endpointURL = endpointURL.substringBeforeLast('&');
        }
    }

    /*
    * @description  This method is used to set Header parameters using headerParametersMap class variable.
    */
    private void addHeaderParameters() {
        for(String key : headerParametersMap.keySet()) {
            request.setHeader(key, headerParametersMap.get(key));
        }
    }

    /*
    * @description  This method is used to form HTTP Request
    */
    public void formHTTPRequest() {
        request = new HTTPRequest();
        addHeaderParameters();
        if(String.isNotEmpty(endpointURL)) {
            endpointURL = endpointURL.substringBefore('?');
            appendURLParameters();
            request.setEndpoint(endpointURL);
            system.debug('endpointURL'+endpointURL);
        }
        if(String.isNotEmpty(requestMethod)) {
            request.setMethod(requestMethod);
        }
        if(String.isNotEmpty(requestBody)) {
            request.setBody(requestBody);
        } else if((requestBodyAsBlob != null) &&  String.isNotEmpty(requestBodyAsBlob.toString())) {
            request.setBodyAsBlob(requestBodyAsBlob);
        } else if((requestBodyAsDocument != null) && String.isNotEmpty(requestBodyAsDocument.toXmlString())) {
            request.setBodyDocument(requestBodyAsDocument);
        }
        if(requestTimeout!=null) {
            request.setTimeout(requestTimeout);
        }
    }

    /*
    * @description  This method is used to send HTTP Request and return the HTTPResponse response.
    */
    public HTTPResponse sendRequest() {
        formHTTPRequest();
        Http http = new Http();
        return http.send(request);
    }

    public class CustomException extends Exception {}
}