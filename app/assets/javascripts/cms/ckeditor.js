
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

CkEditor.init = function() {
  $('.ckeditor').ckeditor({
    toolbarGroups: CkEditor.toolbargroups
  });
};

CkEditor.destroy = function() {

  debugger;
  // CKEDITOR.instances

};

// CkEditor.reload(node) = function() {
//   CkEditor.destroy(node);
//   CkEditor.init();
// }
