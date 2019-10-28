$(document).ready(function() {

  var Accordion = {

    collapse: function(scope) {
      $('.content', scope).removeClass('active');
    },

    open: function(scope) {
      $(scope).css('height', 'auto');
      $('.content', scope).addClass('active');
    }

  };

  window.CmsAccordion = Accordion;

  // this is really ugly, but I can't come up with a better stateless solution
  if (window.location.hash != '') {
    $(window.location.hash).addClass('active');
    $('input#dom_id').val(window.location.hash);
  }
  if (typeof dom_id !== 'undefined' && dom_id) {
    $(dom_id).addClass('active');
    history.replaceState(null, null, dom_id);
  }

  $('.accordion').on('toggled', function (event, item) {
    var id = item.attr('id');
    if (item.hasClass('active')) {
      history.replaceState(null, null, '#'+id);
      $('input#dom_id').val('#'+id);
    } else {
      history.replaceState(null, null, ' ');
      $('input#dom_id').val('');
    }
  });
});
