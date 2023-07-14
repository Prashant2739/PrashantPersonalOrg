({
	 callAuraMethod : function(component, event, helper) {
            var childCmp = component.find("childComponent");
            var retnMsg = childCmp.GetMessageFromChildMethod('Prashant','Sangli',32);
            component.set("v.message", retnMsg);
     }
})