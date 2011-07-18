/*
	Copyright (c) 2004-2011, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/

/*
	This is an optimized version of Dojo, built for deployment and not for
	development. To get sources and documentation, please visit:

		http://dojotoolkit.org
*/

dojo.provide("sen.app");if(!dojo._hasResource["sen.app"]){dojo._hasResource["sen.app"]=true;dojo.provide("sen.app");sen.app={init:function(){var _1=this.getModuleName();this.loadModule(_1);},getModuleName:function(){var _2=window.location.pathname;stub=_2.replace(/^\//,"");return "sen.pages."+stub;},loadModule:function(_3){if(_3===undefined){return;}dojo["require"](_3,true);dojo.ready(function(){var _4=dojo.getObject(_3);if(_4){var _5=new _4();_5.init();dojo.addOnUnload(function(){_5.unload();});}});}};}
