$(document).ready(function() {

  var Table = {};

  Table.preserveCellWidth = function (event, ui) {
	  ui.children().each(function() {
		  $(this).width($(this).width());
	  });
	  return ui;
  };

  Table.bind_sortable = function () {
    $('table.content-nodes tbody').sortable({
      helper: Table.preserveCellWidth,
      stop: function(event, ui) {
        var url = ui.item.attr('data-sort-url'),
            position = $('tr').index(ui.item);
        $.post(url, { position: position });
      }
    });
  };

  window.CmsTable = {
    bind_sortable: Table.bind_sortable
  };

});
