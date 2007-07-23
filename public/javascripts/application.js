// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function auto_complete_on_select(element, selectedElement) {
	var entityParts = selectedElement.id.split('::');
	var entityType = entityParts[0];
	var entityId   = entityParts[1];
	document.getElementById(entityType).value = entityId;
}

// ATM this requires the id of the table to be "form_options"
function toggleVisibility(type) {
	rr = $('form_options').rows;
	for (i=0; i<rr.length; i++) {
		if (rr[i].className == type) {
			if (rr[i].orgdisp="") {
				rr[i].orgdisp=rr[i].style.display;
			}
			vis = rr[i].style.display == rr[i].orgdisp;

			rr[i].style.display = vis ? "none" : rr[i].orgdisp;
		}
	}
}

function onLoadElaine(tab_ids) {
	var tabs = tab_ids.replace(" ", "").split(',');
	for (i=0; i<tabs.length; i++) {
		toggleVisibility(tabs[i]);
	}
}