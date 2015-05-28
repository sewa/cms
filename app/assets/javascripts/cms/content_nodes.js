$(document).ready(function() {

  function preserveCellWidth(event, ui) {
	  ui.children().each(function() {
		  $(this).width($(this).width());
	  });
	  return ui;
  };

  $('table.content-nodes tbody').sortable({
    helper: preserveCellWidth,
    stop: function(event, ui) {
      var url = ui.item.attr('data-sort-url'),
          position = $('tr').index(ui.item);
      $.post(url, { position: position });
    }
  });

});
