//
//  BSWebViewController.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/23.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSWebViewController.h"
#import "WeakScriptMessageDelegate.h"
#import "BAKit_WebView.h"
#import "ScanViewController.h"
#import "HealthScanRequest.h"

@interface BSWebViewController () <WKScriptMessageHandler>

@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKWebViewConfiguration *webConfig;
@property(nonatomic, strong) UIProgressView *progressView;

@end

@implementation BSWebViewController

static NSString * const kBSWebCloseKey = @"BSClose";
static NSString * const kBSWebChineseMedicineSaveSuccessKey = @"BSChineseMedicineSaveSuccess";  // 中药新增随访
static NSString * const kBSWebSignSaveSuccessKey = @"BSSignSaveSuccess";  // 签约成功
static NSString * const kBSWebQRCcodeVisitClickKey = @"QRCcodeBtnClick";      //签约扫码
static NSString * const kBSWebQRCcodeFilingClickKey = @"QRCcodeFilingClick";  //建档扫码
static NSString * const kBSWebHealthCardActivatedSuccessKey = @"BSHealthCardActivatedSuccess";  //健康卡激活成功

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.showNavigationBar) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    [self.navigationController setNavigationBarHidden:!self.showNavigationBar];
}

- (void)setupUI
{
    self.view.backgroundColor = BAKit_Color_White_pod;
    self.webView.hidden = NO;
    
    BAKit_WeakSelf;
    self.webView.ba_web_didFinishBlock = ^(WKWebView *webView, WKNavigation *navigation) {
        BAKit_StrongSelf;
        if (self.ocTojsStr && self.ocTojsStr.length > 0) {
            [webView ba_web_stringByEvaluateJavaScript:self.ocTojsStr completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
            }];
        }
    };
    
    self.webView.ba_web_isLoadingBlock = ^(BOOL isLoading, CGFloat progress) {
        BAKit_StrongSelf
        [self ba_web_progressShow];
        self.progressView.progress = progress;
        if (self.progressView.progress == 1.0f)
        {
            [self ba_web_progressHidder];
        }
    };
    
    self.webView.ba_web_getTitleBlock = ^(NSString *title) {
        BAKit_StrongSelf
        // 获取当前网页的 title
        self.title = title;
    };
}

#pragma mark - 修改 navigator.userAgent
- (void)changeNavigatorUserAgent
{
    BAKit_WeakSelf
    [self.webView ba_web_stringByEvaluateJavaScript:@"navigator.userAgent" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
        BAKit_StrongSelf
        NSLog(@"old agent ----- :%@", result);
        NSString *userAgent = result;
        
        NSString *customAgent = @" native_iOS";
        if ([userAgent hasSuffix:customAgent])
        {
            NSLog(@"navigator.userAgent已经修改过了");
        }
        else
        {
            NSString *customUserAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@"%@", customAgent]]; // 这里加空格是为了好看
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:customUserAgent, @"UserAgent", nil];
            [BAKit_NSUserDefaults registerDefaults:dictionary];
            [BAKit_NSUserDefaults synchronize];
            
            if ([self.webView respondsToSelector:@selector(setCustomUserAgent:)]) {
                [self.webView setCustomUserAgent:customUserAgent];
            }
            
            [self.webView ba_web_reload];
        }
    }];
}

- (void)ba_reload
{
    [self.webView ba_web_reload];
    [self changeNavigatorUserAgent];
}

- (void)ba_web_progressShow
{
    // 开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    // 开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    // 防止progressView被网页挡住
    [self.navigationController.view bringSubviewToFront:self.progressView];
}

- (void)ba_web_progressHidder
{
    /*
     *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
     *动画时长0.25s，延时0.3s后开始动画
     *动画结束后将progressView隐藏
     */
    [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
    } completion:^(BOOL finished) {
        self.progressView.hidden = YES;
        
    }];
}

/**
 *  加载一个 webview
 *
 *  @param request 请求的 NSURL URLRequest
 */
- (void)ba_web_loadRequest:(NSURLRequest *)request
{
    [self.webView ba_web_loadRequest:request];
}

/**
 *  加载一个 webview
 *
 *  @param URL 请求的 URL
 */
- (void)ba_web_loadURL:(NSURL *)URL
{
    [self.webView ba_web_loadURL:URL];
}

/**
 *  加载一个 webview
 *
 *  @param URLString 请求的 URLString
 */
