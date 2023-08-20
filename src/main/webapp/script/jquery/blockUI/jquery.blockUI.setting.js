$(document).ready(function(){
	$.blockUI.defaults.message=$('#loading');
	$.blockUI.defaults.css.width = $('#loading .inner').width();
	$.blockUI.defaults.css.border = '1px solid black';
});