//
//  NodePlanViewController.m
//  bupocket
//
//  Created by bupocket on 2019/3/21.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodePlanViewController.h"
#import "NodePlanViewCell.h"
#import "YBPopupMenu.h"
#import "VotingRecordsViewController.h"
#import "ConfirmTransactionAlertView.h"
#import "NodePlanModel.h"
#import "NodeSharingViewController.h"

#import "NodeTransferSuccessViewController.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"

@interface NodePlanViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) NSMutableArray * nodeListArray;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) YBPopupMenu * popupMenu;
//@property (nonatomic, strong) YBPopupMenu * operationsMenu;
//@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) NSString * contractAddress;
@property (nonatomic, strong) NSString * accountTag;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIButton * interdependentNode;
@property (nonatomic, strong) NSString * searchText;

@property (nonatomic, strong) NSMutableArray * transferInfoArray;

@end

static NSString * const NodePlanCellID = @"NodePlanCellID";

@implementation NodePlanViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)nodeListArray
{
    if (!_nodeListArray) {
        _nodeListArray = [NSMutableArray array];
    }
    return _nodeListArray;
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
    self.navigationItem.title = Localized(@"NodePlan");
    [self setupNav];
    [self setupView];
    
    [self getData];
//    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    UIButton * votingRecords = [UIButton createButtonWithNormalImage:@"nav_records_n" SelectedImage:@"nav_votingRecords_n" Target:self Selector:@selector(votingRecordsAction)];
    votingRecords.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    votingRecords.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:votingRecords];
}
- (void)votingRecordsAction
{
    VotingRecordsViewController * VC = [[VotingRecordsViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
}
//- (void)setupRefresh
//{
//    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
//}
//- (void)loadNewData
//{
//    [self getNodeListDataWithIdentityType:@"" nodeName:@"" capitalAddress:@""];
//}

- (void)getData
{
    [[HTTPManager shareManager] getNodeListDataWithIdentityType:@"" nodeName:@"" capitalAddress:@""  success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.listArray = [NodePlanModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"nodeList"]];
            self.nodeListArray = self.listArray;
            self.contractAddress = responseObject[@"data"][@"contractAddress"];
            self.accountTag = responseObject[@"data"][@"accountTag"];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self ifShowNoData];
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        self.noNetWork.hidden = NO;
    }];
}
- (void)reloadData
{
    [self getData];
}
- (void)ifShowNoData
{
    (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
    self.tableView.mj_footer.hidden = (self.listArray.count == 0);
}
- (void)setInterdependentNode
{
    if (self.interdependentNode.selected == NO) {
        self.listArray = self.nodeListArray;
    } else {
        NSMutableArray * listArray = [NSMutableArray array];
        for (NodePlanModel * nodePlanModel in self.nodeListArray) {
            if ([nodePlanModel.myVoteCount integerValue] > 0 || [nodePlanModel.nodeCapitalAddress isEqualToString:CurrentWalletAddress]) {
                [listArray addObject:nodePlanModel];
            }
        }
        self.listArray = listArray;
    }
    [self ifShowNoData];
    [self.tableView reloadData];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    self.tableView.tableHeaderView = self.headerView;
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH - Margin_40;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, Margin_40)];
        _interdependentNode = [UIButton createButtonWithTitle:[NSString stringWithFormat:@"  %@", Localized(@"InterdependentNode")] TextFont:14 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 NormalImage:@"interdependent_node_n" SelectedImage:@"interdependent_node_s" Target:self Selector:@selector(interdependentNodeAction:)];
        _interdependentNode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_headerView addSubview:_interdependentNode];
        CGFloat interdependentNodeW = [Encapsulation rectWithText:Localized(@"InterdependentNode") font:FONT(13) textHeight:MAIN_HEIGHT].size.width + Margin_30;
        [_interdependentNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_headerView.mas_left).offset(Margin_10);
            make.top.equalTo(self->_headerView.mas_top).offset(Margin_5);
            make.bottom.equalTo(self->_headerView);
            make.width.mas_equalTo(interdependentNodeW);
        }];
        UIButton * infoBtn = [UIButton createButtonWithNormalImage:@"interdependent_node_explain" SelectedImage:@"interdependent_node_explain" Target:self Selector:@selector(infoAction:)];
        [_headerView addSubview:infoBtn];
        infoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_interdependentNode.mas_right).offset(Margin_5);
            make.top.bottom.equalTo(self->_interdependentNode);
            make.width.mas_equalTo(Margin_30);
        }];
        
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = Localized(@"InputAssetName");
        _searchTextField.font = FONT(11);
        _searchTextField.textColor = TITLE_COLOR;
        _searchTextField.delegate = self;
        _searchTextField.tintColor = MAIN_COLOR;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [_searchTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        _searchTextField.placeholder = Localized(@"Search");
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.layer.cornerRadius = TAG_CORNER;
        _searchTextField.layer.borderWidth = 0.5;
        _searchTextField.layer.borderColor = COLOR(@"D2D2D2").CGColor;
        [_headerView addSubview:_searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self->_headerView.mas_right).offset(-Margin_10);
            make.centerY.equalTo(self->_interdependentNode);
            make.size.mas_equalTo(CGSizeMake(ScreenScale(73), Margin_20));
        }];
        
        UIButton * searchBtn = [UIButton createButtonWithNormalImage:@"node_search" SelectedImage:@"node_search" Target:self Selector:@selector(searchAction)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = searchBtn;
        searchBtn.size = CGSizeMake(Margin_20, Margin_20);
        //        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.top.bottom.equalTo(self->_searchTextField);
        //            make.width.mas_equalTo(Margin_20);
        //        }];
    }
    return _headerView;
}
- (void)searchAction
{
    [self.searchTextField resignFirstResponder];
    [self searchData];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.searchText = nil;
    [self searchAction];
    return YES;
}
- (void)textChange:(UITextField *)textField
{
    self.searchText = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
}
- (void)searchData
{
    if (self.searchText.length == 0) {
        self.listArray = self.nodeListArray;
    } else {
        NSMutableArray * listArray = [NSMutableArray array];
        for (NodePlanModel * nodePlanModel in self.nodeListArray) {
            if ([nodePlanModel.nodeName containsString:self.searchText]) {
                [listArray addObject:nodePlanModel];
            }
        }
        self.listArray = listArray;
    }
    [self ifShowNoData];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (void)interdependentNodeAction:(UIButton *)button
{
    button.selected = !button.selected;
    [self setInterdependentNode];
}
- (void)infoAction:(UIButton *)button
{
    NSString * title = Localized(@"RelevantNodes");
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return SafeAreaBottomH + NavBarH;
    } else {
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(160);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodePlanCellID];
    __block NodePlanModel * nodePlanModel = self.listArray[indexPath.section];
    cell.nodePlanModel = nodePlanModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.invitationVoteClick = ^{
        [self shareAction:nodePlanModel];
    };
    cell.votingRecordClick = ^{
        [self votingRecordWithIndex:indexPath.section];
    };
    cell.cancellationVotesClick = ^{
        [self cancellationVotesWithIndex:indexPath.section];
    };
    return cell;
}
- (void)shareAction:(NodePlanModel *)nodePlanModel
{
    NodeSharingViewController * VC = [[NodeSharingViewController alloc] init];
    VC.nodeID = nodePlanModel.nodeId;
    [self.navigationController pushViewController:VC animated:NO];
}
- (void)invitationVoteWithIndex:(NSInteger)index
{
}
- (void)votingRecordWithIndex:(NSInteger)index
{
    VotingRecordsViewController * VC = [[VotingRecordsViewController alloc] init];
    VC.nodePlanModel = self.listArray[index];
    [self.navigationController pushViewController:VC animated:NO];
}
- (void)cancellationVotesWithIndex:(NSInteger)index
{
    NodePlanModel * nodePlanModel = self.listArray[index];
    if ([nodePlanModel.myVoteCount isEqualToString:@"0"]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"IrrevocableVotes")];
        return;
    }
    ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
    confirmTransactionModel.qrRemark = [NSString stringWithFormat:Localized(@"Number of votes revoked on '%@'"), nodePlanModel.nodeName];
    confirmTransactionModel.destAddress = self.contractAddress;
    confirmTransactionModel.accountTag = self.accountTag;
    confirmTransactionModel.amount = @"0";
    NSString * role;
    if ([nodePlanModel.identityType isEqualToString:NodeType_Consensus]) {
        role = Role_validator;
    } else if ([nodePlanModel.identityType isEqualToString:NodeType_Ecological]) {
        role = Role_kol;
    }
    confirmTransactionModel.script = [NSString stringWithFormat:@"{\"method\":\"unVote\",\"params\":{\"role\":\"%@\",\"address\":\"%@\"}}", role, nodePlanModel.nodeCapitalAddress];
    confirmTransactionModel.nodeId = nodePlanModel.nodeId;
    confirmTransactionModel.type = TransactionType_NodeWithdrawal;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
