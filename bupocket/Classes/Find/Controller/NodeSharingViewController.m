//
//  NodeSharingViewController.m
//  bupocket
//
//  Created by bupocket on 2019/4/9.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodeSharingViewController.h"
#import "NodePlanViewCell.h"
#import "SharingCanvassingAlertView.h"
#import <WebKit/WebKit.h>
#import "WKWebViewController.h"

@interface NodeSharingViewController ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) NodePlanModel * nodePlanModel;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) WKWebView * wkWebView;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * shareBtn;

@end

static NSString * const NodeSharingID = @"NodeSharingID";

@implementation NodeSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"InvitationToVote");
    [self setupNav];
    [self setupView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    self.shareBtn = [UIButton createButtonWithNormalImage:@"invitationToVote" SelectedImage:@"invitationToVote" Target:self Selector:@selector(shareAction)];
    self.shareBtn.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    self.shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareBtn];
    self.shareBtn.userInteractionEnabled = NO;
}
- (void)dealloc {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData
{
    [self getData];
}
- (void)getData
{
    [[HTTPManager shareManager] getNodeInvitationVoteDataWithNodeId:self.nodeID success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.shareBtn.userInteractionEnabled = YES;
            self.nodePlanModel = [NodePlanModel mj_objectWithKeyValues:responseObject[@"data"]];
            if (NotNULLString(self.nodePlanModel.introduce)) {
                [self.wkWebView loadHTMLString:self.nodePlanModel.introduce baseURL:nil];
            }
            self.titleLabel.text = Localized(@"NodeIntroduction");
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = NO;
    }];
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)setupView
{
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    [self.view addSubview:self.progressView];
}
- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, ScreenScale(3));
        [_progressView setTrackTintColor:COLOR(@"F0F0F0")];
        _progressView.progressTintColor = MAIN_COLOR;
    }
    return _progressView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nodePlanModel ? 1 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ScreenScale(50) + self.wkWebView.height + NavBarH + SafeAreaBottomH;;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] init];
    if (NotNULLString(self.nodePlanModel.introduce)) {
        [footerView addSubview:self.titleLabel];
        [footerView addSubview:self.wkWebView];
    }
    footerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(40) + self.wkWebView.height  + NavBarH + SafeAreaBottomH);
    return footerView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin_15, 0, DEVICE_WIDTH - Margin_30, Margin_40)];
        _titleLabel.font = FONT(13);
        _titleLabel.textColor = COLOR_9;
    }
    return _titleLabel;
}
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.minimumFontSize = ScreenScale(14);
        wkWebConfig.preferences = preference;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(Margin_10, Margin_40, DEVICE_WIDTH - Margin_20, CGFLOAT_MIN) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.layer.masksToBounds = YES;
        _wkWebView.layer.cornerRadius = MAIN_CORNER;
    }
    return _wkWebView;
}
// WKWebView内点击链接跳转
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        WKWebViewController * VC = [[WKWebViewController alloc] init];
        [VC loadWebURLSring:[navigationAction.request.URL absoluteString]];
        [self.navigationController pushViewController:VC animated:NO];
    }
    return nil;
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:Dispatch_After_Time delay:Dispatch_After_Time options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGRect webFrame = webView.frame;
        webFrame.size.height = webView.scrollView.contentSize.height;
        webView.frame = webFrame;
        [self.tableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePlanModel * nodePlanModel = self.nodePlanModel;
    return nodePlanModel.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodeSharingID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nodePlanModel = self.nodePlanModel;
    return cell;
}
- (void)shareAction
{
    NSString * dateStr = self.nodePlanModel.shareStartTime;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dateStr longLongValue] / 1000];
    NSTimeInterval time = [date timeIntervalSinceNow];
    if (time > 0) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"ShareNotOpened") handler:nil];
        return;
    }
    NSString * path = nil;
    if ([self.nodePlanModel.identityType integerValue] == NodeIDTypeConsensus) {
        path = [NSString stringWithFormat:@"%@%@", Validate_Node_Path, self.nodeID];
    } else if ([self.nodePlanModel.identityType integerValue] == NodeIDTypeEcological) {
        path = [NSString stringWithFormat:@"%@%@", Kol_Node_Path, self.nodeID];
    }
    [[HTTPManager shareManager] getShortLinkDataWithType:@"1" path:path success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSString * shortLink = responseObject[@"data"][@"shortlink"];
            self.nodePlanModel.shortLink = shortLink;
            SharingCanvassingAlertView * alertView = [[SharingCanvassingAlertView alloc] initWithNodePlanModel:self.nodePlanModel confrimBolck:^(NSString * _Nonnull text) {
                
            } cancelBlock:^{
                
            }];
            [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
    } failure:^(NSError *error) {
    }];
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
