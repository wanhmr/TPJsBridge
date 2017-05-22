//
//  ViewController.m
//  TPJsBridge
//
//  Created by Tpphha on 2017/5/20.
//  Copyright © 2017年 Tpphha. All rights reserved.
//

#import "ViewController.h"
#import "TPJsBridge.h"

@interface ViewController () <WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) TPJsService *service;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Mobile JS API Demo";
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"TPCustomJsBridgeConfig" ofType:@"json"];
    NSString *apiBuildFilePath = [[NSBundle mainBundle] pathForResource:@"TPCustomJsBridgeApiBuild" ofType:@"js"];
    
    self.service = [[TPJsService alloc] initWithConfigFilePath:configFilePath apiBuildFilePath:apiBuildFilePath];
    [self.service connect:webView];
    
}


- (void)next {
    [self.navigationController pushViewController:[[self class] new] animated:YES];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s: %@", __FUNCTION__, webView.URL);
}


#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:^{
        completionHandler();
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
