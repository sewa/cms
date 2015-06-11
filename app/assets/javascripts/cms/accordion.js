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

});
