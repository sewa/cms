$(document).ready(function() {

  $(document).foundation();

  $('.tabs').tabs();

  CkEditor.init();

  CmsAssets.bind_draggables('.sidebar', '.form-left');
  CmsAssets.bind_droppables('.sidebar', '.form-left');
  CmsAssets.bind_single_droppables('.form-left');
  CmsAssets.bind_delete();
  CmsAssets.bind_search();

  CmsComponents.bind_remove();
  CmsComponents.bind_draggables();
  CmsComponents.bind_droppables();

});
