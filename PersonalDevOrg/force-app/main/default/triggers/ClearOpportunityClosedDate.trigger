trigger ClearOpportunityClosedDate on Opportunity (before insert, before Update) {
     if((trigger.IsInsert && trigger.IsBefore) || (trigger.IsUpdate && trigger.IsBefore)) {
        ClearOpportunityClosedDate_handler.clearDate(trigger.new);
    }
}