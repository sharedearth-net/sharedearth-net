////////////////////////////////////////////////////
// SharedEarth.net JS
// ------------------	
// Page class - items (/items/*)
////////////////////////////////////////////////////
dojo.provide("sen.pages.items");

// Dependencies
dojo.require("dojo.fx");
dojo.require("dojo.NodeList-fx");
dojo.require("dojo.NodeList-traverse");
dojo.require("dojo.NodeList-manipulate");

dojo.declare("sen.page.items", [sen.Page], {
	
	events: null,
	inFlight: null,
	
	init: function() {
		// Init the interface and connect events
		this.initUi();
		
		// getting called from parent Page
		// need to remove it from Page.js but that looks like big change 
		// and might break other things
		// this.initEvents();
	},
	
	initUi: function() {
		
	},
	
	initEvents: function() {
		this.connectItemEvents();
	},
	
	connectItemEvents: function() {
		
		var self = this;

		dojo.query("form.edit_item, form.new_item").forEach(function(node) {
			var eventConn = dojo.connect(node, "onsubmit", self, function(e) {
				self.showLoading();
			});
			self.events.item.push(eventConn);
		});

	},
	
	disconnectItemEvents: function(prefix) {
		
		dojo.forEach(this.events.item, dojo.disconnect);
		this.events.item = [];
	},
	
	unload: function() {
		// Called when the page is unloaded
		// Disconnect our events
		this.disconnectItemEvents();
	}
});
