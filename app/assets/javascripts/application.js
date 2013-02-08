// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery.facebox
//= require lightbox




	$(document).ready(function() {
		/*      Main facebox   (i.e. sections)  */
	/*	$("#share-facebox").click(function (){
		$('#facebox .popup').css("cssText", "width: 566px !important;");	
		$('#facebox .content').css("cssText", "width: 560px !important;");	
		$('#facebox .content').css("cssText", "padding-right: 0px !important;");
		$('#facebox .content').css("cssText", "padding-bottom: 1px !important;");
		$('.modal').css("cssText", "margin: -11px 0px 0px -11px !important;");
		$('.modal').css("cssText", "position: inherit !important;");
		
		var html= $(".share-facebox-html").html();
	
		$.facebox(html);
		$(".close_image")./attr("src","/assets/img/icons/close-sprite-black.png");
	
		*/
		
		
			$('a[rel*=facebox]').facebox();
		
		
	//	});
						
	});
	
	function check1(){
		
	
		$("#purpose-type").val(10);
	
		faceboxcode();
	
	}	
	function check2(){
	$("#purpose-type").val(20);
	document.getElementById("checkbox-no").value=2;		
	faceboxcode();
	}
	function check3(){
	$("#purpose-type").val(30);
	document.getElementById("checkbox-no").value=3;
	faceboxcode();	
	}
	function check4(){
	$("#purpose-type").val(40);
	document.getElementById("checkbox-no").value=4;
	faceboxcode();	
  
	
	}
	function faceboxcode(){
	
	$("#purpose-type").val(10);	
	$("#item-type").val("share");


	Sharing(1,0);	

	}
  
  
  
	function DetailSharing(){
	
			
	$('#facebox .body').css("cssText", "height: 450px !important;width: 450px !important;");
	$('#facebox .popup').css("cssText", "height: 450px !important;width: 450px !important;");
	$('#facebox .content').css("cssText", "height: 450px !important;width: 450px !important;");
	$('.modal').css("cssText", "height: 450px !important;width: 450px !important;");
	
		$("#msj").html("");
		$("#msj").css("cssText","margin-top:-9px;")
	
		$('#change').css("cssText", "display:none !important;");
	
		$("#main-footer").html("<div id='share-footer' style='position:relative;bottom:-316px;'onClick='Sharing(0);'><div id='up-arrow'></div></div>");
		
		$("#detailed-sharing").html($("#share-in-details").html());
		
		var DetailHtml= $(".share-small-popup").html();
		
		$(".content:eq(1)").html(DetailHtml);
	
	
			
	
	}  
	function Sharing(v,e){
	
/*	$('#facebox .body').css("cssText", "width: 450px !important;height:200px !important;");
	$('#facebox .body').css("border-radius","10px 10px 10px 10px");
	$('#facebox .popup').css("cssText", "width: 450px !important;height:200px !important;");
	$('#facebox .popup').css("border-radius","10px 10px 10px 10px");
	$('#facebox .content').css("cssText", "width: 450px !important;height:200px !important;");
	$('#facebox .content').css("border-radius","10px 10px 10px 10px");
	$('.modal').css("cssText", "width: 450px !important;height:200px !important;");
	$('.modal').css("border-radius","10px 10px 10px 10px");
	
	$('#change').css("cssText", "display:block !important;");
	
	$("#detailed-sharing").html(" ");
	$("#main-footer").html("<div id='share-footer' style='position:relative;bottom:-6px;' onClick='DetailSharing();'><div  id='down-arrow' ></div></div>");
	
	var DetailHtml= $(".share-small-popup").html();
	
	
	
		
		if (v==1)
		{
		
		$.facebox(DetailHtml);
		}
		else
		{
		
			$(".content:eq(1)").html(DetailHtml);
			//$.facebox(DetailHtml);
		}
		
		*/

	$.facebox({div: '#share-small-popup'});
	
	document.forms[5].hid.value="small";
	}
	
	
	
	
	
	/*    Validation */
	function validate(text){
	
	if (text==""){
		if (document.forms[5].hid.value=="small"){
		$("#msj").html("Please fill above field");
		$("#msj").css("cssText","margin-top:-29px;")
		var LessHtml= $(".share-small-popup").html();
		$(".content:eq(1)").html(LessHtml);
		}
		else{
		
		$("#msj").css("cssText","position:absolute;bottom:87px; !important;");
		$("#msj").html("");
		DetailSharing();
		}
		return false;
	}
	else 
	{
		
		return true;
	}
	}
	
	/*   Upload photos  */
	function OpenBrowse(text,name){
	$("#browse_option").html("<input class='realupload' id='item_photo' name='item[photo]' type='file'>");
	$("#item_photo").css("cssText","margin-top:50px;")
	
	
	
	
	
	
	var DetailHtmlPhoto= $(".share-small-popup").html();
	
	$(".content:eq(1)").html(DetailHtmlPhoto);
	document.forms[5].share_text.value=text;
	
	
	document.forms[5].item_name[0].value=name;
	
	
	
	}
	
	/*  Dashboard text bar onclick for close button */
	function SetMainContainer(){
	
	$("#main-wrapper-container").css("cssText","margin-top:-15px !important;");
	}







