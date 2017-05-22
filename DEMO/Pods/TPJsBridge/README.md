# TPJsBridge
An iOS/OSX bridge for sending messages between Obj-C and JavaScript in WKWebView.

TPJsBridge 是一个插件化的 jsBridge 库，参考了 cordova，但做了简化，能够实现复杂的 native 与 wap 的交互
    </br>
    </br>
    功能列表:
    <ol>
        <li>获取设备信息:<button class="btn btn-primary" onclick="getDeviceInfo()">getDeviceInfo</button></li>
        <li>打开网页带动画:<button class="btn btn-primary" onclick="openViewPage(1)">openViewPage</button></li>
        <li>打开网页无动画:<button class="btn btn-primary" onclick="openViewPage(0)">openViewPage</button></li>
    </ol>
    
    
    
    自定义 Plugin 流程：<br/>
    1.继承 TPJsPlugin <br/>
    2.实现功能 <br/>
    3.在 TPCustomJsBridgeApiBuild.js 文件中创建接口 <br/>
    4.在 TPCustomJsBridgeConfig.json 中声明 Plugin <br/>
    上面步骤完成就可以使用了 <br/>
    具体请参考 TPJsPlugin_viewPageManager 实现
