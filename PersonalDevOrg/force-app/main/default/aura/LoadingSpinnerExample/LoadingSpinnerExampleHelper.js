({
    getAccountsHelper : function(component, event, helper) {
        //call apex class method
        var action = component.get('c.getAccounts');
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in accListToDisplay attribute on component.
                component.set('v.accListToDisplay', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})