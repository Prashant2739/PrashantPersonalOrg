public class Test1{
	@future
	public static void method1(){
			list<contact> conToInsert = new list<contact>();
			for(integer i=0;i<5000;i++){
			contact con = new contact();
            con.AccountId= '0017F00001uqiZpQAI';
			con.lastname = 'Test'+i;
			conToInsert.add(con);
		}
			database.insert(conToInsert);
	}
}