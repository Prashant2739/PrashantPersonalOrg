global class AwsUtility{

public static string getSignedURL(string file) {
        String filename = EncodingUtil.urlEncode(file, 'UTF-8');
 
        String BucketName='prashant-rupnur-salesforce' ;
        String AccessKey= 'AKIAIXRXLAZBXKAYQ4MA';
        String SecretKey='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';
        
        Datetime now = DateTime.now();
        Datetime expireson = now.AddSeconds(60); // Lifespan of the link
        Long Lexpires = expireson.getTime()/1000000000;
        
        String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+BucketName+'/'+filename;
        System.debug('redirectToS3Key stringstosign: ' + stringtosign);
        
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(SecretKey));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringtosign),blob.valueof(SecretKey)); 
        String signed= EncodingUtil.base64Encode(mac);     
        String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        String url = 'http://'+BucketName+'.s3.amazonaws.com/'+filename+'?AWSAccessKeyId='+AccessKey+
                              '&Expires='+Lexpires+'&Signature='+signed;
        return url;
        
    }
}