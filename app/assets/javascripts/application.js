// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery.facebox
//= require lightbox


$(document).ready(function() {		
		$('a[rel*=facebox]').facebox();
		$('.close_image').attr("src", "/assets/img/icons/close-sprite-black.png")
				
								
});


function check1() {

	$("#purpose-type").val(10);

	SmallSharing();

}

function check2() {
	$("#purpose-type").val(20);
	document.getElementById("checkbox-no").value = 2;
	SmallSharing();
}

function check3() {
	$("#purpose-type").val(30);
	document.getElementById("checkbox-no").value = 3;
	SmallSharing();
}

function check4() {
	$("#purpose-type").val(40);
	document.getElementById("checkbox-no").value = 4;
	SmallSharing();

}
    
    
  var isDetail = false;
  var detailHTML = "";  
	
	function DetailSharing(){
		
		if (isDetail== false)
		{
			
			if(detailHTML=="")
			 detailHTML = $(".content #share-in-details").html();
  
  		$(".content #share-in-details").html("");  			
			$(".content #detailed-sharing").html(detailHTML).show(100);									
			$(".content #down-arrow").css("background", "url('/assets/img/icons/up_arrow.png') no-repeat 0 5px");
			//document.forms[5].hid.value = "detail";			
			isDetail = true;
		}		
		else
		{
			$(".content #detailed-sharing").html("");
			isDetail = false;
			$(".content #down-arrow").css("background", "url('/assets/img/icons/down_arrow.png') no-repeat 0 5px");
		}
		
	}  
	function SmallSharing(){
		
		$("#item-type").val("share");
		$.facebox({div: '#share-small-popup'});

		$('.content #change').click(function() {			
			$("#share-facebox").click();									
		});
		
	}
	
	
	/*    Validation */
	function validate(text){	
		if (text==""){				
				$(".content #msj").html("sss").html("Please fill all fields");				
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
		
		$("#settings-dd a").click(function() {			
			window.location = $(this).attr('href');
		});
		
//		return false;
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
