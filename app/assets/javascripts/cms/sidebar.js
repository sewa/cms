$(document).ready(function() {

  var sidebar = $('.sidebar');
  if (sidebar.length > 0) {

    var sidebar_top = sidebar.position().top,
        document_height = $(document).height(),
        nav_height = $('.top-bar').outerHeight() + $('.sub-navi').outerHeight() + $('.breadcrumbs').outerHeight();

    function set_height(height) {
      sidebar.height(height);
      $('.image img', '.sidebar').css({
        'max-height': (height / 100) * 80
      }).fadeIn();
    };

    $(document).scroll(function() {
      var scroll_top = $(document).scrollTop() + $('.top-bar').outerHeight();
      if (scroll_top >= sidebar_top) {
        $('.sidebar').css('position', 'fixed');
        $('.sidebar').css('right', '0px');
        $('.sidebar').css('top', $('.top-bar').outerHeight());
        set_height(document_height);
      } else if (scroll_top < sidebar_top){
        $('.sidebar').css('position', 'static');
        set_height(document_height - nav_height);
      }
    });

    set_height(document_height - nav_height);

  }

});
