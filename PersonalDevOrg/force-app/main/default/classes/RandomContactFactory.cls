public class RandomContactFactory {
    public static List<Contact> generateRandomContacts (Integer numCons, String lstName){
        List<Contact> cons = new List<Contact>();
        
        for(Integer i=0;i<numCons;i++) {
            contact con = new contact(FirstName='TestAccount'+ i, LastName=lstName);
            cons.add(con);
        }   
        return cons;
    }
}