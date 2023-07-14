public class ClearOpportunityClosedDate_handler {
    public static void clearDate(List<Opportunity> oppList) {
        system.debug('oppList------->' + oppList);
        if(oppList.size() > 0) {
            try {
                system.debug('oppList.size()------->' + oppList.size());
                for(Opportunity op : oppList) {
                    if (op.CloseDate == date.today()) {
                        system.debug('op.CloseDate------->' + op.CloseDate);
                        op.CloseDate = null;
                    }
                }
            }
            catch(Exception ex) {
                system.debug('Exception---ofLine--->'+ex.getLineNumber());
                system.debug('Exception---Message--->'+ex.getMessage());
            }
        }
    }
}