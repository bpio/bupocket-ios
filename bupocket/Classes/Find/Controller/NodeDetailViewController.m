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
#import "VotingRecordsViewController.h"
#import "BottomConfirmAlertView.h"
#import "NodeDataModel.h"
#import "StatusUpdateModel.h"
#import "NodeVotingAlertView.h"

@interface NodeDetailViewController ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate, WKUIDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) WKWebView * wkWebView;
@property (nonatomic,strong) UIProgressView * progressView;
//@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic, strong) YBPopupMenu *popupMenu;
@property (nonatomic, strong) UIButton * moreBtn;

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NodeDataModel * nodeDataModel;
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
    _moreBtn = [UIButton createButtonWithNormalImage:@"nav_more" SelectedImage:@"nav_more" Target:self Selector:@selector(moreAction:)];
    _moreBtn.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_moreBtn];
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
    [[HTTPManager shareManager] getNodeDetailDataWithIDType:[self.nodePlanModel.identityType integerValue] nodeId: self.nodePlanModel.nodeId success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
//            self.shareBtn.userInteractionEnabled = YES;
            self.titleArray = @[Localized(@"NodeData"), Localized(@"NodeIntroduction"), Localized(@"StatusUpdate")];
            self.nodeDataModel = [NodeDataModel mj_objectWithKeyValues:responseObject[@"data"][@"nodeData"]];
            self.statusArray = [StatusUpdateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"nodeInfo"][@"timeline"]];
            NSString * vote = Localized(@"Votes");
            if ([self.nodePlanModel.nodeVote longLongValue] < 2) {
                vote = Localized(@"Vote");
            }
            NSString * myVote = Localized(@"My votes");
            if ([self.nodePlanModel.myVoteCount longLongValue] < 2) {
                myVote = Localized(@"My vote");
            }
            self.nodeData = @[@[Localized(@"NodeEquityValue"), Localized(@"CampaignBond(BU)"), Localized(@"AccumulatedAward(BU)"), Localized(@"AwardSharingRatioForVotingUsers"), vote, myVote], @[self.nodeDataModel.equityValue, self.nodeDataModel.deposit, self.nodeDataModel.totalRewardAmount, [NSString stringWithFormat:@"%@%%", self.nodeDataModel.ratio], self.nodePlanModel.nodeVote, self.nodePlanModel.myVoteCount]];
