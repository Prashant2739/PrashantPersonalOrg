({
    getMessage : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.Name;
            var param2 = params.Age;
            var param3 = params.Address;
            return "##### Hello "+param1+" From Child Component ##### And Your age is "+param2+" and Adress is "+param3+" ";
        }
        return "";
    }
})