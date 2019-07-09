//
//  VoucherDetailViewController.m
//  bupocket
//
//  Created by huoss on 2019/7/1.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherDetailViewController.h"
#import "VoucherViewCell.h"
#import "DetailListViewCell.h"
#import "ListTableViewCell.h"
#import "UINavigationController+Extension.h"
#import "AcceptorViewController.h"
#import "AssetIssuerViewController.h"
#import "DonateVoucherViewController.h"


@interface VoucherDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, assign) CGFloat infoCellHeight;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIImageView * loadingBg;

@end

static NSString * const VoucherDetailCellID = @"VoucherDetailCellID";

@implementation VoucherDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = Localized(@"VoucherDetail");
//    self.navAlpha = 0;
    self.navBackgroundColor = COLOR(@"3C3B6D");
    self.navTitleColor = self.navTintColor = [UIColor whiteColor];
    [self setupView];
    [self getData];
    // Do any additional setup after loading the view.
}

//- (void)setupRefresh
//{
//    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
//}
//- (void)loadNewData
//{
//    [self getData];
//}
- (void)getData
{
    NSString * holdingQuantity = self.voucherModel.balance;
    [[HTTPManager shareManager] getVoucherDetailDataWithVoucherId:self.voucherModel.voucherId trancheId:self.voucherModel.trancheId spuId:self.voucherModel.spuId contractAddress:self.voucherModel.contractAddress success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.loadingBg.hidden = YES;
            self.voucherModel = [VoucherModel mj_objectWithKeyValues:responseObject[@"data"]];
            //            self.listArray = [CooperateModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"nodeList"]];
            NSString * startTime = ([self.voucherModel.startTime isEqualToString:@"-1"]) ? @"~" : [DateTool getDateStringWithDataStr:self.voucherModel.startTime];
            NSString * endTime = ([self.voucherModel.endTime isEqualToString:@"-1"]) ? @"~" : [DateTool getDateStringWithDataStr:self.voucherModel.endTime];
            self.listArray = [NSMutableArray arrayWithArray:@[@[@""], @[@[Localized(@"Validity"), [NSString stringWithFormat:Localized(@"%@ to %@"), startTime, endTime]], @[Localized(@"VoucherCode"), self.voucherModel.voucherId], @[Localized(@"Specification"), self.voucherModel.voucherSpec], @[Localized(@"Describe"), self.voucherModel.desc], @[Localized(@"HoldingQuantity"), holdingQuantity]], @[@[Localized(@"Acceptor"), self.voucherModel.voucherAcceptance[@"name"]], @[Localized(@"AssetIssuer"), self.voucherModel.voucherIssuer[@"name"]]]]];
            self.infoCellHeight = ([Encapsulation rectWithText:self.voucherModel.desc font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30);
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
        self.noNetWork.hidden = YES;
        self.navBackgroundColor = COLOR(@"3C3B6D");
        self.navTitleColor = self.navTintColor = [UIColor whiteColor];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = NO;
        self.navBackgroundColor = [UIColor whiteColor];
        self.navTitleColor = self.navTintColor = [UIColor blackColor];
    }];
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self getData];
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
    imageBg.userInteractionEnabled = YES;
    imageBg.image = image;
    [self.scrollView addSubview:imageBg];
    [imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Margin_15);
        make.top.mas_equalTo(ScreenScale(75));
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_30);
    }];
    self.loadingBg = [[UIImageView alloc] init];
    self.loadingBg.image = [UIImage imageNamed:@"voucher_detail_loading_bg"];
    [imageBg addSubview:self.loadingBg];
    [self.loadingBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBg);
    }];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, imageBgH + ScreenScale(120) + NavBarH + SafeAreaBottomH);
    self.tableView = [[UITableView alloc] initWithFrame:imageBg.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [imageBg addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBg);
    }];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
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
    if (section == self.listArray.count - 1) {
        return ScreenScale(180) - self.infoCellHeight;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - Margin_50, ScreenScale(120) - self.infoCellHeight)];
        UIButton * giftGiving = [UIButton createButtonWithTitle:Localized(@"GiftGiving") isEnabled:YES Target:self Selector:@selector(giftGivingAction)];
        [footerView addSubview:giftGiving];
        [giftGiving mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView.mas_top).offset(Margin_10);
            make.left.equalTo(footerView.mas_left).offset(Margin_15);
            make.right.equalTo(footerView.mas_right).offset(-Margin_15);
            make.height.mas_equalTo(MAIN_HEIGHT);
        }];
        return footerView;
    }
    return nil;
}
- (void)giftGivingAction
{
    DonateVoucherViewController * VC = [[DonateVoucherViewController alloc] init];
    VC.voucherModel = self.voucherModel;
    [self.navigationController pushViewController:VC animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(143);
    } else if (indexPath.section == 1 && indexPath.row == 3) {
       return self.infoCellHeight;
    } else if (indexPath.section == self.listArray.count - 1) {
        return MAIN_HEIGHT;
    }
    return ScreenScale(40);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        VoucherViewCell * cell = [VoucherViewCell cellWithTableView:tableView identifier:VoucherDetailCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.listBg.image = nil;
        cell.voucherModel = self.voucherModel;
        cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    } else if (indexPath.section == self.listArray.count - 1) {
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeVoucher];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = self.listArray[indexPath.section][indexPath.row][0];
//        cell.detailTitle.text = self.listArray[indexPath.section][indexPath.row][1];
        NSString * iconUrl = (indexPath.row == 0) ? self.voucherModel.voucherAcceptance[@"icon"] : self.voucherModel.voucherIssuer[@"icon"];
        [cell.listImage sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"good_placehoder"]];
//        cell.detail
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = cell.contentView.backgroundColor  = [UIColor clearColor];
        return cell;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:DetailCellDefault];
    cell.title.text = self.listArray[indexPath.section][indexPath.row][0];
    cell.infoTitle.text = self.listArray[indexPath.section][indexPath.row][1];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = (indexPath.section == self.listArray.count - 1) ?  UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    if ([cell.title.text isEqualToString:Localized(@"Describe")]) {
        UIView * lineView = [[UIView alloc] init];
        lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(60), LINE_WIDTH);
        [lineView drawDashLine];
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Margin_5);
            make.bottom.equalTo(cell.contentView);
        }];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == self.listArray.count - 1) {
        if (indexPath.row == 0) {
            AcceptorViewController * VC = [[AcceptorViewController alloc] init];
            VC.voucherModel = self.voucherModel;
            [self.navigationController pushViewController:VC animated:NO];
        } else if (indexPath.row == 1) {
            AssetIssuerViewController * VC = [[AssetIssuerViewController alloc] init];
            VC.voucherModel = self.voucherModel;
            [self.navigationController pushViewController:VC animated:NO];
        }
    }
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