- (void)ba_web_loadURLString:(NSString *)URLString
{
    [self.webView ba_web_loadURLString:URLString];
}

/**
 *  加载本地网页
 *
 *  @param htmlName 请求的本地 HTML 文件名
 */
- (void)ba_web_loadHTMLFileName:(NSString *)htmlName
{
    [self.webView ba_web_loadHTMLFileName:htmlName];
}

/**
 *  加载本地 htmlString
 *
 *  @param htmlString 请求的本地 htmlString
 */
- (void)ba_web_loadHTMLString:(NSString *)htmlString
{
    [self.webView ba_web_loadHTMLString:htmlString];
}

/**
 *  加载 js 字符串，例如：高度自适应获取代码：
 // webView 高度自适应
 [self ba_web_stringByEvaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
 // 获取页面高度，并重置 webview 的 frame
 self.ba_web_currentHeight = [result doubleValue];
 CGRect frame = webView.frame;
 frame.size.height = self.ba_web_currentHeight;
 webView.frame = frame;
 }];
 *
 *  @param javaScriptString js 字符串
 */
- (void)ba_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self.webView ba_web_stringByEvaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

#pragma mark 返回按钮点击
//-(BOOL)navigationShouldPopOnBackButton
//{
//    if (self.webView.ba_web_canGoBack)
//    {
//        [self.webView ba_web_goBack];
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.showNavigationBar) {
        self.webView.frame = CGRectMake(0, 0, BAKit_SCREEN_WIDTH, BAKit_SCREEN_HEIGHT-TOP_BAR_HEIGHT-SafeAreaBottomHeight);
        self.progressView.frame = CGRectMake(0, 0, BAKit_SCREEN_WIDTH, 20);
    } else {
        self.webView.frame = CGRectMake(0, 0, BAKit_SCREEN_WIDTH, BAKit_SCREEN_HEIGHT-SafeAreaBottomHeight);
        self.progressView.frame = CGRectMake(0, 0, BAKit_SCREEN_WIDTH, 20);
    }
}

#pragma mark - setter / getter

- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        //  添加 WKWebView 的代理，注意：用此方法添加代理
        BAKit_WeakSelf
        [_webView ba_web_initWithDelegate:weak_self.webView uIDelegate:weak_self.webView];
        
        _webView.multipleTouchEnabled = YES;
        _webView.autoresizesSubviews = YES;
        _webView.scrollView.bounces = self.showNavigationBar;
        
        [self.view addSubview:_webView];
        
        [self changeNavigatorUserAgent];
    }
    return _webView;
}

