({
    clickIt : function(component, event, helper) {
        component.set("v.strText", "Changing");
    },
    
    handleValueChange : function (component, event, helper) {
        alert("Original strText " + event.getParam("oldValue"));
        alert("Changed strText " + event.getParam("value"));
    }
})