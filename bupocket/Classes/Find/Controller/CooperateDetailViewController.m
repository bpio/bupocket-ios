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
#import "CooperateDetailModel.h"
#import "CooperateSupportModel.h"
#import "ConfirmTransactionAlertView.h"

#import "NodeTransferSuccessViewController.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"
#import "YBPopupMenu.h"

@interface CooperateDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
//@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIView * riskStatementBg;
@property (nonatomic, strong) UIButton * stateBtn;
@property (nonatomic, strong) CustomButton * shareRatioBtn;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) CustomButton * bondButton;

@property (nonatomic, strong) CooperateDetailModel * cooperateDetailModel;
@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, strong) NSMutableArray * transferInfoArray;
@property (nonatomic, strong) YBPopupMenu * popupMenu;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIButton * redemptionAllSupport;
@property (nonatomic, strong) UIButton * signOut;
@property (nonatomic, strong) UIButton * support;

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
- (NSMutableArray *)transferInfoArray
{
    if (!_transferInfoArray) {
        _transferInfoArray = [NSMutableArray array];
    }
    return _transferInfoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"JointlyCooperateDetail");
    [self setupView];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewData
{
    [self getData];
}
- (void)getData
{
    [[HTTPManager shareManager] getNodeCooperateDetailDataWithNodeId:self.nodeId success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.cooperateDetailModel = [CooperateDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.listArray = [CooperateSupportModel mj_objectArrayWithKeyValuesArray:self.cooperateDetailModel.supportList];
            [self.tableView reloadData];
            if ([self.cooperateDetailModel.status isEqualToString:@"43"]) {
                self.footerView.hidden = NO;
                self.redemptionAllSupport.hidden = NO;
            } else if (([self.cooperateDetailModel.status isEqualToString:@"1"] || [self.cooperateDetailModel.status isEqualToString:@"2"]) && ![self.cooperateDetailModel.originatorAddress isEqualToString:CurrentWalletAddress]) {
                self.footerView.hidden = NO;
                self.signOut.hidden = NO;
                self.support.hidden = NO;
            } else {
                self.footerView.hidden = YES;
            }
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
//        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
        self.noNetWork.hidden = YES;
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
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
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomH);
        make.height.mas_equalTo(ScreenScale(75));
    }];
    self.footerView.hidden = YES;
    self.signOut.hidden = YES;
    self.support.hidden = YES;
    self.redemptionAllSupport.hidden = YES;
}
- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = _tableView.backgroundColor;
        CGFloat signOutW = (DEVICE_WIDTH - Margin_30) / 5;
        _signOut = [UIButton createButtonWithTitle:Localized(@"WithdrawalOfSupport") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(signOutAction:)];
        _signOut.backgroundColor = COLOR(@"A1A7C7");
        _signOut.layer.masksToBounds = YES;
        _signOut.layer.cornerRadius = BG_CORNER;
        [_footerView addSubview:_signOut];
        [_signOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_footerView.mas_top).offset(Margin_15);
            make.left.equalTo(self->_footerView.mas_left).offset(Margin_10);
            make.size.mas_equalTo(CGSizeMake(signOutW * 2, MAIN_HEIGHT));
        }];
        _support = [UIButton createButtonWithTitle:Localized(@"IWantToSupport") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(supportAction)];
        _support.backgroundColor = MAIN_COLOR;
        _support.layer.masksToBounds = YES;
        _support.layer.cornerRadius = BG_CORNER;
        [_footerView addSubview:_support];
        [_support mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_signOut);
            make.right.equalTo(self->_footerView.mas_right).offset(-Margin_10);
            make.size.mas_equalTo(CGSizeMake(signOutW * 3, MAIN_HEIGHT));
        }];
        _redemptionAllSupport = [UIButton createButtonWithTitle:Localized(@"RedemptionAllSupport") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(signOutAction:)];
        _redemptionAllSupport.backgroundColor = COLOR(@"A1A7C7");
        _redemptionAllSupport.layer.masksToBounds = YES;
        _redemptionAllSupport.layer.cornerRadius = BG_CORNER;
        [_footerView addSubview:_redemptionAllSupport];
        [_redemptionAllSupport mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_footerView.mas_top).offset(Margin_15);
            make.left.equalTo(self->_footerView.mas_left).offset(Margin_10);
            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_20, MAIN_HEIGHT));
        }];
    }
    return _footerView;
}
- (void)signOutAction:(UIButton *)button
{
    if (button == _redemptionAllSupport) {
        [self setSignOutData];
    } else {
        [Encapsulation showAlertControllerWithTitle:nil message:Localized(@"ConfirmWithdrawalPrompt") cancelHandler:^(UIAlertAction *action) {
            
        } confirmHandler:^(UIAlertAction *action) {
            [self setSignOutData];
        }];
    }
}
- (void)setSignOutData
{
    ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
    confirmTransactionModel.qrRemark = [NSString stringWithFormat:Localized(@"Exit '%@' Project"), self.cooperateDetailModel.title];
    confirmTransactionModel.destAddress = self.cooperateDetailModel.contractAddress;
    confirmTransactionModel.amount = @"0";
    confirmTransactionModel.script = @"{\"method\":\"revoke\"}";
    confirmTransactionModel.nodeId = self.cooperateDetailModel.nodeId;
    confirmTransactionModel.type = TransactionType_Cooperate_SignOut;
    [self showConfirmAlertView:confirmTransactionModel];
}
- (void)supportAction
{
    NSString * leftAmount = [NSString stringWithFormat:@"%lld", [self.cooperateDetailModel.leftCopies longLongValue] * [self.cooperateDetailModel.perAmount longLongValue]];
    DLog(@"剩余支持金额%@", leftAmount);
    SupportAlertView * alertView = [[SupportAlertView alloc] initWithTotalTarget:leftAmount purchaseAmount:self.cooperateDetailModel.perAmount confrimBolck:^(NSString * _Nonnull text) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
            confirmTransactionModel.qrRemark = [NSString stringWithFormat:Localized(@"Supporting '%@' Projects"), self.cooperateDetailModel.title];
            confirmTransactionModel.destAddress = self.cooperateDetailModel.contractAddress;
            confirmTransactionModel.amount = text;
            NSString * copies = [NSString stringWithFormat:@"%lld", [text longLongValue] / [self.cooperateDetailModel.perAmount  longLongValue]];
            confirmTransactionModel.script = [NSString stringWithFormat:@"{\"method\":\"subscribe\",\"params\":{\"shares\":%@}}", copies];
            confirmTransactionModel.nodeId = self.cooperateDetailModel.nodeId;
            confirmTransactionModel.type = TransactionType_Cooperate_Support;
            confirmTransactionModel.copies = copies;
            [self showConfirmAlertView:confirmTransactionModel];
        });
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)showConfirmAlertView:(ConfirmTransactionModel *)confirmTransactionModel
{
    confirmTransactionModel.accountTag = @"";
    ConfirmTransactionAlertView * alertView = [[ConfirmTransactionAlertView alloc] initWithDpos:confirmTransactionModel confrimBolck:^(NSString * _Nonnull transactionCost) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:confirmTransactionModel.amount];
            NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:transactionCost];
            NSDecimalNumber * totleAmount = [amount decimalNumberByAdding:minTransactionCost];
            NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:[totleAmount stringValue] ifShowLoading:NO];
            NSString * totleAmountStr = [amountNumber stringValue];
            if (!NULLString(totleAmountStr) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
            } else if ([totleAmountStr hasPrefix:@"-"]) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
            } else {
                [self getContractTransactionData:confirmTransactionModel];
            }
        });
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}

