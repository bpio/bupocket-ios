//
//  AssetsDetailViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AssetsDetailViewController.h"
#import "AssetsDetailListViewCell.h"
#import "TransferAccountsViewController.h"
#import "OrderDetailsViewController.h"
#import "AssetsDetailModel.h"
#import "ScanningViewController.h"

@interface AssetsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UILabel * assets;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UILabel * header;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;

@end

@implementation AssetsDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.listModel.assetCode;
    [self setupView];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}
- (void)loadNewData
{
    [self getDataWithPageindex:1];
}
- (void)loadMoreData
{
    [self getDataWithPageindex:self.pageindex];
}
- (void)getDataWithPageindex:(NSInteger)pageindex
{
    [HTTPManager getAssetsDetailDataWithAssetCode:self.listModel.assetCode issuer:self.listModel.issuer address:@"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje" pageIndex:pageindex success:^(id responseObject) {
        //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == 0) {
            // 请求成功数据处理
             self.assets.text = [NSString stringWithFormat:@"%@%@", responseObject[@"data"][@"tokenBalance"], self.listModel.assetCode];
            NSString * amountStr = responseObject[@"data"][@"assetAmount"];
            self.amount.text = [amountStr isEqualToString:@"~"] ? amountStr : [NSString stringWithFormat:@"≈￥%@", amountStr];;
            NSArray * listArray = [AssetsDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"txRecord"]];
            if (pageindex == 1) {
                // 清除所有旧数据
                [self.listArray removeAllObjects];
                self.pageindex = 1;
            }
            self.pageindex = self.pageindex + 1;
            [self.listArray addObjectsFromArray:listArray];
            if (listArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD wb_showInfo:message];
        }
        [self.tableView.mj_header endRefreshing];
        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [UIView new]) : (self.tableView.tableFooterView = self.noData);
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarH, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
    
//    [noDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(self.noData);
//    }];
//    UIButton * noDataBtn = [Encapsulation showNoTransactionRecordWithSuperView:nil frame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(250))];
//    self.noData.hidden = NO;
}
- (UIView *)noData
{
    if (!_noData) {
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(250))];
        UIButton * noDataBtn = [Encapsulation showNoTransactionRecordWithSuperView:self.noData frame:CGRectMake(0, ScreenScale(40), DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (void)setupHeaderView
{
    UIView * headerBg = [[UIView alloc] init];
//    UIImage * headerImage = [UIImage imageNamed:@"assets_header"];
//    CGFloat headerImageH = ScreenScale(375 * headerImage.size.height / headerImage.size.width);
    headerBg.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(240) + MAIN_HEIGHT);
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerBg addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(headerBg);
        make.height.mas_equalTo(ScreenScale(240));
    }];

    
