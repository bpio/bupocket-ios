//
//  WKWebViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/18.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "WKWebViewController.h"

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate>

@property (nonatomic, copy) NSString * URLString;
@property (nonatomic, copy) NSString * postString;
@property (nonatomic, copy) NSString * htmlString;
//仅当第一次的时候加载本地JS
@property(nonatomic,assign) BOOL needLoadJSPOST;
//设置加载进度条
@property (nonatomic,strong) UIProgressView * progressView;

//保存请求链接
@property (nonatomic)NSMutableArray* snapShotsArray;
//返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;
//关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;

@property (nonatomic, strong) UIView * noNetWork;

@end

static void *WkwebBrowserContext = &WkwebBrowserContext;

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}

- (void)reloadData
{
    [self webViewloadURLType];
//    if (NotNULLString(self.URLString)) {
//        [self loadWebURLSring:self.URLString];
//    }
//    [self.wkWebView reload];
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (_isNavHidden == YES) {
            _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3);
        }else{
            _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3);
        }
        [_progressView setTrackTintColor:COLOR(@"F0F0F0")];
        _progressView.progressTintColor = MAIN_COLOR;
    }
    return _progressView;
}

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        if (@available(iOS 9.0, *)) {
            Configuration.allowsAirPlayForMediaPlayback = NO;
        } else {
            // Fallback on earlier versions
        }
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
//        [UserContentController addScriptMessageHandler:self name:@"WXPay"];
        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH - SafeAreaBottomH) configuration:Configuration];
        
        _wkWebView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
        // 设置代理
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        //kvo 添加进度监控
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        //开启手势触摸
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}

- (void)webViewloadURLType{
    switch (self.loadType) {
        case WebLoadURLString:{
            //创建一个NSURLRequest 的对象
            NSURLRequest * Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
            //加载网页
            [self.wkWebView loadRequest:Request_zsj];
            break;
        }
        case WebLoadHTMLString:{
            [self loadHostPathURL:self.URLString];
            break;
        }
        case WebLoadJSPOST:{
            // JS发送POST的Flag，为真的时候会调用JS的POST方法
            self.needLoadJSPOST = YES;
            //POST使用预先加载本地JS方法的html实现，请确认WKJSPOST存在
            [self loadHostPathURL:@"WKJSPOST"];
            break;
        }
        case webloadLocalPath: {
            //创建一个NSURLRequest 的对象
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.URLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
            //加载网页
            [self.wkWebView loadRequest:request];
            break;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isNavHidden == YES) {
        self.navigationController.navigationBarHidden = YES;
        //创建一个高20的假状态栏
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        statusBarView.backgroundColor = [UIColor whiteColor];
        // 添加到 navigationBar 上
        [self.view addSubview:statusBarView];
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    //加载web页面
    [self webViewloadURLType];
}


-(void)customBackItemClicked {
    if (self.wkWebView.goBack) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadHostPathURL:(NSString *)url
{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 调用JS发送POST请求
- (void)postRequestWithJS {
    // 拼装成调用JavaScript的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.URLString, self.postString];
    // 调用JS代码
    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
    }];
}


- (void)loadWebURLSring:(NSString *)string{
//    self.URLString = [string addUrlParaString];
    self.URLString = string;
    self.loadType = WebLoadURLString;
}

- (void)loadEncodeWebURLSring:(NSString *)string{
    self.isEncodeUrl = YES;
//    self.URLString = [[string addUrlParaString] stringByURLEncode];
    self.URLString = string;
    self.loadType = WebLoadURLString;
}

- (void)loadWebHTMLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = WebLoadHTMLString;
}
- (void)loadURLPathSring:(NSString *)string{
    self.URLString = string;
    self.loadType = webloadLocalPath;
}

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData{
    self.URLString = string;
    self.postString = postData;
    self.loadType = WebLoadJSPOST;
}

#pragma mark 自定义返回/关闭按钮
//请求链接处理
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    return;
}

