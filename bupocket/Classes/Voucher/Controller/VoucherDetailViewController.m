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


@interface VoucherDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, assign) CGFloat infoCellHeight;

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = Localized(@"VoucherDetail");
//    self.navAlpha = 0;
    self.navBackgroundColor = COLOR(@"3C3B6D");
    self.navTitleColor = self.navTintColor = [UIColor whiteColor];
    self.listArray = [NSMutableArray arrayWithArray:@[@[@""], @[@[Localized(@"Validity"), [NSString stringWithFormat:Localized(@"%@ to %@"), @"2019-07-13", @"2019-09-20"]], @[Localized(@"VoucherCode"), @"Q1000000001"], @[Localized(@"Specification"), @"经典酱香味 500ml"], @[Localized(@"Describe"), @"简单的券描述简单的券描述简单的券描述不能超过25个字"], @[Localized(@"HoldingQuantity"), @"999990 "]], @[@[Localized(@"Acceptor"), @"贵州茅台"], @[Localized(@"AssetIssuer"), @"达尔蒙食品公司"]]]];
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
    imageBg.userInteractionEnabled = YES;
    imageBg.image = image;
    [self.scrollView addSubview:imageBg];
    [imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Margin_15);
        make.top.mas_equalTo(ScreenScale(75));
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_30);
    }];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, imageBgH + ScreenScale(90));
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
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - Margin_50, ScreenScale(155) - self.infoCellHeight)];
        UIButton * giftGiving = [UIButton createButtonWithTitle:@"转赠" isEnabled:YES Target:self Selector:@selector(giftGivingAction)];
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
        self.infoCellHeight = ([Encapsulation rectWithText:@"简单的券描述简单的券描述简单的券描述不能超过25个字" font:FONT(15) textWidth:Info_Width_Max].size.height + Margin_30);
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
        cell.backgroundColor = cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    } else if (indexPath.section == self.listArray.count - 1) {
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeVoucher];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = self.listArray[indexPath.section][indexPath.row][0];
        cell.detailTitle.text = self.listArray[indexPath.section][indexPath.row][1];
        NSString * walletIconName = Current_Wallet_IconName;
        cell.listImage.image = [UIImage imageNamed:walletIconName];
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
    if ([cell.title.text isEqualToString:@"描述"]) {
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
