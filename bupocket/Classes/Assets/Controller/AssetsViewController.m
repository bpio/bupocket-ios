//
//  AssetsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetsListViewCell.h"
#import "MyIdentityViewController.h"
#import "PurseAddressAlertView.h"
#import "AssetsDetailViewController.h"
#import "AssetsListModel.h"
#import "AddAssetsViewController.h"
#import "HMScannerController.h"
#import "RegisteredAssetsViewController.h"
#import "DistributionOfAssetsViewController.h"
#import "TransferAccountsViewController.h"

#import "RegisteredModel.h"
#import "DistributionModel.h"


@interface AssetsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerBg;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UILabel * totalAssets;
@property (nonatomic, strong) UILabel * header;
@property (nonatomic, strong) UILabel * purseName;
@property (nonatomic, strong) UIButton * backup;

@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UIView * noNetWork;

@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, strong) DistributionModel * distributionModel;
@property (nonatomic, strong) NSDictionary * scanDic;

//@property (nonatomic, strong) NSDictionary * assetsDic;

@end

@implementation AssetsViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.listArray = @[@"BU", @"BU1", @"BU2"];
    [self setupRefresh];
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(setupRefresh)];
    // Do any additional setup after loading the view.
}
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //    self.userTableView.mj_footer.hidden = YES;
}
- (void)loadNewData
{
    [self loadData];
}
- (void)loadData
{
    [HTTPManager getAssetsDataWithAddress:[[AccountTool account] purseAccount] currencyType:@"CNY" tokenList:[NSArray array] success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == 0) {
            self.tableView.tableHeaderView = self.headerBg;
            // 请求成功数据处理
            self.listArray = [AssetsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
            //            if (pageindex == 1) {
            //                // 清除所有旧数据
            //                [self.informationArray removeAllObjects];
            //                self.pageindex = 1;
            //            }
            NSString * amountStr = responseObject[@"data"][@"totalAmount"];
            self.amount.text = [amountStr isEqualToString:@"~"] ? amountStr : [NSString stringWithFormat:@"≈%@", amountStr];
            //            self.pageindex = self.pageindex + 1;
            [self.tableView reloadData];
            //            if (listArray.count < 10) {
            //                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            //            } else {
            //                [self.tableView.mj_footer endRefreshing];
            //            }
        } else {
            [MBProgressHUD showErrorMessage:message];
        }
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = NO;
    }];
