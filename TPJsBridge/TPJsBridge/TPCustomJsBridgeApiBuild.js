
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
               iOS: function (e) {
                    jsBridge.invoke("device", "getDeviceInformation", null, e);
               },
               android: function (e) {
                    jsBridge.invoke("device", "getDeviceInformation", e);
               },
               support: {
                    iOSPlatformVersion: "1.0",
                    androidPlatformVersion: "1.0"
               }
});


jsBridge.build(jsBridgeGenerateApiString("openViewPage"), {
               iOS: function (data, e) {
                    jsBridge.invoke("viewPageManager", "openViewPage", data, e);
               },
               android: function (data, e) {
                    jsBridge.invoke("viewPageManager", "openViewPage", data, e);
               },
               support: {
                    iOSPlatformVersion: "1.0",
                    androidPlatformVersion: "1.0"
               }
});
