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


@interface FindViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) NSArray * bannerArray;
@property (nonatomic, strong) UIView * headerView;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = @[@[Localized(@"NodePlan"), Localized(@"JointlyCooperate")], @[Localized(@"Information")], @[Localized(@"YoPin")]];
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
    [[HTTPManager shareManager] getAdsDataWithURL:Node_Ad_Banner success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.bannerArray = responseObject[@"data"][@"slideshow"];
            if (self.bannerArray.count > 0) {
                NSArray * imageArray = [self.bannerArray valueForKeyPath:@"imageUrl"];
                self.cycleScrollView.imageURLStringsGroup = imageArray;
            } else {
                self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
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
         CGFloat headerH = (DEVICE_WIDTH - Margin_20) * 375 / 700;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, headerH + Margin_10)];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(Margin_10, Margin_10, DEVICE_WIDTH - Margin_20, headerH) delegate:self placeholderImage:[UIImage imageNamed:@"banner_placehoder"]];
        _cycleScrollView.autoScrollTimeInterval = 2.5;
        _cycleScrollView.hidesForSinglePage = YES;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.layer.cornerRadius = BG_CORNER;
        _cycleScrollView.clipsToBounds = YES;
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
    NSString * url = [self.bannerArray valueForKeyPath:@"url"][index];
    if (NotNULLString(url)) {
        WKWebViewController * VC = [[WKWebViewController alloc] init];
        [VC loadWebURLSring: url];
        [self.navigationController pushViewController:VC animated:NO];
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"find_list_%ld_%ld", indexPath.section + 1, indexPath.row]];
    CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, Margin_50);
    if ([self.listArray[indexPath.section] count] - 1 == 0) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
        cell.lineView.hidden = YES;
    } else {
        if (indexPath.row == 0) {
            [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
            cell.lineView.hidden = NO;
        } else if (indexPath.row == [self.listArray[indexPath.section] count] - 1) {
            cell.lineView.hidden = YES;
            [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NodePlanViewController * VC = [[NodePlanViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        } else {
            CooperateViewController * VC = [[CooperateViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        }
    } else if (indexPath.section == 1) {
        WKWebViewController * VC = [[WKWebViewController alloc] init];
        VC.navigationItem.title = self.listArray[indexPath.section][indexPath.row];
        [VC loadWebURLSring:Information_URL];
        [self.navigationController pushViewController:VC animated:NO];
    } else if (indexPath.section == 2) {
        [Encapsulation showAlertControllerWithTitle:Localized(@"Disclaimer") message:Localized(@"DisclaimerInfo") confirmHandler:^(UIAlertAction *action) {
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
