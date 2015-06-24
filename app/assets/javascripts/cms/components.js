$(document).ready(function() {

  var Components = {

    draggables: function(scope) {
      return $('.components li', scope);
    },

    droppables: function(scope) {
      return $('#components', scope);
    },

    accept: 'components'

  };

  Components.replace_idx = function(node, attr, idx) {
    var val = node.attr(attr);
    if(val !== undefined) {
      node.attr(attr, val.replace(/\d/, idx));
    }
  };

  Components.update_idx = function(node) {
    Components.replace_idx(node.children('a'), 'href', node.index());
    Components.replace_idx(node.children('.content'), 'id', node.index());
    $.each($('a, ul, label, textarea, select, input, .drop-zone', node), function() {
      var self = this;
      $.each(['id', 'name', 'for', 'data-name'], function(idx, attr) {
        Components.replace_idx($(self), attr, node.index());
      });
    });
  };

  Components.update = function(node) {
    node.children().each(function(idx, child) {
      Components.update_idx($(child));
    });
  };

  Components.droppable = function(drag, drop, accept) {
    drop.droppable({
      greedy: true,
      activeClass: 'active',
      items: "li:not(.placeholder)",
      accept: function(d) {
        var id = d.parent().attr('id');
        if (id !== undefined) {
          return id.match(accept);
        } else {
          return false;
        }
      },
      over: function(event, ui) {
        if (ui.helper.data().dragging == true) {
          ui.draggable.css({
            'width': '100%',
            'height': 'auto'
          });
        }
      },
      drop: function(event, ui) {
        if (ui.helper.data().dragging == true) {
          ui.helper.data().dragging = false;
          ui.draggable.css({
            'width': '100%',
            'height': 'auto'
          });
          ui.draggable.css('z-index', 10);
          $('.placeholder', ui.draggable.parent()).hide();
          CmsAssets.bind_droppables(ui.draggable);
          CmsAssets.bind_single_droppables(ui.draggable);
          CmsAccordion.collapse('#components-tab');
          CmsAccordion.open(ui.draggable);
        }
      }
    }).sortable({
      accept: drag,
      start: function(event, ui) {
        CmsAccordion.collapse('#components-tab');
        CmsCkEditor.destroy('#components-tab');
      },
      stop: function(event, ui) {
        Components.update(ui.item.parent());
        CmsCkEditor.init('#components-tab');
      }
    });
  };

  Components.draggable = function(drag, drop) {
    drag.draggable({
      connectToSortable: drop,
      revert: 'invalid',
      helper: 'clone',
      start: function(event, ui) {
        ui.helper.data().dragging = true;
      }
    });
  };

  Components.bind_droppables = function(drag_scope, drop_scope) {
    Components.droppable(
      Components.draggables(drag_scope),
      Components.droppables(drop_scope),
      Components.accept
    );
  };

  Components.bind_draggables = function(drag_scope, drop_scope) {
    Components.draggable(
      Components.draggables(drag_scope),
      Components.droppables(drop_scope)
    );
  };

  Components.bind_remove = function() {
    $(document).on('click', '.remove-component', function() {
      CmsCkEditor.destroy('#components-tab');
      var li = $(this).parents('li'),
          ul = li.parent(),
          destroy = $('.destroy', li);
      li.hide();
      destroy.val('1');
      Components.update(ul);
      if (ul.children('li:visible').length == 0) {
        ul.addClass('drop-placeholder');
        ul.children('.placeholder').show();
      }
      CmsCkEditor.init('#components-tab');
    });
  };

  window.CmsComponents = {
    bind_droppables: Components.bind_droppables,
    bind_draggables: Components.bind_draggables,
    bind_remove: Components.bind_remove
  };

});
