// Lightbox

$(document).ready(function(){
  var lightbox_wrapper = $('#lightbox_wrapper');

  function closeLightbox(e) {
    e.preventDefault();
    lightbox_wrapper.removeClass('overlayed');
    setTimeout(function () { lightbox_wrapper.removeClass('loaded'); }, 20);

    setTimeout(function () {
      lightbox_wrapper.addClass('hidden');
      $(lightbox_wrapper).find('section.lightbox').remove();
    }, 10);
  };

  $(lightbox_wrapper).find('.overlay').click(closeLightbox);

  function openLightbox (e) {
    e.preventDefault();

    var to_remove = $(lightbox_wrapper).find('section.lightbox');

    if (to_remove.length > 0) {
      to_remove.css('opacity', 0);
      to_remove.remove();
      lightbox_wrapper.removeClass('loaded');
    }

    lightbox_wrapper.removeClass('hidden');
    lightbox_wrapper.addClass('loading');

    setTimeout(function () { lightbox_wrapper.addClass('overlayed'); }, 50);

    $.ajax({
      url: this.href,
      type: 'get',
      success: function(data, status, xhr) {
        lightbox_wrapper.removeClass('loading');
        lightbox_wrapper.addClass('loaded');
        $(lightbox_wrapper).append(data);
        $(lightbox_wrapper).find('.close').click(closeLightbox);

        $(lightbox_wrapper).find('[interaction=lightbox]').click(openLightbox);
      }
    });
  }

  $('[interaction=lightbox]').click(openLightbox);
});