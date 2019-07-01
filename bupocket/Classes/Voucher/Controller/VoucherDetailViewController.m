//
//  VoucherDetailViewController.m
//  bupocket
//
//  Created by huoss on 2019/7/1.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherDetailViewController.h"
#import "DetailListViewCell.h"
#import "UINavigationController+Extension.h"

@interface VoucherDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@end

static NSString * const DetailListCellID = @"DetailListCellID";

@implementation VoucherDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = Localized(@"VoucherDetail");
//    self.navAlpha = 0;
    self.navBackgroundColor = COLOR(@"3C3B6D");
    self.navTitleColor = self.navTintColor = [UIColor whiteColor];
    self.listArray = [NSMutableArray arrayWithObjects:@[@"有效期", @"2019-07-23至2099-12-12  "], @[@"券编码", @"Q1000000001"], @[@"规格", @"经典酱香味 500ml"], @[@"描述", @"简单的券描述简单的券描述简单的券描述不能超过25个字"], @[@"持有数量", @"999990 "], @[@"承兑方", @"贵州茅台"], @[@"资产发行方", @"达尔蒙食品公司"], nil];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    [[HTTPManager shareManager] getNodeCooperateListDataSuccess:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            //            self.listArray = [CooperateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"nodeList"]];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
        //        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        //        self.noNetWork.hidden = NO;
    }];
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = COLOR(@"3C3B6D");
    UIImage * image = [UIImage imageNamed:@"voucher_detail_bg"];
    CGFloat imageBgW = DEVICE_WIDTH - Margin_30;
    CGFloat imageBgH = imageBgW * (image.size.height / image.size.width);
    UIImageView * imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(Margin_15, ScreenScale(75), imageBgW, imageBgH)];
    imageBg.image = image;
    [self.scrollView addSubview:imageBg];
    [imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Margin_15);
        make.top.mas_equalTo(ScreenScale(75));
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_30);
    }];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT * 2);
    self.tableView = [[UITableView alloc] initWithFrame:imageBg.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [imageBg addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBg);
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SafeAreaBottomH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(100);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = DetailListCellID;
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:cellID];
    cell.title.text = self.listArray[indexPath.row][0];
    cell.infoTitle.text = self.listArray[indexPath.row][1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VoucherDetailViewController * VC = [[VoucherDetailViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGFloat y = scrollView.contentOffset.y;
//    self.navAlpha = y / 80;
//    if (y > 80) {
//        self.navTitleColor = self.navTintColor = [UIColor whiteColor];
//    } else {
//        self.navTitleColor = self.navTintColor = TITLE_COLOR;
//        self.navTitleColor = y < 0 ? [UIColor clearColor] : TITLE_COLOR;
//        self.navTintColor = y < 0 ? [UIColor clearColor] : TITLE_COLOR;
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
