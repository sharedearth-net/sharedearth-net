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

$(document).ready(function() {
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
