# TPJsBridge
An iOS/OSX bridge for sending messages between Obj-C and JavaScript in WKWebView.

`TPJsBridge` 是一个插件化的 JsBridge 库，参考了 cordova，但做了简化，能够实现复杂的 native 与 wap 的交互。

目前微信就是使用的这种方式，并且 `TPJsBridge ` 也参考了微信的实现，保持了和微信 JSSDK 的一致性。

```
jsbridge.ready(() => void);
jsbridge.funcName(
	arg: "",
	success: function (res) {
	...do something
	},
	fail: function (error) {
	...do something
	}
);
```
    
## Usage
`pod 'TPJsBridge', '~> 0.0.17'`

```
Initialization code:
NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"TPCustomJsBridgeConfig" ofType:@"json"];

NSString *apiBuildFilePath = [[NSBundle mainBundle] pathForResource:@"TPCustomJsBridgeApiBuild" ofType:@"js"];
    
TPJsConfiguration *configuration = [[TPJsConfiguration alloc] initWithConfigFilePath:configFilePath apiBuildFilePath:apiBuildFilePath];
self.jsBridgeService = [[TPJsService alloc] initWithConfiguration:configuration];
    
[self.jsBridgeService connect:self.webView];
```
    
    
```
自定义 Plugin 流程：
1.继承 TPJsPlugin 
2.实现功能 
3.在 TPCustomJsBridgeApiBuild.js 文件中创建接口 
4.在 TPCustomJsBridgeConfig.json 中声明 Plugin 

具体请参考 TPJsPlugin_viewPageManager 实现
```

![screenshot](./Screenshots/1.gif)
