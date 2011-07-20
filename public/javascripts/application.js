// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
	$('#sidebar-left ul li').hover(function() {
		$('#sidebar-left ul li.selected').addClass('selected-leave');
		$('#sidebar-left ul li.selected').removeClass('selected');
	}, function(){
		$('#sidebar-left ul li.selected-leave').addClass('selected');
	});
});


/* textbox class on request-page */

$(document).ready(function() {
	$('textarea').click(function() {
		$(this).addClass('active');
		$(this).val('');
	});	
});



//dojo.registerModulePath("sen", "../../sen");          // DEVELOPMENT ENVIRONMENT
dojo.registerModulePath("sen", "../../release/sen");    // BUILD ENVIRONMENT
dojo.require("sen.app");

dojo.ready(function() {
	sen.app.init();	
});