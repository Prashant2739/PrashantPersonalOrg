({
    /**
     * Init function to build data table columns and data from server
     * Buid a page reference for the component where we need to navigate
     * @author Manish Choudhari
     * */
    doInit : function(component, event, helper) {
        //buiding a page reference for the component where we need to navigate
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__TargetNavigation',
            }
        };
        component.set("v.pageReference", pageReference);
        
        //setting up data table columns
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone'},
            {label: 'Rating', fieldName: 'Rating', type: 'text'},
            {label: 'Industry', fieldName: 'Industry', type: 'text'},
            {label: 'Active', fieldName: 'Active__c', type: 'boolean'},
            {label: 'Action', type: 'button', initialWidth: 135, typeAttributes: 
             { label: 'Edit', name: 'edit_details', title: 'Click to Edit Details'}}
        ]);
        
        //get data from server 
        var action = component.get("c.getAccounts");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    /**
     * This method will be called when Edit button is clicked in data table
     * Setting up state parameter in page reference to pass the record id
     * Navigate to UrlAddressable component
     * @author Manish Choudhari
     * */
    handleRowAction : function (component, event, helper) {
        var action = event.getParam('action');
        var record = event.getParam('row');
        var pageReference = component.get("v.pageReference");
        switch (action.name) {
            case 'edit_details':
                //set page state to pass record id parameter
                pageReference.state = {"c__recordId": record.Id, "c__objectName": "Account"};
                
                //navigate to component
                var navService = component.find("navService");
                event.preventDefault();
                //navigate function navigates to page reference
                navService.navigate(pageReference);
                break;
        }
    },
})