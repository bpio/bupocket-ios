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

//#import "UINavigationController+Extension.h"

@interface AssetsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * scanButton;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerBg;
@property (nonatomic, strong) UIView * headerViewBg;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UIImage * headerImage;
// Switch the test network
@property (nonatomic, strong) UILabel * networkPrompt;

@property (nonatomic, assign) CGFloat headerViewH;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UILabel * totalAssets;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UIView * noNetWork;

@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, strong) DistributionModel * distributionModel;
@property (nonatomic, strong) NSDictionary * scanDic;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) NSString * assetsCacheDataKey;

@end

@implementation AssetsViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupNav];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self setupView];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork]) {
        self.assetsCacheDataKey = Assets_HomePage_CacheData_Test;
    } else {
        self.assetsCacheDataKey = Assets_HomePage_CacheData;
    }
    [self setupRefresh];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = [defaults objectForKey:self.assetsCacheDataKey];
    if (dic) {
        [self setDataWithResponseObject:dic];
    }
    // Do any additional setup after loading the view.
}
/*
- (void)setupNav
{
    self.scanButton = [UIButton createButtonWithNormalImage:@"nav_scan" SelectedImage:@"transferAccounts_scan" Target:self Selector:@selector(scanAction)];
    self.scanButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
        self.scanButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.scanButton];
}
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}

- (void)setNetworkEnvironment
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork]) {
        self.networkPrompt.text = Localized(@"TestNetworkPrompt");
//        self.headerImageView.image = [UIImage imageNamed:@"assets_header_test"];
        self.headerImageView.backgroundColor = COLOR(@"4B4A66");
        self.headerImageView.image = nil;
    } else {
        self.networkPrompt.text = nil;
        self.headerImageView.image = self.headerImage;
        self.headerImageView.backgroundColor = COLOR(@"645FC3");
    }
//    self.navBackgroundColor = self.headerImageView.backgroundColor;
//    self.navTitleColor = self.navTintColor = [UIColor clearColor];
//    self.navAlpha = 1.0;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}

- (void)reloadData
{
    [self setNetworkEnvironment];
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = _headerViewH;
    [self.tableView.mj_header beginRefreshing];
}
- (void)setDataWithResponseObject:(id)responseObject
{
    [self.tableView addSubview:self.headerBg];
    [self.tableView insertSubview:self.headerBg atIndex:0];
    self.listArray = [AssetsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
    NSString * amountStr = responseObject[@"data"][@"totalAmount"];
    if ([amountStr isEqualToString:@"~"]) {
        self.amount.text = amountStr;
    } else {
        self.amount.text = [NSString stringWithFormat:@"≈%@", amountStr];
        //                NSString * currencyType = responseObject[@"data"][@"currencyType"];
        //                self.amount.attributedText = [Encapsulation attrWithString:amountString preFont:FONT_Bold(32) preColor:[UIColor whiteColor] index:amountString.length - currencyType.length sufFont:FONT(16) sufColor:[UIColor whiteColor] lineSpacing:0];
    }
    NSString * currencyUnit = [AssetCurrencyModel getCurrencyUnitWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
    self.totalAssets.text = [NSString stringWithFormat:@"%@（%@）", Localized(@"TotalAssets"), currencyUnit];
    [self setNetworkEnvironment];
    [self.tableView reloadData];
}
- (void)loadData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * addAssetsKey = Add_Assets;
    if ([defaults boolForKey:If_Switch_TestNetwork]) {
        addAssetsKey = Add_Assets_Test;
    }
    NSArray * assetsArray = [defaults objectForKey:addAssetsKey];
    if (!assetsArray) {
        assetsArray = [NSArray array];
    }
    NSString * currentCurrency = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[defaults objectForKey:Current_Currency] integerValue]];
    [[HTTPManager shareManager] getAssetsDataWithAddress:[[AccountTool account] purseAccount] currencyType:currentCurrency tokenList:assetsArray success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            [self setDataWithResponseObject:responseObject];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject forKey:self.assetsCacheDataKey];
            [defaults synchronize];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
//        self.noNetWork.hidden = YES;
        self.statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (self.listArray.count == 0) {
            self.noNetWork.hidden = NO;
            self.statusBarStyle = UIStatusBarStyleDefault;
            [self.navigationController setNeedsStatusBarAppearanceUpdate];
        }
    }];
}

- (void)getAssetsStateData
{
    [[HTTPManager shareManager] getRegisteredORDistributionDataWithAssetCode:self.registeredModel.code issueAddress:[[AccountTool account] purseAccount] success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        self.distributionModel = [DistributionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        if ([self.scanDic[@"action"] isEqualToString:@"token.register"]) {
            if (code == Success_Code) {
                // has been registered
                [self alertViewWithMessage:Localized(@"RegisteredAsset")];
            } else {
                // unregistered
                RegisteredAssetsViewController * VC = [[RegisteredAssetsViewController alloc] init];
                VC.uuid = self.scanDic[@"uuID"];
                VC.registeredModel = self.registeredModel;
                [self.navigationController pushViewController:VC animated:YES];
            }
        } else if ([self.scanDic[@"action"] isEqualToString:@"token.issue"]) {
            if (code == Success_Code) {
                // has been registered
                if ([self.distributionModel.totalSupply floatValue] == 0) {
                    // Unrestricted
                    [self pushDistributionVC];
                } else {
                    // limited
                    CGFloat isOverFlow = [self.distributionModel.totalSupply floatValue] - [self.distributionModel.actualSupply floatValue] - self.registeredModel.amount;
                    if ([self.distributionModel.totalSupply floatValue] == [self.distributionModel.actualSupply floatValue]) {
                        // You have issued the asset
                        [self alertViewWithMessage:Localized(@"IssuedAssets")];
                    } else if (isOverFlow < 0) {
                        // Your tokens issued exceed the total amount of tokens registered
                        [self alertViewWithMessage:Localized(@"CirculationExceeded")];
                    } else {
                        [self pushDistributionVC];
                    }
                }
            } else {
                // unregistered
                [self alertViewWithMessage:[NSString stringWithFormat:@"%@%@ %@", Localized(@"TemporarilyRegisteredAssets"), self.registeredModel.code, Localized(@"InabilityToIssue")]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)pushDistributionVC
{
    DistributionOfAssetsViewController * VC = [[DistributionOfAssetsViewController alloc] init];
    VC.uuid = self.scanDic[@"uuID"];
    VC.distributionModel = self.distributionModel;
    VC.registeredModel = self.registeredModel;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)setupView
{
    self.headerImage = [UIImage imageNamed:@"assets_header"];
    _headerViewH = ScreenScale(375 * self.headerImage.size.height / self.headerImage.size.width);
    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//        CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - TabBarH - SafeAreaBottomH)
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorInset = UIEdgeInsetsZero;
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
        _headerImageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH);
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        [headerBg addSubview:_headerImageView];
        
        _headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH)];
        [headerBg addSubview:_headerViewBg];
        
        _networkPrompt = [[UILabel alloc] init];
        _networkPrompt.font = FONT(15);
        _networkPrompt.textColor = MAIN_COLOR;
        self.networkPrompt.numberOfLines = 0;
        self.networkPrompt.preferredMaxLayoutWidth = DEVICE_WIDTH - Margin_40;
        [_headerViewBg addSubview:_networkPrompt];
        [self.networkPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerViewBg.mas_top).offset(StatusBarHeight);
            make.centerX.equalTo(self.headerViewBg.mas_centerX).offset(-Margin_10);
        }];
        
        UIButton * scanBtn = [UIButton createButtonWithNormalImage:@"nav_scan" SelectedImage:@"nav_scan" Target:self Selector:@selector(scanAction)];
        scanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_headerViewBg addSubview:scanBtn];
        [scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        
        UILabel * purseName = [[UILabel alloc] init];
        purseName.textColor = [UIColor whiteColor];
        purseName.font = FONT(16);
        purseName.text = [AccountTool account].identityName;
        [userBg addSubview:purseName];
        [purseName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(userBg);
        }];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:If_Backup]) {
            UIButton * backup = [UIButton createButtonWithTitle:Localized(@"PleaseBackup") TextFont:14 TextColor:COLOR(@"FFB134") Target:self Selector:@selector(backupAction:)];
            backup.layer.cornerRadius = Margin_10;
            backup.layer.borderColor = COLOR(@"FFB134").CGColor;
            backup.layer.borderWidth = LINE_WIDTH;
            backup.contentEdgeInsets = UIEdgeInsetsMake(0, EDGEINSET_WIDTH, 0, EDGEINSET_WIDTH);
            [userBg addSubview:backup];
            if (purseName.text.length > 0) {
                [backup mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(purseName.mas_right).offset(Margin_5);
                }];
            } else {
                [backup mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(userBg);
                }];
            }
            [backup mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.height.right.equalTo(userBg);
            }];
        } else {
            [purseName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(userBg);
            }];
        }
        CustomButton * QRCode = [[CustomButton alloc] init];
        QRCode.layoutMode = HorizontalInverted;
        [QRCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        QRCode.titleLabel.font = FONT(13);
        [QRCode setTitle:[NSString stringEllipsisWithStr:[AccountTool account].purseAccount] forState:UIControlStateNormal];
        [QRCode setImage:[UIImage imageNamed:@"qrCode"] forState:UIControlStateNormal];
        [QRCode addTarget:self action:@selector(QRCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerViewBg addSubview: QRCode];
        
        self.amount = [[UILabel alloc] init];
        self.amount.font = FONT(32);
        self.amount.textColor = [UIColor whiteColor];
        [self.headerViewBg addSubview:self.amount];
        
        self.totalAssets = [[UILabel alloc] init];
        self.totalAssets.font = FONT(15);
        self.totalAssets.textColor = [UIColor whiteColor];
        [self.headerViewBg addSubview:self.totalAssets];
        [self.totalAssets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headerViewBg.mas_bottom).offset(- Margin_20);
            make.left.equalTo(self.headerViewBg.mas_left).offset(Margin_20);
           
        }];
        [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.totalAssets.mas_top).offset(-Margin_10);
            make.left.equalTo(self.totalAssets);
        }];
        [QRCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.amount.mas_top).offset(-Margin_15);
            make.centerX.equalTo(self.headerViewBg);
        }];
        [userBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(QRCode.mas_top).offset(-Margin_15);
            make.height.mas_equalTo(Margin_20);
            make.centerX.equalTo(self.headerViewBg);
        }];
        
        [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(userBg.mas_top).offset(-Margin_15);
            make.centerX.equalTo(self.headerViewBg);
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
//        self.navTitleColor = self.navTintColor = [UIColor clearColor];
//        self.navAlpha = 0;
        self.scanButton.selected = NO;
    } else {
        CGFloat min = - _headerViewH;
        CGFloat progress = (offsetY / min);
        _headerBg.y = -_headerViewH;
        _headerBg.height = _headerViewH;
        _headerImageView.alpha = progress;
        _statusBarStyle = (progress < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
//        self.navTitleColor = self.navTintColor = (progress < 0.5) ? TITLE_COLOR : [UIColor clearColor];
//        self.navAlpha = 1 - progress;
        self.scanButton.selected = (progress < 0.5) ? YES : NO;
    }
    _headerImageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, _headerBg.height);
    _headerViewBg.y = _headerBg.height - _headerViewH;
}
- (void)alertViewWithMessage:(NSString *)message
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)scanAction
{
    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        [MBProgressHUD showInfoMessage:stringValue];
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            BOOL isCorrectAddress = [Keypair isAddressValid: stringValue];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (isCorrectAddress) {
                    TransferAccountsViewController * VC = [[TransferAccountsViewController alloc] init];
                    for (AssetsListModel * listModel in self.listArray) {
                        if (listModel.type == Token_Type_BU) {
                            VC.listModel = listModel;
                        }
                    }
                    VC.address = stringValue;
                    [weakself.navigationController pushViewController:VC animated:YES];
                } else {
                    weakself.scanDic = [JsonTool dictionaryOrArrayWithJSONSString:[NSString dencode:stringValue]];
                    if (weakself.scanDic) {
                        weakself.registeredModel = [RegisteredModel mj_objectWithKeyValues:self.scanDic[@"data"]];
                        [weakself getAssetsStateData];
                    } else {
                        [MBProgressHUD showWarnMessage:Localized(@"ScanFailure")];
                    }
                }
            }];
        }];
        
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
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
        UILabel * header = [[UILabel alloc] init];
        header.font = FONT(15);
        header.textColor = TITLE_COLOR;
        header.text = Localized(@"MyAssets");
        [headerView addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(Margin_10);
            make.top.equalTo(headerView.mas_top).offset(Margin_5);
            make.bottom.equalTo(headerView);
        }];
        UIButton * addAssets = [UIButton createButtonWithNormalImage:@"addAssets" SelectedImage:@"addAssets" Target:self Selector:@selector(addAssetsAcrion)];
        [headerView addSubview:addAssets];
        [addAssets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView.mas_right).offset(-Margin_10);
            make.centerY.equalTo(header);
            make.size.mas_equalTo(CGSizeMake(Margin_30, Margin_30));
        }];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return TabBarH + SafeAreaBottomH + Margin_10;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
