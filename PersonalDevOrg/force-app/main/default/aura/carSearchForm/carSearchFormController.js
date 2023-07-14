({
	onSearchClick : function(component, event, helper) {
		helper.handleOnSearchClick(component, event, helper);
	},
    
    toggleButton : function(component, event, helper) {
        var cmpValue = component.get("v.isNewAvailable");
        console.log(cmpValue);
        if(cmpValue){
           component.set("v.isNewAvailable",false);
            console.log('In the true block');
        } else{
           component.set("v.isNewAvailable",true);
            console.log('In the false block');
        }
            
    },
    
    newValueSelected : function(component, event, helper) {
        var selectedOption = component.find("carTypeList").get("v.value");
        alert(selectedOption+'Option');
        
    }
 

})