$(document).ready(function() {

  var Search = {
    field: '.search-form input'
  };

  Search.execute = function(url, val) {
    $.ajax({
      url: url,
      data: { q: val },
      dataType: 'script'
    });
  };

  Search.init = function() {
    $(Search.field).parents('form').on( 'submit', function (event) {
      event.preventDefault();
    });
    $(document).on('keyup', Search.field, function() {
      var url = $(this).parents('form').attr('action'),
          val = $(this).val();
      if (val.length > 2) {
        Search.execute(url, val);
      } else if (val.length == 0) {
        Search.execute(url, '');
      }
      return false;
    });
  };

  window.CmsSearch = {
    init: Search.init
  };

});
