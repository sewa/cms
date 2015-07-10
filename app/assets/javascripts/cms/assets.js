$(document).ready(function() {

  var Assets = {

    accept: {
      images: 'images',
      documents: 'documents'
    },

    draggables: function(scope) {
      return {
        images: $('.images li', scope),
        documents: $('.documents li', scope)
      };
    },

    droppables: function(scope) {
      return {
        images: $('.drop-zone.images', scope),
        documents: $('.drop-zone.documents', scope)
      };
    },

    single_droppables: function(scope) {
      return {
        images: $('.drop-zone-single.images', scope),
        documents: $('.drop-zone-single.documents', scope)
      };
    }

  };

  Assets.toggle_attribute_destroyed = function(ul, input) {
    if (ul.children().length == 0) {
      input.val('1');
    } else {
      input.val('');
    }
  };

  Assets.toggle_destroy_attribute = function(ul) {
    var input = $('input.destroy', ul.parents('.row'));
    Assets.toggle_attribute_destroyed(ul, input);
  };

  Assets.droppable = function(drag, drop, accept) {
    drop.droppable({
      greedy: true,
      activeClass: 'active',
      accept: function(d) {
        if (typeof d !== 'undefined' && typeof d.parent().attr('class') !== 'undefined') {
          return d.parent().attr('class').match(accept);
        } else {
          return false;
        }
      },
      // the helper is not appended to the drop zone
      // when you drag an asset on a dragged compoenent.
      // solution was to clone the helper append it to the drop zone
      // and remove the original helper.
      drop: function(event, ui) {
        if(ui.helper.data().dragged == true) {
          ui.helper.data().dragged = false;
          var placeholder = $('.ui-sortable-placeholder', this);
          if (placeholder.length > 0) {
            ui.helper.clone()
              .attr('style', '')
              .insertAfter(placeholder)
              .find('input[type=hidden]')
              .attr('name', $(this).attr('data-name'));
          } else {
            ui.helper.clone()
              .attr('style', '')
              .appendTo(this)
              .find('input[type=hidden]')
              .attr('name', $(this).attr('data-name'));
          }
          ui.helper.remove();
          Assets.toggle_destroy_attribute($(this));
        }
      }
    }).sortable({
      accept: drop
    });
  };

  Assets.draggable = function(drag, drop) {
    drag.draggable({
      connectToSortable: drop,
      revert: 'invalid',
      helper: 'clone',
      start: function(event, ui) {
        ui.helper.data().dragged = true;
      }
    });
  };

  Assets.single_droppable = function(drop, accept) {
    drop.droppable({
      activeClass: 'active',
      accept: function(d) {
        if (typeof d !== 'undefined' && typeof d.parent().attr('class') !== 'undefined') {
          return d.parent().attr('class').match(accept);
        } else {
          return false;
        }
      },
      drop: function(event, ui) {
        $(this).empty();
        ui.helper.clone()
          .attr('style', '')
          .appendTo(this)
          .find('input[type=hidden]')
          .attr('name', $(this).attr('data-name'));
        ui.helper.remove();
        Assets.toggle_destroy_attribute($(this));
      }
    });
  };

  Assets.bind_droppables = function(drag_scope, drop_scope) {
    Assets.droppable(
      Assets.draggables(drag_scope).images,
      Assets.droppables(drop_scope).images,
      Assets.accept.images
    );

    Assets.droppable(
      Assets.draggables(drag_scope).documents,
      Assets.droppables(drop_scope).documents,
      Assets.accept.documents
    );
  };

  Assets.bind_single_droppables = function(drop_scope) {
    Assets.single_droppable(
      Assets.single_droppables(drop_scope).images,
      Assets.accept.images
    );

    Assets.single_droppable(
      Assets.single_droppables(drop_scope).documents,
      Assets.accept.documents
    );
  };

  Assets.bind_draggable_images = function(drag_scope, drop_scope) {
    Assets.draggable(
      Assets.draggables(drag_scope).images,
      Assets.droppables(drop_scope).images
    );
  };

  Assets.bind_draggable_documents = function(drag_scope, drop_scope) {
    Assets.draggable(
      Assets.draggables(drag_scope).documents,
      Assets.droppables(drop_scope).documents
    );
  };

  Assets.bind_draggables = function(drag_scope, drop_scope) {
    Assets.bind_draggable_images(drag_scope, drop_scope);
    Assets.bind_draggable_documents(drag_scope, drop_scope);
  };

  Assets.bind_remove = function() {
    $(document).on('click', '.drop-zone .delete, .drop-zone-single .delete', function(e) {
      e.preventDefault();
      var ul = $(this).parents('ul').first(),
          input = $('input.empty', $(this).parents('.row'));
      $(this).parent().parent().parent().remove();
      Assets.toggle_destroy_attribute(ul);
    });
  };

  window.CmsAssets = {
    bind_droppables: Assets.bind_droppables,
    bind_single_droppables: Assets.bind_single_droppables,
    bind_draggables: Assets.bind_draggables,
    bind_draggable_images: Assets.bind_draggable_images,
    bind_draggable_documents: Assets.bind_draggable_documents,
    bind_remove: Assets.bind_remove
  };

});
