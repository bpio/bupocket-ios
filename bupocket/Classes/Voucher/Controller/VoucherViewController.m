//
//  VoucherViewController.m
//  bupocket
//
//  Created by bupocket on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherViewController.h"
#import "UITabBar+Extension.h"
#import "ReceiveViewController.h"
#import "WalletListViewController.h"
#import "VoucherViewCell.h"
#import "VoucherDetailViewController.h"
#import "TipsAlertView.h"

@interface VoucherViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) NSString * headerTitle;
@property (nonatomic, assign) CGFloat headerTitleH;
@property (nonatomic, strong) UIButton * titleBtn;

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
        TipsAlertView * alertView = [[TipsAlertView alloc] initWithTipsType:TipsTypeDefault title:Localized(@"VoucherPromptTitle") message:Localized(@"VoucherPrompt") confrimBolck:^{
            [defaults setBool:YES forKey:If_Hidden_New];
            [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
        }];
        [alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
//        [Encapsulation showAlertControllerWithTitle:Localized(@"VoucherPromptTitle") message:Localized(@"VoucherPromptInfo") confirmHandler:^(UIAlertAction *action) {
//            [defaults setBool:YES forKey:If_Hidden_New];
//            [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
//        }];
    }
    if (!_isChoiceVouchers) {
        [self setupNav];
    } else {
        self.headerTitle = [NSString stringWithFormat:Localized(@"%@ Vouchers available under"), CurrentWalletName];
        self.headerTitleH = Margin_10 + [Encapsulation getSizeSpaceLabelWithStr:self.headerTitle font:FONT_13 width:View_Width_Main height:CGFLOAT_MAX lineSpacing:LINE_SPACING].height;
    }
    [self setupView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isChoiceVouchers) {
        self.navigationItem.title = Localized(@"ChoiceVouchersTitle");
    } else {
        self.navigationItem.title = CurrentWalletName ? CurrentWalletName : Current_WalletName;
        [self reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = -(SafeAreaBottomH + TabBarH);
}
- (void)loadNewData
{
    [self getDataWithPageindex: PageIndex_Default];
}
- (void)loadMoreData
{
    [self getDataWithPageindex:self.pageindex];
}
- (void)getDataWithPageindex:(NSInteger)pageindex
{
    [[HTTPManager shareManager] getVoucherListDataWithPageIndex:pageindex success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * listArray = [VoucherModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"voucherList"]];
            if (pageindex == PageIndex_Default) {
                [self.listArray removeAllObjects];
                self.pageindex = PageIndex_Default;
            }
            self.pageindex = self.pageindex + 1;
            [self.listArray addObjectsFromArray:listArray];
            if (listArray.count < PageSize_Max) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.noNetWork.hidden = NO;
    }];
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
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)QRCodeAction
{
    ReceiveViewController * VC = [[ReceiveViewController alloc] init];
    VC.receiveType = ReceiveTypeVoucher;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)setupView
{
    CGFloat tableViewH = _isChoiceVouchers ? DEVICE_HEIGHT - NavBarH : DEVICE_HEIGHT - NavBarH - TabBarH;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, tableViewH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
//    self.tableView.tableFooterView = self.noData;
    
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = self.tableView.height;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, self.tableView.height - self.headerTitleH)];
        _noData.backgroundColor = [UIColor whiteColor];
//        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"VoucherNoData") imageName:@"no_data_voucher" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(220)) / 2, DEVICE_WIDTH, ScreenScale(220))];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"VoucherNoData") imageName:@"no_data_voucher" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(220) - MAIN_HEIGHT - Margin_15) / 2 - Margin_50, DEVICE_WIDTH, ScreenScale(220))];
        [_noData addSubview:noDataBtn];
        CGRect shareRect = CGRectMake(ScreenScale(80), CGRectGetMaxY(noDataBtn.frame) + Margin_15, DEVICE_WIDTH - ScreenScale(140), MAIN_HEIGHT);
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
    if (section == 0 && _isChoiceVouchers) {
//        if (_isChoiceVouchers) {
        return self.headerTitleH;
//            return Margin_20 + self.titleBtn.height;
//        } else {
//            return ScreenScale(7.5);
//        }
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _isChoiceVouchers) {
        self.titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleBtn.titleLabel.numberOfLines = 0;
        NSInteger index = [CurrentWalletName length];
        UIColor * preColor = MAIN_COLOR;
        UIColor * sufColor = COLOR(@"2A2A2A");
        if ([CurrentAppLanguage isEqualToString:EN]) {
            index = self.headerTitle.length - [CurrentWalletName length];
            preColor = COLOR(@"2A2A2A");
            sufColor = MAIN_COLOR;
        }
        [self.titleBtn setAttributedTitle:[Encapsulation attrWithString:self.headerTitle preFont:FONT_13 preColor:preColor index:index sufFont:FONT_13 sufColor:sufColor lineSpacing:LINE_SPACING] forState:UIControlStateNormal];
        self.titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.titleBtn.contentEdgeInsets = UIEdgeInsetsMake(Margin_10, Margin_Main, 0, Margin_Main);
//        CGSize maximumSize = CGSizeMake(DEVICE_WIDTH, CGFLOAT_MAX);
//        CGSize expectSize = [self.titleBtn sizeThatFits:maximumSize];
//        self.titleBtn.size = expectSize;
        return self.titleBtn;
    } else {
        return [[UIView alloc] init];
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
//    return (DEVICE_WIDTH - Margin_20) / 704 * 325;
    VoucherModel * voucherModel = self.listArray[indexPath.row];
    return voucherModel.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherViewCell * cell = [VoucherViewCell cellWithTableView:tableView identifier:VoucherCellID];
    VoucherModel * voucherModel = self.listArray[indexPath.row];
    cell.voucherModel = voucherModel;
    cell.checked.hidden = !([self.voucherId isEqualToString: voucherModel.voucherId]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VoucherModel * voucherModel = self.listArray[indexPath.row];
    if (_isChoiceVouchers) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.voucher) {
            self.voucher(voucherModel);
        }
    } else {
        VoucherDetailViewController * VC = [[VoucherDetailViewController alloc] init];
        VC.voucherModel = voucherModel;
        [self.navigationController pushViewController:VC animated:YES];
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
