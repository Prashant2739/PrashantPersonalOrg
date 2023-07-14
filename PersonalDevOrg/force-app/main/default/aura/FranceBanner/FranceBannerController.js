({
	echo : function(cmp) {
        // create a one-time use instance of the serverEcho action
		// in the server-side controller
		var action = cmp.get("c.serverEcho");
        action.setParams({FirstName : cmp.get("v.FirstName")});
        
        action.setCallback(this, function(response){
			var state = response.getState();
        if (state === "SUCCESS"){
            alert("From Server :" +response.getReturnValue());
        }
        else if(state ==="Incomplete") {
            alert("Showing Message for :State is incomplete");
        }    
 	
});

	$A.enqueueAction(action); 
    }
    
})