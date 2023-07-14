({
    next : function(component, event, helper) {
        //Get the current selected tab value
        var currentTab = component.get("v.selTabId");
         
        if(currentTab == 'tab1'){
            component.set("v.selTabId" , 'tab2');   
        }else if(currentTab == 'tab2'){
            component.set("v.selTabId" , 'tab3');     
        }
    },
     
    back : function(component, event, helper) {
        //Get the current selected tab value  
        var currentTab = component.get("v.selTabId");
         
        if(currentTab == 'tab2'){
            component.set("v.selTabId" , 'tab1');     
        } else if(currentTab == 'tab3'){
            component.set("v.selTabId" , 'tab2');     
        }
    }
})