// Transaction confirmation and submission
- (void)getContractTransactionData:(ConfirmTransactionModel *)confirmTransactionModel
{
    [[HTTPManager shareManager] getContractTransactionWithModel:confirmTransactionModel  success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSString * dateStr = [[responseObject objectForKey:@"data"] objectForKey:@"expiryTime"];
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dateStr longLongValue] / 1000];
            NSTimeInterval time = [date timeIntervalSinceNow];
            if (time < 0) {
                [Encapsulation showAlertControllerWithMessage:Localized(@"Overtime") handler:nil];
            } else {
                [self showPWAlertView:confirmTransactionModel];
            }
        } else {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithNodeErrorCode:code] handler:nil];
//            [Encapsulation showAlertControllerWithMessage:[NSString stringWithFormat:@"code=%@\nmsg:%@", responseObject[@"errCode"], responseObject[@"msg"]] handler:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)showPWAlertView:(ConfirmTransactionModel *)confirmTransactionModel
{
    PasswordAlertView * PWAlertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"TransactionWalletPWPrompt") walletKeyStore:CurrentWalletKeyStore isAutomaticClosing:YES confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        [self submitTransactionWithPassword:password confirmTransactionModel:confirmTransactionModel];
    } cancelBlock:^{
        
    }];
    [PWAlertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [PWAlertView.PWTextField becomeFirstResponder];
}
- (void)submitTransactionWithPassword:(NSString *)password confirmTransactionModel:(ConfirmTransactionModel *)confirmTransactionModel
{
    __weak typeof(self) weakSelf = self;
    [[HTTPManager shareManager] submitContractTransactionPassword:password success:^(TransactionResultModel *resultModel) {
        weakSelf.transferInfoArray = [NSMutableArray arrayWithObjects:confirmTransactionModel.destAddress, [NSString stringAppendingBUWithStr:confirmTransactionModel.amount], [NSString stringAppendingBUWithStr:resultModel.actualFee], nil];
        if (NULLString(confirmTransactionModel.qrRemark)) {
            [weakSelf.transferInfoArray addObject:confirmTransactionModel.qrRemark];
        }
        [self.transferInfoArray addObject:[DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", resultModel.transactionTime]]];
        if (resultModel.errorCode == Success_Code) {
            NodeTransferSuccessViewController * VC = [[NodeTransferSuccessViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        } else {
            TransferResultsViewController * VC = [[TransferResultsViewController alloc] init];
            VC.state = NO;
            VC.resultModel = resultModel;
            //            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:resultModel.errorCode]];
            VC.transferInfoArray = weakSelf.transferInfoArray;
            [self.navigationController pushViewController:VC animated:NO];
        }
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        VC.transactionHash = resultModel.transactionHash;
        [self.navigationController pushViewController:VC animated:NO];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.cooperateDetailModel) {
        self.sectionNumber = self.listArray.count > 0 ? 3 : 2;
    } else {
        self.sectionNumber = 0;
    }
    return self.sectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    } else if (section == 2) {
        return self.listArray.count;
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
    if (section == self.sectionNumber - 1) {
        CGFloat footerH = SafeAreaBottomH + NavBarH + Margin_5;
        if (([self.cooperateDetailModel.status isEqualToString:@"43"] || [self.cooperateDetailModel.status isEqualToString:@"1"] || [self.cooperateDetailModel.status isEqualToString:@"2"]) && ![self.cooperateDetailModel.originatorAddress isEqualToString:CurrentWalletAddress]) {
            footerH += ScreenScale(75);
        }
        return  footerH;
    } else {
        return CGFLOAT_MIN;
    }
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
            return ScreenScale(70);
        } else {
            return ScreenScale(35);
        }
    } else if (indexPath.section == 1) {
        return ceil([Encapsulation getSizeSpaceLabelWithStr:Localized(@"RiskStatementPrompt") font:FONT(13) width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:5.0].height + Margin_25) + 1;
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
                cell.textLabel.text = self.cooperateDetailModel.title;
                cell.detailTextLabel.text = nil;
                [cell.contentView addSubview:self.stateBtn];
                if ([self.cooperateDetailModel.status isEqualToString:@"3"]) {
                    self.stateBtn.selected = YES;
                } else if ([self.cooperateDetailModel.status isEqualToString:@"4"]) {
                    self.stateBtn.enabled = NO;
                }
                [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.centerY.equalTo(cell.contentView);
                }];
            } else if (indexPath.row == 1) {
                cell.textLabel.font = FONT_Bold(18);
                cell.textLabel.textColor = MAIN_COLOR;
                cell.detailTextLabel.font = FONT_Bold(18);
                cell.detailTextLabel.textColor = WARNING_COLOR;
                NSString * str = [NSString stringWithFormat:@"%@ %@%@", [NSString stringAmountSplitWith:self.cooperateDetailModel.perAmount], @"BU/", Localized(@"Shares")];
                cell.textLabel.attributedText = [Encapsulation attrWithString:str preFont:FONT_Bold(18) preColor:MAIN_COLOR index:str.length - 4 sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:0];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", self.cooperateDetailModel.rewardRate];
            } else if (indexPath.row == 2) {
                cell.textLabel.font = cell.detailTextLabel.font = FONT(12);
                cell.textLabel.textColor = cell.detailTextLabel.textColor = COLOR(@"B2B2B2");
                cell.textLabel.text = Localized(@"PurchaseAmount");
                [cell.contentView addSubview:self.shareRatioBtn];
                [self.shareRatioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(cell.contentView);
                    make.right.equalTo(cell.contentView.mas_right).offset(-Margin_15);
                }];
            }
        else {
                cell.textLabel.font = cell.detailTextLabel.font = FONT(13);
                cell.textLabel.textColor = cell.detailTextLabel.textColor = COLOR_6;
                if (indexPath.row == 3) {
                    cell.textLabel.font = cell.detailTextLabel.font = FONT(12);
                    cell.textLabel.textColor = cell.detailTextLabel.textColor = COLOR_9;
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %lld %@", Localized(@"SupportPortion"), [self.cooperateDetailModel.cobuildCopies longLongValue] - [self.cooperateDetailModel.leftCopies longLongValue], Localized(@"Shares")];
                    //                [NSString stringWithFormat:@"%@%@", self.cooperateDetailModel.supportPerson, Localized(@"SupportNumber")];
                    cell.detailTextLabel.text = [NSString stringWithFormat:Localized(@"The remaining %@ copies"), self.cooperateDetailModel.leftCopies];
                    [cell.contentView addSubview:self.lineView];
                    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-Margin_5);
                        make.left.equalTo(cell.contentView.mas_left).offset(Margin_15);
                        make.right.equalTo(cell.contentView.mas_right).offset(-Margin_15);
                        make.height.mas_equalTo(LINE_WIDTH);
                    }];
                    [cell.contentView addSubview:self.progressView];
                    if (NULLString(self.cooperateDetailModel.totalCopies)) {
                        NSString * supported = [NSString stringWithFormat:@"%lld", [self.cooperateDetailModel.cobuildCopies longLongValue] - [self.cooperateDetailModel.leftCopies longLongValue]];
                        self.progressView.progress = [[[NSDecimalNumber decimalNumberWithString:supported] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:self.cooperateDetailModel.cobuildCopies]] doubleValue];
                    }
                    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.contentView.mas_top).offset(Margin_15);
                        make.left.equalTo(cell.contentView.mas_left).offset(Margin_15);
                        make.right.equalTo(cell.contentView.mas_right).offset(-Margin_15);
                    }];
                } else if (indexPath.row == 4) {
                    cell.textLabel.text = Localized(@"TargetAmount");
                    NSString * targetAmount = [NSString stringWithFormat:@"%lld", [self.cooperateDetailModel.cobuildCopies longLongValue] * [self.cooperateDetailModel.perAmount longLongValue]];
                    cell.detailTextLabel.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:targetAmount]];
                } else if (indexPath.row == 5) {
                    cell.textLabel.text = Localized(@"TotalSupport");
                    cell.detailTextLabel.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:self.cooperateDetailModel.supportAmount]];
                } else if (indexPath.row == 6) {
//                    cell.textLabel.text = Localized(@"Bond");
                    [cell.contentView addSubview:self.bondButton];
                    [self.bondButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.equalTo(cell.contentView);
                        make.left.equalTo(cell.contentView.mas_left).offset(Margin_15);
                    }];
                    cell.detailTextLabel.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:self.cooperateDetailModel.initiatorAmount]];
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
        cell.cooperateSupportModel = self.listArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (UIButton *)stateBtn
{
    if (!_stateBtn) {
        _stateBtn = [UIButton createButtonWithTitle:Localized(@"InProgress") TextFont:14 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] NormalBackgroundImage:@"cooperate_state" SelectedBackgroundImage:@"cooperate_state_s" Target:nil Selector:nil];
        [_stateBtn setTitle:Localized(@"Completed") forState:UIControlStateSelected];
        [_stateBtn setTitle:Localized(@"Quit") forState:UIControlStateDisabled];
        [_stateBtn setBackgroundImage:[UIImage imageNamed:@"cooperate_state_s"] forState:UIControlStateDisabled];
    }
    return _stateBtn;
}
- (CustomButton *)bondButton
{
    if (!_bondButton) {
        _bondButton = [[CustomButton alloc] init];
        _bondButton.layoutMode = HorizontalInverted;
        _bondButton.titleLabel.font = FONT(13);
        [_bondButton setTitleColor:COLOR_6 forState:UIControlStateNormal];
        [_bondButton setTitle:Localized(@"Bond") forState:UIControlStateNormal];
        [_bondButton setImage:[UIImage imageNamed:@"interdependent_node_explain"] forState:UIControlStateNormal];
        [_bondButton addTarget:self action:@selector(bondAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bondButton;
}
- (void)bondAction:(UIButton *)button
{
    [self infoAction:button title:Localized(@"CooperateBond")];
}
- (CustomButton *)shareRatioBtn
{
    if (!_shareRatioBtn) {
        _shareRatioBtn = [[CustomButton alloc] init];
        _shareRatioBtn.layoutMode = HorizontalInverted;
        _shareRatioBtn.titleLabel.font = FONT(12);
        [_shareRatioBtn setTitle:Localized(@"AwardSharingRatio") forState:UIControlStateNormal];
        [_shareRatioBtn setImage:[UIImage imageNamed:@"interdependent_node_explain"] forState:UIControlStateNormal];
        [_shareRatioBtn setTitleColor:COLOR(@"B2B2B2") forState:UIControlStateNormal];
        [_shareRatioBtn addTarget:self action:@selector(shareRatioAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareRatioBtn;
}
- (void)shareRatioAction:(UIButton *)btn
{
    [self infoAction:btn title:Localized(@"ShareRatioInfo")];
}
- (void)infoAction:(UIButton *)button title:(NSString *)title
{
    CGFloat titleHeight = [Encapsulation rectWithText:title font:TITLE_FONT textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    _popupMenu = [YBPopupMenu showRelyOnView:button.imageView titles:@[title] icons:nil menuWidth:DEVICE_WIDTH - ScreenScale(100) otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = titleHeight + Margin_30;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = TITLE_FONT;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR(@"56526D");
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.tableView.scrollEnabled = NO;
        popupMenu.tableView.allowsSelection = NO;
        popupMenu.height = titleHeight + Margin_40;
    }];
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
        [riskStatementBtn setAttributedTitle:[Encapsulation attrWithString:Localized(@"RiskStatementPrompt") preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:5.0] forState:UIControlStateNormal];
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
