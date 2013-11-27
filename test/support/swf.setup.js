'use strict';

function loadTestSWF( baseURL ) {
	// Configuration
	
	var swfId = 'TestSWF';
	var swfPath = baseURL + 'test/src/service/Test/bin/Test.swf';
	var installerSwfPath = baseURL + 'bower_components/swfobject/swfobject/expressInstall.swf';
	
	// Create the target element and add it to the body
	
	var targetElementId = 'SWFContainer';
	var targetElement = document.createElement('div');
	targetElement.id = targetElementId;
	document.body.appendChild(targetElement);
	
	// Embed the SWF in the target element
	
	var width = '100%';
	var height = '100%';
	var minVersion = '11.2.0';
	var flashVars = {};
	var params = {
		allowScriptAccess: 'always', // allow ExternalInterface.call() access to scripts
		quality: 'high'
	};
	var attributes = {
		id: swfId,
		name: swfId
	};
	
	swfobject.embedSWF(
		swfPath,
		targetElementId, 
		width, height,
		minVersion,
		installerSwfPath,
		flashVars,
		params,
		attributes
	);
}

