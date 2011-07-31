/*
	Copyright (c) 2004-2011, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["sen.page"]){dojo._hasResource["sen.page"]=true;dojo.provide("sen.page");dojo.require("dojo.fx");dojo.require("dojo.NodeList-fx");dojo.require("dojo.NodeList-traverse");dojo.require("dojo.NodeList-manipulate");dojo.declare("sen.page",null,{constructor:function(_1){},connectTextareaEvents:function(){var _2=this;dojo.query("a.comments-show-hide").forEach(function(_3){var _4=dojo.connect(_3,"onclick",_2,"toggleComments");_2.connectedEvents.comments.push(_4);});dojo.query("form.new_comment textarea").forEach(function(_5){var _6=dojo.connect(_5,"onfocus",_2,"toggleCommentBoxHeight");_2.connectedEvents.comments.push(_6);});dojo.query("form.new_comment textarea").forEach(function(_7){var _8=dojo.connect(_7,"onblur",_2,"toggleCommentBoxHeight");_2.connectedEvents.comments.push(_8);});},toggleCommentBoxHeight:function(e){if(e.type=="blur"){this.commentBlur(e.target);}else{this.commentFocus(e.target);}},disconnectCommentEvents:function(_9){dojo.forEach(this.connectedEvents.comments,dojo.disconnect);this.connectedEvents.comments=[];}});}