({
    /**
     * Get page reference and set record id, object name attribute
     * @author Manish Choudhari
     * */
	doInit: function(component, event, helper) {
        //getting page reference from pageReference attribute supplied by lightning:isUrlAddressable interface
        var myPageRef = component.get("v.pageReference");
        //get parameter from state
        var recordId = myPageRef.state.c__recordId;
        var objectName = myPageRef.state.c__objectName;
        component.set("v.recordId", recordId);
		component.set("v.objectName", objectName);
        
    }
})