$(document).ready(function() {
	$('#sidebar-left ul li').hover(function() {
		$('#sidebar-left ul li.selected').addClass('selected-leave');
		$('#sidebar-left ul li.selected').removeClass('selected');
	}, function(){
		$('#sidebar-left ul li.selected-leave').addClass('selected');
	});
});

$(document).ready(function() {
	$('.close').click(function() {
		$('.notification').hide();
	});	
});

/* code of function.js */

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

/* code of modal.js */

function overlay() {
	el = document.getElementById("overlay");
	el.style.visibility = (el.style.visibility == "visible") ? "hidden" : "visible";
}

/* textbox class on request-page */

$(document).ready(function() {
	$('input[type="radio"]').click(function() {
		$('label.active').removeClass('active');
		$(this).next().addClass('active');
	});	
});

/* Code for showing the preview when creating a new item */
$(document).ready(function() {
  $("#item_photo").change(function() {

    var fileInputElem = $(this)[0]; 
    var photoFile = fileInputElem.files[0];

    //Remove prev item picture, if any
    $('.item-pic').remove();

    var reader = new FileReader();
    reader.onload = function(evt) {

      //Create image element with the right stuff
      var photoPreview = $('<img />');
      photoPreview.attr('src', evt.target.result);
      photoPreview.attr('with', '150px');
      photoPreview.attr('height', '150px');
      photoPreview.attr('src', evt.target.result);
      photoPreview.addClass('item-pic');

      // Add new created picture to the right container
      var photoContainer = $('#item-pic-holder');
      photoContainer.removeClass('no-image-uploaded');
      photoContainer.append(photoPreview);
    };

    reader.readAsDataURL(photoFile);
  });
});

$(document).ready(function(){
	$('.my-activity').click(function(e){
		e.preventDefault();
		$(this).addClass('active');
		$('.actions').removeClass('active');
		$('.my-activity-click').removeClass('hidden-class');
		$('.my-action-click').addClass('hidden-class');
	});

	$('.actions').click(function(e){
		e.preventDefault();
		$(this).addClass('active');
		$('.my-activity').removeClass('active');
		$('.my-action-click').removeClass('hidden-class');
		$('.my-activity-click').addClass('hidden-class');
	});
});



$(document).ready(function() {

	// $('#myModal').modal('show')
	$('a[id*=share_mine]').click(function() {
		sharing_item = $(this);
		$.ajax({
		    type: "POST",
		    data: "",
			url: $(this).attr('action'),
		    dataType: "json",
		    success: function(data, textStatus) {
		        if (data.redirect) {
		            window.location.replace(data.redirect);
		        }
		        else {
					sharing_item.click(false);
		            sharing_item.replaceWith("item added");
					sharing_item.css({ 'color': '9c9e9c'});
		        }
		    }
		});
	});	
});

/* Remove default search box value on click  */

$(document).ready(function() {
	$('#search').click(function(e) {
		if ($(this).attr("value")=="Search")
		{	
		  $(this).attr("value","")
		  $(this).focus();
          e.preventDefault();
	    }
	});	
});

////////////////////////////////////////////////////////////////////////
// All code above should eventually be ported to Dojo


// THIS WAS SET FOR DEVELOPMENT ONLY, BUT IN THE INTEREST OF TRANSPARENCY AND
// NOT HIDING CODE FOR NOW IT IS GOING TO BE HOW IT IS USED PUBLICALLY
// At this stage there is no need to compile the code
dojo.registerModulePath("sen", "../../sen");
//dojo.registerModulePath("sen", "../../release/sen");    // FUTURE BUILD ENVIRONMENT

// Require the base sen.app class
dojo.require("sen.app");

dojo.ready(function() {
    var senApp = new sen.app();
    senApp.init();
});

// =require lightbox