//    UIImageView * headerImageView = [[UIImageView alloc] initWithImage:headerImage];
//    headerImageView.userInteractionEnabled = YES;
//    [headerBg addSubview:headerImageView];
//    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(headerBg);
//        make.height.mas_equalTo(headerImageH);
//    }];
    
    UIImageView * assetsIcon = [[UIImageView alloc] init];
    [assetsIcon sd_setImageWithURL:[NSURL URLWithString:self.listModel.icon] placeholderImage:[UIImage imageNamed:@"BU"]];
    [headerBg addSubview:assetsIcon];
    [assetsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBg.mas_top).offset(ScreenScale(20));
        make.centerX.equalTo(headerBg);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(50), ScreenScale(50)));
    }];
    
    self.assets = [[UILabel alloc] init];
    self.assets.textColor = TITLE_COLOR;
    self.assets.font = FONT_Bold(24);
    [headerBg addSubview:self.assets];
    [self.assets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(assetsIcon.mas_bottom).offset(ScreenScale(25));
        make.centerX.equalTo(headerBg);
    }];
    self.amount = [[UILabel alloc] init];
    self.amount.font = FONT(15);
    self.amount.textColor = COLOR(@"999999");
    [headerBg addSubview:self.amount];
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.assets.mas_bottom).offset(ScreenScale(15));
        make.centerX.equalTo(headerBg);
    }];
    
    CGFloat btnW = (DEVICE_WIDTH - ScreenScale(34)) / 2;
    CustomButton * scanBtn = [[CustomButton alloc] init];
    scanBtn.layoutMode = HorizontalNormal;
    [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanBtn.titleLabel.font = FONT(14);
    [scanBtn setTitle:Localized(@"AssetsDetailScan") forState:UIControlStateNormal];
    [scanBtn setImage:[UIImage imageNamed:@"assetsDetail_scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    //    .titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerBg addSubview: scanBtn];
    [scanBtn setViewSize:CGSizeMake(btnW, MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:ScreenScale(3)];
    scanBtn.backgroundColor = COLOR(@"5745C3");
    [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView.mas_bottom).offset(-ScreenScale(18));
        make.left.equalTo(headerBg.mas_left).offset(ScreenScale(12));
        make.size.mas_equalTo(CGSizeMake(btnW, MAIN_HEIGHT));
    }];
    CustomButton * transferAccounts = [[CustomButton alloc] init];
    transferAccounts.layoutMode = HorizontalNormal;
    [transferAccounts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    transferAccounts.titleLabel.font = FONT(14);
    [transferAccounts setTitle:Localized(@"TransferAccounts") forState:UIControlStateNormal];
    [transferAccounts setImage:[UIImage imageNamed:@"TransferAccounts"] forState:UIControlStateNormal];
    [transferAccounts addTarget:self action:@selector(transferAccountsAction:) forControlEvents:UIControlEventTouchUpInside];
    //    .titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [headerBg addSubview: transferAccounts];
    [transferAccounts setViewSize:CGSizeMake(btnW, MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:ScreenScale(3)];
    transferAccounts.backgroundColor = MAIN_COLOR;
    [transferAccounts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerBg.mas_right).offset(-ScreenScale(12));
        make.size.bottom.equalTo(scanBtn);
    }];
    
    self.header = [[UILabel alloc] init];
    self.header.font = FONT(15);
    self.header.textColor = TITLE_COLOR;
    [headerBg addSubview:self.header];
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBg.mas_left).offset(ScreenScale(10));
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.equalTo(headerBg);
    }];
    [self setHeaderTitle];
    
    self.tableView.tableHeaderView = headerBg;
}
#pragma mark - scanAction
- (void)scanAction:(UIButton *)button
{
#if TARGET_OS_SIMULATOR
    HSSLog(@"模拟器不支持扫一扫");
#elif TARGET_OS_IPHONE
    ScanningViewController * VC = [[ScanningViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
#endif
}
#pragma mark - transferAccountsAction
- (void)transferAccountsAction:(UIButton *)button
{
    TransferAccountsViewController * VC = [[TransferAccountsViewController alloc] init];
    VC.navigationItem.title = @"BU转账";
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(85);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
//    if (section == 0) {
//        return MAIN_HEIGHT;
//    } else {
//        return ScreenScale(10);
//    }
}
/*
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
     UIView * headerView = [[UIView alloc] init];
     if (section == 0) {
         //        CustomButton * header = [[CustomButton alloc] init];
         //        header.layoutMode = HorizontalNormal;
         //        [header setImage:[UIImage imageNamed:@"ifReaded_n"] forState:UIControlStateNormal];
         //        [header setTitle:@"我的资产" forState:UIControlStateNormal];
         //        [header setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
         //        header.titleLabel.font = FONT(15);
         self.header = [[UILabel alloc] init];
         self.header.font = FONT(15);
         self.header.textColor = TITLE_COLOR;
         [headerView addSubview:self.header];
         [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(headerView.mas_left).offset(ScreenScale(10));
             make.centerY.equalTo(headerView);
         }];
         [self setHeaderTitle];
     }
     return headerView;
 }
 */
- (void)setHeaderTitle
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| %@", Localized(@"RecentTransactionRecords")]];
    //        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //        dic[NSFontAttributeName] = FONT(15);
    //        dic[NSForegroundColorAttributeName] = TITLE_COLOR;
    //        [attr addAttributes:dic range:NSMakeRange(3, str.length - 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, 1)];
    [attr addAttribute:NSFontAttributeName value:FONT_Bold(18) range:NSMakeRange(0, 1)];
    self.header.attributedText = attr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetsDetailListViewCell * cell = [AssetsDetailListViewCell cellWithTableView:tableView];
    cell.assetCode = self.listModel.assetCode;
    cell.listModel = self.listArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderDetailsViewController * VC = [[OrderDetailsViewController alloc] init];
    VC.assetCode = self.listModel.assetCode;
    VC.listModel = self.listArray[indexPath.section];
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
