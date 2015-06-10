$(document).ready(function() {

  function mark_attribute_deleted(ul, input) {
    if (ul.children().length == 0) {
      input.val('-1');
    } else {
      input.val('');
    }
  };

  function attribute_not_empty(ul) {
    var input = $('input.empty', ul.parents('.row'));
    mark_attribute_deleted(ul, input);
  };

  function droppable_asset(from, to, accept) {
    to.droppable({
      greedy: true,
      activeClass: 'active',
      accept: function(d) {
        return d.parent().attr('class').match(accept);
      },
      drop: function(event, ui) {
        if(ui.helper.data().dragged == true) {
          ui.helper.data().dragged = false;
          var h = ui.helper.clone();
          h.attr('style', '').appendTo(this);
          var name = $(this).attr('data-name');
          h.find('input[type=hidden]').attr('name', name);
          attribute_not_empty($(this));
        }
      }
    }).sortable({
      accept: from
    });
  };

  function draggable_asset(from, to) {
    from.draggable({
      connectToSortable: to,
      revert: 'invalid',
      helper: 'clone',
      start: function(event, ui) {
        ui.helper.data().dragged = true;
      }
    });
  }

  droppable_asset($('.images li', '.sidebar'), $('.drop-zone.images'), 'images');
  droppable_asset($('.documents li', '.sidebar'), $('.drop-zone.documents'), 'documents');

  draggable_asset($('.images li', '.sidebar'), $('.drop-zone.images'), 'images');
  draggable_asset($('.documents li', '.sidebar'), $('.drop-zone.documents'), 'documents');

  // components
  var to = $('#components'),
      from = $('.components li', '.sidebar'),
      accept = 'components';

  function replace_idx(node, attr, idx) {
    var val = node.attr(attr);
    if(val !== undefined) {
      node.attr(attr, val.replace(/\d/, idx));
    }
  }

  function set_index(node) {
    replace_idx(node.children('a'), 'href', node.index());
    replace_idx(node.children('.content'), 'id', node.index());
    console.log(node.index());
    $.each($('label, input, .drop-zone', node), function() {
      var self = this;
      $.each(['id', 'name', 'for', 'data-name'], function(idx, attr) {
        replace_idx($(self), attr, node.index());
      });
    });
  };

  function update(node) {
    node.children().each(function(idx, child) {
      set_index($(child));
    });
  }

  to.droppable({
    greedy: true,
    activeClass: 'active',
    accept: function(d) {
      var id = d.parent().attr('id');
      if (id !== undefined) {
        return id.match(accept);
      } else {
        return false;
      }
    },
    over: function(event, ui) {
      if(ui.helper.data().component == true) {
        ui.draggable.css({
          'width': '100%',
          'height': 'auto'
        });
      }
    },
    drop: function(event, ui) {
      ui.draggable.css({
        'width': '100%',
        'height': 'auto'
      });
      var ul = ui.draggable.parent();
      ul.removeClass('drop-placeholder');
      ul.children('.placeholder').remove();
      droppable_asset($('.images li', '.sidebar'), $('.drop-zone.images', ui.draggable), 'images');
      droppable_asset($('.documents li', '.sidebar'), $('.drop-zone.documents', ui.draggable), 'documents');
    }
  }).sortable({
    accept: from,
    stop: function(event, ui) {
      update(ui.item.parent());
    }
  });

  from.draggable({
    connectToSortable: to,
    revert: 'invalid',
    helper: 'clone',
    start: function(event, ui) {
      ui.helper.data().component = true;
    }
  });

  $(document).on('click', '.remove-component', function() {
    var li = $(this).parents('li'),
        ul = li.parent();
    li.remove();
    update(ul);
  });

  // single drop
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

  // delete
  $(document).on('click', '.drop-zone .delete, .drop-zone-single .delete', function(e) {
    e.preventDefault();
    var ul = $(this).parents('ul').first(),
        input = $('input.empty', $(this).parents('.row'));
    $(this).parent().parent().parent().remove();
    mark_attribute_deleted(ul, input);
  });

  // search
  $('.assets-search-form input').on('keyup', function() {
    var self = this,
        val = $(this).val(),
        success = function (data) {
          $(self).parent().next().html(data);
          draggable_asset($('.images li', '.sidebar'), $('.drop-zone.images'));
        };

    if (val.length > 2) {
      $.get($(this).attr('data-url'), { q: $(this).val() }, success);
    } else if (val.length == 0) {
      $.get($(this).attr('data-url'), success);
    }
  });

});
