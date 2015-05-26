$(document).ready(function() {

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

  $('.drop-url').droppable({
    activeClass: 'active',
    accept: function(d) {
      return d.parent().attr('class').match('images');
    },
    drop: function(event, ui) {
      $(this).val(ui.draggable.attr('data-url'));
    }
  });

  $(document).on('click', '.drop-zone .delete', function(e) {
    e.preventDefault();
    $(this).parents('li').remove();
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

});
