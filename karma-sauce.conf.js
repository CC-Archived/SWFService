// Karma configuration
// Generated on Mon Nov 25 2013 20:40:03 GMT-0500 (EST)

module.exports = function(config) {
  config.set({

    // base path, that will be used to resolve files and exclude
    basePath: '',


    // frameworks to use
    frameworks: ['mocha'],


    // list of files / patterns to load in the browser
    files: [
      'node_modules/mocha-as-promised/mocha-as-promised.js',
      'node_modules/chai/chai.js',
      'node_modules/chai-as-promised/lib/chai-as-promised.js',
      'node_modules/sinon/pkg/sinon.js',
      'node_modules/sinon-chai/lib/sinon-chai.js',
      
      'bower_components/jquery/jquery.js',
      'bower_components/swfobject/swfobject/swfobject.js',
      { pattern: 'bower_components/swfobject/swfobject/expressInstall.swf', included: false },
      
      'test/support/mocha.setup.js',
      'test/support/chai.setup.js',
      'test/support/swf.setup.js',
      'test/support/karma.setup.js',
      
      'src/client/dist/SWFService.js',
      
      { pattern: 'test/src/service/Test/bin/Test.swf', included: false },
      
      'test/src/client/js/**/*.js'
    ],


    // list of files to exclude
    exclude: [
      
    ],


    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,

    // Sauce Labs configuration
    sauceLabs: {
      testName: 'SWFService Unit Tests',
      recordVideo: false,
      recordScreenshots: false
    },
    customLaunchers: {
      // Firefox
      
      sl_firefox_windows_xp: {
        base: 'SauceLabs',
        browserName: 'firefox',
        platform: 'windows xp'
      },
      sl_firefox_windows_7: {
        base: 'SauceLabs',
        browserName: 'firefox',
        platform: 'windows 7'
      },
      sl_firefox_windows_8: {
        base: 'SauceLabs',
        browserName: 'firefox',
        platform: 'windows 8'
      },
      sl_firefox_windows_8_1: {
        base: 'SauceLabs',
        browserName: 'firefox',
        platform: 'windows 8.1'
      },
      sl_firefox_mac_10_6: {
        base: 'SauceLabs',
        browserName: 'firefox',
        platform: 'Mac 10.6'
      },
      
      // Chrome
      
      sl_chrome_windows_xp: {
        base: 'SauceLabs',
        browserName: 'chrome',
        platform: 'windows xp'
      },
      
      sl_chrome_windows_7: {
        base: 'SauceLabs',
        browserName: 'chrome',
        platform: 'windows 7'
      },
      
      sl_chrome_windows_8: {
        base: 'SauceLabs',
        browserName: 'chrome',
        platform: 'windows 8'
      },
      
      sl_chrome_windows_8_1: {
        base: 'SauceLabs',
        browserName: 'chrome',
        platform: 'windows 8.1'
      },
      sl_chrome_mac_10_6: {
        base: 'SauceLabs',
        browserName: 'chrome',
        platform: 'Mac 10.6'
      },
      sl_chrome_mac_10_8: {
        base: 'SauceLabs',
        browserName: 'chrome',
        platform: 'Mac 10.8'
      },
      
      // Internet Explorer 9
      
      sl_ie9_windows_7: {
        base: 'SauceLabs',
        browserName: 'internet explorer',
        platform: 'windows 7',
        version: '9'
      },
      
      // Internet Explorer 10
      
      sl_ie10_windows_7: {
        base: 'SauceLabs',
        browserName: 'internet explorer',
        platform: 'windows 7',
        version: '10'
      },
      sl_ie10_windows_8: {
        base: 'SauceLabs',
        browserName: 'internet explorer',
        platform: 'windows 8',
        version: '10'
      },
      
      // Internet Explorer 11
      
      sl_ie11_windows8_1: {
        base: 'SauceLabs',
        browserName: 'internet explorer',
        platform: 'windows 8.1',
        version: '11'
      },
      
      // Safari 5
      
      sl_safari5_mac_10_6: {
        base: 'SauceLabs',
        browserName: 'safari',
        platform: 'Mac 10.6',
        version: "5"
      },
      
      // Safari 6
      
      sl_safari6_mac_10_8: {
        base: 'SauceLabs',
        browserName: 'safari',
        platform: 'Mac 10.8',
        version: "6"
      },
    },

    browsers: [
      // Firefox
      
      'sl_firefox_windows_xp',
      'sl_firefox_windows_7',
      'sl_firefox_windows_8',
      'sl_firefox_windows_8_1',
      'sl_firefox_mac_10_6',
      
      // Chrome
      
      'sl_chrome_windows_xp',
      'sl_chrome_windows_7',
      'sl_chrome_windows_8',
      'sl_chrome_windows_8_1',
      'sl_chrome_mac_10_6',
      'sl_chrome_mac_10_8',
      
      // Internet Explorer 9
      
      'sl_ie9_windows_7',
      
      // Internet Explorer 10
      
      'sl_ie10_windows_7',
      'sl_ie10_windows_8',
      'sl_ie11_windows8_1',
      
      // Safari 5
      
      'sl_safari5_mac_10_6',
      
      // Safari 6
      
      'sl_safari6_mac_10_8'
    ],

    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 120000,


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: true
  });
};