#pragma mark - WKNavigationDelegate

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /* 主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 判断是否需要加载（仅在第一次加载）
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
        [self postRequestWithJS];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    // 获取加载网页的标题
    if (self.navigationItem.title.length == 0) {
        self.navigationItem.title = self.wkWebView.title;
    }

//    if (self.title.length == 0) {
//        self.title = self.wkWebView.title;
//    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.noNetWork.hidden = YES;
    //    [self updateNavigationItems];
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
}

//内容返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//服务器请求跳转的时候调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSURL *url = [navigationAction.request URL];
    
//    NSString *urlStr = [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[navigationAction.request.URL absoluteString]];
    //    if (orderInfo.length > 0) {
    //        [self payWithUrlOrder:orderInfo];
    //    }
    //    //拨打电话
    //    //兼容安卓的服务器写法:<a class = "mobile" href = "tel://电话号码"></a>
    //    NSString *mobileUrl = [[navigationAction.request URL] absoluteString];
    //    mobileUrl = [mobileUrl stringByRemovingPercentEncoding];
    //    NSArray *urlComps = [mobileUrl componentsSeparatedByString:@"://"];
    //    if ([urlComps count]){
    //
    //        if ([[urlComps objectAtIndex:0] isEqualToString:@"tel"]) {
    //
    //            UIAlertController *mobileAlert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"拨号给 %@ ？",urlComps.lastObject] preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *suerAction = [UIAlertAction actionWithTitle:@"拨号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobileUrl]];
    //            }];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //                return ;
    //            }];
    //
    //            [mobileAlert addAction:suerAction];
    //            [mobileAlert addAction:cancelAction];
    //
    //            [self presentViewController:mobileAlert animated:YES completion:nil];
    //        }
    //    }
    
    
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    //    [self updateNavigationItems];
    
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
    //    decisionHandler(WKNavigationActionPolicyAllow);
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    DLog(@"Error:%@",error.localizedDescription);
    self.progressView.hidden = YES;
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    self.noNetWork.hidden = NO;
//    [MBProgressHUD showTipMessageInWindow:Localized(@"LoadFailure")];
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    DLog(@"Error:%@",error.localizedDescription);
    self.progressView.hidden = YES;
    // 如果请求被取消
    if (error.code == NSURLErrorCancelled) {
        return;
    }
}

// 当Web视图的Web内容进程终止时调用。
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    self.progressView.hidden = YES;
}

#pragma mark - WKUIDelegate

// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    /*
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
     */
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    
}
//// WKWebView内点击链接跳转
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return nil;
//}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKScriptMessageHandler

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    //    if ([message.name isEqualToString:@"WXPayOpen"]) {
    //        NSLog(@"%@", message.body);
    //        if (self.wapPayInfoBlock) {
    //            self.wapPayInfoBlock(message.body);
    //        }
    //    }
    //
    //    if ([message.name isEqualToString:@"WXPayClose"]) {
    //        NSLog(@"%@", message.body);
    //        if (self.wapPayInfoBlock) {
    //            self.wapPayInfoBlock(message.body);
    //        }
    //    }
    //
    //    if ([message.name isEqualToString:@"WXPaySuccess"]) {
    //        NSLog(@"%@", message.body);
    //        if (self.wapPayInfoBlock) {
    //            self.wapPayInfoBlock(message.body);
    //        }
    //    }
    //
    //    if ([message.name isEqualToString:@"WXPayFailer"]) {
    //        NSLog(@"%@", message.body);
    //        if (self.wapPayInfoBlock) {
    //            self.wapPayInfoBlock(message.body);
    //        }
    //    }
    
}


- (UIBarButtonItem *)customBackBarItem
{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"nav_goback_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage* backItemHlImage = [[UIImage imageNamed:@"nav_goback_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}



- (UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localized(@"Close") style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

- (NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

- (void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}


#pragma mark- 链接内容
- (NSDictionary *)urlInfo:(NSString *)query{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if([query rangeOfString:@"&"].location != NSNotFound){
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        for (NSString *pair in pairs) {
            NSArray *elements = [pair componentsSeparatedByString:@"="];
            if (elements.count == 2) {
                NSString *key = [elements objectAtIndex:0];
                NSString *val = [elements objectAtIndex:1];
                [dict setObject:val forKey:key];
            }
        }
    }
    else{
        NSArray *elements = [query componentsSeparatedByString:@"="];
        if (elements.count == 2) {
            NSString *key = [elements objectAtIndex:0];
            NSString *val = [elements objectAtIndex:1];
            [dict setObject:val forKey:key];
        }
    }
    return dict;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
