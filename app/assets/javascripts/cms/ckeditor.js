$(document).ready(function() {

  var CkEditor = {
    toolbargroups: [
	    { name: 'document', groups: [ 'mode' ] },
	    { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ] },
	    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
	    { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
	    { name: 'links' },
	    '/',
	    { name: 'styles' },
	    { name: 'colors' },
	    { name: 'tools' },
	    { name: 'others' }
    ]
  };

  var opts = {
    toolbarGroups: CkEditor.toolbargroups
  };

  CkEditor.init = function(scope) {
    $('.ckeditor', scope).ckeditor(opts);
  };

  CkEditor.destroy = function(node) {
    $('.ckeditor', node).each(function(idx, textarea){
      var id = $(textarea).attr('id'),
          editor = CKEDITOR.instances[id];
      if (typeof editor !== 'undefined') {
        editor.destroy();
        CKEDITOR.remove(id);
      }
    });
  };

  CkEditor.replace = function(node) {
    $('.ckeditor', node).each(function(idx, textarea){
      CKEDITOR.replace($(textarea).attr('id'), opts);
    });
  };

  window.CmsCkEditor = CkEditor;

});