//    [[NetworkingManager sharedManager] getDataWithSuccessHandler:^(NSString * _Nonnull msg, id  _Nonnull data) {
////        for (NSDictionary *dic in (NSArray *)data) {
////            BYExchangePairModel *itemModel = [[BYExchangePairModel alloc] initWithDictionary:dic error:nil];
////            [self.selectedArray addObject:itemModel];
////        }
////        [BYMarketSelectedManager shareInstance].marketSelectedArray = self.selectedArray;
//    } failureHandler:^(NSError * _Nonnull failure) {
//
//    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - TabBarH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIView *)headerBg
{
    if (!_headerBg) {
        UIView * headerBg = [[UIView alloc] init];
        UIImage * headerImage = [UIImage imageNamed:@"assets_header"];
        CGFloat headerImageH = ScreenScale(375 * headerImage.size.height / headerImage.size.width);
        headerBg.frame = CGRectMake(0, 0, DEVICE_WIDTH, headerImageH + MAIN_HEIGHT);
        
        UIImageView * headerImageView = [[UIImageView alloc] initWithImage:headerImage];
        headerImageView.userInteractionEnabled = YES;
        [headerBg addSubview:headerImageView];
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(headerBg);
            make.height.mas_equalTo(headerImageH);
        }];
        
        // 扫描登记、发行资产
        UIButton * issueBtn = [UIButton createButtonWithNormalImage:@"nav_scan" SelectedImage:@"nav_scan" Target:self Selector:@selector(issueAction)];
        issueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [headerBg addSubview:issueBtn];
        [issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerBg.mas_top).offset(StatusBarHeight);
            make.size.mas_equalTo(CGSizeMake(ScreenScale(44), Margin_30));
            make.right.equalTo(headerBg.mas_right).offset(- Margin_15);
        }];
        UIImageView * userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userIcon_placeholder"]];
        [userIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconAction)]];
        userIcon.userInteractionEnabled = YES;
        [headerBg addSubview:userIcon];
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerBg.mas_top).offset(MAIN_HEIGHT + StatusBarHeight);
            make.centerX.equalTo(headerBg);
        }];
        
        UIView * userBg = [[UIView alloc] init];
        [headerBg addSubview:userBg];
        [userBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userIcon.mas_bottom).offset(Margin_10);
            make.height.mas_equalTo(Margin_20);
            make.centerX.equalTo(headerBg);
        }];
        _purseName = [[UILabel alloc] init];
        _purseName.textColor = [UIColor whiteColor];
        _purseName.font = FONT(16);
        _purseName.text = [AccountTool account].identityName;
        [userBg addSubview:self.purseName];
        [_purseName mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(userIcon.mas_bottom).offset(ScreenScale(15));
            make.left.centerY.equalTo(userBg);
        }];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:ifBackup]) {
            _backup = [UIButton createButtonWithTitle:Localized(@"PleaseBackup") TextFont:14 TextColor:COLOR(@"FFB134") Target:self Selector:@selector(backupAction:)];
            _backup.layer.cornerRadius = Margin_10;
            _backup.layer.borderColor = COLOR(@"FFB134").CGColor;
            _backup.layer.borderWidth = LINE_WIDTH;
            _backup.contentEdgeInsets = UIEdgeInsetsMake(0, ScreenScale(8), 0, ScreenScale(8));
            [userBg addSubview:self.backup];
            if (_purseName.text.length > 0) {
                [_backup mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.purseName.mas_right).offset(ScreenScale(5));
                }];
            } else {
                [_backup mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(userBg);
                }];
            }
            [_backup mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.right.equalTo(userBg);
            }];
        } else {
            [_purseName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(userBg);
            }];
        }
        CustomButton * QRCode = [[CustomButton alloc] init];
        QRCode.layoutMode = HorizontalInverted;
        [QRCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        QRCode.titleLabel.font = FONT(13);
        [QRCode setTitle:[NSString stringEllipsisWithStr:[AccountTool account].purseAccount] forState:UIControlStateNormal];
        [QRCode setImage:[UIImage imageNamed:@"QRCode"] forState:UIControlStateNormal];
        [QRCode addTarget:self action:@selector(QRCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        //    .titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [headerBg addSubview: QRCode];
        [QRCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userBg.mas_bottom).offset(ScreenScale(14));
            make.centerX.equalTo(headerBg);
//            make.width.mas_equalTo(DEVICE_WIDTH - ScreenScale(200));
        }];
        self.amount = [[UILabel alloc] init];
        self.amount.font = FONT(32);
        self.amount.textColor = [UIColor whiteColor];
        [headerBg addSubview:self.amount];
        [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(QRCode.mas_bottom).offset(Margin_20);
            make.left.equalTo(headerBg.mas_left).offset(ScreenScale(15));
        }];
        
        self.totalAssets = [[UILabel alloc] init];
        self.totalAssets.font = FONT(15);
        self.totalAssets.textColor = [UIColor whiteColor];
        [headerBg addSubview:self.totalAssets];
        [self.totalAssets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerImageView.mas_bottom).offset(-Margin_20);
            make.left.equalTo(self.amount);
        }];
        self.totalAssets.text = Localized(@"TotalAssets");
        
        self.header = [[UILabel alloc] init];
        self.header.font = FONT(15);
        self.header.textColor = TITLE_COLOR;
        [headerBg addSubview:self.header];
        [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerBg.mas_left).offset(Margin_10);
            make.top.equalTo(headerImageView.mas_bottom);
            make.bottom.equalTo(headerBg.mas_bottom).offset(ScreenScale(5));
        }];
        [self setHeaderTitle];
        
        UIButton * addAssets = [UIButton createButtonWithNormalImage:@"addAssets" SelectedImage:@"addAssets" Target:self Selector:@selector(addAssetsAcrion)];
        [headerBg addSubview:addAssets];
        [addAssets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerBg.mas_right).offset(ScreenScale(-10));
            make.centerY.equalTo(headerImageView.mas_bottom);
        }];
        _headerBg = headerBg;
    }
    return _headerBg;
}
- (void)issueAction
{
//    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        // 判断是否是钱包地址
        if ([Keypair isAddressValid: stringValue]) {
            TransferAccountsViewController * VC = [[TransferAccountsViewController alloc] init];
            for (AssetsListModel * listModel in self.listArray) {
                if ([listModel.assetCode isEqualToString:@"BU"]) {
                    VC.listModel = listModel;
                }
            }
            VC.address = stringValue;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            self.scanDic = [JsonTool dictionaryOrArrayWithJSONSString:[NSString dencode:stringValue]];
            if (self.scanDic) {
                self.registeredModel = [RegisteredModel mj_objectWithKeyValues:self.scanDic[@"data"]];
                [self getAssetsStateData];
            } else {
                [MBProgressHUD showWarnMessage:@"扫描结果无效"];
            }
        }
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
}

