////////////////////////////////////////////////////
// SharedEarth.net JS
// ------------------	
// Page class - people (/people/*)
////////////////////////////////////////////////////

// Let dojo know about us
dojo.provide("sen.page.requests");

// Dependencies
dojo.require("dojo.fx");
dojo.require("dojo.NodeList-fx");
dojo.require("dojo.NodeList-traverse");
dojo.require("dojo.NodeList-manipulate");

// Class definition
dojo.declare("sen.page.requests", [sen.Page], {
    
	constructor: function () {
	},
	
	initUi: function() {
		// Hide submit buttons for adding comments
		dojo.query("form.new_comment input#comment_submit").forEach(function(node) {
			dojo.style(node, "display", "none");
		});
	},
	
	initEvents: function() {
		
		this.inherited(arguments);	// Parent function
		
		this.connectCommentEvents();
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
		
		// MIDDLE AREA
		// Make textareas bigger on focus
		dojo.query("#content form.new_comment textarea").forEach(function(node) {
			self.setDefaultText(node);
			
			var eventConn = dojo.connect(node, "onfocus", self, "toggleCommentBox");
			self.events.comments.push(eventConn);
		});
		
		// Make textareas smaller on blur
		dojo.query("#content form.new_comment textarea").forEach(function(node) {
			var eventConn = dojo.connect(node, "onblur", self, "toggleCommentBox");
			self.events.comments.push(eventConn);
		});
		
		// SIDEBAR
		// Make textareas bigger on focus
		dojo.query("#sidebar form.new_comment textarea").forEach(function(node) {
			self.setDefaultText(node);
			
			var eventConn = dojo.connect(node, "onfocus", self, "toggleCommentBox");
			self.events.comments.push(eventConn);
		});
		
		// Make textareas smaller on blur
		dojo.query("#sidebar form.new_comment textarea").forEach(function(node) {
			var eventConn = dojo.connect(node, "onblur", self, "toggleCommentBox");
			self.events.comments.push(eventConn);
		});
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
			
			// Make sure comment length is maximum 420
			if ( comment.toString().length > 420 ){
				self.notify({ title: "Oops!", body: "Comment is too long (maximum 420 characters)" });
			}
			else
			{

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
							
							// TODO: Refactor, don't need to hit the DOM so many times if we can just get the parents() nodeList
							if (targetNode.parents("div.content-box-holder").next().query(".comment-list").length > 0) {
								
								// Completed request
								if (targetNode.parents("div.content-box-holder").next().query(".comment-list").children("li").length > 0) {
									targetNode.parents("div.content-box-holder").next().query(".comment-list").children("li").first().before(comment);
								} else {
									targetNode.parents("div.content-box-holder").next().query(".comment-list").append(comment);
								}
								targetNode.parents("div.content-box-holder").next().query(".comment-list").children("li.new-comment").fadeIn({auto: true, duration: 800});
								
							// The comment might need to be added at the end of the list, or before the no-bg
							// textarea, depending on which part of the page it is on
							} else if (targetNode.parents(".comment-list").children("li").first().query("textarea").length > 0) {
								
								// Find whether we need the "even" CSS class
								var addEven = true;
								targetNode.parents(".comment-list").children("li").first().next().forEach(function(node) {
									if (dojo.hasClass(node, "even")) {
										addEven = false;
									}
								});
								
								// Comment box is at the top, so we're dealing with the left section
								// Add the comment dom node and fade it in
								targetNode.parents(".comment-list").children("li").first().after(comment);
								
								if (addEven === true) {
									targetNode.parents(".comment-list").children("li.new-comment").forEach(function(node) {
										dojo.addClass(node, "even");
									});
								}
								
								targetNode.parents(".comment-list").children("li.new-comment").fadeIn({auto: true, duration: 800});
							
							} else {
								
								// Comment box is not at the top, we're dealing with the right-hand activity feed
								// Add the comment dom node and fade it in
								targetNode.parents(".comment-list").children("li.no-bg").before(comment);
								targetNode.parents(".comment-list").children("li.new-comment").fadeIn({auto: true, duration: 800});
							}
							
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
		}
		
		return;
	}
});
