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

dojo.declare("sen.pages.items", null, {
	
	events: null,
	inFlight: null,
	
	init: function() {
		
		// Keep track of these so that we can disconnect them later
		this.events = {
			"comments": [],
			"item": []
		};
		
		// In flight data for requests
		this.inFlight = {
			"comments": []
		};
		
		// Init the interface and connect events
		this.initUi();
		this.initEvents();
	},
	
	initUi: function() {
		// Hide submit buttons for adding comments
		dojo.query("form.new_comment input#comment_submit").forEach(function(node) {
			dojo.style(node, "display", "none");
		});
		
		// Show default description for items
		dojo.query("#item_description").forEach(function(node) {
			
			if (dojo.attr(node, "value") == "") {
				dojo.attr(node, "value", dojo.attr(node, "default_description"));
			} else {
				dojo.addClass(node, "active");
			}
		});
	},
	
	initEvents: function() {
		
		this.connectItemEvents();
		this.connectCommentEvents();
	},
	
	connectItemEvents: function() {
		
		var self = this;
		
		// Connect item description events
		dojo.query("#item_description").forEach(function(node) {
			var eventConn = dojo.connect(node, "onfocus", self, "toggleItemDescription");
			self.events.item.push(eventConn);
		});
		
		dojo.query("#item_description").forEach(function(node) {
			var eventConn = dojo.connect(node, "onblur", self, "toggleItemDescription");
			self.events.item.push(eventConn);
		});
		
		// Connect form event
		dojo.query("form.edit_item").forEach(function(node) {
			var eventConn = dojo.connect(node, "onsubmit", self, function(e) {
				
				dojo.stopEvent(e);
				var itemDesc = dojo.byId("item_description");
				
				if (dojo.attr(itemDesc, "value") == dojo.attr(itemDesc, "default_description")) {
					dojo.attr(itemDesc, "value", "");
				}
				
				e.target.submit();
			});
			self.events.item.push(eventConn);
		});
	},
	
	disconnectItemEvents: function(prefix) {
		
		dojo.forEach(this.events.item, dojo.disconnect);
		this.events.item = [];
	},
	
	connectCommentEvents: function() {
		
		var self = this;
		
		// Comment form
		dojo.query("form.new_comment").forEach(function(node) {
			// Submit action - to remove later?
			var eventConn = dojo.connect(node, "onsubmit", self, "addComment");
			self.events.comments.push(eventConn);
			
			// Key press of 'enter' key
			var eventConn = dojo.connect(node, "onkeypress", self, "addComment");
			self.events.comments.push(eventConn);
		});
		
		// Show hide comment lists
		dojo.query("a.comments-show-hide").forEach(function(node) {
			var eventConn = dojo.connect(node, "onclick", self, "toggleComments");
			self.events.comments.push(eventConn);
		});
		
		// Make textareas bigger on focus
		dojo.query("form.new_comment textarea").forEach(function(node) {
			if (dojo.attr(node, "value") != "Write a comment...") {
				dojo.addClass(node, "active-comment-box");
			}
			
			var eventConn = dojo.connect(node, "onfocus", self, "toggleCommentBoxHeight");
			self.events.comments.push(eventConn);
		});
		
		// Make textareas smaller on blur
		dojo.query("form.new_comment textarea").forEach(function(node) {
			var eventConn = dojo.connect(node, "onblur", self, "toggleCommentBoxHeight");
			self.events.comments.push(eventConn);
		});
	},
	
	disconnectCommentEvents: function(prefix) {
		
		dojo.forEach(this.events.comments, dojo.disconnect);
		this.events.comments = [];
	},
	
	toggleItemDescription: function(e) {
		
		var node = e.target;
		
		if (e.type == "blur") {
			if (dojo.attr(node, "value") == "") {
				dojo.attr(node, "value", dojo.attr(node, "default_description"));
                dojo.removeClass(node, "active");
			}
		} else {
			if (dojo.attr(node, "value") == dojo.attr(node, "default_description")) {
                dojo.attr(node, "value", "");
            }
            dojo.addClass(node, "active");
		}
	},
	
	toggleCommentBoxHeight: function(e) {
		
		if (e.type == "blur") {
			this.commentBlur(e.target);
		} else {
			this.commentFocus(e.target);
		}
	},
	
	commentBlur: function(commentNode) {
		
		dojo.animateProperty({
			node: commentNode,
			duration: 200,
			properties: {
				height: { start: "30", end: "15" }
			}
		}).play();
		
		if (dojo.attr(commentNode, "value") == "") {
			dojo.attr(commentNode, "value", "Write a comment...");
			dojo.removeClass(commentNode, "active-comment-box");
		}
	},
	
	commentFocus: function(commentNode) {
		
		dojo.animateProperty({
			node: commentNode,
			duration: 200,
			properties: {
				height: { start: "15", end: "30" }
			}
		}).play();
		
		if (dojo.attr(commentNode, "value") == "Write a comment...") {
			dojo.attr(commentNode, "value", "");
		}
		
		dojo.addClass(commentNode, "active-comment-box");
	},
	
	toggleComments: function(e) {
		
		// Stop the link event and propagation
		dojo.stopEvent(e);
		
		var self = this,
			targetNode = new dojo.NodeList(e.target);
		
		// This is kind of hacky, the HTML generated really should be uniform
		if (targetNode.parents(".sidebar-box").query("ul.comment-list").length > 0) {
			targetNode.parents(".sidebar-box").query("ul.comment-list").forEach(function(node) {
				dojo.toggleClass(node, "comment-list-hidden");
			});
		} else {
			targetNode.parents(".sidebar-box").next().query("ul.comment-list").forEach(function(node) {
				dojo.toggleClass(node, "comment-list-hidden");
			});
		}
	},
	
	addComment: function(e) {
		
		//console.debug("content:", dojo.contentBox(dojo.attr(e.target, "value")), e.target, dojo.attr(e.target, "scrollHeight"));
		
		// Check if our target node is the form, or somewhere else
		// Somewhere else would mean it came from a keypress, not form submit
		if (dojo.getNodeProp(e.target, "tagName").toLowerCase() !== "form") {
			
			// Check if the enter key was pressed, otherwise don't do anything
			if (e.keyCode == dojo.keys.ENTER &&
				e.shiftKey == false) {
				
				dojo.stopEvent(e);	// Stop propagation and prevent default
				
				var nl = new dojo.NodeList(e.target),
					ajaxUrl = nl.parents("form").attr("action"),
					targetNode = nl.parents("form");
				
			} else if (e.keyCode == dojo.keys.ESCAPE) {
				
				// Blur the field, and return from here
				//console.debug("text:", e.target, dojo.attr);
				dojo.attr(e.target, "value", "");
				e.target.blur();
				this.commentBlur(e.target);
				return;
				
			} else {
				return;		// They're hitting shift+enter to add a new line, don't submit
			}
		} else {
			dojo.stopEvent(e);	// Stop propagation and prevent default
			
			var ajaxUrl = dojo.attr(e.target, "action"),
				targetNode = new dojo.NodeList(e.target);
		}
		
		var self = this,
			commentId = targetNode.query(".new-comment-commentable-id").first().attr("value"),
			comment = targetNode.query(".new-comment-text").first().attr("value");
		
		// Make sure we're not already adding a comment for this item
		if (this.inFlight.comments[commentId] !== true && comment != "") {
		
			// Show our loader
			dojo.style(e.target, "display", "none");
			targetNode.before('<div class="loader"></div>');
			
			// This request is in flight, don't allow any more
			this.inFlight.comments[commentId] = true;
			
			// POST for forms
			dojo.xhrPost({
				url: ajaxUrl,
				handleAs: "json",
				content: {
					"comment[commentable_id]": commentId,
					"comment[commentable_type]": targetNode.query(".new-comment-commentable-type").first().attr("value"),
					"comment[comment]": comment,
					"authenticity_token": dojo.global.AUTH_TOKEN,
					"utf8": "✓"
				},
				
				load: function(data) {
					
					// Successful request?
					if (data.success && data.success == false) {
						
						self.notify({ title: "Oops!", body: "Something went wrong. Please try again." });
						
					} else {
						var comment = String(data.comment_html).replace(/\"clearfix\"/, "\"clearfix new-comment\" style=\"opacity:0;\"");
						
						// Add the comment dom node and fade it in
						targetNode.parents(".comment-list").children("li.no-bg").before(comment);
						targetNode.parents(".comment-list").children("li.new-comment").fadeIn({auto: true, duration: 800});
						
						// Then find the text listing the number of comments, and increment the count
						var commentCountNode = targetNode.parents("div.inner-content").prev().query("a.comments-show-hide").first(),
							currentText = commentCountNode.attr("innerHTML");
							regExp = /([0-9]+)/g,
							currentCount = String(currentText).match(regExp);
						
						// Write the count back to the dom node
						var newComment = String(currentText).replace(regExp, parseInt(currentCount) + 1);
						commentCountNode.attr("innerHTML", newComment);
						
						// Blank out the textarea
						targetNode.query("textarea").attr("value", "");
						
						// Show the textarea again and hide the loader
						dojo.style(e.target, "display", null);
						targetNode.parent().query("div.loader").remove();
						
						// Finally, we're no longer in flight
						self.inFlight.comments[commentId] = false;
					}
				},
				
				error: function (err, ioArgs) {
					self.notify({ title: "Oops!", body: "Something went wrong. Please try again." });
					
					// Show the textarea again and hide the loader
					dojo.style(e.target, "display", null);
					targetNode.parent().query("div.loader").remove();
					
					// We're no longer in flight
					self.inFlight.comments[commentId] = false;
				}
			});
		}
		
		return;
	},
	
	unload: function() {
		// Called when the page is unloaded
		// Disconnect our events
		this.disconnectCommentEvents();
		this.disconnectItemEvents();
	}
});
