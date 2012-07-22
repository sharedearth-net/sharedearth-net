////////////////////////////////////////////////////
// SharedEarth.net JS
// ------------------	
// Page class - people (/people/*)
////////////////////////////////////////////////////

// Let dojo know about us
dojo.provide("sen.page.search");

// Dependencies
dojo.require("dojo.fx");
dojo.require("dojo.NodeList-fx");
dojo.require("dojo.NodeList-manipulate");
dojo.provide("dojox.NodeList.delegate");
dojo.require("dojo.NodeList-traverse");

// for jquery live like functionality
dojo.extend(dojo.NodeList, {
    delegate: function ( selector,eventName, fn) {
        return this.connect(eventName, function (evt) {
            var closest = dojo.query(evt.target).closest(selector, this);
            if (closest.length) {
                fn.call(closest[0], evt);
            }
        }); //dojo.NodeList
    }
});

// Class definition
dojo.declare("sen.page.search", [sen.Page], {
    
	constructor: function () {
		
	},
	
	initUi: function() {

	},
	
	initEvents: function() {	
		this.inherited(arguments);	// Parent function
		dojo.query("body").delegate("li.people-holder p.action-link a", "onclick", this.peopleAction);	
	},
	
	peopleAction : function(e){

		var nl = new dojo.NodeList(e.target),
					targetNode = nl.parents(".action-link");

		// Show our loader
		dojo.style(e.target, "display", "none");
		targetNode.before('<div class="loader" style="margin-left:20px;display:inline-block;"></div>');
		
		return false;
	}

});
