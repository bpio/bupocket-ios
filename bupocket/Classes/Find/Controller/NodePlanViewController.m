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
#import "BottomConfirmAlertView.h"
//#import "ConfirmTransactionAlertView.h"
#import "NodePlanModel.h"
#import "NodeSharingViewController.h"
#import "DataBase.h"

//#import "NodeTransferSuccessViewController.h"
//#import "TransferResultsViewController.h"
//#import "ResultViewController.h"
//#import "RequestTimeoutViewController.h"
//#import <IQKeyboardManager/IQKeyboardManager.h>

@interface NodePlanViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) NSMutableArray * nodeListArray;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) YBPopupMenu * popupMenu;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) NSString * contractAddress;
@property (nonatomic, strong) NSString * accountTag;
@property (nonatomic, strong) NSString * accountTagEn;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIButton * interdependentNode;
@property (nonatomic, strong) NSString * searchText;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"NodePlan");
    [self setupNav];
    [self setupView];
    [self setupRefresh];
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
    [self.navigationController pushViewController:VC animated:YES];
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
    [self getCacheData];
    [[HTTPManager shareManager] getNodeListDataWithIdentityType:@"" nodeName:@"" capitalAddress:@""  success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * array = responseObject[@"data"][@"nodeList"];
            self.listArray = [NodePlanModel mj_objectArrayWithKeyValuesArray:array];
            self.nodeListArray = self.listArray;
            self.contractAddress = responseObject[@"data"][@"contractAddress"];
            self.accountTag = responseObject[@"data"][@"accountTag"];
            self.accountTagEn = responseObject[@"data"][@"accountTagEn"];
            [[DataBase shareDataBase] deleteCachedDataWithCacheType:CacheTypeNodeList];
            [[DataBase shareDataBase] saveDataWithArray:array cacheType:CacheTypeNodeList];
            [self setNodeData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self reloadUI];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = (self.listArray.count > 0);
        if (self.listArray.count > 0) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
- (void)getCacheData
{
    NSArray * listArray = [[DataBase shareDataBase] getCachedDataWithCacheType:CacheTypeNodeList];
    if (listArray.count > 0) {
        self.listArray = [NSMutableArray array];
        [self.listArray addObjectsFromArray:listArray];
        self.nodeListArray = self.listArray;
        [self setNodeData];
        [self reloadUI];
    }
}
- (void)reloadUI
{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, SafeAreaBottomH + NavBarH)]) : (self.tableView.tableFooterView = self.noData);
    self.tableView.mj_footer.hidden = (self.listArray.count == 0);
    self.noNetWork.hidden = YES;
}
- (void)reloadData
{
    [self getData];
}
//- (void)ifShowNoData
//{
//    (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, SafeAreaBottomH + NavBarH)]) : (self.tableView.tableFooterView = self.noData);
//    self.tableView.mj_footer.hidden = (self.listArray.count == 0);
//}
#pragma mark 数据筛选
- (void)setNodeData
{
    if (self.interdependentNode.selected == NO && self.searchText.length == 0) {
        self.listArray = self.nodeListArray;
    } else if (self.interdependentNode.selected == YES  && self.searchText.length == 0) {
        NSMutableArray * listArray = [NSMutableArray array];
        for (NodePlanModel * nodePlanModel in self.nodeListArray) {
            if ([nodePlanModel.myVoteCount integerValue] > 0 || [nodePlanModel.nodeCapitalAddress isEqualToString:CurrentWalletAddress]) {
                [listArray addObject:nodePlanModel];
            }
        }
        self.listArray = listArray;
    } else if (self.interdependentNode.selected == NO && self.searchText.length > 0) {
        NSMutableArray * listArray = [NSMutableArray array];
        for (NodePlanModel * nodePlanModel in self.nodeListArray) {
            if ([nodePlanModel.nodeName containsString:self.searchText]) {
                [listArray addObject:nodePlanModel];
            }
        }
        self.listArray = listArray;
    } else if (self.interdependentNode.selected == YES && self.searchText.length > 0)  {
        NSMutableArray * listArray = [NSMutableArray array];
        for (NodePlanModel * nodePlanModel in self.nodeListArray) {
            if (([nodePlanModel.myVoteCount integerValue] > 0 || [nodePlanModel.nodeCapitalAddress isEqualToString:CurrentWalletAddress]) && [nodePlanModel.nodeName containsString:self.searchText]) {
                [listArray addObject:nodePlanModel];
            }
        }
        self.listArray = listArray;
    }
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
//    self.noNetWork.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(Margin_Section_Header - Margin_5, 0, 0, 0);
    [self.view addSubview:self.headerView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH - Margin_40;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (void)searchAction
{
    [self.searchTextField resignFirstResponder];
    [self setNodeData];
    [self reloadUI];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.searchText = nil;
    [self searchAction];
    return YES;
}
- (void)textChange:(UITextField *)textField
{
    self.searchText = TrimmingCharacters(self.searchTextField.text);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, Margin_Section_Header)];
        _interdependentNode = [UIButton createButtonWithTitle:[NSString stringWithFormat:@"  %@", Localized(@"InterdependentNode")] TextFont:FONT_TITLE TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 NormalImage:@"interdependent_node_n" SelectedImage:@"interdependent_node_s" Target:self Selector:@selector(interdependentNodeAction:)];
        _interdependentNode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_headerView addSubview:_interdependentNode];
        CGFloat interdependentNodeW = [Encapsulation rectWithText:Localized(@"InterdependentNode") font:FONT_TITLE textHeight:MAIN_HEIGHT].size.width + Margin_30;
        [_interdependentNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_headerView.mas_left).offset(Margin_10);
