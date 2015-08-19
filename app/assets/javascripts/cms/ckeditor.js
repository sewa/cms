$(document).ready(function() {

  // TOOD: limit headings to h3 .... hx
  var CkEditor = {
    toolbar: [
      { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
      { name: 'tools', items: [ 'Maximize' ] },
	    '/',
      { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', '-', 'RemoveFormat' ] },
      { name: 'paragraph', groups: [ 'list', 'indent' ], items: [ 'NumberedList', 'BulletedList' ] },
      { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
	    { name: 'styles', items: ['Format'] },
    ]
  };

  var opts = {
    toolbar: CkEditor.toolbar,
    format_tags: 'p;h3;h4'
  };

  // do not use the class name .ckeditor for richtext textareas.
  // some magic initialization will take place by default.
  CkEditor.init = function(scope) {
    $('.richtext', scope).each(function(idx, textarea) {
      $(textarea).ckeditor(opts);
    });
  };

  CkEditor.destroy = function(scope) {
    $('.richtext', scope).each(function(idx, textarea){
      var id = $(textarea).attr('id'),
          editor = CKEDITOR.instances[id];
      if (typeof editor !== 'undefined') {
        editor.destroy();
        CKEDITOR.remove(id);
      }
    });
  };

  window.CmsCkEditor = {
    init: CkEditor.init,
    destroy: CkEditor.destroy
  };

});
