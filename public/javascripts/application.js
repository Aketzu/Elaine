// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var date;

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
	
	initializeClock();
	jsClockGMT();
}

function initializeClock() {
	if (!document.getElementById('clock0')) {
		return;
	}

	var timeString = document.getElementById('clock0').innerHTML;
	date = new Date(Date.parse(timeString));
}

function jsClockGMT(){
	// Copyright 1999 - 2001 by Ray Stott
	if (!document.getElementById('clock0')) {
		return;
	}
	
	date = new Date(date.valueOf() + 1000);

	var hour = date.getHours();
	var minute = date.getMinutes();
	var second = date.getSeconds();
	
	var temp = " " + ((hour < 10) ? "0" : "") + hour;
	temp += ((minute < 10) ? ":0" : ":") + minute;
	temp += ((second < 10) ? ":0" : ":") + second;
	document.getElementById('clock0').innerHTML = "";
	document.getElementById('clock0').innerHTML = temp;
	setTimeout("jsClockGMT()",1000);
}
