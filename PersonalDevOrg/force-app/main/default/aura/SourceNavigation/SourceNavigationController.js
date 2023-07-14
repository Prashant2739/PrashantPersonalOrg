({
    init : function(cmp, event, helper) {
        var navService = cmp.find("navService");
        var pageReference = {
            
            "type": "standard__component",
            "attributes": {
                "componentName": "c__TargetNavigation"    
            },    
            "state": {
                'firstName':'Test',
                'lastName':'user'    
            }
        };
        cmp.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
        .then($A.getCallback(function(url) {
            cmp.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));
    },
    
    handleClick: function(cmp, event, helper) {
        console.log('Inside Logic');
        var navService = cmp.find("navService");
        // Uses the pageReference definition in the init handler
        var pageReference = cmp.get("v.pageReference");
        console.log('pageReference'+pageReference);
        event.preventDefault();
        navService.navigate(pageReference);
    }
})