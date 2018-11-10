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

#import "UINavigationController+Extension.h"


@interface AssetsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerBg;
@property (nonatomic, strong) UIView * headerViewBg;
@property (nonatomic, strong) UIImageView * headerImageView;

@property (nonatomic, strong) UIButton * addAssets;
@property (nonatomic, assign) CGFloat headerViewH;
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

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

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
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
} 
- (void)viewDidLoad {
    [super viewDidLoad];
    _statusBarStyle = UIStatusBarStyleLightContent;
    UIImage * headerImage = [UIImage imageNamed:@"assets_header"];
    _headerViewH = ScreenScale(375 * headerImage.size.height / headerImage.size.width) + MAIN_HEIGHT;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
   [self setupRefresh];
//    self.tableView.tableHeaderView = self.headerBg;
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
//    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupRefresh
{
//    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    header.lastUpdatedTimeLabel.hidden = YES;
////    header.activityIndicatorViewStyle
//    self.tableView.mj_header = header;
//    self.tableView.mj_header.lastUpdatedTime.hidden = YES;
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = _headerViewH;
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadData
{
    NSArray * assetsArray = [[NSUserDefaults standardUserDefaults] objectForKey:AddAssets];
    if (!assetsArray) {
        assetsArray = [NSArray array];
    }
    [[HTTPManager shareManager] getAssetsDataWithAddress:[[AccountTool account] purseAccount] currencyType:@"CNY" tokenList:assetsArray success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == 0) {
//            [self.view addSubview:self.headerBg];
            [self.tableView addSubview:self.headerBg];
            [self.tableView insertSubview:self.headerBg atIndex:0];
            self.listArray = [AssetsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
            NSString * amountStr = responseObject[@"data"][@"totalAmount"];
            self.amount.text = [amountStr isEqualToString:@"~"] ? amountStr : [NSString stringWithFormat:@"≈%@", amountStr];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:message];
        }
        [self.tableView.mj_header endRefreshing];
//        self.noNetWork.hidden = YES;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = NO;
        self.statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }];
}
- (void)getAssetsStateData
{
    [[HTTPManager shareManager] getRegisteredORDistributionDataWithAssetCode:self.registeredModel.code issueAddress:[[AccountTool account] purseAccount] success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        self.distributionModel = [DistributionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
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
                // 已登记
                if ([self.distributionModel.totalSupply floatValue] == 0) {
                    // 无限制
                    [self pushDistributionVC];
                } else {
                    // 有限制
                    CGFloat isOverFlow = [self.distributionModel.totalSupply floatValue] - [self.distributionModel.actualSupply floatValue] - self.registeredModel.amount;
                    if ([self.distributionModel.totalSupply floatValue] == [self.distributionModel.actualSupply floatValue]) {
                        // 您已发行过该资产
                        [self alertViewWithMessage:Localized(@"IssuedAssets")];
                    } else if (isOverFlow < 0) {
                        // 您的资产发行量超过了登记总量
                        [self alertViewWithMessage:Localized(@"CirculationExceeded")];
                    } else {
                        [self pushDistributionVC];
                    }
                }
            } else {
                // 未登记
                [self alertViewWithMessage:[NSString stringWithFormat:@"%@%@ %@", Localized(@"TemporarilyRegisteredAssets"), self.registeredModel.code, Localized(@"InabilityToIssue")]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
// 发行资产
- (void)pushDistributionVC
{
    DistributionOfAssetsViewController * VC = [[DistributionOfAssetsViewController alloc] init];
    VC.uuid = self.scanDic[@"uuID"];
    VC.distributionModel = self.distributionModel;
    VC.registeredModel = self.registeredModel;
    [self.navigationController pushViewController:VC animated:YES];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - TabBarH - SafeAreaBottomH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(_headerViewH, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    return _tableView;
}

- (UIView *)headerBg
{
    if (!_headerBg) {
        UIView * headerBg = [[UIView alloc] init];
        headerBg.frame = CGRectMake(0, -_headerViewH, DEVICE_WIDTH, _headerViewH);
        
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"assets_header"];
        _headerImageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH - MAIN_HEIGHT);
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        [headerBg addSubview:_headerImageView];
        
        _headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH)];
        [headerBg addSubview:_headerViewBg];
        
        UIButton * issueBtn = [UIButton createButtonWithNormalImage:@"nav_scan" SelectedImage:@"nav_scan" Target:self Selector:@selector(issueAction)];
        issueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_headerViewBg addSubview:issueBtn];
        [issueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerViewBg.mas_top).offset(StatusBarHeight);
            make.size.mas_equalTo(CGSizeMake(ScreenScale(44), Margin_30));
            make.right.equalTo(self.headerViewBg.mas_right).offset(- Margin_20);
        }];
        UIImageView * userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userIcon_placeholder"]];
        [userIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconAction)]];
        userIcon.userInteractionEnabled = YES;
        [self.headerViewBg addSubview:userIcon];
        
        UIView * userBg = [[UIView alloc] init];
        [self.headerViewBg addSubview:userBg];
        
        _purseName = [[UILabel alloc] init];
        _purseName.textColor = [UIColor whiteColor];
        _purseName.font = FONT(16);
        _purseName.text = [AccountTool account].identityName;
        [userBg addSubview:self.purseName];
        [_purseName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(userBg);
        }];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:ifBackup]) {
            _backup = [UIButton createButtonWithTitle:Localized(@"PleaseBackup") TextFont:14 TextColor:COLOR(@"FFB134") Target:self Selector:@selector(backupAction:)];
            _backup.layer.cornerRadius = Margin_10;
            _backup.layer.borderColor = COLOR(@"FFB134").CGColor;
            _backup.layer.borderWidth = LINE_WIDTH;
            _backup.contentEdgeInsets = UIEdgeInsetsMake(0, EDGEINSET_WIDTH, 0, EDGEINSET_WIDTH);
            [userBg addSubview:self.backup];
            if (_purseName.text.length > 0) {
                [_backup mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.purseName.mas_right).offset(Margin_5);
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
        [self.headerViewBg addSubview: QRCode];
        
        self.amount = [[UILabel alloc] init];
        self.amount.font = FONT(32);
        self.amount.textColor = [UIColor whiteColor];
        [self.headerViewBg addSubview:self.amount];
        
        self.totalAssets = [[UILabel alloc] init];
        self.totalAssets.font = FONT(15);
        self.totalAssets.textColor = [UIColor whiteColor];
        self.totalAssets.text = Localized(@"TotalAssets");
        [self.headerViewBg addSubview:self.totalAssets];
        [self.totalAssets mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.amount.mas_bottom).offset(Margin_10);
            make.bottom.equalTo(self.headerViewBg.mas_bottom).offset(-MAIN_HEIGHT - Margin_20);
            make.left.equalTo(self.headerViewBg.mas_left).offset(Margin_20);
           
        }];
        [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.totalAssets.mas_top).offset(-Margin_10);
            make.left.equalTo(self.totalAssets);
        }];
        [QRCode mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(userBg.mas_bottom).offset(Margin_15);
            make.bottom.equalTo(self.amount.mas_top).offset(-Margin_20);
            make.centerX.equalTo(self.headerViewBg);
        }];
        [userBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(QRCode.mas_top).offset(-Margin_15);
            make.height.mas_equalTo(Margin_20);
            make.centerX.equalTo(self.headerViewBg);
        }];
        
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.headerViewBg.mas_top).offset(MAIN_HEIGHT + StatusBarHeight);
            make.bottom.equalTo(userBg.mas_top).offset(-Margin_15);
            make.centerX.equalTo(self.headerViewBg);
        }];
        self.header = [[UILabel alloc] initWithFrame:CGRectMake(Margin_10, _headerImageView.height + Margin_5, DEVICE_WIDTH - Margin_20, Margin_40)];
        [self.headerViewBg addSubview:self.header];
        self.header.attributedText = [Encapsulation attrTitle:Localized(@"MyAssets") ifRequired:NO];
        
        self.addAssets = [UIButton createButtonWithNormalImage:@"addAssets" SelectedImage:@"addAssets" Target:self Selector:@selector(addAssetsAcrion)];
        [self.headerViewBg addSubview:self.addAssets];
