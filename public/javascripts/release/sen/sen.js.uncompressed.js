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

dojo.provide("sen.app");
if(!dojo._hasResource["sen.app"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["sen.app"] = true;
dojo.provide("sen.app");

sen.app = {
	
    init: function() {
		
        // Get the module name, then attempt to load the module
		var moduleName = this.getModuleName();
		this.loadModule(moduleName);
    },
	
	getModuleName: function() {
		
		var stubBase = window.location.pathname;
		stub = stubBase.replace(/^\//, "");
		
		return "sen.pages."+stub;
	},
	
	loadModule: function(moduleName) {
		
		// Make sure we have a valid module name
		if (moduleName === undefined) {
			return;
		}
		
		// Use the omitModuleCheck param of dojo.require (second param)
		// This will mean we don't get a nasty error if the module doesn't exist
		// The dojo["require"] format is to fool the build script, otherwise we get an error
		dojo["require"](moduleName, true);
		
		dojo.ready(function() {
			
			// Check if the object exists, and if so, call its init() function
			// If not, there was no module for this page
			var module = dojo.getObject(moduleName);
			
			if (module) {
				var senModule = new module();
				senModule.init();
				
				dojo.addOnUnload(function() {
					senModule.unload();
				});
			}
		});
	}
};

}

