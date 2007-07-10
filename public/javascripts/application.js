// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function auto_complete_on_select(element, selectedElement) {
	var entityParts = selectedElement.id.split('::');
	var entityType = entityParts[0];
	var entityId   = entityParts[1];
	document.getElementById(entityType).value = entityId;
}

