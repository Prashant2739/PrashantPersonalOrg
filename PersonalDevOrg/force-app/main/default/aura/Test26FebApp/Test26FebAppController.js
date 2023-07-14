({
    setActive: function(component, event, helper) {
        var bout = component.find("bout");
        bout.forEach(function(v) {
            $A.util.removeClass(v, "active");
        });
        $A.util.addClass(event.target, "active");
    }
})