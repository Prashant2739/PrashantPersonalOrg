({
	doAdd : function(component, event, helper) {
		var num1 = component.get('v.Number1');
        var num2 = component.get('v.Number2');
        component.set ('v.output',parseInt(num1) + parseInt(num2));
	},
    doSub : function(component, event, helper) {
		var num1 = component.get('v.Number1');
        var num2 = component.get('v.Number2');
        component.set ('v.output',parseInt(num1) - parseInt(num2));
	},
 	doMult : function(component, event, helper) {
		var num1 = component.get('v.Number1');
        var num2 = component.get('v.Number2');
        component.set ('v.output',parseInt(num1) * parseInt(num2));
	},
	doDivide : function(component, event, helper) {
		var num1 = component.get('v.Number1');
        var num2 = component.get('v.Number2');
        component.set ('v.output',parseInt(num1) / parseInt(num2));
	},
})