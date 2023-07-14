({
	doinit : function(component, event, helper) {
        var objectnames= component.get("v.objectNamesForDesign");
        var parts= objectnames.split(",");
        var objectNameList=[];
        for(var i = 0; i < parts.length; i++){
            objectNameList.push(parts[i]);
        }
        component.set("v.objectNamesForApexParameter",objectNameList);
        var action = component.get("c.getAllObjectsLabel");
        action.setParams({ 
            objApiList : component.get("v.objectNamesForApexParameter") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.objectsLabel", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
        
    },
})