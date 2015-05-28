$(document).ready(function() {

  var sidebar = $('.sidebar');
  if (sidebar.length > 0) {

    var sidebar_top = sidebar.position().top,
        document_height = $(document).height(),
        nav_height = $('.top-bar').outerHeight() + $('.sub-navi').outerHeight() + $('.breadcrumbs').outerHeight();

    $(document).scroll(function() {
      var scroll_top = $(document).scrollTop();
      if (scroll_top >= sidebar_top) {
        $('.sidebar').css('position', 'fixed');
        $('.sidebar').css('right', '0px');
        $('.sidebar').css('top', '0px');
        sidebar.height(document_height);
      } else if (scroll_top < sidebar_top){
        $('.sidebar').css('position', 'static');
        sidebar.height(document_height - nav_height);
      }
    });

    sidebar.height(document_height - nav_height);

    $('.tabs', '.sidebar').tabs();
  }

});
