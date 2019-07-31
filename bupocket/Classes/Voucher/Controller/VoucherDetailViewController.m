//
//  VoucherDetailViewController.m
//  bupocket
//
//  Created by bupocket on 2019/7/1.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherDetailViewController.h"
#import "VoucherViewCell.h"
#import "DetailListViewCell.h"
#import "ListTableViewCell.h"
#import "UINavigationController+Extension.h"
#import "AcceptorViewController.h"
#import "AssetIssuerViewController.h"
#import "TransactionViewController.h"


@interface VoucherDetailViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, assign) CGFloat infoCellHeight;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIImageView * loadingBg;

@property (nonatomic, assign) CGFloat imageBgH;
@property (nonatomic, assign) CGFloat proportion;

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
    self.proportion = ((DEVICE_WIDTH - Margin_30) / 345);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = Localized(@"VoucherDetail");
    self.navAlpha = 0;
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
            NSString * startTime = ([self.voucherModel.startTime isEqualToString:Voucher_Validity_Date]) ? @"~" : [DateTool getDateStringWithDataStr:self.voucherModel.startTime];
            NSString * endTime = ([self.voucherModel.endTime isEqualToString:Voucher_Validity_Date]) ? @"~" : [DateTool getDateStringWithDataStr:self.voucherModel.endTime];
            NSString * date = ([self.voucherModel.startTime isEqualToString:Voucher_Validity_Date]) ? Localized(@"LongTerm") : [NSString stringWithFormat:Localized(@"%@ to %@"), startTime, endTime];
            NSString * specifications = NotNULLString(self.voucherModel.voucherSpec) ? self.voucherModel.voucherSpec : Localized(@"None");
            self.listArray = [NSMutableArray arrayWithArray:@[@[@""], @[@[Localized(@"Validity"), date], @[Localized(@"VoucherCode"), self.voucherModel.voucherId], @[Localized(@"Specification"), specifications], @[Localized(@"Describe"), self.voucherModel.desc], @[Localized(@"HoldingQuantity"), holdingQuantity]], @[@[Localized(@"Acceptor"), self.voucherModel.voucherAcceptance[@"name"]], @[Localized(@"AssetIssuer"), self.voucherModel.voucherIssuer[@"name"]]]]];
            
            self.infoCellHeight = MAX(Detail_Main_Height, ([Encapsulation getSizeSpaceLabelWithStr:self.voucherModel.desc font:FONT_TITLE width:Info_Width_Max height:CGFLOAT_MAX lineSpacing:LINE_SPACING].height + Margin_20));
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
        self.navTitleColor = self.navTintColor = TITLE_COLOR;
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
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = COLOR(@"3C3B6D");
    UIImage * image = [UIImage imageNamed:@"voucher_detail_bg"];
    CGFloat imageBgW = DEVICE_WIDTH - Margin_30;
    self.imageBgH = imageBgW * (image.size.height / image.size.width);
    UIImageView * imageBg = [[UIImageView alloc] init];
    imageBg.userInteractionEnabled = YES;
    imageBg.image = image;
    imageBg.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageBg];
    [imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Margin_15);
        make.top.mas_equalTo(Margin_15 + NavBarH);
        make.size.mas_equalTo(CGSizeMake(imageBgW, self.imageBgH));
    }];
    self.loadingBg = [[UIImageView alloc] init];
    self.loadingBg.image = [UIImage imageNamed:@"voucher_detail_loading_bg"];
    [imageBg addSubview:self.loadingBg];
    [self.loadingBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageBg);
    }];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, self.imageBgH + ScreenScale(100) + NavBarH + SafeAreaBottomH);
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
//        return ScreenScale(180) - self.infoCellHeight;
        return self.imageBgH - (ScreenScale(145) + self.infoCellHeight + Margin_40 * ([self.listArray[1] count] - 1) * self.proportion + (MAIN_HEIGHT * [self.listArray[2] count])) - Margin_10 * self.proportion;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        UIView * footerView = [[UIView alloc] init];
