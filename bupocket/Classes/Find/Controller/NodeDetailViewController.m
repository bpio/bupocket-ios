//
//  NodeDetailViewController.m
//  bupocket
//
//  Created by huoss on 2019/8/26.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "NodeDetailViewController.h"
#import "NodePlanViewCell.h"
#import "ListTableViewCell.h"
#import "StatusViewCell.h"
#import "SharingCanvassingAlertView.h"
#import <WebKit/WebKit.h>
#import "WKWebViewController.h"
#import "YBPopupMenu.h"

@interface NodeDetailViewController ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) NodePlanModel * nodePlanModel;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) WKWebView * wkWebView;
@property (nonatomic,strong) UIProgressView * progressView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic, strong) YBPopupMenu *popupMenu;
//@property (nonatomic, strong) UIButton * shareBtn;

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * nodeData;
@property (nonatomic, strong) NSArray * statusArray;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIButton * vote;

@end

static NSString * const NodeDetailID = @"NodeDetailID";
static NSString * const NodeInfoID = @"NodeInfoID";
static NSString * const StatusID = @"StatusID";

@implementation NodeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"NodeDetail");
    [self setupNav];
    [self setupView];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    UIButton * moreBtn = [UIButton createButtonWithNormalImage:@"nav_more" SelectedImage:@"nav_more" Target:self Selector:@selector(moreAction:)];
    moreBtn.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
