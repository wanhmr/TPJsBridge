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
        var t = api.split("."), n = window;
        return t.forEach(function (e) {
            !n[e] && (n[e] = {}),
                n = n[e];
        }),
            n;
    }
    //存储函数，返回index
    function generateCallbackId() {
        var newIndex = index++;
        var callbackId = "_CALLBACK_" + newIndex.toString();
        return callbackId;
    }
    //fireCallback
    function fireCallback(callbackId, callbackData, deleteCallback, async) {
        //获取回调函数
        var callback = callbacks[callbackId];
        if (callback) {
            if (async) {
                setTimeout(function () {
                    callback.call(null, callbackData);
                }, 0);
            }
            else {
                callback.call(null, callbackData);
            }
        }
        else {
            console.error("jsbridge: not found such callback: " + callbackId);
        }
        if (deleteCallback) {
            delete callbacks[callbackId];
        }
    }
    //native的回调函数，execGlobalCallback:
    function execGlobalCallback(callbackId, callbackData, async) {
        if (!callbackId)
            return;
        fireCallback(callbackId, callbackData, true, async);
    }
    //mapp.build
    function build(path, handler) {
        var currentPlatformHandler;
        var lastCommaLocation = path.lastIndexOf("."), prefix = path.substring(0, lastCommaLocation), suffix = path.substring(lastCommaLocation + 1), classObj = registerApi(prefix); //mapp.device 生成对应的数组存储关系
        if (classObj[suffix]) {
            throw new Error("jsbridge: ealready has " + path);
        }
        handler.iOS && (jsBridge.platform & IJsBridgePlatform.iOSPlatform) ? currentPlatformHandler = handler.iOS : handler.android && (jsBridge.platform & IJsBridgePlatform.androidPlatform) ? currentPlatformHandler = handler.android : handler.browser && (currentPlatformHandler = handler.browser),
            classObj[suffix] = currentPlatformHandler; //存储函数
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
    //创建一个iframe，执行src，供拦截
    function openUrl(url) {
        var action = document.createElement("iframe");
        action.style.cssText = "display:none;width:0px;height:0px;";
        action.src = url;
        //并将iframe插入到body或者html的子节点中；
        var o = document.body || document.documentElement;
        o.appendChild(action);
        setTimeout(function () {
            action.parentNode.removeChild(action);
        }, 0);
    }
    //invoke
    //mapp.invoke("device", "getDeviceInfo", e);
    function invoke(className, methodName, data, callback) {
        if (!className || !methodName)
            return null;
        var url;
        var callbackId;
        if (callback) {
            callbackId = generateCallbackId();
            callbacks[callbackId] = callback;
        }
        var api = scheme + "." + className + "." + methodName;
        var provideApi = scheme + "." + methodName;
        //如果当前版本支持Bridge
        if ((jsBridge.platform & IJsBridgePlatform.clientPlatform) && (supportApi(api) || supportApi(provideApi))) {
            url = scheme + ":" + "/" + "/" + encodeURIComponent(className) + "/" + encodeURIComponent(methodName);
            if (data) {
                url += "?data=" + JSON.stringify(data);
            }
            if (callbackId) {
                url += "#" + callbackId;
            }
            openUrl(url);
        }
        else {
            console.error("jsbride: the version didn't support path:" + className + "." + methodName);
        }
    }
    //当本地jsbridge初始化完成，调用此方法告诉前端jsbridge已经初始化完毕
    function execPatchEvent(type) {
        var ev = document.createEvent('Event');
        ev.initEvent(type, true, true);
        document.dispatchEvent(ev);
    }
    var userAgent = navigator.userAgent, //判断浏览器类型
    iOSPlatformRegx = /(iPad|iPhone|iPod).*? (\w+)\/([\d\.]+)/, //ios浏览器标志
    androidPlatformRegx = /(Android).*? (\w+)\/([\d\.]+)/, //android浏览器标志
    index = 1, callbacks = {}, apiVersions = new JsBridgeMap();
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
            this.fireCallback = fireCallback;
            this.build = build;
            this.invoke = invoke;
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
        typeof define == "function" ? define(this[scheme]) : typeof module == "object" && (module.exports = this[scheme]);
})(jsBridgeInfo.scheme, generateJsBridge);
