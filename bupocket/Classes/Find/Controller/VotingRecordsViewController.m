//
//  VotingRecordsViewController.m
//  bupocket
//
//  Created by bupocket on 2019/3/22.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "VotingRecordsViewController.h"
#import "NodePlanViewCell.h"
#import "VotingRecordsViewCell.h"
#import "VotingRecordsModel.h"

@interface VotingRecordsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;

@end

static NSString * const NodeCellID = @"NodeCellID";
static NSString * const NodeRecordsCellID = @"NodeRecordsCellID";
static NSString * const VotingRecordsCellID = @"VotingRecordsCellID";

@implementation VotingRecordsViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"VotingRecords");
    [self setupView];
    [self setupRefresh];
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
    NSString * nodeId = @"";
    if (self.nodePlanModel) {
        nodeId = self.nodePlanModel.nodeId;
    }
    [[HTTPManager shareManager] getVotingRecordDataWithNodeId:nodeId success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.listArray = [VotingRecordsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
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
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH;
        if (_nodePlanModel) {
            noDataH -= ScreenScale(80);
        }
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.nodePlanModel) {
        return self.listArray.count + 1;
    } else {
        return self.listArray.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && !self.nodePlanModel) {
        return Margin_5;
    } else if (self.nodePlanModel && section == 1) {
        return MAIN_HEIGHT;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.nodePlanModel && section == 1) {
        UIButton * title = [UIButton createButtonWithTitle:Localized(@"VotingRecords") TextFont:13 TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:nil Selector:nil];
        title.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, 0);
        title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        return title;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger index = self.listArray.count - 1;
    if (self.nodePlanModel) {
        index = self.listArray.count;
    }
    if (index == 0) {
        return CGFLOAT_MIN;
    } else if (section == index) {
        return SafeAreaBottomH + NavBarH;
    } else {
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.nodePlanModel && indexPath.section == 0) {
        return ScreenScale(80);
    } else {
        return ScreenScale(105);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.nodePlanModel && indexPath.section == 0) {
        NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodeCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.moreOperations.hidden = YES;
        cell.nodePlanModel = self.nodePlanModel;
        return cell;
    } else {
        NSString * cellID = VotingRecordsCellID;
        NSInteger index = indexPath.section;
        if (self.nodePlanModel) {
            cellID = NodeRecordsCellID;
            index = indexPath.section - 1;
        }
        VotingRecordsViewCell * cell = [VotingRecordsViewCell cellWithTableView:tableView identifier:cellID];
        cell.votingRecordsModel = self.listArray[index];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (self.nodePlanModel && indexPath.section == 0) {
//    } else {
    
//    }
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
