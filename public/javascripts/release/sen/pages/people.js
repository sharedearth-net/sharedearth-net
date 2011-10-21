////////////////////////////////////////////////////
// SharedEarth.net JS
// ------------------	
// Page class - people (/people/*)
////////////////////////////////////////////////////

// Let dojo know about us
dojo.provide("sen.page.people");

// Dependencies
dojo.require("dojo.fx");
dojo.require("dojo.NodeList-fx");
dojo.require("dojo.NodeList-traverse");
dojo.require("dojo.NodeList-manipulate");

// Class definition
dojo.declare("sen.page.people", [sen.Page], {
    
	constructor: function () {
		// Call our parent constructor
        this.inherited(arguments);
	},
	
	initUi: function() {
		// Hide submit buttons for adding comments
		dojo.query("form.new_comment input#comment_submit").forEach(function(node) {
			dojo.style(node, "display", "none");
		});
		
		//this.notify({ title: "Notification!", body: "Notification! Yeah!" });
	},
	
	initEvents: function() {
		
		this.inherited(arguments);	// Parent function
		
		this.connectDashboardEvents();
		this.connectCommentEvents();
	},
	
	connectDashboardEvents: function(prefix) {
		
		var selector = prefix !== undefined ? prefix + ".dashboard-action-link" : ".dashboard-action-link",
			self = this;
		
		// Disconnect dashboard actions
		this.disconnectEvents("dashboard");
		
		// Connect each action
		// TODO: Currently this will remove all events and re-attach them
		// Would be good to find a way to just remove the ones that were
		// remove()d and connect only new elements
		dojo.query(selector).forEach(function(node) {
			var eventConn = dojo.connect(node, "onclick", self, function(e) { self.doLinkClick(node, e); });
			self.events.dashboard.push(eventConn);
		});
		
		// Show hide comment lists
		dojo.query("a.action-comments-show-hide").forEach(function(node) {
			var eventConn = dojo.connect(node, "onclick", self, "toggleActionComments");
			self.events.comments.push(eventConn);
		});
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
			self.setDefaultText(node);
			
			var eventConn = dojo.connect(node, "onfocus", self, "toggleCommentBox");
			self.events.comments.push(eventConn);
		});
		
		// Make textareas smaller on blur
		dojo.query("form.new_comment textarea").forEach(function(node) {
			var eventConn = dojo.connect(node, "onblur", self, "toggleCommentBox");
			self.events.comments.push(eventConn);
		});
		
		// ABOUT ME BOX
		// Make textarea bigger on focus
		//dojo.query("#person_description").forEach(function(node) {
		//	var eventConn = dojo.connect(node, "onfocus", self, "toggleTextareaStyle");
		//	self.connectedEvents.comments.push(eventConn);
		//});
		//
		//// Make textarea smaller on blur
		//dojo.query("#person_description").forEach(function(node) {
		//	var eventConn = dojo.connect(node, "onblur", self, "toggleTextareaStyle");
		//	self.connectedEvents.comments.push(eventConn);
		//});
	},
	
	//toggleTextareaStyle: function(e) {
	//	
	//	if (e.type == "blur") {
	//		
	//		dojo.removeClass(e.target, "active-comment-box");
	//		
	//	} else {
	//		
	//		dojo.addClass(e.target, "active-comment-box");
	//	}
	//},
	
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
	
	toggleActionComments: function(e) {
		
		// Stop the link event and propagation
		dojo.stopEvent(e);
		
		var self = this,
			targetNode = new dojo.NodeList(e.target);
		
		targetNode.parents("div.inner-content").query("ul.comment-list").forEach(function(node) {
			dojo.toggleClass(node, "comment-list-hidden");
		});
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
				
				error: function(err, ioArgs){
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
	
	doLinkClick: function(node, e) {
		
		// Prevent the event from continuing and propagating in the browser
		dojo.stopEvent(e);
		
		var ajaxUrl = dojo.attr(e.target, "href"),
			self = this,
			nodeList = new dojo.NodeList(e.target),
			requestIdLink = nodeList.parents("li.content-box").children("a").attr("href"),
			requestId = String(requestIdLink).replace("/requests/", "");
		
		// Make sure we're not already processing an action for this request
		if (this.inFlight.dashboard[requestId] !== true) {
		
			// Show our loader
			var actionList = nodeList.parents("div.requests ul.action-list");
			actionList.forEach(function(node) {
				dojo.style(node, "display", "none");
			});
			actionList.before('<div class="loader"></div>');
			
			// This request is in flight, don't allow any more
			this.inFlight.dashboard[requestId] = true;
			
			// Rails requires a PUT
			dojo.xhrPut({
				url: ajaxUrl,
				handleAs: "json",
				content: {
					"authenticity_token": dojo.global.AUTH_TOKEN	// Required by Rails
				},
				load: function(data) {
					
					// TODO: Error checking if we got a bad request, or is it covered
					// by the error callback?
					if (data.success && data.success == false) {
						
						self.notify({ title: "Oops!", body: "Something went wrong. Please try again." });
						
					} else {
						
						var activityHtml = data.activity_html,
							requestHtml = data.request_html,
							requestNodeRemove = nodeList.parents("li.item"),
							requestNode = requestNodeRemove.prev(),
							activityNode = dojo.query("ul.dashboard-recent-activity").children().first(),
							redirectToFeedback = false;
						
						// Make sure we have an element, otherwise just find the parent and stick it in as the first element
						// Remove the activity node and put the new one in
						// Checks to make sure that the <ul> isn't empty apart from this node, and if so, act differently
						if (requestNode.length === 0) {
							
							requestNode = requestNodeRemove.parent();
							requestNodeRemove.remove();
							
							// Insert the HTML node
							if (String(requestHtml) !== "") {
								requestNode.forEach(function(node) {
									//dojo.place('<li class="content-box clearfix">'+requestHtml+'</li>', node, "first");
									requestNode.after("<p class='event-sentences'>There are no unanswered requests</p>");
								});
							} 
													
						} 
						actionList.parent().query("div.loader").remove();
						
					
					}
				},
				
				error: function (err, ioArgs) {
					self.notify({ title: "Oops!", body: "Something went wrong. Please try again." });
					
					// Show the textarea again and hide the loader
					actionList.forEach(function (node) {
						dojo.style(node, "display", null);
					});
					actionList.parent().query("div.loader").remove();
					
					// Finally, we're no longer in flight
					self.inFlight.dashboard[requestId] = false;
				}
			});
		}
	}
});
