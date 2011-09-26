define("sen/Page", ["dojo", "dojo/fx", "dojo/NodeList-fx", "dojo/NodeList-traverse", "dojo/NodeList-manipulate", "dojo/window"], function(dojo) {

dojo.declare("sen.Page", null, {
    
	constructor: function(params){
        
	},
	
	showNotice: function () {
		
		var windowBox = dojo.window.getBox();
		console.debug("w", ( windowBox.w - dojo.style("notification-box", "width") ) / 2);
		console.debug("h", ( (windowBox.h - dojo.style("notification-box", "height") ) / 2) - 20);
		
		// set the properties of the overlay box, the left and top positions
		dojo.style("notification-box", {
			display: "block",
			left: ( windowBox.w - dojo.style("notification-box", "width") ) / 2 + "px",
			top: ( (windowBox.h - dojo.style("notification-box", "height") ) / 2) - 20 + "px",
			position: "absolute"
		});
		
		// set the window background for the overlay. i.e the body becomes darker
		dojo.style("notification-overlay", {
			display: "block",
			width: windowBox.w + "px",
			height: windowBox.h + "px"
		});
	}
});

return sen.page;
});
