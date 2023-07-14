({
    navigate : function(component, event, helper) {
        var test1 = component.get("v.test");
        var test2 = component.set("v.test", "12");
        var navigateEvent = $A.get("e.force:navigateToComponent");
        navigateEvent.setParams({
            componentDef: "c:Component2",
            //You can pass attribute value from Component1 to Component2
            componentAttribute : {
                accId : "12"
            }
        });
        navigateEvent.fire();
    }
})