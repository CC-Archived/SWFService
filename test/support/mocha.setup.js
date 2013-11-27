'use strict';

mocha.setup({
	ui: 'bdd',
	ignoreLeaks: false,
	globals: [
		// Adobe Flash Player's ExternalInterface defines several globals:
		'__flash_getWindowLocation', 
		'__flash_getTopLocation', 
		'__flash_temp',
		'__flash__arrayToXML', 
		'__flash__argumentsToXML', 
		'__flash__objectToXML', 
		'__flash__escapeXML', 
		'__flash__toXML', 
		'__flash__request',
		'__flash__addCallback',
		'__flash__removeCallback',
		'top'
	]
});