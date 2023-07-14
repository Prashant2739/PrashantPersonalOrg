({
	handleBubbling : function(component, event, helper) {
		event.stopPropagation();
        console.log('handler bubble in ---container');
        
	},
    handleCapture : function(component, event, helper) {
		console.log('handler capture in ---container');
        //event.stopPropagation();
	},
})