public class AccList{

    List<Account> a = [select Name, Industry, Type, Website, Fax from Account where type ='Customer - Channel'];
    
    public list<Account> getACC() {
    return a;
    }
}