//            self.nodePlanModel = [NodePlanModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSString * introduce = responseObject[@"data"][@"nodeInfo"][@"introduce"];
            if ([self.nodePlanModel.identityType isEqualToString:@"2"]) {
                introduce = responseObject[@"data"][@"nodeInfo"][@"applyIntroduce"];
            }
            if (NotNULLString(introduce)) {
                [self.wkWebView loadHTMLString:introduce baseURL:nil];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = (self.titleArray.count > 0);
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
    if ([self.nodePlanModel.status integerValue] != NodeStatusSuccess) {
        NSString * status;
        if ([self.nodePlanModel.status integerValue] == NodeStatusExit) {
            status = Localized(@"NodeStatusExiting");
        } else if ([self.nodePlanModel.status integerValue] == NodeStatusQuit) {
            status = Localized(@"NodeStatusExited");
        }
        [Encapsulation showAlertControllerWithMessage:status handler:nil];
        return;
    }
    NodeVotingAlertView * alertView = [[NodeVotingAlertView alloc] initWithVoteConfrimBolck:^(NSString * _Nonnull text) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showConfirmAlertWithTitle:button.titleLabel.text amount:text];
        });
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeNone inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
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
        return [[self.nodeData firstObject] count];
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
        return self.wkWebView.height;
    } else {
        StatusUpdateModel * statusUpdateModel = self.statusArray[indexPath.row];
        return statusUpdateModel.cellHeight;
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
        
        cell.title.text = [self.nodeData firstObject][indexPath.row];
        NSString * info = [self.nodeData lastObject][indexPath.row];
        cell.detailTitle.text = [NSString stringAppendingBUWithStr:info];
        cell.detail.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.lineView.hidden = (indexPath.row == self.nodeData.count - 1 );
        if (indexPath.row == 3) {
            cell.detailTitle.textAlignment = NSTextAlignmentRight;
            [cell.listImage setImage:[UIImage imageNamed:@"explain_info"] forState:UIControlStateNormal];
            cell.detailTitle.text = info;
        } else {
            cell.detailTitle.text = [NSString stringAmountSplitWith:info];
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
//            make.edges.equalTo(cell.contentView);
            make.top.bottom.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView.mas_left).offset(Margin_10);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin_10);
        }];
        return cell;
    } else {
        StatusCellType cellType;
        if (indexPath.row == 0) {
            cellType = StatusCellTypeTop;
        } else if (indexPath.row == self.statusArray.count - 1) {
            cellType = StatusCellTypeBottom;
        } else {
            cellType = StatusCellTypeDefault;
        }
        StatusViewCell *cell = [StatusViewCell cellWithTableView:tableView indexPath:indexPath identifier:StatusID cellType:cellType];
        cell.statusUpdateModel = self.statusArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1 && indexPath.row == 3) {
        [self moreAction:cell.listImage];
    }
}
- (void)moreAction:(UIView *)sender
{
    CGFloat width;
    CGFloat height;
    CGFloat itemHeight;
    NSArray * titleArray;
    NSArray * imageArray;
    BOOL allowsSelection;
    if (sender == self.moreBtn) {
        titleArray = @[Localized(@"CancellationOfVotes"), Localized(@"OperationalRecords")];
        imageArray = @[@"cancellation_of_votes", @"voting_records"];
        NSString * language = CurrentAppLanguage;
        if ([language hasPrefix:ZhHans]) {
            width = ScreenScale(120);
        } else {
            width = ScreenScale(165);
        }
        sender = self.moreBtn.imageView;
        sender.height = Margin_15;
        itemHeight = Margin_50;
        height = itemHeight * 2 + Margin_10;
        allowsSelection = YES;
    } else {
        NSString * title = Localized(@"SharingRatioInfo");
        CGFloat titleHeight = [Encapsulation rectWithText:title font:FONT_TITLE textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
        titleArray = @[title];
        width = DEVICE_WIDTH - ScreenScale(100);
        itemHeight = titleHeight + Margin_30;
        height = titleHeight + Margin_40;
        allowsSelection = NO;
    }
    _popupMenu = [YBPopupMenu showRelyOnView:sender titles:titleArray icons:imageArray menuWidth:width otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = itemHeight;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = YES;
        popupMenu.fontSize = FONT_TITLE;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR_POPUPMENU;
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.tableView.scrollEnabled = NO;
        popupMenu.tableView.allowsSelection = allowsSelection;
        popupMenu.delegate = self;
        popupMenu.height = height;
    }];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    NSString * title = ybPopupMenu.titles[index];
    if ([title isEqualToString:Localized(@"CancellationOfVotes")]) {
        [self cancellationVotes:title];
    } else if ([title isEqualToString: Localized(@"OperationalRecords")]) {
        VotingRecordsViewController * VC = [[VotingRecordsViewController alloc] init];
        VC.nodePlanModel = self.nodePlanModel;
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (void)cancellationVotes:(NSString *)title
{
    if ([self.nodePlanModel.myVoteCount isEqualToString:@"0"]) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"IrrevocableVotes") handler:nil];
        return;
    }
    [self showConfirmAlertWithTitle:title amount:@"0"];
}
- (void)showConfirmAlertWithTitle:(NSString *)title amount:(NSString *)amount
{
    NSString * qrRemark;
    NSString * qrRemarkEn;
    NSString * script;
    NSString * role;
    NSString * type;
    if ([self.nodePlanModel.identityType integerValue] == NodeIDTypeConsensus) {
        role = Role_validator;
    } else if ([self.nodePlanModel.identityType integerValue] == NodeIDTypeEcological) {
        role = Role_kol;
    }
    
    if ([title isEqualToString:Localized(@"CancellationOfVotes")]) {
        qrRemark = [NSString stringWithFormat:Localized_Language(@"Number of votes revoked on '%@'", ZhHans), self.nodePlanModel.nodeName];
        qrRemarkEn = [NSString stringWithFormat:Localized_Language(@"Number of votes revoked on '%@'", EN), self.nodePlanModel.nodeName];
        script = DposUnVote(role, self.nodePlanModel.nodeCapitalAddress);
        type = [NSString stringWithFormat:@"%zd", TransactionTypeNodeWithdrawal];
    } else if ([title isEqualToString:Localized(@"I want to vote")]) {
        qrRemark = [NSString stringWithFormat:Localized_Language(@"Vote for '%@'%@", ZhHans), self.nodePlanModel.nodeName, amount];
        qrRemarkEn = [NSString stringWithFormat:Localized_Language(@"Vote for '%@'%@", EN), self.nodePlanModel.nodeName, amount];
        script = NodeVote(role, self.nodePlanModel.nodeCapitalAddress);
        type = [NSString stringWithFormat:@"%zd", TransactionTypeVote];
    }
    ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
    confirmTransactionModel.qrRemark = qrRemark;
    confirmTransactionModel.qrRemarkEn = qrRemarkEn;
    confirmTransactionModel.destAddress = self.contractAddress;
    confirmTransactionModel.accountTag = self.accountTag;
    confirmTransactionModel.accountTagEn = self.accountTagEn;
    confirmTransactionModel.amount = amount;
    confirmTransactionModel.script = script;
    confirmTransactionModel.nodeId = self.nodePlanModel.nodeId;
    confirmTransactionModel.type = type;
    BottomConfirmAlertView * confirmAlertView = [[BottomConfirmAlertView alloc] initWithIsShowValue:NO handlerType:HandlerTypeTransferDpos confirmModel:confirmTransactionModel confrimBolck:^{
    } cancelBlock:^{
        
    }];
    [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
/*
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
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
    } failure:^(NSError *error) {
    }];
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
 */
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        // 图片自适应
        //        NSString * jsString = @"var objs = document.getElementsByTagName('img');for(var i=0;i++){var img = objs[i];img.style.maxWidth = '20%';img.style.height='auto';}";
        //        WKUserScript * wkUserScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        //        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        NSString *jScript = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=%f'); document.getElementsByTagName('head')[0].appendChild(meta);", DEVICE_WIDTH - Margin_20];
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        WKPreferences *preference = [[WKPreferences alloc]init];
//        preference.minimumFontSize = ScreenScale(12);
        preference.minimumFontSize = ScreenScale(13);
        wkWebConfig.preferences = preference;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(Margin_10, 0, DEVICE_WIDTH - Margin_20, CGFLOAT_MIN) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
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
//    [self setImageFit];
    // 设置字体
    //    NSString *fontFamilyStr = @"document.getElementsByTagName('body')[0].style.fontFamily='Arial';";
    //    [webView evaluateJavaScript:fontFamilyStr completionHandler:nil];
    //    //设置颜色
    //    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#9098b8'" completionHandler:nil];
    //    //修改字体大小
    //    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'"completionHandler:nil];
    //修改字体大小
//    document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '85%'
    // 设置字体颜色
    NSString * fontColorStr = @"document.getElementsByTagName('body')[0].style.color='#666666';";
    // 设置字体
    NSString * fontFamilyStr = @"document.getElementsByTagName('body')[0].style.fontFamily='PingFangSC-Light';";
    // 设置字体大小
    NSString * fontSizeStr = @"document.getElementsByTagName('body')[0].style.fontSize='13px';";
    [webView evaluateJavaScript:fontSizeStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        [webView evaluateJavaScript:fontFamilyStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                [webView evaluateJavaScript:fontColorStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //                    [webView sizeToFit];
                        CGRect webFrame = webView.frame;
                        webFrame.size.height = webView.scrollView.contentSize.height;
                        webView.frame = webFrame;
                        [self.tableView reloadData];                        
                    });
                }];
            }];
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
    
    js = [NSString stringWithFormat:js,DEVICE_WIDTH - Margin_20,DEVICE_WIDTH - Margin_20];
    
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
