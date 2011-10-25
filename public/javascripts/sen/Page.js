////////////////////////////////////////////////////
// SharedEarth.net JS
// ------------------	
// Base class for pages. Includes functionality 
// to show the overlay and basic functions that all
// pages will use
////////////////////////////////////////////////////

// Let dojo know about us
dojo.provide("sen.Page");

// Dependancies
dojo.require("dojo.window");

// Class definition
dojo.declare("sen.Page", null, {
    
	/**
	 * Default constructor
	 * Set up event and inFlight arrays ready for use
	 */
	constructor: function () {
        
		// Events connected on this page, kept for reference so that we can
		// disconnect them when the page unloads
		this.events = {
			notice: [],
			dashboard: [],
			comments: [],
			item: []
		};
		
		// In flight status for various parts of the page
		// This is used to keep track of when a particular request is active,
		// ie. the AJAX call is still waiting to return
		// Generally this is used to prevent the same event being triggered
		// multiple times, such as posting comments or approving actions
		this.inFlight = {
			dashboard: [],
			comments: []
		};
		
		// Connect any events we're going to need
		this.initEvents();
	},
	
	/**
	 * Initialisation function, starts interface, events, etc
	 */
	init: function() {
		
		// Init the interface and connect events
		this.initUi();
		this.initEvents();
	},
	
	initUi: function() {
		
	},
	
	/**
	 * Can be overridden from inheriting classes to provide additional event
	 * connections
	 */
	initEvents: function () {
		// Stub
	},
	
	/**
	 * Called on focus / blur for comment boxes to change their style
	 * and value
	 */
	toggleCommentBox: function(e) {
		
		if (e.type == "blur") {
			this.commentBlur(e.target);
		} else if (e.type == "focus") {
			this.commentFocus(e.target);
		}
	},
	
	commentBlur: function(commentNode) {
		
		dojo.animateProperty({
			node: commentNode,
			duration: 200,
			properties: {
				height: { start: "50", end: "15" }
			}
		}).play();
		
		if (dojo.attr(commentNode, "value") == "") {
			dojo.attr(commentNode, "value", dojo.attr(commentNode, "data-default"));
			dojo.removeClass(commentNode, "active-comment-box");
		}
	},
	
	commentFocus: function(commentNode) {
		
		dojo.animateProperty({
			node: commentNode,
			duration: 200,
			properties: {
				height: { start: "15", end: "50" }
			}
		}).play();
		
		if (dojo.attr(commentNode, "value") === dojo.attr(commentNode, "data-default")) {
			dojo.attr(commentNode, "value", "");
		}
		
		dojo.addClass(commentNode, "active-comment-box");
	},
	
	setDefaultText: function(node) {
		
		// If this is the first time the user has clicked, store the default
		// value for later replacement
		if (dojo.attr(node, "data-default") === "") {
			dojo.attr(node, "data-default", dojo.attr(node, "value"));
		}
		
		// Set as active if the browser has cached a value the user entered
		if (dojo.attr(node, "value") != dojo.attr(node, "data-default")) {
			dojo.addClass(node, "active-comment-box");
		}
	},
	
	/**
	 * Iterate through the array and disconnect all event references
	 * This will prevent memory leaks, and it's nice to clean up after ourselves
	 */
	disconnectEvents: function (eventType) {
		
		var dcEvents = (eventType !== undefined) ? this.events[eventType] : this.events;
		
		if (dojo.isArray(dcEvents)) {	// Only one event type
			
			dojo.forEach(dcEvents, dojo.disconnect);
			this.events[eventType] = [];
			
		} else {	// All event types
			
			for (var i in dcEvents) {
				if (dcEvents.hasOwnProperty(i)) {
					dojo.forEach(dcEvents[i], dojo.disconnect);
					this.events[i] = [];
				}
			}
		}
	},
	
	/**
	 * Called on page unload to disconnect events and perform any other cleanup
	 * required
	 * The connection to this event on page unload is established in
	 * sen/app.js
	 */
	unload: function() {
		// Disconnect our events
		this.disconnectEvents();
	},
	
	/**
	 * Open the notification dialog with a custom message
	 * Fail if we weren't given suitable values
	 */
	notify: function (notifyOptions) {
		
		var options = (notifyOptions !== undefined) ? notifyOptions : {};
		
		if (options.title !== undefined && options.body !== undefined) {
			
			// Set our values and options
			dojo.attr(dojo.byId("notification-title"), "innerHTML", options.title);
			dojo.attr(dojo.byId("notification-body"), "innerHTML", options.body);
			
			// Get the size of the window so we can calculate the position
			var windowBox = dojo.window.getBox();
			
			// Set the properties of the overlay box, the left and top positions
			dojo.style("notification-box", {
				display: "block",
				left: ( windowBox.w - dojo.style("notification-box", "width") ) / 2 + "px",
				top: ( (windowBox.h - dojo.style("notification-box", "height") ) / 2) - 20 + "px",
				position: "absolute"
			});
			
			// Set the window background for the overlay. i.e the body becomes darker
			dojo.style("notification-overlay", {
				display: "block",
				width: windowBox.w + "px",
				height: windowBox.h + "px"
			});
			
			// Allow clicks on the overlay to close the notification off
			this.events.notice.push(dojo.connect(dojo.byId("notification-overlay"), "onclick", this, "hideNotice"));
			this.events.notice.push(dojo.connect(dojo.byId("notification-close"), "onclick", this, "hideNotice"));
      this.events.notice.push(dojo.connect(dojo.byId("notification-ok"), "onclick", this, "hideNotice"));
		}
	},
	
	/**
	 * Hide the notification box
	 */
	hideNotice: function () {
		
		dojo.fadeOut({
			node: "notification-box",
			onEnd: function() {
				dojo.style("notification-box", { display: "none", opacity: "1.0" });
			}
		}).play();
		
		dojo.style("notification-overlay", { display: "none" });
		
		this.disconnectEvents("notice");
	},
	
	/*
	 * Show loading popup with ajax-loader.gif
	 * */
	showLoading: function(){

		// Get the size of the window so we can calculate the position
		var windowBox = dojo.window.getBox();
		
		// Set the properties of the overlay box, the left and top positions
		dojo.style("loading-box", {
			display: "block",
			left: ( windowBox.w - dojo.style("loading-box", "width") ) / 2 + "px",
			top: ( (windowBox.h - dojo.style("loading-box", "height") ) / 2) - 20 + "px",
			position: "absolute"
		});
		
		// Set the window background for the overlay. i.e the body becomes darker
		dojo.style("loading-overlay", {
			display: "block",
			width: windowBox.w + "px",
			height: windowBox.h + "px"
		});

	}
});
