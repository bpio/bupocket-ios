//
//  VoucherViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherViewController.h"
#import "UITabBar+Extension.h"
#import "ReceiveViewController.h"
#import "WalletListViewController.h"
#import "VoucherViewCell.h"
#import "VoucherDetailViewController.h"

@interface VoucherViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;

@end

static NSString * const VoucherCellID = @"VoucherCellID";

@implementation VoucherViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:If_Hidden_New];
    if (![defaults objectForKey:If_Hidden_New]) {
        [Encapsulation showAlertControllerWithTitle:Localized(@"VoucherPromptTitle") message:Localized(@"VoucherPromptInfo") confirmHandler:^(UIAlertAction *action) {
            [defaults setBool:YES forKey:If_Hidden_New];
            [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
        }];
    }
    [self setupNav];
    self.listArray = [NSMutableArray arrayWithArray:@[@"", @"", @""]];
    [self setupView];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = CurrentWalletName ? CurrentWalletName : Current_WalletName;
}

- (void)setupNav
{
    UIButton * wallet = [UIButton createButtonWithNormalImage:@"nav_wallet" SelectedImage:@"nav_wallet" Target:self Selector:@selector(walletAction)];
    wallet.frame = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    wallet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:wallet];
    
    UIButton * QRCode = [UIButton createButtonWithNormalImage:@"nav_QR_code" SelectedImage:@"nav_QR_code" Target:self Selector:@selector(QRCodeAction)];
    QRCode.frame = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    QRCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:QRCode];
}
- (void)walletAction
{
    WalletListViewController * VC = [[WalletListViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
}
- (void)QRCodeAction
{
    ReceiveViewController * VC = [[ReceiveViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
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
        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
//        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
//        self.noNetWork.hidden = NO;
    }];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH - TabBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//    self.tableView.tableFooterView = self.noData;
    
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH - TabBarH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        _noData.backgroundColor = [UIColor whiteColor];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"VoucherNoData") imageName:@"no_data_voucher" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(220) - MAIN_HEIGHT - Margin_15) / 2 - Margin_50, DEVICE_WIDTH, ScreenScale(220))];
        [_noData addSubview:noDataBtn];
        CGRect shareRect = CGRectMake(ScreenScale(80), CGRectGetMaxY(noDataBtn.frame) + Margin_15, DEVICE_WIDTH - ScreenScale(160), MAIN_HEIGHT);
        UIButton * shareBtn = [UIButton createButtonWithTitle:Localized(@"ShareQRCode") TextFont:FONT_16 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(QRCodeAction)];
        [shareBtn setViewSize:shareRect.size borderWidth:LINE_WIDTH borderColor:MAIN_COLOR borderRadius:MAIN_CORNER];
        shareBtn.frame = shareRect;
        [_noData addSubview:shareBtn];
    }
    return _noData;
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
    if (section == 0) {
        return ScreenScale(7.5);
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
    return (DEVICE_WIDTH - Margin_20) / 704 * 325;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherViewCell * cell = [VoucherViewCell cellWithTableView:tableView identifier:VoucherCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VoucherDetailViewController * VC = [[VoucherDetailViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
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