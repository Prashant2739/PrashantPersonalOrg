({
    
   handleClick: function (cmp, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": "0017F000024ddHGQAY",
            "slideDevName": "detail"
        });
        navEvt.fire();
    }
    
   
});