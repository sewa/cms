$(document).ready(function() {

  function mark_attribute(ul, input) {
    if (ul.children().length == 0) {
      input.val('-1');
    } else {
      input.val('');
    }
  };

  function attribute_not_empty(ul) {
    var input = $('input.empty', ul.parents('.row'));
    mark_attribute(ul, input);
  };

  function droppable(from, to, accept) {
    to.droppable({
      activeClass: 'active',
      // jqueryui has a bug in the accept callback when you use the clone helper.
      accept: function(d) {
        return d.parent().attr('class').match(accept);
      },
      drop: function(event, ui) {
        if(ui.helper.data().dragged == true) {
          ui.helper.data().dragged = false;
          var name = ui.draggable.parent().attr('data-name');
          ui.draggable.find('input[type=hidden]').attr('name', name);
          attribute_not_empty($(this));
        }
      }
    }).sortable({
      accept: from
    });
  };

  function draggable(from, to) {
    from.draggable({
      connectToSortable: to,
      revert: 'invalid',
      helper: 'clone',
      start: function(event, ui) {
        ui.helper.data().dragged = true;
      }
    });
  }

  function dragndrop(from, to, accept) {
    droppable(from, to, accept);
    draggable(from, to);
  };

  dragndrop($('.images li', '.sidebar'), $('.drop-zone.images'), 'images');
  dragndrop($('.documents li', '.sidebar'), $('.drop-zone.documents'), 'documents');

  function drop_single(to, accept) {
    $(to).droppable({
      activeClass: 'active',
      accept: function(d) {
        return d.parent().attr('class').match(accept);
      },
      drop: function(event, ui) {
        var li = ui.draggable.clone();
        $(this).empty().append(li);
        var name = li.parent().attr('data-name');
        li.find('input[type=hidden]').attr('name', name);
        attribute_not_empty($(this));
      }
    });
  }

  drop_single($('.drop-zone-single.images'), 'images');
  drop_single($('.drop-zone-single.documents'), 'documents');

  $(document).on('click', '.drop-zone .delete, .drop-zone-single .delete', function(e) {
    e.preventDefault();
    var ul = $(this).parents('ul').first(),
        input = $('input.empty', $(this).parents('.row'));
    $(this).parent().parent().parent().remove();
    mark_attribute(ul, input);
  });

  $('.tabs', '.sidebar').tabs();

  $('.assets-search-form input').on('keyup', function() {
    var self = this,
        val = $(this).val(),
        success = function (data) {
          $(self).parent().next().html(data);
          draggable($('.images li', '.sidebar'), $('.drop-zone.images'));
        };

    if (val.length > 2) {
      $.get($(this).attr('data-url'), { q: $(this).val() }, success);
    } else if (val.length == 0) {
      $.get($(this).attr('data-url'), success);
    }
  });

  var sidebar_top = $('.sidebar').position().top;
  if (sidebar_top) {
    $(document).scroll(function() {
      console.log(sidebar_top);
      var scroll_top = $(document).scrollTop();
      if (scroll_top >= sidebar_top) {
        $('.sidebar').css('position', 'fixed');
        $('.sidebar').css('right', '0px');
        $('.sidebar').css('top', '0px');
      } else if (scroll_top < sidebar_top){
        $('.sidebar').css('position', 'static');
      }
    });
  }

});
