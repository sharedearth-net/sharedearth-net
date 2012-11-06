$(document).ready(function(){
	$("#settings-dd").click(function(event) {
		return false;
	});

	$('#settings-menu').click(function(event) {
		event.preventDefault();
		$('#settings-dd').toggle();
		return false;
	});
	 $(function() {
        $( "#tabs" ).tabs();
    });
	  $(function() {
        $( "#tabs" ).tabs();
    });
   	$('input.feedback').screwDefaultButtons({
        image: 'url("img/icons/feedback.png")',
        width: 123,
        height: 41
    });
});