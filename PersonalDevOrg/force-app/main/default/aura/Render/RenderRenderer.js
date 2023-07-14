({
	render: function(cmp, helper) {
       console.log('render');
       helper.changeValue(cmp);
       return this.superRender()
    },
})