//        _addAssets.centerY = CGRectGetMaxY(_headerImageView.frame);
//        self.addAssets.x = DEVICE_WIDTH - ScreenScale(65);
//        self.addAssets.size = CGSizeMake(ScreenScale(55), ScreenScale(55));
        [self.addAssets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerViewBg.mas_right).offset(-Margin_10);
            make.centerY.equalTo(self.header);
            make.size.mas_equalTo(CGSizeMake(Margin_30, Margin_30));
//            make.centerY.equalTo(self.headerImageView.mas_bottom);
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
        _headerImageView.alpha = 1.0;
    } else {
        CGFloat min = - _headerViewH;
        CGFloat progress = (offsetY / min);
        _headerBg.y = -_headerViewH;
        _headerBg.height = _headerViewH;
        _headerImageView.alpha = progress;
        _statusBarStyle = (progress < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }
    _headerImageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, _headerBg.height - MAIN_HEIGHT);
    _headerViewBg.y = _headerBg.height - _headerViewH;
    /*
     CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
     if (offset <= 0) {
     _headerBg.y = 0;
     _headerBg.height = _headerViewH - offset;
     _headerImageView.alpha = 1.0;
     } else {
     _headerBg.height = _headerViewH;
     CGFloat min = _headerViewH - NavBarH;
     _headerBg.y = - MIN(min, offset);
     CGFloat progress = 1 - (offset / min);
     _headerImageView.alpha = progress;
     _statusBarStyle = (progress < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
     [self.navigationController setNeedsStatusBarAppearanceUpdate];
     }
     _headerImageView.height = _headerBg.height - MAIN_HEIGHT;
     _header.y = _headerImageView.height;
     */
}
- (void)alertViewWithMessage:(NSString *)message
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)issueAction
{
//    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
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
                [MBProgressHUD showWarnMessage:Localized(@"ScanFailure")];
            }
        }
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
//    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appdelegate.window.rootViewController.definesPresentationContext = YES;
//    [appdelegate.window.rootViewController presentViewController:presentedVC  animated:YES completion:nil];
}

#pragma mark - backup
- (void)backupAction:(UIButton *)button
{
    [self.navigationController pushViewController:[[MyIdentityViewController alloc] init] animated:YES];
}
#pragma mark - QRCode
- (void)QRCodeAction:(UIButton *)button
{
    NSString * address = [AccountTool account].purseAccount;
    PurseAddressAlertView * alertView = [[PurseAddressAlertView alloc] initWithPurseAddress:address confrimBolck:^{
        [[UIPasteboard generalPasteboard] setString:address];
        [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return TabBarH + NavBarH + Margin_10;
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
    AssetsListViewCell * cell = [AssetsListViewCell cellWithTableView:tableView];
    cell.listModel = self.listArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.header.attributedText = [Encapsulation attrTitle:Localized(@"MyAssets") ifRequired:NO];
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
