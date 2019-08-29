//
//  CooperateDetailViewController.m
//  bupocket
//
//  Created by bupocket on 2019/4/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "CooperateDetailViewController.h"
#import "AssetsDetailListViewCell.h"
#import "SupportAlertView.h"
#import "CooperateDetailModel.h"
#import "CooperateSupportModel.h"
#import "BottomConfirmAlertView.h"
//#import "ConfirmTransactionAlertView.h"

//#import "NodeTransferSuccessViewController.h"
//#import "TransferResultsViewController.h"
//#import "ResultViewController.h"
//#import "RequestTimeoutViewController.h"
#import "YBPopupMenu.h"

#import "CooperateDetailViewCell.h"
#import "InfoViewCell.h"
#import "InfoModel.h"

@interface CooperateDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;

@property (nonatomic, strong) CooperateDetailModel * cooperateDetailModel;
@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, strong) YBPopupMenu * popupMenu;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIButton * redemptionAllSupport;
@property (nonatomic, strong) UIButton * signOut;
@property (nonatomic, strong) UIButton * support;
@property (nonatomic, strong) InfoModel * infoModel;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"JointlyCooperateDetail");
    self.infoModel = [[InfoModel alloc] init];
    self.infoModel.info = Localized(@"RiskStatementPrompt");
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
            if ([self.cooperateDetailModel.status integerValue] == CooperateStatusFailure) {
                self.footerView.hidden = NO;
                self.redemptionAllSupport.hidden = NO;
            } else if ([self.cooperateDetailModel.status integerValue] == CooperateStatusInProcessing && ![self.cooperateDetailModel.originatorAddress isEqualToString:CurrentWalletAddress]) {
                self.footerView.hidden = NO;
                self.signOut.hidden = NO;
                self.support.hidden = NO;
            } else {
                self.footerView.hidden = YES;
            }
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
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
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(ScreenScale(75) + SafeAreaBottomH);
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
        CGFloat signOutW = (DEVICE_WIDTH - Margin_40) / 5;
        _signOut = [UIButton createButtonWithTitle:Localized(@"WithdrawalOfSupport") TextFont:FONT_BUTTON TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(signOutAction:)];
        _signOut.backgroundColor = COLOR(@"A1A7C7");
        _signOut.layer.masksToBounds = YES;
        _signOut.layer.cornerRadius = MAIN_CORNER;
        [_footerView addSubview:_signOut];
        [_signOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_footerView.mas_top).offset(Margin_Main);
            make.left.equalTo(self->_footerView.mas_left).offset(Margin_Main);
            make.size.mas_equalTo(CGSizeMake(signOutW * 2, MAIN_HEIGHT));
        }];
        _support = [UIButton createButtonWithTitle:Localized(@"IWantToSupport") TextFont:FONT_BUTTON TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(supportAction)];
        _support.backgroundColor = MAIN_COLOR;
        _support.layer.masksToBounds = YES;
        _support.layer.cornerRadius = MAIN_CORNER;
        [_footerView addSubview:_support];
        [_support mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_signOut);
            make.right.equalTo(self->_footerView.mas_right).offset(-Margin_Main);
            make.size.mas_equalTo(CGSizeMake(signOutW * 3, MAIN_HEIGHT));
        }];
        _redemptionAllSupport = [UIButton createButtonWithTitle:Localized(@"RedemptionAllSupport") TextFont:FONT_BUTTON TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(signOutAction:)];
        _redemptionAllSupport.backgroundColor = COLOR(@"A1A7C7");
        _redemptionAllSupport.layer.masksToBounds = YES;
        _redemptionAllSupport.layer.cornerRadius = MAIN_CORNER;
        [_footerView addSubview:_redemptionAllSupport];
        [_redemptionAllSupport mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_footerView.mas_top).offset(Margin_Main);
            make.left.equalTo(self->_footerView.mas_left).offset(Margin_Main);
            make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT));
        }];
    }
    return _footerView;
}
- (void)signOutAction:(UIButton *)button
{
    if (button == _redemptionAllSupport) {
        [self setSignOutData];
    } else {
        [Encapsulation showAlertControllerWithTitle:Localized(@"ConfirmWithdrawalPrompt") message:nil confirmHandler:^{
            [self setSignOutData];
        }];
//        [Encapsulation showAlertControllerWithTitle:nil message:Localized(@"ConfirmWithdrawalPrompt") cancelHandler:^(UIAlertAction *action) {
//
//        } confirmHandler:^(UIAlertAction *action) {
//            [self setSignOutData];
//        }];
    }
}
- (void)setSignOutData
{
    ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
    confirmTransactionModel.qrRemark = [NSString stringWithFormat:Localized_Language(@"Exit '%@' Project", ZhHans), self.cooperateDetailModel.title];
    confirmTransactionModel.qrRemarkEn = [NSString stringWithFormat:Localized_Language(@"Exit '%@' Project", EN), self.cooperateDetailModel.title];
    confirmTransactionModel.destAddress = self.cooperateDetailModel.contractAddress;
    confirmTransactionModel.amount = @"0";
    confirmTransactionModel.script = DopsRevoke;
    confirmTransactionModel.nodeId = self.cooperateDetailModel.nodeId;
    confirmTransactionModel.type = [NSString stringWithFormat:@"%zd", TransactionTypeCooperateSignOut];
    confirmTransactionModel.isCooperateDetail = YES;
    [self showConfirmAlertView:confirmTransactionModel];
}
- (void)supportAction
{
    NSString * leftAmount = [NSString stringWithFormat:@"%lld", [self.cooperateDetailModel.leftCopies longLongValue] * [self.cooperateDetailModel.perAmount longLongValue]];
    DLog(@"剩余支持金额%@", leftAmount);
    SupportAlertView * alertView = [[SupportAlertView alloc] initWithTotalTarget:leftAmount purchaseAmount:self.cooperateDetailModel.perAmount confrimBolck:^(NSString * _Nonnull text) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
            confirmTransactionModel.qrRemark = [NSString stringWithFormat:Localized_Language(@"Supporting '%@' Projects", ZhHans), self.cooperateDetailModel.title];
            confirmTransactionModel.qrRemarkEn = [NSString stringWithFormat:Localized_Language(@"Supporting '%@' Projects", EN), self.cooperateDetailModel.title];
//            [NSString stringWithFormat:Localized(@"Supporting '%@' Projects"), self.cooperateDetailModel.title];
            confirmTransactionModel.destAddress = self.cooperateDetailModel.contractAddress;
            confirmTransactionModel.amount = text;
            NSString * copies = [NSString stringWithFormat:@"%lld", [text longLongValue] / [self.cooperateDetailModel.perAmount  longLongValue]];
            confirmTransactionModel.script = DopsSubscribe(copies);
            confirmTransactionModel.nodeId = self.cooperateDetailModel.nodeId;
            confirmTransactionModel.type = [NSString stringWithFormat:@"%zd", TransactionTypeCooperateSupport];
            confirmTransactionModel.copies = copies;
            confirmTransactionModel.isCooperateDetail = YES;
            [self showConfirmAlertView:confirmTransactionModel];
        });
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeNone inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)showConfirmAlertView:(ConfirmTransactionModel *)confirmTransactionModel
{
    confirmTransactionModel.accountTag = @"";
    BottomConfirmAlertView * confirmAlertView = [[BottomConfirmAlertView alloc] initWithIsShowValue:NO handlerType:HandlerTypeTransferDpos confirmModel:confirmTransactionModel confrimBolck:^{
    } cancelBlock:^{
        
    }];
    [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    /*
    ConfirmTransactionAlertView * alertView = [[ConfirmTransactionAlertView alloc] initWithDposConfrimBolck:^(NSString * _Nonnull transactionCost) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:confirmTransactionModel.amount];
            NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:transactionCost];
            NSDecimalNumber * totleAmount = [amount decimalNumberByAdding:minTransactionCost];
            NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:[totleAmount stringValue] ifShowLoading:NO];
            NSString * totleAmountStr = [amountNumber stringValue];
            if (!NotNULLString(totleAmountStr) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
            } else if ([totleAmountStr hasPrefix:@"-"]) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
            } else {
                if (![[HTTPManager shareManager] getTransactionHashWithModel: confirmTransactionModel]) return;
                [self showPWAlertView:confirmTransactionModel];
            }
        });
    } cancelBlock:^{
        
    }];
    alertView.confirmTransactionModel = confirmTransactionModel;
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
     */
}
/*
// Transaction confirmation and submission
- (void)getContractTransactionData:(ConfirmTransactionModel *)confirmTransactionModel
{
    [[HTTPManager shareManager] getContractTransactionWithModel:confirmTransactionModel  success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code || code == ErrorNotSubmitted) {
            NSString * dateStr = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"data"] objectForKey:@"expiryTime"]];
            if (code == Success_Code) {
                NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dateStr longLongValue] / 1000];
                NSTimeInterval time = [date timeIntervalSinceNow];
                if (time < 0) {
                    [Encapsulation showAlertControllerWithMessage:Localized(@"Overtime") handler:nil];
                } else {
                    [self submitTransactionWithConfirmTransactionModel:confirmTransactionModel];
                }
            } else {
                [Encapsulation showAlertControllerWithMessage:[NSString stringWithFormat:Localized(@"NotSubmitted%@"), [DateTool getTimeIntervalWithStr:dateStr]] handler:nil];
            }
        } else {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithErrorCode:code] handler:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)showPWAlertView:(ConfirmTransactionModel *)confirmTransactionModel
{
    PasswordAlertView * PWAlertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"TransactionWalletPWPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        if (NotNULLString(password)) {
            [self getContractTransactionData:confirmTransactionModel];
        }
    } cancelBlock:^{
        
    }];
    [PWAlertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [PWAlertView.PWTextField becomeFirstResponder];
}
- (void)submitTransactionWithConfirmTransactionModel:(ConfirmTransactionModel *)confirmTransactionModel
{
    [[HTTPManager shareManager] submitTransactionWithSuccess:^(TransactionResultModel *resultModel) {
        if (resultModel.errorCode == Success_Code) {
            NodeTransferSuccessViewController * VC = [[NodeTransferSuccessViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            ResultViewController * VC = [[ResultViewController alloc] init];
            VC.state = NO;
            VC.resultModel = resultModel;
            VC.confirmModel = confirmTransactionModel;
            [self.navigationController pushViewController:VC animated:YES];
        }
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        VC.transactionHash = resultModel.transactionHash;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.cooperateDetailModel) {
//        self.sectionNumber = self.listArray.count > 0 ? 3 : 2;
        self.sectionNumber = 3;
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
        return Margin_Section_Header;
    } else if (section == 2) {
        return Margin_Section_Header - Margin_5;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        NSArray * titles = @[Localized(@"RiskStatement"), Localized(@"SupportRecords")];
        UIButton * title = [UIButton createHeaderButtonWithTitle:titles[section - 1]];
        CGFloat top = (section == 2) ? Margin_5 : 0;
        title.contentEdgeInsets = UIEdgeInsetsMake(top, Margin_Main, 0, Margin_Main);
        return title;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.sectionNumber - 1) {
        CGFloat footerH = SafeAreaBottomH + NavBarH + Margin_5;
        if ([self.cooperateDetailModel.status integerValue] == CooperateStatusFailure || ([self.cooperateDetailModel.status integerValue] == CooperateStatusInProcessing && ![self.cooperateDetailModel.originatorAddress isEqualToString:CurrentWalletAddress])) {
            footerH += ScreenScale(75);
        }
        if (self.listArray.count == 0) {
            footerH += ScreenScale(280);
        }
        return footerH;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == self.sectionNumber - 1 && self.listArray.count == 0) {
        CGFloat noDataH = ScreenScale(280);
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        [_noData addSubview:noDataBtn];
        return self.noData;
    } else {
        return [[UIView alloc] init];
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
        } else if (indexPath.row == 6) {
            return MAIN_HEIGHT;
        } else {
            return ScreenScale(35);
        }
    } else if (indexPath.section == 1) {
//        return [Encapsulation getAttrHeightWithInfoStr:Localized(@"RiskStatementPrompt") width:Content_Width_Main];
        return self.infoModel.cellHeight;
    } else {
        return ScreenScale(85);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CooperateDetailViewCell * cell = [CooperateDetailViewCell cellWithTableView:tableView identifier:CooperateDetailCellID];
        if (indexPath.row == 0) {
            cell.title.font = FONT_Bold(18);
            cell.title.textColor = TITLE_COLOR;
            cell.title.text = self.cooperateDetailModel.title;
            cell.infoTitle.text = nil;
            cell.stateBtn.hidden = NO;
            if ([self.cooperateDetailModel.status integerValue] == CooperateStatusInProcessing) {
                [cell.stateBtn setTitle:Localized(@"InProgress") forState:UIControlStateNormal];
                [cell.stateBtn setBackgroundImage:[UIImage imageNamed:@"cooperate_state"] forState:UIControlStateNormal];
            } else if ([self.cooperateDetailModel.status integerValue] == CooperateStatusSuccess) {
                [cell.stateBtn setTitle:Localized(@"Completed") forState:UIControlStateNormal];
                [cell.stateBtn setBackgroundImage:[UIImage imageNamed:@"cooperate_state_s"] forState:UIControlStateNormal];
            } else if ([self.cooperateDetailModel.status integerValue] == CooperateStatusFailure) {
                [cell.stateBtn setTitle:Localized(@"Quit") forState:UIControlStateNormal];
                [cell.stateBtn setBackgroundImage:[UIImage imageNamed:@"cooperate_state_s"] forState:UIControlStateNormal];
            }
        } else if (indexPath.row == 1) {
            NSString * perAmount = [NSString stringAmountSplitWith:self.cooperateDetailModel.perAmount];
            NSString * str = [NSString stringWithFormat:@"%@ %@", perAmount, Localized(@"BU/Portion")];
            cell.title.attributedText = [Encapsulation attrWithString:str preFont:FONT_Bold(18) preColor:MAIN_COLOR index:perAmount.length sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:0];
        } else if (indexPath.row == 2) {
            cell.title.font = cell.infoTitle.font = FONT(12);
            cell.title.textColor = cell.infoTitle.textColor = COLOR(@"B2B2B2");
            cell.title.text = Localized(@"PurchaseAmount");
        } else {
            if (indexPath.row == 3) {
                cell.title.font = cell.infoTitle.font = FONT(12);
                cell.title.textColor = cell.infoTitle.textColor = COLOR_9;
                int64_t received = [self.cooperateDetailModel.cobuildCopies longLongValue] - [self.cooperateDetailModel.leftCopies longLongValue];
                if (received > 1) {
                    cell.title.text = [NSString stringWithFormat:Localized(@"%lld shares received"), received];
                } else {
                    cell.title.text = [NSString stringWithFormat:Localized(@"%lld share received"), received];
                }
                NSString * leftStr = [NSString stringWithFormat:Localized(@"%lld shares left"), [self.cooperateDetailModel.leftCopies longLongValue]];
                if ([self.cooperateDetailModel.leftCopies longLongValue] < 2) {
                    leftStr = [NSString stringWithFormat:Localized(@"%lld share left"), [self.cooperateDetailModel.leftCopies longLongValue]];
                }
                cell.infoTitle.text = leftStr;
                cell.lineView.hidden = NO;
                cell.progressView.hidden = NO;
                cell.votingRatio.hidden = NO;
                if (NotNULLString(self.cooperateDetailModel.totalCopies)) {
                    NSString * supported = [NSString stringWithFormat:@"%lld", [self.cooperateDetailModel.cobuildCopies longLongValue] - [self.cooperateDetailModel.leftCopies longLongValue]];
                    double progress = [[[NSDecimalNumber decimalNumberWithString:supported] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:self.cooperateDetailModel.cobuildCopies]] doubleValue];
                    cell.progressView.progress = progress;
                    cell.votingRatio.text = [NSString stringWithFormat:@"%.2f%%", progress * 100];
                }
            } else if (indexPath.row == 4) {
                cell.title.text = Localized(@"TargetAmount");
                NSString * targetAmount = [NSString stringWithFormat:@"%lld", [self.cooperateDetailModel.cobuildCopies longLongValue] * [self.cooperateDetailModel.perAmount longLongValue]];
                cell.infoTitle.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:targetAmount]];
            } else if (indexPath.row == 5) {
                cell.title.text = Localized(@"TotalSupport");
                cell.infoTitle.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:self.cooperateDetailModel.supportAmount]];
            } else if (indexPath.row == 6) {
                cell.bondButton.hidden = NO;
                [cell.bondButton addTarget:self action:@selector(bondAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.infoTitle.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:self.cooperateDetailModel.initiatorAmount]];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        InfoViewCell * cell = [InfoViewCell cellWithTableView:tableView cellType:CellTypeNormal];
        cell.infoModel = self.infoModel;
        return cell;
    } else {
        AssetsDetailListViewCell * cell = [AssetsDetailListViewCell cellWithTableView:tableView];
        cell.cooperateSupportModel = self.listArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)bondAction:(UIButton *)button
{
    [self infoAction:button title:Localized(@"CooperateDeposit")];
}
- (void)infoAction:(UIButton *)button title:(NSString *)title
{
    CGFloat titleHeight = [Encapsulation rectWithText:title font:FONT_TITLE textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    _popupMenu = [YBPopupMenu showRelyOnView:button.imageView titles:@[title] icons:nil menuWidth:DEVICE_WIDTH - ScreenScale(100) otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = titleHeight + Margin_30;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = FONT_TITLE;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR_POPUPMENU;
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.tableView.scrollEnabled = NO;
        popupMenu.tableView.allowsSelection = NO;
        popupMenu.height = titleHeight + Margin_40;
    }];
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
