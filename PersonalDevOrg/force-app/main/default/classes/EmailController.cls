public class EmailController{    
    public string toAddress{get;set;}
    public string message{get;set;}
    public PageReference sendingEmail(){
        Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
        String[] sendingTo = new String[]{toAddress};
        semail.setToAddresses(sendingTo);
        semail.setSubject('Single Email message Example');
        semail.setPlainTextBody('Hello!!!!!This is a test email to test single email message program');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
        message='Email Sent !!!';
        return null;
    }
}