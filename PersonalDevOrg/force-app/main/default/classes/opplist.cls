public class opplist{

    list<opportunity> oppo = [select Name, Type, StageName, Amount from opportunity where StageName='Closed Won' ];
    List<Account> acc = [select Name, Industry, Type, Website, Fax from Account where type ='Customer - Channel'];
    
    public list<opportunity> getOppo(){
    return oppo;
    }
    
    public list<Account> getACC() {
    return acc;
    }
    
    public pagereference tab() {   
    return page.tabsPractice;
    }
    
    public pagereference section() {
    return page.Multiplelist;
    }
}