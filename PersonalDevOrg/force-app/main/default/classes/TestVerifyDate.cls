@isTest
public class TestVerifyDate {
    @isTest static void testCheckDatesdate2() {
        Date d1 = VerifyDate.CheckDates(System.today(), System.today()+10);
        System.assertEquals(System.today()+10, d1);
    }
    
    @isTest static void testCheckDatesenddate() {
        Date d2 = VerifyDate.CheckDates(System.today(), System.today()+50);
        Date startDate = System.Date.today().toStartOfMonth(); 
        System.assertEquals(startDate.addMonths(1).addDays(-1), d2);
    }
    
    @isTest static void testDateWithin30Days() {
        Boolean d3 = VerifyDate.DateWithin30Days(System.today(), System.today()+10);
        System.assertEquals(True, d3);
    }
    
    @isTest static void testDateWithin30Days1() {
        Boolean d3 = VerifyDate.DateWithin30Days(System.today()+10, System.today());
        System.assertEquals(False, d3);
    }
    
    @isTest static void testDateWithin30Days2() {
        Boolean d3 = VerifyDate.DateWithin30Days(System.today(), System.today()+50);
        System.assertEquals(False, d3);
    }
    
    @isTest static void testSetEndOfMonthDate() {
        Date d3 = VerifyDate.SetEndOfMonthDate(System.today());
        Integer numberOfDays = Date.daysInMonth(d3.year(), d3.month());
        Date lastDayOfMonth = Date.newInstance(d3.year(), d3.month(), numberOfDays);
        System.assertEquals(lastDayOfMonth, d3);
    }
}