//    self.shareBtn.userInteractionEnabled = NO;
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
//            self.shareBtn.userInteractionEnabled = YES;
            self.titleArray = @[Localized(@"NodeData"), Localized(@"NodeIntroduction"), Localized(@"StatusUpdate")];
            self.nodeData = @[Localized(@"NodeEquityValue"), Localized(@"CampaignBond(BU)"), Localized(@"AccumulatedAward(BU)"), Localized(@"AwardSharingRatioForVotingUsers"), Localized(@"Vote"), Localized(@"My vote")];
            self.statusArray = @[@"08-28\n12:00", @"07-26\n10:00", @"07-18\n16:00"];
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
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(ScreenScale(75) + SafeAreaBottomH);
    }];
}
- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = _tableView.backgroundColor;
        _vote = [UIButton createButtonWithTitle:Localized(@"I want to vote") isEnabled:YES Target:self Selector:@selector(voteAction:)];
        [_footerView addSubview:_vote];
        [_vote mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_footerView.mas_top).offset(Margin_Main);
            make.left.equalTo(self->_footerView.mas_left).offset(Margin_Main);
            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT));
        }];
    }
    return _footerView;
}
- (void)voteAction:(UIButton *)button
{
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
    return (self.titleArray.count > 0) ? self.titleArray.count + 1 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 1;
    } else if (section == 1) {
        return self.nodeData.count;
    } else {
        return self.statusArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return Margin_Section_Header;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        return [UIButton createAttrHeaderTitle:self.titleArray[section - 1]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.titleArray.count) {
        return SafeAreaBottomH + NavBarH + ScreenScale(90);
    } else {
        return Margin_10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.nodePlanModel) {
        return self.nodePlanModel.cellHeight;
    } else if (indexPath.section == 1) {
        return ScreenScale(35);
    } else if (indexPath.section == 2) {
        return self.wkWebView.height + Margin_15;
    } else {
        return ScreenScale(80);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodeDetailID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nodePlanModel = self.nodePlanModel;
        return cell;
    } else if (indexPath.section == 1) {
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.font = cell.detailTitle.font = FONT_13;
        cell.title.textColor = COLOR_6;
        cell.detailTitle.textColor = TITLE_COLOR;
        
        cell.title.text = self.nodeData[indexPath.row];
        cell.detailTitle.text = [NSString stringAppendingBUWithStr:@"23,345,333.897645"];
        cell.detail.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.lineView.hidden = (indexPath.row == self.nodeData.count - 1 );
        if (indexPath.row == self.nodeData.count - 3) {
            cell.detailTitle.textAlignment = NSTextAlignmentRight;
            [cell.listImage setImage:[UIImage imageNamed:@"explain_info"] forState:UIControlStateNormal];
            cell.detailTitle.text = @"50%";
        } else {
            cell.detailTitle.text = [NSString stringAmountSplitWith:@"23345333.897645"];
        }
//        if (indexPath.row == 0 || indexPath.row > self.nodeData.count - 3) {
//            cell.detailTitle.text = [NSString stringAmountSplitWith:@"13000000"];
//        } else if (indexPath.row < self.nodeData.count - 3) {
//            cell.detailTitle.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:@"23345333.897645"]];
//        }
//        InfoViewCell * cell = [InfoViewCell cellWithTableView:tableView cellType:CellTypeNormal];
//        cell.infoStr = Localized(@"RiskStatementPrompt");
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NodeInfoID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NodeInfoID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.wkWebView];
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        return cell;
    } else {
        StatusViewCell *cell = [StatusViewCell cellWithTableView:tableView identifier:StatusID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.type = indexPath.row;
//        cell.title.text = array[0][indexPath.row];
        return cell;
    }
}
- (void)moreAction:(UIButton *)button
{
    NSArray * titleArray = @[Localized(@"CancellationOfVotes"), Localized(@"OperationalRecords")];
    NSArray * imageArray = @[@"cancellation_of_votes", @"voting_records"];
    CGFloat width;
    NSString * language = CurrentAppLanguage;
    if ([language hasPrefix:ZhHans]) {
        width = ScreenScale(120);
    } else {
        width = ScreenScale(165);
    }
    _popupMenu = [YBPopupMenu showRelyOnView:button titles:titleArray icons:imageArray menuWidth:width otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = Margin_50;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = FONT_TITLE;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR_POPUPMENU;
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.tableView.scrollEnabled = NO;
        popupMenu.tableView.allowsSelection = NO;
        popupMenu.height = popupMenu.itemHeight * 2 + Margin_10;
    }];
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
 */
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
        // 图片自适应
        //        NSString * jsString = @"var objs = document.getElementsByTagName('img');for(var i=0;i++){var img = objs[i];img.style.maxWidth = '20%';img.style.height='auto';}";
        //        WKUserScript * wkUserScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        //        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        NSString *jScript = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=%f'); document.getElementsByTagName('head')[0].appendChild(meta);", View_Width_Main];
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        WKPreferences *preference = [[WKPreferences alloc]init];
        preference.minimumFontSize = ScreenScale(12);
        wkWebConfig.preferences = preference;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(Margin_Main, Margin_40, View_Width_Main, CGFLOAT_MIN) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.layer.masksToBounds = YES;
        _wkWebView.layer.cornerRadius = BG_CORNER;
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _wkWebView.scrollView.scrollIndicatorInsets = _wkWebView.scrollView.contentInset;
        }
    }
    return _wkWebView;
}
// WKWebView内点击链接跳转
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        WKWebViewController * VC = [[WKWebViewController alloc] init];
        [VC loadWebURLSring:[navigationAction.request.URL absoluteString]];
        [self.navigationController pushViewController:VC animated:YES];
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
    [self setImageFit];
    // 设置字体
    //    NSString *fontFamilyStr = @"document.getElementsByTagName('body')[0].style.fontFamily='Arial';";
    //    [webView evaluateJavaScript:fontFamilyStr completionHandler:nil];
    //    //设置颜色
    //    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#9098b8'" completionHandler:nil];
    //    //修改字体大小
    //    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
    //修改字体大小
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '85%'" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGRect webFrame = webView.frame;
            webFrame.size.height = webView.scrollView.contentSize.height;
            webView.frame = webFrame;
            [self.tableView reloadData];
        }];
        
    }];
}
- (void)setImageFit
{
    NSString *js = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    js = [NSString stringWithFormat:js,View_Width_Main,Content_Width_Main];
    
    [self.wkWebView evaluateJavaScript:js completionHandler:nil];
    
    [self.wkWebView evaluateJavaScript:@"ResizeImages();"completionHandler:nil];
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
