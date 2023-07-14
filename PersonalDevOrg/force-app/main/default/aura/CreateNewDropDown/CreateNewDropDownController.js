({
    handleChange : function(component, event, helper) {
        var action = component.get("c.fetchRecordTypeValues");
        var sObjectName = component.get("v.objectName");
        sObjectName.set("v.objectName",recordValue);
		action.setParams({ "objectName" : recordValue });
        var recordValue = component.find("createRecord").get("v.value");
        console.log(recordValue);
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({ 
                "entityApiName": recordValue
            });
        createRecordEvent.fire();
    }
})