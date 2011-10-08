dojo.provide("sen.app");

dojo.declare("sen.app", null, {
	
	constructor: function () {
		
	},
	
	init: function () {
		
		// Get the module name, then attempt to load the module
		var moduleName = this.getModuleName();
		this.loadModule(moduleName);
	},
	
	getModuleName: function () {
		
		var stubBase = window.location.pathname,
			stubMatches = stubBase.match(/^\/([A-Za-z]+)(\/)*([?]*)/),
			stub = stubMatches[1];
		
		return "sen.page."+stub;
	},
	
	loadModule: function (moduleName) {
		
		// Make sure we have a valid module name
		if (moduleName === undefined) {
			return;
		}
		
		dojo.require("sen.Page");	// Needed for every page class, so let's pull it in here
		
		// Use the omitModuleCheck param of dojo.require (second param)
		// This will mean we don't get a nasty error if the module doesn't exist
		// The dojo["require"] format is to fool the build script, otherwise we get an error
		dojo["require"](moduleName, true);
		
		dojo.ready(function () {
			
			// Check if the object exists, and if so, call its init() function
			// If not, there was no module for this page
			var module = dojo.getObject(moduleName);
			
			if (module) {
				var senModule = new module();
				senModule.init();
				
				dojo.addOnUnload(function () {
					senModule.unload();
				});
			}
			
			var error_div = dojo.byId("error_explanation");
			if (error_div){
				
				if ( senModule && senModule.notify ) {
					// module does not inherit Page
					var page_obj = senModule;
				}
				else
				{
					var page_obj = new sen.Page();
				}
				
			  var title = dojo.byId("error_title").innerHTML;
			  var list = dojo.byId("error_list").innerHTML;
			  page_obj.notify({ title: title, body: list });
			}
			
		});
	}
});
