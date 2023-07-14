({
    handleClick : function(cmp, event, helper) {
        var navService = cmp.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'home'
            }
        };
        cmp.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.navigate(pageReference);
        /*.then($A.getCallback(function(url) {
            cmp.set("v.url", url ? url : defaultUrl);
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }*));*/
    },
    
})