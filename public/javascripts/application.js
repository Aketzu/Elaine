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
	$$("*[class^=\"" + type + "\"]").each(function(n) {
				n.toggle();
	});
}

function onLoadElaine(tab_ids) {
	if(tab_ids.length > 0) {
		var tabs = tab_ids.split(' ');

		for (i=0; i<tabs.length; i++) {
			toggleVisibility(tabs[i]);
		}
	}
}