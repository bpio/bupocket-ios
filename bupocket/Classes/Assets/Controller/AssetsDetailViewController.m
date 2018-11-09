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
#import "HMScannerController.h"
//#import "ScanningViewController.h"

@interface AssetsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerBg;
@property (nonatomic, assign) CGFloat headerViewH;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UILabel * assets;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UILabel * header;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWork;

@end

@implementation AssetsDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.listModel.assetCode;
    _headerViewH = ScreenScale(240);
    self.pageindex = 1;
    [self setupView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(loadNewData)];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    } else {
        // Fallback on earlier versions
    }
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = _headerViewH;
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
    [[HTTPManager shareManager] getAssetsDetailDataWithAssetCode:self.listModel.assetCode issuer:self.listModel.issuer address:[AccountTool account].purseAccount pageIndex:pageindex success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == 0) {
            // 请求成功数据处理
//            self.tableView.tableHeaderView = self.headerBg;
            [self.tableView addSubview:self.headerBg];
            [self.tableView insertSubview:self.headerBg atIndex:0];
             self.assets.text = [NSString stringWithFormat:@"%@%@", responseObject[@"data"][@"tokenBalance"], self.listModel.assetCode];
            NSString * amountStr = responseObject[@"data"][@"assetAmount"];
            self.amount.text = [amountStr isEqualToString:@"~"] ? amountStr : [NSString stringWithFormat:@"≈￥%@", amountStr];
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
            [MBProgressHUD showTipMessageInWindow:message];
        }
        [self.tableView.mj_header endRefreshing];
        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [UIView new]) : (self.tableView.tableFooterView = self.noData);
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.noNetWork.hidden = NO;
    }];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(_headerViewH, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

- (UIView *)noData
{
    if (!_noData) {
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(250))];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoTransactionRecord") imageName:@"NoTransactionRecord" superView:self.noData frame:CGRectMake(0, Margin_40, DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (UIView *)headerBg
{
    if (!_headerBg) {
        UIView * headerBg = [[UIView alloc] init];
        headerBg.backgroundColor = [UIColor whiteColor];
        headerBg.frame = CGRectMake(0, -_headerViewH, DEVICE_WIDTH, _headerViewH);
        UIImageView * assetsIcon = [[UIImageView alloc] init];
        [assetsIcon sd_setImageWithURL:[NSURL URLWithString:self.listModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [headerBg addSubview:assetsIcon];
        [assetsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerBg.mas_top).offset(Margin_20);
            make.centerX.equalTo(headerBg);
            make.size.mas_equalTo(CGSizeMake(ScreenScale(50), ScreenScale(50)));
        }];
        
        self.assets = [[UILabel alloc] init];
        self.assets.textColor = TITLE_COLOR;
        self.assets.font = FONT_Bold(24);
        [headerBg addSubview:self.assets];
        [self.assets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(assetsIcon.mas_bottom).offset(Margin_25);
            make.centerX.equalTo(headerBg);
        }];
        self.amount = [[UILabel alloc] init];
        self.amount.font = FONT(15);
        self.amount.textColor = COLOR_9;
        [headerBg addSubview:self.amount];
        [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.assets.mas_bottom).offset(Margin_15);
            make.centerX.equalTo(headerBg);
        }];
        
        CGFloat btnW = (DEVICE_WIDTH - ScreenScale(34)) / 2;
        CustomButton * scanBtn = [[CustomButton alloc] init];
        scanBtn.layoutMode = HorizontalNormal;
        [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        scanBtn.titleLabel.font = TITLE_FONT;
        [scanBtn setTitle:Localized(@"AssetsDetailScan") forState:UIControlStateNormal];
        [scanBtn setImage:[UIImage imageNamed:@"assetsDetail_scan"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
        //    .titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerBg addSubview: scanBtn];
        [scanBtn setViewSize:CGSizeMake(btnW, MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:ScreenScale(3)];
        scanBtn.backgroundColor = NAVITEM_COLOR;
        [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.amount.mas_bottom).offset(Margin_25);
            make.left.equalTo(headerBg.mas_left).offset(Margin_12);
            make.size.mas_equalTo(CGSizeMake(btnW, MAIN_HEIGHT));
        }];
        CustomButton * transferAccounts = [[CustomButton alloc] init];
        transferAccounts.layoutMode = HorizontalNormal;
        [transferAccounts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        transferAccounts.titleLabel.font = TITLE_FONT;
        [transferAccounts setTitle:Localized(@"TransferAccounts") forState:UIControlStateNormal];
        [transferAccounts setImage:[UIImage imageNamed:@"TransferAccounts"] forState:UIControlStateNormal];
        [transferAccounts addTarget:self action:@selector(transferAccountsAction:) forControlEvents:UIControlEventTouchUpInside];
        //    .titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerBg addSubview: transferAccounts];
        [transferAccounts setViewSize:CGSizeMake(btnW, MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:MAIN_FILLET];
        transferAccounts.backgroundColor = MAIN_COLOR;
        [transferAccounts mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerBg.mas_right).offset(-Margin_12);
            make.size.top.equalTo(scanBtn);
        }];
        _headerBg = headerBg;
    }
    return _headerBg;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= -_headerViewH) {
        _headerBg.y = offsetY;
        _headerBg.height = - offsetY;
    }
}
#pragma mark - scanAction
- (void)scanAction:(UIButton *)button
{
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        TransferAccountsViewController * VC = [[TransferAccountsViewController alloc] init];
        VC.listModel = self.listModel;
        VC.address = stringValue;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
}
#pragma mark - transferAccountsAction
- (void)transferAccountsAction:(UIButton *)button
{
    TransferAccountsViewController * VC = [[TransferAccountsViewController alloc] init];
    VC.listModel = self.listModel;
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
    if (section == 0) {
        return MAIN_HEIGHT;
    } else {
        return CGFLOAT_MIN;
    }
}

 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
     UIView * headerView = [[UIView alloc] init];
     if (section == 0) {
         self.header = [[UILabel alloc] init];
         [headerView addSubview:self.header];
         [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(headerView.mas_left).offset(Margin_10);
             make.bottom.equalTo(headerView);
             make.top.equalTo(headerView.mas_top).offset(ScreenScale(5));
         }];
         self.header.attributedText = [Encapsulation attrTitle:Localized(@"RecentTransactionRecords") ifRequired:NO];
     }
     return headerView;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return SafeAreaBottomH + NavBarH + Margin_10;
    } else {
        return CGFLOAT_MIN;        
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