- (void)getAssetsStateData
{
    [HTTPManager getRegisteredORDistributionDataWithAssetCode:self.registeredModel.code issueAddress:[[AccountTool account] purseAccount] success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        self.distributionModel = [DistributionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
//        NSDictionary * assetsDic = [responseObject objectForKey:@"data"];
        if ([self.scanDic[@"action"] isEqualToString:@"token.register"]) {
            if (code == 0) {
                // 已登记
                [self alertViewWithMessage:Localized(@"RegisteredAsset")];
            } else {
                // 未登记
                RegisteredAssetsViewController * VC = [[RegisteredAssetsViewController alloc] init];
                VC.uuid = self.scanDic[@"uuID"];
                VC.registeredModel = self.registeredModel;
                [self.navigationController pushViewController:VC animated:YES];
            }
        } else if ([self.scanDic[@"action"] isEqualToString:@"token.issue"]) {
            if (code == 0) {
                CGFloat isOverFlow = [self.distributionModel.totalSupply floatValue] - [self.distributionModel.actualSupply floatValue] - self.registeredModel.amount;
                if ([self.distributionModel.totalSupply floatValue] != 0 && isOverFlow < 0) {
                    // 已发行
                    [self alertViewWithMessage:Localized(@"IssuedAssets")];
                } else {
                    // 已登记
                    DistributionOfAssetsViewController * VC = [[DistributionOfAssetsViewController alloc] init];
                    VC.uuid = self.scanDic[@"uuID"];
                    VC.distributionModel = self.distributionModel;
                    VC.registeredModel = self.registeredModel;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            } else {
                // 未登记
                [self alertViewWithMessage:Localized(@"TemporarilyRegisteredAssets")];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)alertViewWithMessage:(NSString *)message
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
//    UIAlertController * alertController = [Encapsulation alertControllerWithCancelTitle:Localized(@"IGotIt") title:nil message:message];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - backup
- (void)backupAction:(UIButton *)button
{
    [self.navigationController pushViewController:[[MyIdentityViewController alloc] init] animated:YES];
//    NavigationViewController * Nav = [[NavigationViewController alloc] initWithRootViewController:[[MyIdentityViewController alloc] init]];
//    [Nav.navigationController setNavigationBarHidden:YES animated:YES];
//    [UIApplication sharedApplication].keyWindow.rootViewController = Nav;
}
#pragma mark - QRCode
- (void)QRCodeAction:(UIButton *)button
{
    NSString * address = [AccountTool account].purseAccount;
    PurseAddressAlertView * alertView = [[PurseAddressAlertView alloc] initWithPurseAddress:address confrimBolck:^{
        [[UIPasteboard generalPasteboard] setString:address];
        [MBProgressHUD showTipMessageInWindow:@"已复制"];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.2 needEffectView:NO];
}
    

#pragma mark - userIcon
- (void)userIconAction
{
    [self.navigationController pushViewController:[[MyIdentityViewController alloc] init] animated:YES];
}
- (void)addAssetsAcrion
{
    AddAssetsViewController * VC = [[AddAssetsViewController alloc] init];
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
//        return Margin_10;
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
            make.left.equalTo(headerView.mas_left).offset(Margin_10);
            make.centerY.equalTo(headerView);
        }];
        [self setHeaderTitle];
    }
    return headerView;
}
 */
- (void)setHeaderTitle
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| %@", Localized(@"MyAssets")]];
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
    AssetsListViewCell * cell = [AssetsListViewCell cellWithTableView:tableView];
    cell.listModel = self.listArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AssetsDetailViewController * VC = [[AssetsDetailViewController alloc] init];
    VC.listModel = self.listArray[indexPath.section];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)changeLanguage
{
    self.totalAssets.text = Localized(@"TotalAssets");
    [self.backup setTitle:Localized(@"PleaseBackup") forState:UIControlStateNormal];
    [self setHeaderTitle];
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
