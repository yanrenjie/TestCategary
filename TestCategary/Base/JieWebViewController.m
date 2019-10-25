//
//  JieWebViewController.m
//  TestCategary
//
//  Created by 颜仁浩 on 2019/10/25.
//  Copyright © 2019 颜仁浩. All rights reserved.
//

#import "JieWebViewController.h"

@interface JieWebViewController ()

/** <#digest#> */
@property (weak, nonatomic) UIProgressView *progressView;

/** <#digest#> */
@property (strong, nonatomic) UIButton *backBtn;

/** <#digest#> */
@property (strong, nonatomic) UIButton *closeBtn;

@end

@implementation JieWebViewController

- (void)setGotoURL:(NSString *)gotoURL {
//    @"`#%^{}\"[]|\\<> "   最后有一位空格
    _gotoURL = [gotoURL stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        if (@available(iOS 11.0, *)){
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        UIEdgeInsets contentInset = self.webView.scrollView.contentInset;
        contentInset.top += self.jie_navgationBar.jie_height;
        self.webView.scrollView.contentInset = contentInset;
        self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
    }
    
    JieWeak(self);
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.webView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    if (self.gotoURL.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.gotoURL]]];
    } else if (!IsEmpty(self.contentHTML)) {
        [self.webView loadHTMLString:self.contentHTML baseURL:nil];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        // 加载完成
        if (self.webView.estimatedProgress  >= 1.0f ) {
            [UIView animateWithDuration:0.25f animations:^{
                self.progressView.alpha = 0.0f;
                self.progressView.progress = 0.0f;
            }];
        } else {
            self.progressView.alpha = 1.0f;
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        id newVal = [change objectForKey:NSKeyValueChangeNewKey];
        if (!IsEmpty(newVal) && [newVal isKindOfClass:[NSString class]] && [self webViewController:self webViewIsNeedAutoTitle:self.webView]) {
            self.title = newVal;
        }
    } else if ([keyPath isEqualToString:@"scrollView.contentSize"]) {
        [self webView:self.webView scrollView:self.webView.scrollView contentSize:self.webView.scrollView.contentSize];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.progressView];
}


#pragma mark - LMJNavUIBaseViewControllerDataSource
#pragma mark - 设置左上角的一个返回按钮和一个关闭按钮
/** 导航条的左边的 view */
- (UIView *)jieNavigationBarLeftView:(JieNavigationBar *)navigationBar {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    leftView.backgroundColor = [UIColor yellowColor];
    self.backBtn.jie_origin = CGPointZero;
    self.closeBtn.jie_x = leftView.jie_width - self.closeBtn.jie_width;
    
    [leftView addSubview:self.backBtn];
    [leftView addSubview:self.closeBtn];
    return leftView;
}


- (void)leftButtonEvent:(UIButton *)sender navigationBar:(JieNavigationBar *)navigationBar {
    [self backBtnClick:sender webView:self.webView];
}


- (void)left_close_button_event:(UIButton *)sender {
    [self closeBtnClick:sender webView:self.webView];
}


#pragma mark - LMJWebViewControllerDataSource
// 默认需要, 是否需要进度条
- (BOOL)webViewController:(JieWebViewController *)webViewController webViewIsNeedProgressIndicator:(WKWebView *)webView {
    return YES;
}


// 默认需要自动改变标题
- (BOOL)webViewController:(JieWebViewController *)webViewController webViewIsNeedAutoTitle:(WKWebView *)webView {
    return YES;
}


#pragma mark - LMJWebViewControllerDelegate
// 导航条左边的返回按钮的点击
- (void)backBtnClick:(UIButton *)backBtn webView:(WKWebView *)webView {
    if (self.webView.canGoBack) {
        self.closeBtn.hidden = NO;
        [self.webView goBack];
    } else {
        [self closeBtnClick:self.closeBtn webView:self.webView];
    }
}


// 关闭按钮的点击
- (void)closeBtnClick:(UIButton *)closeBtn webView:(WKWebView *)webView {
    // 判断两种情况: push 和 present
    if ((self.navigationController.presentedViewController || self.navigationController.presentingViewController) && self.navigationController.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


// 监听 self.webView.scrollView 的 contentSize 属性改变，从而对底部添加的自定义 View 进行位置调整
- (void)webView:(WKWebView *)webView scrollView:(UIScrollView *)scrollView contentSize:(CGSize)contentSize {
    NSLog(@"%@\n%@\n%@", webView, scrollView, NSStringFromCGSize(contentSize));
}


#pragma mark - webDelegate
// 1, 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"decidePolicyForNavigationAction   ====    %@", navigationAction);
    decisionHandler(WKNavigationActionPolicyAllow);
    
}


// 2开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation   ====    %@", navigation);
}


// 4, 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"decidePolicyForNavigationResponse   ====    %@", navigationResponse);
    decisionHandler(WKNavigationResponsePolicyAllow);
}


// 5,内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didCommitNavigation   ====    %@", navigation);
}


// 3, 6, 加载 HTTPS 的链接，需要权限认证时调用  \  如果 HTTPS 是用的证书在信任列表中这不要此代理方法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}


// 7页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation   ====    %@", navigation);
}

// 8页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error {
    NSLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
}


//当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用回调函数
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
    NSLog(@"webViewWebContentProcessDidTerminate");
}


#pragma mark - 懒加载
- (WKWebView *)webView {
    if (_webView == nil) {
        //初始化一个WKWebViewConfiguration对象
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 0;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        // 检测各种特殊的字符串：比如电话、网站
        config.dataDetectorTypes = UIDataDetectorTypeAll;
        // 播放视频
        config.allowsInlineMediaPlayback = YES;

        // 交互对象设置
        config.userContentController = [[WKUserContentController alloc] init];
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        [self.view addSubview:webView];
        _webView = webView;
        
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webView.opaque = NO;
        webView.backgroundColor = [UIColor clearColor];
        //滑动返回看这里
        webView.allowsBackForwardNavigationGestures = YES;
        webView.allowsLinkPreview = YES;
    }
    return _webView;
}


- (UIProgressView *)progressView {
    if(_progressView == nil && [self.parentViewController isKindOfClass:[UINavigationController class]]) {
        UIProgressView *progressView = [[UIProgressView alloc] init];
        [self.view addSubview:progressView];
        _progressView = progressView;
        progressView.jie_height = 1;
        progressView.jie_width = ScreenWidth;
        progressView.jie_y = self.jie_navgationBar.jie_height;
        progressView.tintColor = [UIColor greenColor];
        
        if ([self respondsToSelector:@selector(webViewController:webViewIsNeedProgressIndicator:)]) {
            if (![self webViewController:self webViewIsNeedProgressIndicator:self.webView]) {
                progressView.hidden = YES;
            }
        }
    }
    return _progressView;
}


- (UIButton *)backBtn {
    if (_backBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        btn.jie_size = CGSizeMake(34, 44);
        [btn addTarget:self action:@selector(leftButtonEvent:navigationBar:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = btn;
    }
    return _backBtn;
}


- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.jie_size = CGSizeMake(44, 44);
        btn.hidden = YES;
        [btn addTarget:self action:@selector(left_close_button_event:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}


- (void)dealloc {
    NSLog(@"JieWebViewController -- dealloc");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"scrollView.contentSize"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
    self.webView.UIDelegate = nil;
    self.webView.navigationDelegate = nil;
    self.webView.scrollView.delegate = nil;
}

@end
