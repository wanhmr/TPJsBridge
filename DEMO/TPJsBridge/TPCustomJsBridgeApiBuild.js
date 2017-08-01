
var jsBridge = window[jsBridgeInfo.scheme];
function jsBridgeGenerateApiString(firstComponent) {
    var other = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        other[_i - 1] = arguments[_i];
    }
    var apiString = jsBridgeInfo.scheme;
    var args = Array.prototype.slice.call(arguments);
    args.forEach(function (value, index) {
                 apiString += "." + value;
                 });
    return apiString;
}


jsBridge.build(jsBridgeGenerateApiString("getDeviceInformation"), {
               iOS: function (o) {
                    jsBridge.invoke("device", "getDeviceInformation", o);
               },
               android: function (o) {
                    jsBridge.invoke("device", "getDeviceInformation", o);
               },
               support: {
                    iOSPlatformVersion: "1.0",
                    androidPlatformVersion: "1.0"
               }
});


jsBridge.build(jsBridgeGenerateApiString("openViewPage"), {
               iOS: function (o) {
                    jsBridge.invoke("viewPageManager", "openViewPage", o);
               },
               android: function (o) {
                    jsBridge.invoke("viewPageManager", "openViewPage",  o);
               },
               support: {
                    iOSPlatformVersion: "1.0",
                    androidPlatformVersion: "1.0"
               }
});
