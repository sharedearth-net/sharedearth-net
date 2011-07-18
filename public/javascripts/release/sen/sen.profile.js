/*
	Copyright (c) 2004-2011, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


dependencies={action:"clean,release",optimize:"shrinksafe",releaseDir:"../../..",releaseName:"release",version:"1.6.1",layers:[{name:"dojo.js",dependencies:["dojo.parser"]},{name:"string.discard",resourceName:"string.discard",discard:true,copyrightFile:"myCopyright.txt",dependencies:["dojo.string"]},{name:"../../sen/sen.js",resourceName:"sen.app",layerDependencies:[],dependencies:["sen.app"]}],prefixes:[["sen","../../sen"]]};