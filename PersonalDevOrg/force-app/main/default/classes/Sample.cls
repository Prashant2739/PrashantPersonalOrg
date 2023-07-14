public class Sample 
{
    public Boolean option {get;set;}
    public Boolean bool {get;set;}
    
    public Sample()
    {
         bool = false;
    }
    public void change()
    {
        if(option == true)
        {
            bool = true;
        }
        else
        {
            bool = false;
        }
    }
}