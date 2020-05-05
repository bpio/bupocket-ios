//
//  CooperateViewController.m
//  bupocket
//
//  Created by bupocket on 2019/4/4.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "CooperateViewController.h"
#import "CooperateViewCell.h"
#import "CooperateDetailViewController.h"
#import "CooperateModel.h"
#import "YBPopupMenu.h"
#import "DataBase.h"

@interface CooperateViewController ()<UITableViewDelegate, UITableViewDataSource, YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) YBPopupMenu * popupMenu;

@end

static NSString * const CooperateCellID = @"CooperateCellID";

@implementation CooperateViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"JointlyCooperate");
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
    if (self.listArray.count == 0) {
        [self getCacheData];        
    }
    [[HTTPManager shareManager] getNodeCooperateListDataSuccess:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * array = responseObject[@"data"][@"nodeList"];
            self.listArray = [CooperateModel mj_objectArrayWithKeyValuesArray:array];
            [[DataBase shareDataBase] deleteCachedDataWithCacheType:CacheTypeCooperateList];
            [[DataBase shareDataBase] saveDataWithArray:array cacheType:CacheTypeCooperateList];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
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
    NSArray * listArray = [[DataBase shareDataBase] getCachedDataWithCacheType:CacheTypeCooperateList];
    if (listArray.count > 0) {
        self.listArray = [NSMutableArray array];
        [self.listArray addObjectsFromArray:listArray];
        [self reloadUI];
    }
}
- (void)reloadUI
{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
    self.tableView.mj_footer.hidden = (self.listArray.count == 0);
    self.noNetWork.hidden = YES;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
//        _noData.backgroundColor = WHITE_BG_COLOR;
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
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
    if (section == 0) {
        return Margin_5;
    } else {
        return CGFLOAT_MIN;
    }
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
    CooperateViewCell * cell = [CooperateViewCell cellWithTableView:tableView identifier:CooperateCellID];
    cell.cooperateModel = self.listArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CooperateDetailViewController * VC = [[CooperateDetailViewController alloc] init];
    CooperateModel * cooperateModel = self.listArray[indexPath.section];
    VC.nodeId = cooperateModel.nodeId;
    [self.navigationController pushViewController:VC animated:YES];
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
