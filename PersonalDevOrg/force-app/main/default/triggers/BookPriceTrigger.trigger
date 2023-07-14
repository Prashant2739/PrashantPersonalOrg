trigger BookPriceTrigger on Book__c (before insert) {

    Book__c[] books = Trigger.new;
   BooksPrice.applyDiscount(books);
    
}