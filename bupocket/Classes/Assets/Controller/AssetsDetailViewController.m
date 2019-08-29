//
//  AssetsDetailViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AssetsDetailViewController.h"
#import "AssetsDetailListViewCell.h"
#import "TransactionViewController.h"
#import "TransactionDetailsViewController.h"
#import "AssetsDetailModel.h"
#import "ReceiveViewController.h"
#import "DataBase.h"

@interface AssetsDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerViewBg;
@property (nonatomic, assign) CGFloat headerViewH;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIImageView * assetsIconBg;
@property (nonatomic, strong) UIImageView * assetsIcon;
@property (nonatomic, strong) CustomButton * receiveBtn;
@property (nonatomic, strong) CustomButton * transferAccounts;

@property (nonatomic, strong) UILabel * assets;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWorkBg;
@property (nonatomic, strong) UIView * noNetWork;

@property (nonatomic, strong) NSString * assetsStr;
@property (nonatomic, strong) NSString * amountStr;

@end

@implementation AssetsDetailViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.listModel.assetCode;
    [self setupView];
    [self getCacheData];
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
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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
    [[HTTPManager shareManager] getAssetsDetailDataWithTokenType:self.listModel.type currencyType:currentCurrency assetCode:self.listModel.assetCode issuer:self.listModel.issuer address:CurrentWalletAddress pageIndex:pageindex success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSDictionary * assetDic = responseObject[@"data"] [@"assetData"];
            [self setHeaderDataWithAsset:assetDic[@"balance"] amount:assetDic[@"totalAmount"]];
            NSArray * array = responseObject[@"data"] [@"txRecord"];
            NSArray * listArray = [AssetsDetailModel mj_objectArrayWithKeyValuesArray:array];
            if (pageindex == PageIndex_Default) {
                [self.listArray removeAllObjects];
                self.pageindex = PageIndex_Default;
            }
            self.pageindex = self.pageindex + 1;
            [self.listArray addObjectsFromArray:listArray];
            [self.dataArray addObjectsFromArray:array];
            if (listArray.count < PageSize_Max) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [[DataBase shareDataBase] deleteCachedDataWithCacheType:CacheTypeTransactionRecord];
            [[DataBase shareDataBase] saveDataWithArray:self.dataArray cacheType:CacheTypeTransactionRecord];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self reloadUI];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.listArray.count > 0) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        } else {
            self.tableView.tableFooterView = self.noNetWorkBg;
        }
        self.noNetWork.hidden = (self.listArray.count > 0);
    }];
}
- (void)getCacheData
{
    NSArray * listArray = [[DataBase shareDataBase] getCachedDataWithCacheType:CacheTypeTransactionRecord];
    if (listArray.count > 0) {
        self.listArray = [NSMutableArray array];
        [self.listArray addObjectsFromArray:listArray];
        [self reloadUI];
    }
}
- (void)reloadUI
{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
    self.tableView.mj_footer.hidden = (self.listArray.count == 0);
    self.noNetWork.hidden = YES;
}
- (void)setHeaderDataWithAsset:(NSString *)asset amount:(NSString *)amount
{
    self.assetsStr = [NSString stringWithFormat:@"%@ %@", asset, self.listModel.assetCode];
    NSString * currencyUnit = [AssetCurrencyModel getCurrencyUnitWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
    self.amountStr = [amount isEqualToString:@"~"] ? amount : [NSString stringWithFormat:@"≈%@%@", currencyUnit, amount];
    self.assets.text = _assetsStr;
    self.amount.text = self.amountStr;
    CGFloat assetsH = [Encapsulation rectWithText:self.assetsStr font:FONT_Bold(24) textWidth:DEVICE_WIDTH - Margin_40].size.height;
    CGFloat amountH = [Encapsulation rectWithText:self.amountStr font:FONT(15) textWidth:DEVICE_WIDTH - Margin_40].size.height;
    self.headerViewH = ScreenScale(200) + assetsH + amountH;
    self.headerViewBg.frame = CGRectMake(0, 0, DEVICE_WIDTH, self.headerViewH);
    self.tableView.tableHeaderView = self.headerViewBg;
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, ContentSizeBottom, 0);
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
}
- (UIView *)noNetWorkBg
{
    if (!_noNetWorkBg) {
        CGFloat noDataH = DEVICE_HEIGHT - _headerViewH - NavBarH - SafeAreaBottomH;
        _noNetWorkBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        _noNetWork = [Encapsulation showNoNetWorkWithSuperView:_noNetWorkBg target:self action:@selector(reloadData)];
    }
    return _noNetWorkBg;
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - _headerViewH - NavBarH - SafeAreaBottomH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        _noData.backgroundColor = [UIColor whiteColor];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoTransactionRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (void)setupHeaderView
{
    _headerViewBg = [[UIView alloc] init];
    _headerViewBg.backgroundColor = [UIColor whiteColor];
    _assetsIconBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_bg"]];
    [_headerViewBg addSubview:_assetsIconBg];
    
    _assetsIcon = [[UIImageView alloc] init];
    [_assetsIcon sd_setImageWithURL:[NSURL URLWithString:self.listModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [_assetsIcon setViewSize:CGSizeMake(Margin_60, Margin_60) borderWidth:0 borderColor:nil borderRadius:Margin_30];
    [_assetsIconBg addSubview:_assetsIcon];
    
    _assets = [[UILabel alloc] init];
    _assets.textColor = TITLE_COLOR;
    _assets.font = FONT_Bold(24);
    _assets.numberOfLines = 0;
    _assets.textAlignment = NSTextAlignmentCenter;
    [_headerViewBg addSubview:_assets];
    
    _amount = [[UILabel alloc] init];
    _amount.font = FONT(15);
    _amount.textColor = COLOR_9;
    _amount.numberOfLines = 0;
    _amount.textAlignment = NSTextAlignmentCenter;
    [_headerViewBg addSubview:_amount];
    
    _receiveBtn = [[CustomButton alloc] init];
    _receiveBtn.layoutMode = HorizontalNormal;
    [_receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _receiveBtn.titleLabel.font = FONT_TITLE;
    [_receiveBtn setTitle:Localized(@"Receive") forState:UIControlStateNormal];
    [_receiveBtn setImage:[UIImage imageNamed:@"receive_w"] forState:UIControlStateNormal];
    [_receiveBtn addTarget:self action:@selector(receiveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerViewBg addSubview: _receiveBtn];
    _receiveBtn.layer.masksToBounds = YES;
    _receiveBtn.layer.cornerRadius = MAIN_CORNER;
    _receiveBtn.backgroundColor = RECEIVE_COLOR;
    
    _transferAccounts = [[CustomButton alloc] init];
    _transferAccounts.layoutMode = HorizontalNormal;
    [_transferAccounts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _transferAccounts.titleLabel.font = FONT_TITLE;
    [_transferAccounts setTitle:Localized(@"TransferAccounts") forState:UIControlStateNormal];
    [_transferAccounts setImage:[UIImage imageNamed:@"transferAccounts"] forState:UIControlStateNormal];
    [_transferAccounts addTarget:self action:@selector(transferAccountsAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headerViewBg addSubview: _transferAccounts];
    _transferAccounts.layer.masksToBounds = YES;
    _transferAccounts.layer.cornerRadius = MAIN_CORNER;
    _transferAccounts.backgroundColor = MAIN_COLOR;
    [self layoutSubView];
    [self setHeaderDataWithAsset:self.listModel.amount amount:self.listModel.assetAmount];
}
- (void)layoutSubView
{
    [_assetsIconBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerViewBg.mas_top).offset(Margin_10);
        make.centerX.equalTo(self.headerViewBg);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(82), ScreenScale(82)));
    }];
    [_assetsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.assetsIconBg);
        make.size.mas_equalTo(CGSizeMake(Margin_60, Margin_60));
    }];
    [self.assets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.assetsIcon.mas_bottom).offset(Margin_15);
        make.centerX.equalTo(self.headerViewBg);
        make.width.mas_lessThanOrEqualTo(View_Width_Main);
    }];
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.assets.mas_bottom).offset(Margin_15);
        make.centerX.equalTo(self.headerViewBg);
        make.width.mas_lessThanOrEqualTo(View_Width_Main);
    }];
    CGFloat btnW = (View_Width_Main - Margin_10) / 2;
    [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amount.mas_bottom).offset(Margin_20);
        make.left.equalTo(self.headerViewBg.mas_left).offset(Margin_Main);
        make.size.mas_equalTo(CGSizeMake(btnW, MAIN_HEIGHT));
    }];
    [_transferAccounts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerViewBg.mas_right).offset(-Margin_Main);
        make.size.top.equalTo(self->_receiveBtn);
    }];
}
#pragma mark - receiveAction
- (void)receiveAction:(UIButton *)button
{
    ReceiveViewController * VC = [[ReceiveViewController alloc] init];
    VC.receiveType = ReceiveTypeDefault;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)showAlert
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Encapsulation showAlertControllerWithMessage:Localized(@"NotSupportedOperation") handler:nil];
    });
}
#pragma mark - transferAccountsAction
- (void)transferAccountsAction:(UIButton *)button
{
    TransactionViewController * VC = [[TransactionViewController alloc] init];
    VC.transferType = TransferTypeAssets;
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
        return Margin_Section_Header - Margin_5;
    } else {
        return CGFLOAT_MIN;
    }
}

 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
     UIView * headerView = [[UIView alloc] init];
     if (section == 0) {
         UIButton * header = [UIButton createHeaderButtonWithTitle:Localized(@"RecentTransactionRecords")];
         header.contentEdgeInsets = UIEdgeInsetsMake(Margin_5, Margin_Main, 0, Margin_Main);
         return header;
     }
     return headerView;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TransactionDetailsViewController * VC = [[TransactionDetailsViewController alloc] init];
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
