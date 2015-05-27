$(function(){
  $(document).foundation();
  var config = {};
  config.toolbarGroups = [
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
  ];
  $('.ckeditor').ckeditor(config);
});
