/*
	Copyright (c) 2004-2011, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["sen.app"]){dojo._hasResource["sen.app"]=true;dojo.provide("sen.app");sen.app={init:function(){var _1=this.getModuleName();this.loadModule(_1);},getModuleName:function(){var _2=window.location.pathname,_3=_2.match(/^\/([A-Za-z]+)(\/)*([?]*)/),_4=_3[1];return "sen.pages."+_4;},loadModule:function(_5){if(_5===undefined){return;}dojo["require"](_5,true);dojo.ready(function(){var _6=dojo.getObject(_5);if(_6){var _7=new _6();_7.init();dojo.addOnUnload(function(){_7.unload();});}});}};}