//        WithFrame:CGRectMake(0, 0, DEVICE_WIDTH - Margin_50, ScreenScale(140) * self.proportion - self.infoCellHeight)
        /*
        CGFloat btnW = (DEVICE_WIDTH - ScreenScale(80)) / 2;
        UIButton * exchange = [UIButton createButtonWithTitle:@"兑换" isEnabled:YES Target:self Selector:@selector(exchangeAction)];
        exchange.backgroundColor = COLOR(@"3485FB");
        [footerView addSubview:exchange];
        [exchange mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(footerView.mas_top).offset(Margin_10);
            make.centerY.equalTo(footerView.mas_centerY).offset(-Margin_20 * self.proportion);
            make.left.equalTo(footerView.mas_left).offset(Margin_15);
            make.width.mas_equalTo(btnW);
//            make.right.equalTo(footerView.mas_right).offset(-Margin_15);
            make.height.mas_equalTo(Margin_40);
        }];
         */
        UIButton * giftGiving = [UIButton createButtonWithTitle:Localized(@"GiftGiving") isEnabled:YES Target:self Selector:@selector(giftGivingAction)];
        [footerView addSubview:giftGiving];
        [giftGiving mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(footerView.mas_top).offset(Margin_10);
            make.left.equalTo(footerView.mas_left).offset(Margin_15);
            make.centerY.equalTo(footerView.mas_centerY).offset(-Margin_20 * self.proportion);
//            make.left.equalTo(exchange.mas_right).offset(Margin_20);
            make.right.equalTo(footerView.mas_right).offset(-Margin_15);
            make.height.mas_equalTo(Margin_40);
        }];
        
        return footerView;
    }
    return nil;
}
/*
- (void)exchangeAction
{
    [Encapsulation showAlertControllerWithTitle:Localized(@"PromptTitle") message:@"兑换功能即将上线" confirmHandler:^(UIAlertAction *action) {
        
    }];
}
 */
- (void)giftGivingAction
{
    TransactionViewController * VC = [[TransactionViewController alloc] init];
    VC.voucherModel = self.voucherModel;
    VC.transferType = TransferTypeVoucher;
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(145);
    } else if (indexPath.section == 1 && indexPath.row == 3) {
       return self.infoCellHeight;
    } else if (indexPath.section == self.listArray.count - 1) {
        return MAIN_HEIGHT;
    }
    return ScreenScale(40) * self.proportion;
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
        cell.title.textColor = COLOR_9;
        cell.title.text = self.listArray[indexPath.section][indexPath.row][0];
//        cell.detailTitle.text = self.listArray[indexPath.section][indexPath.row][1];
        NSString * iconUrl = (indexPath.row == 0) ? self.voucherModel.voucherAcceptance[@"icon"] : self.voucherModel.voucherIssuer[@"icon"];
        [cell.listImage sd_setImageWithURL:[NSURL URLWithString:iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"good_placehoder"]];
        cell.lineView.hidden = (indexPath.row == [self.listArray[indexPath.section] count] - 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = cell.contentView.backgroundColor  = [UIColor clearColor];
        return cell;
    }
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType:DetailCellDefault];
    cell.title.font = FONT_TITLE;
    cell.infoTitle.font = FONT_TITLE;
    cell.title.text = self.listArray[indexPath.section][indexPath.row][0];
    NSString * detail = self.listArray[indexPath.section][indexPath.row][1];
    if (indexPath.section == 1 && indexPath.row == 3 && NotNULLString(detail)) {
        cell.infoTitle.attributedText = [Encapsulation attrWithString:detail preFont:FONT_TITLE preColor:COLOR_6 index:0 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:LINE_SPACING];
    } else {
        cell.infoTitle.text = detail;
    }
    cell.backgroundColor = cell.contentView.backgroundColor  = [UIColor clearColor];
    cell.selectionStyle = (indexPath.section == self.listArray.count - 1) ?  UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
    if ([cell.title.text isEqualToString:Localized(@"Describe")]) {
        UIView * lineView = [[UIView alloc] init];
        lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(60), LINE_WIDTH);
        [lineView drawDashLine];
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Margin_15);
//            make.centerX.equalTo(cell.contentView);
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
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) {
            AssetIssuerViewController * VC = [[AssetIssuerViewController alloc] init];
            VC.voucherModel = self.voucherModel;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    self.navAlpha = y / 80;
    self.navBackgroundColor = COLOR(@"3C3B6D");
//    self.navTitleColor = self.navTintColor = [UIColor whiteColor];
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
