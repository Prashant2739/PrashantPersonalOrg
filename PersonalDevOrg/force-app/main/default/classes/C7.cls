public class C7{

    string keyword;
    List<Account> results = new List<Account>();
    
    public string getkeyword(){
        return keyword;
    }
    
    public List<Account> getresults(){
        return results;
    }
    
    public void setkeyword(string input){
         keyword= input;   
    }
    
    public pageReference Srearch_Now(){
    results = (List<Account>)[FIND: keyword in ALL Fields RETURNING Account(Name,Type,Industry,Phone,Fax)][0];    
    return Null;    
    }
}