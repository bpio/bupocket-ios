//
//  FindViewController.m
//  bupocket
//
//  Created by bupocket on 2019/3/21.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "FindViewController.h"
#import "SDCycleScrollView.h"
#import "ListTableViewCell.h"
#import "WKWebViewController.h"
#import "WechatTool.h"
#import "NodePlanViewController.h"
#import "CooperateViewController.h"
#import "AdsModel.h"
#import "DataBase.h"


@interface FindViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSMutableArray * bannerArray;
@property (nonatomic, strong) UIView * headerView;

@end

@implementation FindViewController

- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = @[@[Localized(@"NodePlan"), Localized(@"JointlyCooperate")], @[Localized(@"Information")], @[Localized(@"YoPin")]];
    [self setupView];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
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
    [[HTTPManager shareManager] getBannerAdsDataWithSuccess:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * array = responseObject[@"data"][@"slideshow"];
            self.bannerArray = [AdsModel mj_objectArrayWithKeyValuesArray:array];
            [self reloadUI];
            [[DataBase shareDataBase] deleteCachedDataWithCacheType:CacheTypeFindBanner];
            [[DataBase shareDataBase] saveDataWithArray:array cacheType:CacheTypeFindBanner];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (self.bannerArray.count == 0) {
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        }
    }];
}
- (void)getCacheData
{
    NSArray * listArray = [[DataBase shareDataBase] getCachedDataWithCacheType:CacheTypeFindBanner];
    //    NSArray * listArray = [CacheData cachedAddressBookData];
    if (listArray.count > 0) {
        self.bannerArray = [NSMutableArray array];
        [self.bannerArray addObjectsFromArray:listArray];
        [self reloadUI];
    }
}
- (void)reloadUI
{
    if (self.bannerArray.count > 0) {
        NSMutableArray * imageArray = [NSMutableArray array];
        for (AdsModel * adsModel in self.bannerArray) {
            [imageArray addObject:adsModel.imageUrl];
        }
        self.cycleScrollView.imageURLStringsGroup = imageArray;
        self.tableView.tableHeaderView = self.cycleScrollView;
    } else {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    [self.tableView reloadData];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}
- (UIView *)headerView
{
    if (!_headerView) {
//         CGFloat headerH = (DEVICE_WIDTH - Margin_20) * 375 / 700;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(150))];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_headerView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"banner_placehoder"]];
        _cycleScrollView.autoScrollTimeInterval = Auto_Scroll_TimeInterval;
        _cycleScrollView.hidesForSinglePage = YES;
        [_headerView addSubview:_cycleScrollView];
    }
    return _headerView;
}
- (void)reloadData
{
    [self getData];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    AdsModel * adsModel = self.bannerArray[index];
    NSString * url = adsModel.url;
//    NSString * url = [self.bannerArray valueForKeyPath:@"url"][index];
    if (NotNULLString(url)) {
        WKWebViewController * VC = [[WKWebViewController alloc] init];
        [VC loadWebURLSring: url];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return SafeAreaBottomH + NavBarH + TabBarH;
    } else {
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Margin_50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeDetail];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    [cell.listImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"find_list_%ld_%ld", indexPath.section + 1, indexPath.row]] forState:UIControlStateNormal];
    cell.lineView.hidden = (indexPath.row == [self.listArray[indexPath.section] count] - 1);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NodePlanViewController * VC = [[NodePlanViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            CooperateViewController * VC = [[CooperateViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    } else if (indexPath.section == 1) {
        WKWebViewController * VC = [[WKWebViewController alloc] init];
        VC.navigationItem.title = self.listArray[indexPath.section][indexPath.row];
        [VC loadWebURLSring:Information_URL];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.section == 2) {
        [Encapsulation showAlertControllerForceWithTitle:Localized(@"Disclaimer") message:Localized(@"DisclaimerInfo") confirmHandler:^{
            [WechatTool enterWechatMiniProgram];
        }];
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
