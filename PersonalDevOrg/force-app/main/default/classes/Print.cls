Public class Print{

    string S1 ='This is my first custom controller';
    string S2 ='This is my first VF page';
    integer a=10;
    integer b=50;
    integer c;
    
    public string getfirst(){
        return S1;
    }
        
    public integer getLast(){
        c = a+b;
        return c;    
    }
}