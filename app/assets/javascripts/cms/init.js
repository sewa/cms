$(document).ready(function() {

  $(document).foundation();

  $('.tabs').tabs();
  $('.timepicker').timepicker({
    timeOnlyTitle: 'Zeit wählen',
		timeText: 'Zeit',
		hourText: 'Stunde',
		minuteText: 'Minute',
		secondText: 'Sekunde',
		millisecText: 'Millisekunde',
		microsecText: 'Mikrosekunde',
		timezoneText: 'Zeitzone',
		currentText: 'Jetzt',
		closeText: 'Fertig',
		timeFormat: 'HH:mm',
		timeSuffix: '',
		amNames: ['vorm.', 'AM', 'A'],
		pmNames: ['nachm.', 'PM', 'P'],
		isRTL: false,
    step: 15,
    timeOnly: true,
    oneLine: true,
    showButtonPanel: false,
    controlType: 'select',
    hourMin: 7,
	  hourMax: 20,
    stepMinute: 10
  });

  CmsCkEditor.init('.form-left');

  CmsAssets.bind_draggables('.sidebar', '.form-left');
  CmsAssets.bind_droppables('.sidebar', '.form-left');
  CmsAssets.bind_single_droppables('.form-left');
  CmsAssets.bind_remove();

  CmsComponents.bind_draggables('.sidebar', '.form-left');
  CmsComponents.bind_droppables('.sidebar', '.form-left');
  CmsComponents.bind_remove();

  CmsSearch.init();

  CmsTable.bind_sortable();

  $('.select2', '.form-left').select2();
});