- (WKWebViewConfiguration *)webConfig
{
    if (!_webConfig) {
        
        // 创建并配置WKWebView的相关参数
        // 1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
        // 2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
        // 3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
        
        _webConfig = [[WKWebViewConfiguration alloc] init];
        _webConfig.allowsInlineMediaPlayback = YES;
        
        //        _webConfig.allowsPictureInPictureMediaPlayback = YES;
        
        // 通过 JS 与 webView 内容交互
        // 注入 JS 对象名称 senderModel，当 JS 通过 senderModel 来调用时，我们可以在WKScriptMessageHandler 代理中接收到
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WeakScriptMessageDelegate *delegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
        [userContentController addScriptMessageHandler:delegate name:kBSWebCloseKey];
        [userContentController addScriptMessageHandler:delegate name:kBSWebChineseMedicineSaveSuccessKey];
        [userContentController addScriptMessageHandler:delegate name:kBSWebHealthCardActivatedSuccessKey];
        [userContentController addScriptMessageHandler:delegate name:kBSWebSignSaveSuccessKey];
        [userContentController addScriptMessageHandler:delegate name:kBSWebQRCcodeVisitClickKey];
        [userContentController addScriptMessageHandler:delegate name:kBSWebQRCcodeFilingClickKey];
        
        _webConfig.userContentController = userContentController;
        // 初始化偏好设置属性：preferences
        _webConfig.preferences = [WKPreferences new];
        // The minimum font size in points default is 0;
        //        _webConfig.preferences.minimumFontSize = 40;
        // 是否支持 JavaScript
        _webConfig.preferences.javaScriptEnabled = YES;
        // 不通过用户交互，是否可以打开窗口
        //        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    }
    return _webConfig;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:kBSWebCloseKey]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([message.name isEqualToString:kBSWebChineseMedicineSaveSuccessKey])
    {
        [self postNotification:kZyFollowupSaveSuccess];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([message.name isEqualToString:kBSWebHealthCardActivatedSuccessKey])
    {
        [self postNotification:kHealthCardActivatedSuccess];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([message.name isEqualToString:kBSWebSignSaveSuccessKey])
    {
        [self postNotification:kSignSaveSuccess];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([message.name isEqualToString:kBSWebQRCcodeVisitClickKey]) {
        ScanViewController *scanVC = [[ScanViewController alloc]init];
        Bsky_WeakSelf
        scanVC.block = ^(ScanViewController *vc, NSString *scanCode) {
            Bsky_StrongSelf
            [vc.navigationController popViewControllerAnimated:YES];
            [self gethealthScanWithStr:scanCode ScanType:ScanBusinessHomeDoctorType];
        };
        [self.navigationController pushViewController:scanVC animated:YES];
    }
    else if ([message.name isEqualToString:kBSWebQRCcodeFilingClickKey])
    {
        ScanViewController *scanVC = [[ScanViewController alloc]init];
        Bsky_WeakSelf
        scanVC.block = ^(ScanViewController *vc, NSString *scanCode) {
            Bsky_StrongSelf
            [vc.navigationController popViewControllerAnimated:YES];
            [self gethealthScanWithStr:scanCode ScanType:ScanBusinessHealthFilesType];
        };
        [self.navigationController pushViewController:scanVC animated:YES];
    }
}
#pragma mark ---- 健康卡处理
- (void)gethealthScanWithStr:(NSString *)scanCode ScanType:(ScanBusinessType)type {
    HealthScanRequest *scanRequest = [[HealthScanRequest alloc]init];
    //家庭医生服务(包括签约)0300501
    scanRequest.requestModel.ewmsg = scanCode;
    scanRequest.businessType = type;
    Bsky_WeakSelf
    [MBProgressHUD showHud];
    [scanRequest startWithCompletionBlockWithSuccess:^(__kindof HealthScanRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        NSString *jsStr = nil;
        if (type == ScanBusinessHealthFilesType) {
            
            jsStr = [NSString stringWithFormat:@"getIosArchives('%@')",request.responseModel.zjhm];
        }
        else
        {
            jsStr = [NSString stringWithFormat:@"getIosQRresult('%@')",request.responseModel.zjhm];
        }
        [self.webView ba_web_stringByEvaluateJavaScript:jsStr completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
            
        }];
    } failure:^(__kindof HealthScanRequest * _Nonnull request) {
        Bsky_StrongSelf
        [MBProgressHUD hideHud];
        NSString *jsStr = nil;
        if (type == ScanBusinessHealthFilesType) {
            
            jsStr = [NSString stringWithFormat:@"getIosArchives('%@')",scanCode];
        }
        else
        {
            jsStr = [NSString stringWithFormat:@"getIosQRresult('%@')",scanCode];
        }
        [self.webView ba_web_stringByEvaluateJavaScript:jsStr completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
            
        }];
    }];
}

- (UIProgressView *)progressView {
    if (!_progressView)
    {
        _progressView = [UIProgressView new];
        _progressView.tintColor = UIColorFromRGB(0x000000);
        _progressView.progressTintColor = self.ba_web_progressTintColor ? self.ba_web_progressTintColor : UIColorFromRGB(0xff0000);
        _progressView.trackTintColor = self.ba_web_progressTrackTintColor ? self.ba_web_progressTrackTintColor : UIColorFromRGB(0x000000);
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)dealloc {
    if (!_webConfig) {
        return;
    }
    [self.webConfig.userContentController removeScriptMessageHandlerForName:kBSWebCloseKey];
    [self.webConfig.userContentController removeScriptMessageHandlerForName:kBSWebChineseMedicineSaveSuccessKey];
    [self.webConfig.userContentController removeScriptMessageHandlerForName:kBSWebHealthCardActivatedSuccessKey];
    [self.webConfig.userContentController removeScriptMessageHandlerForName:kBSWebSignSaveSuccessKey];
    [self.webConfig.userContentController removeScriptMessageHandlerForName:kBSWebQRCcodeVisitClickKey];
    [self.webConfig.userContentController removeScriptMessageHandlerForName:kBSWebQRCcodeFilingClickKey];
    [self.webView removeFromSuperview];
    [self.progressView removeFromSuperview];
    self.webView = nil;
    self.webConfig = nil;
    self.progressView = nil;
}

@end
