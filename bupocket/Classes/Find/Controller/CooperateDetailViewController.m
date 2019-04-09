//
//  CooperateDetailViewController.m
//  bupocket
//
//  Created by huoss on 2019/4/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "CooperateDetailViewController.h"
#import "AssetsDetailListViewCell.h"
#import "SupportAlertView.h"

@interface CooperateDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIView * riskStatementBg;
@property (nonatomic, strong) NSString * riskStatement;
@property (nonatomic, strong) UIButton * stateBtn;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UIView * lineView;

@end

static NSString * const CooperateDetailCellID = @"CooperateDetailCellID";

@implementation CooperateDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
//// 节点共建详情
//"JointlyCooperateDetail" = "共建信息详情";
//"InProgress" = "进行中";
//"InitialPurchaseAmount(BU/Portion)" = "起购金额（BU/份）";
//"IncentiveSharingRatio" = "奖励分享比例";
//"TotalSponsorSupport(BU)" = "发起人支持总额(BU)";
//"The remaining %@ copies" = "剩余%@份";
//"TotalTargetAmount(BU)" = "目标总额（BU)";
//"TotalSupport(BU)" = "已支持总额(BU)";
//"RiskStatement" = "风险说明";
//"SupportRecords" = "支持记录";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"JointlyCooperateDetail");
    self.listArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", nil];
    self.riskStatement = @"1、节点共建不是商品交易。支持者根据自己的判断选择、支持众筹项目，与发起人共同实现梦想并获得发起人承诺的回报，众筹存在一定风险。\n2、众筹平台只提供平台网络空间、技术服务和支持等中介服务。作为中间平台，并不是发起人或支持者中的任何一方，众筹仅存在于发起人和支持者之间，使用平台产生的法律后果由发起人与支持者自行承担。\n3、如果发生发起人无法发放回报、延迟发放回报、不提供回报后续服务等情形，您需要直接和发起人协商解决，平台对此不承担任何责任。";
    [self setupView];
    //    [self setupRefresh];
    // Do any additional setup after loading the view.
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
    /*
     [[HTTPManager shareManager] getVotingRecordDataWithNodeId:nodeId success:^(id responseObject) {
     NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
     if (code == Success_Code) {
     self.listArray = [VotingRecordsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
     [self.tableView reloadData];
     } else {
     [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
     }
     [self.tableView.mj_header endRefreshing];
     (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
     self.noNetWork.hidden = YES;
     self.tableView.mj_footer.hidden = (self.listArray.count == 0);
     } failure:^(NSError *error) {
     [self.tableView.mj_header endRefreshing];
     self.noNetWork.hidden = NO;
     }];
     */
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setFooterView];
}
- (void)setFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(75) + SafeAreaBottomH + NavBarH)];
    self.tableView.tableFooterView = footerView;
    CGFloat signOutW = (DEVICE_WIDTH - Margin_30) / 5;
    UIButton * signOut = [UIButton createButtonWithTitle:Localized(@"SignOut") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(signOutAction)];
    signOut.backgroundColor = WARNING_COLOR;
    signOut.layer.masksToBounds = YES;
    signOut.layer.cornerRadius = BG_CORNER;
    [footerView addSubview:signOut];
    [signOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(Margin_15);
        make.left.equalTo(footerView.mas_left).offset(Margin_10);
        make.size.mas_equalTo(CGSizeMake(signOutW * 2, MAIN_HEIGHT));
    }];
    UIButton * support = [UIButton createButtonWithTitle:Localized(@"Support") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(supportAction)];
    support.backgroundColor = MAIN_COLOR;
    support.layer.masksToBounds = YES;
    support.layer.cornerRadius = BG_CORNER;
    [footerView addSubview:support];
    [support mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signOut);
        make.right.equalTo(footerView.mas_right).offset(-Margin_10);
        make.size.mas_equalTo(CGSizeMake(signOutW * 3, MAIN_HEIGHT));
    }];
}
- (void)signOutAction
{
}
- (void)supportAction
{
    SupportAlertView * alertView = [[SupportAlertView alloc] initWithTotalTarget:@"5000000" purchaseAmount:@"1000000" confrimBolck:^(NSString * _Nonnull text) {
        
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return Margin_40;
    } else if (section == 2) {
        return Margin_30;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        NSArray * titles = @[Localized(@"RiskStatement"), Localized(@"SupportRecords")];
        UIButton * title = [UIButton createButtonWithTitle:titles[section - 1] TextFont:13 TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:nil Selector:nil];
        title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        title.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, Margin_10);
        return title;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return Margin_50;
        } else if (indexPath.row == 1) {
            return Margin_25;
        } else if (indexPath.row == 2) {
            return Margin_20;
        } else if (indexPath.row == 3) {
            return MAIN_HEIGHT;
        } else if (indexPath.row == 4) {
            return Margin_40;
        } else {
            return ScreenScale(35);
        }
    } else if (indexPath.section == 1) {
        return ceil([Encapsulation getSizeSpaceLabelWithStr:self.riskStatement font:FONT(13) width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:5.0].height + Margin_25) + 1;
//        [Encapsulation rectWithText:self.riskStatement font:FONT(13) textWidth:DEVICE_WIDTH - Margin_30].size.height + Margin_20;
    } else {
        return ScreenScale(85);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        static NSString * DetailInfo = @"DetailInfo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailInfo];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DetailInfo];
        }
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.font = FONT_Bold(18);
                cell.textLabel.textColor = TITLE_COLOR;
                cell.textLabel.text = @"百信共建小分队";
                cell.detailTextLabel.text = nil;
                [cell.contentView addSubview:self.stateBtn];
                [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.centerY.equalTo(cell.contentView);
                }];
            } else if (indexPath.row == 1) {
                cell.textLabel.font = FONT_Bold(18);
                cell.textLabel.textColor = MAIN_COLOR;
                cell.detailTextLabel.font = FONT_Bold(18);
                cell.detailTextLabel.textColor = WARNING_COLOR;
                cell.textLabel.text = @"10,000";
                cell.detailTextLabel.text = @"86%";
            } else if (indexPath.row == 2) {
                cell.textLabel.font = cell.detailTextLabel.font = FONT(12);
                cell.textLabel.textColor = cell.detailTextLabel.textColor = COLOR(@"B2B2B2");
                cell.textLabel.text = Localized(@"InitialPurchaseAmount(BU/Portion)");
                cell.detailTextLabel.text = Localized(@"IncentiveSharingRatio");
            } else if (indexPath.row == 4) {
                cell.textLabel.font = cell.detailTextLabel.font = FONT(12);
                cell.textLabel.textColor = cell.detailTextLabel.textColor = COLOR_9;
                cell.textLabel.text = [NSString stringWithFormat:Localized(@"The remaining %@ copies"), @"20"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", @"560", Localized(@"SupportNumber")];
                [cell.contentView addSubview:self.lineView];
                [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cell.contentView);
                    make.left.equalTo(cell.contentView.mas_left).offset(Margin_15);
                    make.right.equalTo(cell.contentView.mas_right).offset(-Margin_15);
                    make.height.mas_equalTo(LINE_WIDTH);
                }];
            } else {
                cell.textLabel.font = cell.detailTextLabel.font = FONT(13);
                cell.textLabel.textColor = cell.detailTextLabel.textColor = COLOR_6;
                if (indexPath.row == 3) {
                    cell.textLabel.text = Localized(@"TotalSponsorSupport(BU)");
                    cell.detailTextLabel.text = @"2,000,000";
                    [cell.contentView addSubview:self.progressView];
                    self.progressView.progress = 0.8;
                    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView.mas_left).offset(Margin_15);
                        make.right.equalTo(cell.contentView.mas_right).offset(-Margin_15);
                    }];
                } else if (indexPath.row == 5) {
                    cell.textLabel.text = Localized(@"TotalTargetAmount(BU)");
                    cell.detailTextLabel.text = @"5,000,000";
                } else if (indexPath.row == 6) {
                    cell.textLabel.text = Localized(@"TotalSupport(BU)");
                    cell.detailTextLabel.text = @"60,000";
                }
            }
        } else {
            [cell.contentView addSubview:self.riskStatementBg];
            self.riskStatementBg.backgroundColor = self.tableView.backgroundColor;
            [self.riskStatementBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
//            cell.textLabel.text = nil;
//            cell.detailTextLabel.text = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        AssetsDetailListViewCell * cell = [AssetsDetailListViewCell cellWithTableView:tableView];
        //    cell.votingRecordsModel = self.listArray[index];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (UIButton *)stateBtn
{
    if (!_stateBtn) {
        _stateBtn = [UIButton createButtonWithTitle:Localized(@"InProgress") TextFont:14 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] NormalBackgroundImage:@"cooperate_state" SelectedBackgroundImage:@"cooperate_state_s" Target:nil Selector:nil];
        [_stateBtn setTitle:Localized(@"Completed") forState:UIControlStateSelected];
    }
    return _stateBtn;
}
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = MAIN_COLOR;
        _progressView.trackTintColor = COLOR(@"E7E8EC");
        _progressView.progressViewStyle = UIProgressViewStyleBar;
    }
    return _progressView;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
- (UIView *)riskStatementBg
{
    if (!_riskStatementBg) {
        _riskStatementBg = [[UIView alloc] init];
        UIButton * riskStatementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        riskStatementBtn.titleLabel.numberOfLines = 0;
        riskStatementBtn.backgroundColor = [UIColor whiteColor];
        riskStatementBtn.layer.masksToBounds = YES;
        riskStatementBtn.layer.cornerRadius = BG_CORNER;
        riskStatementBtn.contentEdgeInsets = UIEdgeInsetsMake(Margin_10, Margin_10, Margin_10, Margin_10);
        [riskStatementBtn setAttributedTitle:[Encapsulation attrWithString:self.riskStatement preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:5.0] forState:UIControlStateNormal];
        [_riskStatementBg addSubview:riskStatementBtn];
        [riskStatementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_riskStatementBg);
            make.left.equalTo(self->_riskStatementBg.mas_left).offset(Margin_10);
            make.right.equalTo(self->_riskStatementBg.mas_right).offset(-Margin_10);
            make.bottom.equalTo(self->_riskStatementBg.mas_bottom).offset(-Margin_5);
        }];
    }
    return _riskStatementBg;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
