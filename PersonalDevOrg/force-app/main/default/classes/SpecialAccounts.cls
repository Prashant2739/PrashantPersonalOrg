global class SpecialAccounts {
    
    global class AccountInfo {
        webservice String AcctName;
        webservice Integer AcctNumber;
    }
    
    webservice static Account createAccount(AccountInfo info) {
        Account acct = new Account();
        acct.Name = info.AcctName;
        acct.AccountNumber = String.valueOf(info.AcctNumber);
        insert acct;
        return acct;
    }
    
    webservice static Id [] createAccounts(Account parent, 
                                           Account child, Account grandChild) {
                                               
                                               insert parent;
                                               child.parentId = parent.Id;
                                               insert child;
                                               grandChild.parentId = child.Id;
                                               insert grandChild;
                                               
                                               Id [] results = new Id[3];
                                               results[0] = parent.Id;
                                               results[1] = child.Id;
                                               results[2] = grandChild.Id;
                                               return results;
                                           }
}