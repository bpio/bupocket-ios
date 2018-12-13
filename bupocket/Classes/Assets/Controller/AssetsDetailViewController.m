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

@interface AssetsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerBg;
@property (nonatomic, strong) UIView * headerViewBg;
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
    [self setupView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    [self setupRefresh];
    // Do any additional setup after loading the view.
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
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = _headerViewH;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = -(ContentSizeBottom);
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
    NSString * currentCurrency = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
    [[HTTPManager shareManager] getAssetsDetailDataWithTokenType:self.listModel.type currencyType:currentCurrency assetCode:self.listModel.assetCode issuer:self.listModel.issuer address:[AccountTool account].purseAccount pageIndex:pageindex success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            [self.tableView addSubview:self.headerBg];
            [self.tableView insertSubview:self.headerBg atIndex:0];
            NSDecimalNumber * balanceNumber = [NSDecimalNumber decimalNumberWithString:responseObject[@"data"][@"assetData"][@"balance"]];
            self.assets.text = [NSString stringWithFormat:@"%@ %@", balanceNumber, self.listModel.assetCode];
            NSString * amountStr = responseObject[@"data"][@"assetData"][@"totalAmount"];
            NSString * currencyUnit = [AssetCurrencyModel getCurrencyUnitWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
            self.amount.text = [amountStr isEqualToString:@"~"] ? amountStr : [NSString stringWithFormat:@"≈%@%@", currencyUnit, amountStr];
            NSArray * listArray = [AssetsDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"txRecord"]];
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
        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [UIView new]) : (self.tableView.tableFooterView = self.noData);
        self.noNetWork.hidden = YES;
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
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
        CGFloat noDataH = DEVICE_HEIGHT - _headerViewH - NavBarH - SafeAreaBottomH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoTransactionRecord") imageName:@"noTransactionRecord" superView:self.noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
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
        _headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH)];
        [headerBg addSubview:_headerViewBg];
        UIImageView * assetsIconBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_bg"]];
        [_headerViewBg addSubview:assetsIconBg];
        [assetsIconBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerViewBg.mas_top).offset(Margin_10);
            make.centerX.equalTo(self.headerViewBg);
            make.size.mas_equalTo(CGSizeMake(ScreenScale(82), ScreenScale(82)));
        }];
        
        UIImageView * assetsIcon = [[UIImageView alloc] init];
        [assetsIcon sd_setImageWithURL:[NSURL URLWithString:self.listModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [assetsIcon setViewSize:CGSizeMake(Margin_60, Margin_60) borderWidth:0 borderColor:nil borderRadius:Margin_30];
        [assetsIconBg addSubview:assetsIcon];
        [assetsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(assetsIconBg);
            make.size.mas_equalTo(CGSizeMake(Margin_60, Margin_60));
        }];
        self.assets = [[UILabel alloc] init];
        self.assets.textColor = TITLE_COLOR;
        self.assets.font = FONT_Bold(24);
        [self.headerViewBg addSubview:self.assets];
        [self.assets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(assetsIcon.mas_bottom).offset(Margin_15);
            make.centerX.equalTo(self.headerViewBg);
            make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
        }];
        self.amount = [[UILabel alloc] init];
        self.amount.font = FONT(15);
        self.amount.textColor = COLOR_9;
        [self.headerViewBg addSubview:self.amount];
        [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.assets.mas_bottom).offset(Margin_15);
            make.centerX.equalTo(self.headerViewBg);
            make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
        }];
        
        CGFloat btnW = (DEVICE_WIDTH - Margin_30) / 2;
        CustomButton * scanBtn = [[CustomButton alloc] init];
        scanBtn.layoutMode = HorizontalNormal;
        [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        scanBtn.titleLabel.font = TITLE_FONT;
        [scanBtn setTitle:Localized(@"AssetsDetailScan") forState:UIControlStateNormal];
        [scanBtn setImage:[UIImage imageNamed:@"assetsDetail_scan"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerViewBg addSubview: scanBtn];
        [scanBtn setViewSize:CGSizeMake(btnW, MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:ScreenScale(3)];
        scanBtn.backgroundColor = NAVITEM_COLOR;
        [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.amount.mas_bottom).offset(Margin_20);
            make.left.equalTo(self.headerViewBg.mas_left).offset(Margin_10);
            make.size.mas_equalTo(CGSizeMake(btnW, MAIN_HEIGHT));
        }];
        CustomButton * transferAccounts = [[CustomButton alloc] init];
        transferAccounts.layoutMode = HorizontalNormal;
        [transferAccounts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        transferAccounts.titleLabel.font = TITLE_FONT;
        [transferAccounts setTitle:Localized(@"TransferAccounts") forState:UIControlStateNormal];
        [transferAccounts setImage:[UIImage imageNamed:@"transferAccounts"] forState:UIControlStateNormal];
        [transferAccounts addTarget:self action:@selector(transferAccountsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerViewBg addSubview: transferAccounts];
        [transferAccounts setViewSize:CGSizeMake(btnW, MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:MAIN_CORNER];
        transferAccounts.backgroundColor = MAIN_COLOR;
        [transferAccounts mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerViewBg.mas_right).offset(-Margin_10);
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
    } else {
        _headerBg.y = -_headerViewH;
        _headerBg.height = _headerViewH;
    }
    _headerViewBg.y = _headerBg.height - _headerViewH;
}
#pragma mark - scanAction
- (void)scanAction:(UIButton *)button
{
    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            BOOL isCorrectAddress = [Keypair isAddressValid: stringValue];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (isCorrectAddress) {
                    TransferAccountsViewController * VC = [[TransferAccountsViewController alloc] init];
                    VC.listModel = weakself.listModel;
                    VC.address = stringValue;
                    [weakself.navigationController pushViewController:VC animated:YES];
                } else {
                    [MBProgressHUD showTipMessageInWindow:Localized(@"ScanFailure")];
                }
            }];
        }];
        
        
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
         self.header.font = FONT(15);
         self.header.textColor = COLOR_6;
         self.header.text = Localized(@"RecentTransactionRecords");
         [headerView addSubview:self.header];
         [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(headerView.mas_left).offset(Margin_10);
             make.bottom.equalTo(headerView);
             make.top.equalTo(headerView.mas_top).offset(Margin_5);
         }];
     }
     return headerView;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return ContentSizeBottom;
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
