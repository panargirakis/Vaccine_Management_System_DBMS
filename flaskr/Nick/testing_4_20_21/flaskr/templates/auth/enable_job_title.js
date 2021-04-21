$('#accept').click(function() {
	if ($('#healthcare_worker').is(':disabled')) {
    	$('#healthcare_worker').removeAttr('disabled');
    } else {
    	$('#healthcare_worker').attr('disabled', 'disabled');
    }
});