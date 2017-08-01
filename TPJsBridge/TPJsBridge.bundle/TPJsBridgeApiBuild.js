
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


jsBridge.build(jsBridgeGenerateApiString("getDeviceInfo"), {
               iOS: function (e) {
                    jsBridge.invoke("device", "getDeviceInfo", e);
               },
               android: function (e) {
                    jsBridge.invoke("device", "getDeviceInfo", e);
               },
               support: {
                    iOSPlatformVersion: "1.0",
                    androidPlatformVersion: "1.0"
               }
});