//            make.top.equalTo(self->_headerView.mas_top).offset(Margin_5);
            make.top.bottom.equalTo(self->_headerView);
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
//        [_searchTextField addDoneOnKeyboardWithTarget:self action:@selector(searchAction)];
        UIButton * searchBtn = [UIButton createButtonWithNormalImage:@"node_search" SelectedImage:@"node_search" Target:self Selector:@selector(searchAction)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = searchBtn;
        searchBtn.size = CGSizeMake(Margin_20, Margin_20);
        searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_5, 0, 0);
        _headerView.backgroundColor = _tableView.backgroundColor;
    }
    return _headerView;
}
- (void)interdependentNodeAction:(UIButton *)button
{
    button.selected = !button.selected;
    [self setNodeData];
    [self reloadUI];
}
- (void)infoAction:(UIButton *)button
{
    NSString * title = Localized(@"RelevantNodes");
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(160);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodePlanCellID];
    __block NodePlanModel * nodePlanModel = self.listArray[indexPath.row];
    cell.nodePlanModel = nodePlanModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.invitationVoteClick = ^{
        [self shareAction:nodePlanModel];
    };
    cell.votingRecordClick = ^{
        [self votingRecordWithIndex:indexPath.row];
    };
    cell.cancellationVotesClick = ^{
        [self cancellationVotesWithIndex:indexPath.row];
    };
    return cell;
}
- (void)shareAction:(NodePlanModel *)nodePlanModel
{
    if ([nodePlanModel.status integerValue] == NodeStatusSuccess) {
        NodeSharingViewController * VC = [[NodeSharingViewController alloc] init];
        VC.nodeID = nodePlanModel.nodeId;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        NSString * status;
        if ([nodePlanModel.status integerValue] == NodeStatusExit) {
            status = Localized(@"NodeStatusExiting");
        } else if ([nodePlanModel.status integerValue] == NodeStatusQuit) {
            status = Localized(@"NodeStatusExited");
        }
        [Encapsulation showAlertControllerWithMessage:status handler:nil];
    }
}
- (void)votingRecordWithIndex:(NSInteger)index
{
    VotingRecordsViewController * VC = [[VotingRecordsViewController alloc] init];
    VC.nodePlanModel = self.listArray[index];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)cancellationVotesWithIndex:(NSInteger)index
{
    NodePlanModel * nodePlanModel = self.listArray[index];
    if ([nodePlanModel.myVoteCount isEqualToString:@"0"]) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"IrrevocableVotes") handler:nil];
        return;
    }
    ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
    confirmTransactionModel.qrRemark = [NSString stringWithFormat:Localized_Language(@"Number of votes revoked on '%@'", ZhHans), nodePlanModel.nodeName];
    confirmTransactionModel.qrRemarkEn = [NSString stringWithFormat:Localized_Language(@"Number of votes revoked on '%@'", EN), nodePlanModel.nodeName];
    confirmTransactionModel.destAddress = self.contractAddress;
    confirmTransactionModel.accountTag = self.accountTag;
    confirmTransactionModel.accountTagEn = self.accountTagEn;
    confirmTransactionModel.amount = @"0";
    NSString * role;
    if ([nodePlanModel.identityType integerValue] == NodeIDTypeConsensus) {
        role = Role_validator;
    } else if ([nodePlanModel.identityType integerValue] == NodeIDTypeEcological) {
        role = Role_kol;
    }
    confirmTransactionModel.script = DposUnVote(role, nodePlanModel.nodeCapitalAddress);
    confirmTransactionModel.nodeId = nodePlanModel.nodeId;
    confirmTransactionModel.type = [NSString stringWithFormat:@"%zd", TransactionTypeNodeWithdrawal];
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
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithNodeErrorCode:code] handler:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
 */
/*
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
