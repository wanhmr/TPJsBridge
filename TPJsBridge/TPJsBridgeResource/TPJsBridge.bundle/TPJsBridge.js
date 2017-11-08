var ICallbackStatus;
(function (ICallbackStatus) {
    ICallbackStatus[ICallbackStatus["NO_RESULT"] = 0] = "NO_RESULT";
    ICallbackStatus[ICallbackStatus["OK"] = 1] = "OK";
    ICallbackStatus[ICallbackStatus["CLASS_NOT_FOUND_EXCEPTION"] = 2] = "CLASS_NOT_FOUND_EXCEPTION";
    ICallbackStatus[ICallbackStatus["ILLEGAL_ACCESS_EXCEPTION"] = 3] = "ILLEGAL_ACCESS_EXCEPTION";
    ICallbackStatus[ICallbackStatus["INSTANTIATION_EXCEPTION"] = 4] = "INSTANTIATION_EXCEPTION";
    ICallbackStatus[ICallbackStatus["MALFORMED_URL_EXCEPTION"] = 5] = "MALFORMED_URL_EXCEPTION";
    ICallbackStatus[ICallbackStatus["IO_EXCEPTION"] = 6] = "IO_EXCEPTION";
    ICallbackStatus[ICallbackStatus["INVALID_ACTION"] = 7] = "INVALID_ACTION";
    ICallbackStatus[ICallbackStatus["JSON_EXCEPTION"] = 8] = "JSON_EXCEPTION";
    ICallbackStatus[ICallbackStatus["ERROR"] = 9] = "ERROR";
})(ICallbackStatus || (ICallbackStatus = {}));
var IJsBridgePlatform;
(function (IJsBridgePlatform) {
    IJsBridgePlatform[IJsBridgePlatform["iOSPlatform"] = 1] = "iOSPlatform";
    IJsBridgePlatform[IJsBridgePlatform["androidPlatform"] = 2] = "androidPlatform";
    IJsBridgePlatform[IJsBridgePlatform["broswerPlatform"] = 4] = "broswerPlatform";
    IJsBridgePlatform[IJsBridgePlatform["clientPlatform"] = 3] = "clientPlatform";
})(IJsBridgePlatform || (IJsBridgePlatform = {}));
var JsBridgeMap = (function () {
    function JsBridgeMap() {
    }
    return JsBridgeMap;
}());
function generateJsBridge(scheme) {
    "use strict";
    //app版本比较
    function compareVersion(v1, v2) {
        v1 = String(v1).split("."),
            v2 = String(v2).split(".");
        try {
            for (var i = 0, max = Math.max(v1.length, v2.length); i < max; i++) {
                var subV1 = isFinite(v1[i]) && Number(v1[i]) || 0, subV2 = isFinite(v2[i]) && Number(v2[i]) || 0;
                if (subV1 < subV2)
                    return -1;
                if (subV1 > subV2)
                    return 1;
            }
        }
        catch (o) {
            return -1;
        }
        return 0;
    }
    //在window中注册所有的函数:
    //eg. scheme.device
    function registerApi(api) {
        var t = api.split(".");
        var n = window;
        t.forEach(function (e) {
            !n[e] && (n[e] = {});
            n = n[e];
        });
        return n;
    }
    //存储函数，返回index
    function generateCallbackId() {
        var increaseIndex = index++;
        var callbackId = "_CALLBACK_" + increaseIndex.toString();
        return callbackId;
    }
    //mapp.build
    function build(path, handler) {
        var currentPlatformHandler, lastCommaLocation = path.lastIndexOf("."), prefix = path.substring(0, lastCommaLocation), suffix = path.substring(lastCommaLocation + 1), classObj = registerApi(prefix); //mapp.device 生成对应的数组存储关系
        if (classObj[suffix]) {
            console.error("JSBridge: ealready has " + path);
        }
        if (handler.iOS && (jsBridge.platform & IJsBridgePlatform.iOSPlatform)) {
            currentPlatformHandler = handler.iOS;
        }
        else if (handler.android && (jsBridge.platform & IJsBridgePlatform.androidPlatform)) {
            currentPlatformHandler = handler.android;
        }
        else {
            currentPlatformHandler = handler.browser;
        }
        //存储函数
        if (currentPlatformHandler) {
            classObj[suffix] = currentPlatformHandler;
        }
        // 存储函数调用版本
        var currentVersion;
        if (jsBridge.platform & IJsBridgePlatform.iOSPlatform) {
            currentVersion = handler.support.iOSPlatformVersion;
        }
        else if (jsBridge.platform & IJsBridgePlatform.androidPlatform) {
            currentVersion = handler.support.androidPlatformVersion;
        }
        if (currentVersion) {
            apiVersions[path] = currentVersion;
        }
    }
    //support: 查询当前版本是否支持某个接口
    function supportApi(path) {
        if (!(jsBridge.platform & IJsBridgePlatform.clientPlatform)) {
            return false;
        }
        else {
            var apiVersion = apiVersions[path];
            if (apiVersion) {
                return jsBridge.compareAppVersion(apiVersion) <= 0;
            }
            else {
                return false;
            }
        }
    }
    //fireCallback
    function fireCallback(callbackId, callbackData, async) {
        //获取回调对象
        var callback = callbacks[callbackId];
        if (!callback)
            return;
        var executeCallback = function () { };
        if (typeof callback === "object") {
            executeCallback = function () {
                if (callbackData.status === ICallbackStatus.OK) {
                    if (callback.success) {
                        callback.success.call(null, callbackData.message);
                    }
                }
                else {
                    if (callback.fail) {
                        callback.fail.call(null, callbackData.message);
                    }
                }
            };
            if (async) {
                setTimeout(function () {
                    executeCallback();
                }, 0);
            }
            else {
                executeCallback();
            }
        }
        else if (typeof callback === "function") {
            if (async) {
                setTimeout(function () {
                    callback.call(null, callbackData.message);
                }, 0);
            }
            else {
                callback.call(null, callbackData.message);
            }
        }
        else {
            console.error("JSBridge: not found such callback: " + callbackId);
        }
        if (!callback.hold) {
            delete callbacks[callbackId];
        }
    }
    //native的回调函数，execGlobalCallback:
    function execGlobalCallback(callbackId, callbackData, async) {
        if (callbackId) {
            fireCallback(callbackId, callbackData, async);
        }
        else {
            console.error("jsbridge: callbackId is empty");
        }
    }
    function postMessage(msg) {
        window.webkit.messageHandlers.TPJsBridge.postMessage(msg);
    }
    //mapp.invoke("device", "getDeviceInfo", e);
    function invoke(className, methodName, callback, hold) {
        if (hold === void 0) { hold = false; }
        if (!className || !methodName)
            return null;
        var url;
        var callbackId;
        // 存储回调对象
        if (callback) {
            if (hold) {
                callbackId = "__CALLBACK__" + className + "_" + methodName;
            }
            else {
                callbackId = generateCallbackId();
            }
            callback.hold = hold;
            callbacks[callbackId] = callback;
        }
        else {
            console.info("callback did not exist.");
        }
        var data = {};
        for (var key in callback) {
            if (callback.hasOwnProperty(key) && key !== "success" && key !== "fail" && key !== "hold") {
                var element = callback[key];
                data[key] = element;
            }
        }
        var api = scheme + "." + className + "." + methodName;
        var provideApi = scheme + "." + methodName;
        //如果当前版本支持Bridge
        if ((jsBridge.platform & IJsBridgePlatform.clientPlatform) && (supportApi(api) || supportApi(provideApi))) {
            url = scheme + ":" + "/" + "/" + encodeURIComponent(className) + "/" + encodeURIComponent(methodName);
            if (Object.keys(data).length !== 0) {
                url += "?data=" + encodeURIComponent(JSON.stringify(data));
            }
            if (callbackId) {
                url += "#" + callbackId;
            }
            postMessage(url);
        }
        else {
            console.error("JSBride: the version didn't support path: " + className + "." + methodName);
        }
    }
    function execPatchEvent(type) {
        var ev = document.createEvent('Event');
        ev.initEvent(type, true, true);
        document.dispatchEvent(ev);
    }
    function execReady() {
        if (!isReady) {
            isReady = true;
            postMessage("ready");
            var callback = callbacks["_CALLBACK_READY_"];
            if (callback) {
                callback.call();
            }
        }
    }
    function ready(callback) {
        if (typeof callback !== "function")
            return;
        if (isReady) {
            callback.call();
        }
        else {
            callbacks["_CALLBACK_READY_"] = callback;
        }
    }
    var userAgent = navigator.userAgent, //判断浏览器类型
    iOSPlatformRegx = /(iPad|iPhone|iPod).*? (\w+)\/([\d\.]+)/, //ios浏览器标志
    androidPlatformRegx = /(Android).*? (\w+)\/([\d\.]+)/, //android浏览器标志
    index = 1, callbacks = {}, isReady = false, apiVersions = new JsBridgeMap();
    var platform;
    if (iOSPlatformRegx.test(userAgent)) {
        platform = IJsBridgePlatform.iOSPlatform;
    }
    else if (androidPlatformRegx.test(userAgent)) {
        platform = IJsBridgePlatform.androidPlatform;
    }
    else {
        platform = IJsBridgePlatform.broswerPlatform;
    }
    var JsBridge = (function () {
        function JsBridge() {
            this.debug = true;
            this.platform = platform;
            this.version = "1";
            this.appVersion = "1";
            this.build = build;
            this.invoke = invoke;
            this.execReady = execReady;
            this.ready = ready;
            this.execGlobalCallback = execGlobalCallback;
            this.execPatchEvent = execPatchEvent;
        }
        JsBridge.prototype.compareAppVersion = function (ver) {
            return compareVersion(this.appVersion, ver);
        };
        return JsBridge;
    }());
    var jsBridge = new JsBridge();
    return jsBridge;
}
var JsBridgeInfo = (function () {
    function JsBridgeInfo() {
        this.scheme = "#scheme#";
    }
    return JsBridgeInfo;
}());
var jsBridgeInfo = new JsBridgeInfo();
(function (scheme, jsBridge) {
    this[scheme] = jsBridge(scheme),
        typeof define === "function" ? define(this[scheme]) : typeof module === "object" && (module.exports = this[scheme]);
})(jsBridgeInfo.scheme, generateJsBridge);
