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
//#import "CancellationOfVotingAlertView.h"

@interface NodePlanViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) NSMutableArray * nodeListArray;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) YBPopupMenu * popupMenu;
@property (nonatomic, strong) YBPopupMenu * operationsMenu;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) NSString * contractAddress;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIButton * interdependentNode;

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
    [self getNodeListDataWithIdentityType:@"" nodeName:@"" capitalAddress:@""];
//    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    UIButton * votingRecords = [UIButton createButtonWithNormalImage:@"nav_records_n" SelectedImage:@"nav_votingRecords_n" Target:self Selector:@selector(votingRecordsAction)];
    votingRecords.frame = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
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
- (void)getNodeListDataWithIdentityType:(NSString *)identityType
                               nodeName:(NSString *)nodeName
                         capitalAddress:(NSString *)capitalAddress
{
    [[HTTPManager shareManager] getNodeListDataWithIdentityType:identityType nodeName:nodeName capitalAddress:capitalAddress  success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.listArray = [NodePlanModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"nodeList"]];
            self.nodeListArray = self.listArray;
//            self.contractAddress = responseObject[@"data"][@"contractAddress"];
            self.contractAddress = CurrentWalletAddress;
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self ifShowNoData];
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        self.noNetWork.hidden = NO;
    }];
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
        for (NodePlanModel * nodePlanModel in self.listArray) {
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
//    [self.view addSubview:self.headerView];
//    CGFloat tableViewY = CGRectGetMaxY(self.headerView.frame);
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, DEVICE_WIDTH, DEVICE_HEIGHT - tableViewY) style:UITableViewStyleGrouped];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    self.tableView.tableHeaderView = self.headerView;
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
- (void)searchAction
{
    [self.searchTextField resignFirstResponder];
//    if (self.searchText.length > 0) {
//        if (!self.tableView.mj_header) {
//            [self setupRefresh];
//        } else {
//            [self.tableView.mj_header beginRefreshing];
//        }
//    }
}
- (void)textChange:(UITextField *)textField
{
//    self.searchText = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
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
    return ScreenScale(85);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodePlanCellID];
    __block NodePlanModel * nodePlanModel = self.listArray[indexPath.section];
    cell.nodePlanModel = nodePlanModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.operationClick = ^(UIButton * _Nonnull btn) {
        btn.tag = indexPath.section;
        if ([nodePlanModel.nodeCapitalAddress isEqualToString:CurrentWalletAddress]) {
            [self setupOperation: btn isOriginator:YES];
        } else {
            [self setupOperation: btn isOriginator:NO];
        }
    };
    return cell;
}
- (void)setupOperation:(UIButton *)button isOriginator:(BOOL)isOriginator
{
    //    CGFloat titleHeight = [Encapsulation rectWithText:title font:TITLE_FONT textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    self.index = button.tag;
    NSMutableArray * titles = [NSMutableArray arrayWithObjects:Localized(@"CancellationOfVotes"), Localized(@"VotingRecords"), Localized(@"InvitationToVote"), nil];
    NSMutableArray * icons = [NSMutableArray arrayWithObjects:@"cancellationOfVotes", @"votingRecords", @"", nil];
    if (isOriginator == NO) {
        [titles addObject:Localized(@"ReceiveAwards")];
        [icons addObject:@""];
    }
    NSString * title;
    for (NSString * str in titles) {
        if (title.length < str.length) {
            title = str;
        }
    }
    CGFloat menuW = [Encapsulation rectWithText:title font:TITLE_FONT textHeight:Margin_15].size.width + ScreenScale(65);
    _operationsMenu = [YBPopupMenu showRelyOnView:button titles:titles icons:icons menuWidth:menuW otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = Margin_50;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = YES;
        popupMenu.fontSize = TITLE_FONT;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR(@"56526D");
//        popupMenu.tableView.scrollEnabled = NO;
//        popupMenu.tableView.allowsSelection = NO;
        popupMenu.delegate = self;
        popupMenu.showMaskView = NO;
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        NodePlanModel * nodePlanModel = self.listArray[self.index];
        ConfirmTransactionModel * confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
        confirmTransactionModel.qrRemark = [NSString stringWithFormat:@"撤销对“{%@}”的投票数,节点地址是%@?", nodePlanModel.nodeName, nodePlanModel.nodeCapitalAddress];
        confirmTransactionModel.destAddress = self.contractAddress;
        confirmTransactionModel.amount = @"0";
        NSString * role;
        if ([nodePlanModel.identityType isEqualToString:NodeType_Consensus]) {
            role = Role_validator;
        } else if ([nodePlanModel.identityType isEqualToString:NodeType_Ecological]) {
            role = Role_kol;
        }
        confirmTransactionModel.script = [NSString stringWithFormat:@"{\"method\":\"unVote\",\"params\":{\"role\":\"%@\",\"address\":\"%@\"}}", role, nodePlanModel.nodeCapitalAddress];
        confirmTransactionModel.nodeId = nodePlanModel.nodeId;
        ConfirmTransactionAlertView * alertView = [[ConfirmTransactionAlertView alloc] initWithDpos:confirmTransactionModel confrimBolck:^{
        } cancelBlock:^{
            
        }];
        [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
//        CancellationOfVotingAlertView * alertView = [[CancellationOfVotingAlertView alloc] initWithText:@"撤销" confrimBolck:^(NSString * _Nonnull text) {
//
//        } cancelBlock:^{
//
//        }];
//         [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    } else if (index == 1) {
        VotingRecordsViewController * VC = [[VotingRecordsViewController alloc] init];
        VC.nodePlanModel = self.listArray[self.index];
        [self.navigationController pushViewController:VC animated:NO];
    }
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
