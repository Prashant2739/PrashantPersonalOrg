@RestResource(urlMapping='/v1/BookManagement/')
global class BookManager {
    @httpGet
    global static Book__c doGetBook(){
       	Book__c book = new Book__c();
        map<string,string> paramsMap = restcontext.request.params;
        string bookId = paramsMap.get('Id');
		book = [SELECT Id, Name, Price__c from Book__c where id =:bookId];   
        return book;
    }
    
    @httpDELETE
    global static string doDeleteBook(){
       	Book__c book = new Book__c();
        map<string,string> paramsMap = restcontext.request.params;
        string bookId = paramsMap.get('Id');
		book = [SELECT Id, Name, Price__c from Book__c where id =:bookId];
        delete book;
        return 'Record Deleted';
    }
    
    @httpPOST
    global static Book__c doPOSTBook(string name, decimal price){
       	Book__c book = new Book__c(Name=name,Price__c=price);
        insert book;
        return book;
    }
    
    @httpPUT
    global static Book__c doPUTBook(string name, decimal price){
        map<string,string> paramsMap = restcontext.request.params;
        string bookId = paramsMap.get('Id');
       	Book__c book = new Book__c(Name=name,Price__c=price,Id=bookId );
        update book;
        return book;
    }
}