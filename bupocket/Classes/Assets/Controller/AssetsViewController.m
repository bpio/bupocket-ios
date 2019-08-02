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
//#import "WalletAddressAlertView.h"
#import "AssetsDetailViewController.h"
#import "AssetsListModel.h"
#import "AddAssetsViewController.h"
#import "HMScannerController.h"
#import "RegisteredAssetsViewController.h"
#import "DistributionOfAssetsViewController.h"
//#import "TransferAccountsViewController.h"
#import "TransactionViewController.h"
#import "WalletListViewController.h"
#import "LoginConfirmViewController.h"
#import "BottomConfirmAlertView.h"
//#import "ConfirmTransactionAlertView.h"
#import "ScanCodeFailureViewController.h"
#import "ReceiveViewController.h"
#import "RegisteredModel.h"
#import "DistributionModel.h"
#import "BackUpWalletViewController.h"

#import "LoginConfirmModel.h"
#import "ConfirmTransactionModel.h"
#import "DposModel.h"

#import "UINavigationController+Extension.h"

//#import "NodeTransferSuccessViewController.h"
//#import "TransferResultsViewController.h"
//#import "ResultViewController.h"
//#import "RequestTimeoutViewController.h"
#import "UITabBar+Extension.h"


@interface AssetsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * wallet;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerBg;
@property (nonatomic, strong) UIView * headerViewBg;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UIImage * headerImage;
// Switch the test network
@property (nonatomic, strong) UIButton * networkPrompt;

@property (nonatomic, assign) CGFloat headerViewH;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UILabel * totalAssets;
@property (nonatomic, strong) UIView * noNetWork;

@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, strong) DistributionModel * distributionModel;
@property (nonatomic, strong) NSDictionary * scanDic;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) NSString * assetsCacheDataKey;
@property (nonatomic, strong) UILabel * safetyTips;
@property (nonatomic, strong) UILabel * safetyTipsTitle;

@property (nonatomic, strong) ConfirmTransactionModel * confirmTransactionModel;
@property (nonatomic, strong) DposModel * dposModel;

@end

@implementation AssetsViewController

//static UIButton * _noBackup;

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
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self setupNav];
    [self setupView];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        self.assetsCacheDataKey = Assets_HomePage_CacheData_Custom;
    } else if ([defaults boolForKey:If_Switch_TestNetwork]) {
        self.assetsCacheDataKey = Assets_HomePage_CacheData_Test;
    } else {
        self.assetsCacheDataKey = Assets_HomePage_CacheData;
    }
    [self setupRefresh];
    NSDictionary * dic = [defaults objectForKey:self.assetsCacheDataKey];
    if (dic) {
        [self setDataWithResponseObject:dic];
    }
    if ([defaults objectForKey:If_Hidden_New]) {
        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
    } else {
        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:1 tabbarNum:self.navigationController.tabBarController.viewControllers.count];
    }
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    self.wallet = [UIButton createButtonWithNormalImage:@"nav_wallet_w" SelectedImage:@"nav_wallet" Target:self Selector:@selector(walletAction)];
    self.wallet.frame = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    self.wallet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.wallet];
    self.navAlpha = 0;
    self.navBackgroundColor = [UIColor whiteColor];
    self.navTitleColor = self.navTintColor = [UIColor whiteColor];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
//    self.navigationItem.title = CurrentWalletName ? CurrentWalletName : Current_WalletName;
//}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.navigationItem.title = CurrentWalletName ? CurrentWalletName : Current_WalletName;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}
#pragma mark - Asset List Data
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = _headerViewH - NavBarH;
}
- (void)loadData
{
    NSString * addAssetsKey;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        addAssetsKey = Add_Assets_Custom;
    } else if ([defaults boolForKey:If_Switch_TestNetwork]) {
        addAssetsKey = Add_Assets_Test;
    } else {
        addAssetsKey = Add_Assets;
    }
    NSArray * assetsArray = [defaults objectForKey:addAssetsKey];
    if (!assetsArray) {
        assetsArray = [NSArray array];
    }
    NSString * currentCurrency = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[defaults objectForKey:Current_Currency] integerValue]];
    NSString * currentWalletAddress = CurrentWalletAddress;
    if (!currentWalletAddress) {
        currentWalletAddress = [[[AccountTool shareTool] account] purseAccount];
    }
    [[HTTPManager shareManager] getAssetsDataWithAddress:currentWalletAddress currencyType:currentCurrency tokenList:assetsArray success:^(id responseObject) {
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
        self.statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (self.listArray.count == 0) {
            self.noNetWork.hidden = NO;
            self.statusBarStyle = UIStatusBarStyleDefault;
            [self.navigationController setNeedsStatusBarAppearanceUpdate];
        } else {
            [MBProgressHUD showTipMessageInWindow:Localized(@"NoNetWork")];
        }
    }];
}
- (void)setDataWithResponseObject:(id)responseObject
{
    [self.tableView addSubview:self.headerBg];
    [self.tableView insertSubview:self.headerBg atIndex:0];
    self.listArray = [AssetsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
    NSString * amountStr = responseObject[@"data"][@"totalAmount"];
    if ([amountStr isEqualToString:@"~"]) {
        self.totalAssets.text = amountStr;
    } else {
        NSString * currencyUnit = [AssetCurrencyModel getCurrencyUnitWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
        NSString * amountString = [NSString stringWithFormat:@"≈%@%@", amountStr, currencyUnit];
        NSMutableAttributedString * attr = [Encapsulation attrWithString:amountString preFont:FONT(36) preColor:[UIColor whiteColor] index:amountString.length - currencyUnit.length sufFont:FONT(18) sufColor:[UIColor whiteColor] lineSpacing:0];
        [attr addAttribute:NSBaselineOffsetAttributeName value:@((FONT(18).lineHeight)/2) range:NSMakeRange(amountString.length - currencyUnit.length, currencyUnit.length)];
        self.totalAssets.attributedText = attr;
    }
    [self setNetworkEnvironment];
    [self getVersionData];
    [self.tableView reloadData];
}
#pragma mark - Switching Network Environment
- (void)setNetworkEnvironment
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"CustomEnvironment") Target:nil Selector:nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
        self.headerImageView.image = [UIImage imageNamed:@"assets_header_custom"];
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork]) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"TestNetworkPrompt") Target:nil Selector:nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
        self.headerImageView.image = [UIImage imageNamed:@"assets_header_test"];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.headerImageView.image = self.headerImage;
    }
}
- (void)getVersionData
{
    [[HTTPManager shareManager] getVersionDataWithSuccess:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dataDic forKey:Version_Info];
            [defaults synchronize];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - Scan code registration / issue
- (void)getAssetsStateData
{
    NSString * currentWalletAddress = CurrentWalletAddress;
    if (!currentWalletAddress) {
        currentWalletAddress = [[[AccountTool shareTool] account] purseAccount];
    }
    [[HTTPManager shareManager] getRegisteredORDistributionDataWithAssetCode:self.registeredModel.code issueAddress:currentWalletAddress success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        self.distributionModel = [DistributionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
        if ([self.scanDic[@"action"] isEqualToString:@"token.register"]) {
            if (code == Success_Code) {
                // has been registered
                [Encapsulation showAlertControllerWithMessage:Localized(@"RegisteredAsset") handler:nil];
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
                if ([self.distributionModel.totalSupply longLongValue] == 0) {
                    // Unrestricted
                    [self pushDistributionVC];
                } else {
                    // limited
                    [self pushDistributionVC];
                }
            } else {
                // unregistered
                [Encapsulation showAlertControllerWithMessage:[NSString stringWithFormat:Localized(@"The code of your issued tokens:%@ has not been registered yet, so it cannot be issued"), self.registeredModel.code] handler:nil];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Scan code login
- (void)getScanCodeLoginDataWithUUid:(NSString *)uuid
{
    [[HTTPManager shareManager] getAccountCenterDataWithAppId:nil uuid:uuid success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            LoginConfirmViewController * VC = [[LoginConfirmViewController alloc] init];
            VC.loginConfirmModel = [LoginConfirmModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (code == ErrorAccountUnbound) {
            NSDictionary * dic = responseObject[@"data"];
            ScanCodeFailureViewController * VC = [[ScanCodeFailureViewController alloc] init];
            VC.exceptionPromptStr = dic[@"errorMsg"];
            VC.promptStr = dic[@"errorDescription"];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (code == ErrorQRCodeExpired || code == ErrorAccountQRCodeExpired) {
            ScanCodeFailureViewController * VC = [[ScanCodeFailureViewController alloc] init];
            VC.exceptionPromptStr = Localized(@"Overdue");
            VC.promptStr = Localized(@"RefreshQRCode");
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithNodeErrorCode:code] handler:nil];
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
    _headerViewH = ScreenScale(375 * self.headerImage.size.height / self.headerImage.size.width) + Margin_15;
    [self.view addSubview:self.tableView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
        _headerImageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH - Margin_15);
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        [headerBg addSubview:_headerImageView];
        
        _headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, _headerViewH)];
        [headerBg addSubview:_headerViewBg];
    
        _totalAssets = [[UILabel alloc] init];
        _totalAssets.font = FONT(36);
        _totalAssets.textColor = [UIColor whiteColor];
        [_headerViewBg addSubview:_totalAssets];
        
        
        CustomButton * totalAssetsTitle = [[CustomButton alloc] init];
        totalAssetsTitle.layoutMode = HorizontalInverted;
        totalAssetsTitle.titleLabel.font = FONT(15);
        [totalAssetsTitle setTitle:Localized(@"AssetValuation") forState:UIControlStateNormal];
        [totalAssetsTitle setImage:[UIImage imageNamed:@"estimated_total_assets"] forState:UIControlStateNormal];
        [totalAssetsTitle addTarget:self action:@selector(totalAssetsInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerViewBg addSubview:totalAssetsTitle];
        
        
        UIView * operationBtnBg = [[UIView alloc] init];
        operationBtnBg.backgroundColor = [UIColor whiteColor];
        operationBtnBg.layer.masksToBounds = YES;
        operationBtnBg.layer.cornerRadius = BG_CORNER;
        [self.headerViewBg addSubview:operationBtnBg];
        [operationBtnBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerViewBg.mas_left).offset(Margin_Main);
            make.right.equalTo(self.headerViewBg.mas_right).offset(- Margin_Main);
            make.bottom.equalTo(self.headerViewBg);
            make.height.mas_equalTo(TextViewH);
        }];
        
        CGFloat btnW = [Encapsulation rectWithText:totalAssetsTitle.titleLabel.text font:totalAssetsTitle.titleLabel.font textHeight:Margin_20].size.width + Margin_20;
        [totalAssetsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.totalAssets.mas_bottom).offset(Margin_10);
            make.bottom.equalTo(operationBtnBg.mas_top).offset(-Margin_20);
            make.size.mas_equalTo(CGSizeMake(btnW, Margin_20));
            make.centerX.equalTo(self.headerViewBg);
        }];
        
        [self.totalAssets mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.headerViewBg.mas_top).offset(StatusBarHeight + MAIN_HEIGHT);
//            make.top.equalTo(self.headerViewBg.mas_top).offset(NavBarH + Margin_10);
            make.bottom.equalTo(totalAssetsTitle.mas_top).offset(-Margin_5);
            make.centerX.equalTo(self.headerViewBg);
            make.width.mas_lessThanOrEqualTo(View_Width_Main);
        }];
        NSArray * operationArray = @[Localized(@"Scan"), Localized(@"Receive"), Localized(@"AddAssets")];
        CGFloat operationBtnW = (Content_Width_Main) / operationArray.count;
        for (NSInteger i = 0; i < operationArray.count; i ++) {
            CustomButton * operationBtn = [[CustomButton alloc] init];
            operationBtn.layoutMode = VerticalNormal;
            operationBtn.titleLabel.font = FONT(15);
            operationBtn.bounds = CGRectMake(0, 0, operationBtnW, ScreenScale(80));
            [operationBtn setTitleColor:COLOR_9 forState:UIControlStateNormal];
            [operationBtn setTitle:operationArray[i] forState:UIControlStateNormal];
            [operationBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"assetsOperation_%zd", i]] forState:UIControlStateNormal];
            operationBtn.tag = i;
            [operationBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
            [operationBtnBg addSubview:operationBtn];
            [operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(operationBtnBg.mas_left).offset(Margin_10 + operationBtnW * i);
                make.centerY.equalTo(operationBtnBg);
                make.size.mas_equalTo(CGSizeMake(operationBtnW, TextViewH - Margin_20));
            }];
        }
        _headerBg = headerBg;
    }
    return _headerBg;
}
- (void)totalAssetsInfo:(UIButton *)button
{
    [Encapsulation showAlertControllerWithMessage:Localized(@"AssetsInfo") handler:nil];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.navAlpha = (offsetY + _headerViewH) / ScreenScale(80);
    if ((offsetY + _headerViewH) > ScreenScale(80)) {
        self.wallet.selected = YES;
        self.navTitleColor = self.navTintColor = TITLE_COLOR;
        self.wallet.selected = YES;
        _statusBarStyle = UIStatusBarStyleDefault;
    } else {
        self.wallet.selected = NO;
        self.navTitleColor = self.navTintColor = [UIColor whiteColor];
        self.wallet.selected = NO;
        _statusBarStyle = UIStatusBarStyleLightContent;
    }
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
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
    }
    _headerImageView.frame = CGRectMake(0, 0, DEVICE_WIDTH, _headerBg.height - Margin_15);
    _headerViewBg.y = _headerBg.height - _headerViewH;
}
- (void)walletAction
{
    WalletListViewController * VC = [[WalletListViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - assets operation
- (void)operationAction:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            [self scanAction];
            break;
        case 1:
            [self showWalletAddress];
            break;
        case 2:
            [self addAssetsAcrion];
            break;
            
        default:
            break;
    }
}
#pragma mark - scan
- (void)scanAction
{
    __block NSString * result = nil;
    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        if (result) {
            return;
        }
        result = stringValue;
        if ([stringValue hasPrefix:Voucher_Prefix]) {
            NSString * address = [stringValue substringFromIndex:[Voucher_Prefix length]];
            TransactionViewController * VC = [[TransactionViewController alloc] init];
            VC.receiveAddressStr = address;
            VC.transferType = TransferTypeVoucher;
            [self.navigationController pushViewController:VC animated:YES];
            return;
        }
        if ([stringValue hasPrefix:Dpos_Prefix]) {
            [self getDposTransactionWithStr:stringValue];
            return;
        }
        // 扫码登录
        if ([stringValue hasPrefix:@"http"] && [stringValue containsString:Account_Center_Contains] && ![[[[[stringValue componentsSeparatedByString:Account_Center_Contains] firstObject] componentsSeparatedByString:@"://"] lastObject] containsString:@"/"] && [[[stringValue componentsSeparatedByString:Account_Center_Contains] lastObject] length] == 32) {
            [self getScanCodeLoginDataWithUUid:[[stringValue componentsSeparatedByString:Account_Center_Contains] lastObject]];
            return;
        } else if ([stringValue hasPrefix:@"http"] && [stringValue containsString:Dpos_Contains] && ![[[[[stringValue componentsSeparatedByString:Dpos_Contains] firstObject] componentsSeparatedByString:@"://"] lastObject] containsString:@"/"] && [[[stringValue componentsSeparatedByString:Dpos_Contains] lastObject] length] == 32) {
            // 扫码调用合约
            [self getApplyNodeDataWithStr:[[stringValue componentsSeparatedByString:Dpos_Contains] lastObject]];
            return;
        }
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            BOOL isCorrectAddress = [Keypair isAddressValid: stringValue];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (isCorrectAddress) {
                    TransactionViewController * VC = [[TransactionViewController alloc] init];
                    for (AssetsListModel * listModel in self.listArray) {
                        if (listModel.type == Token_Type_BU) {
                            VC.listModel = listModel;
                        }
                    }
                    VC.transferType = TransferTypeAssets;
                    VC.receiveAddressStr = stringValue;
                    [weakself.navigationController pushViewController:VC animated:YES];
                } else {
                    weakself.scanDic = [JsonTool dictionaryOrArrayWithJSONSString:[NSString dencode:stringValue]];
                    if (weakself.scanDic) {
                        weakself.registeredModel = [RegisteredModel mj_objectWithKeyValues:self.scanDic[@"data"]];
                        [weakself getAssetsStateData];
                    } else {
                        [MBProgressHUD showTipMessageInWindow:Localized(@"ScanFailure")];
                    }
                }
            }];
        }];
        
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
}
#pragma mark - wallet address
- (void)showWalletAddress
{
    ReceiveViewController * VC = [[ReceiveViewController alloc] init];
    VC.receiveType = ReceiveTypeDefault;
    [self.navigationController pushViewController:VC animated:YES];
    /*
    WalletAddressAlertView * alertView = [[WalletAddressAlertView alloc] initWithWalletAddress:CurrentWalletAddress confrimBolck:^{
        [[UIPasteboard generalPasteboard] setString:CurrentWalletAddress];
        [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
     */
}

#pragma mark - add Assets
- (void)addAssetsAcrion
{
    AddAssetsViewController * VC = [[AddAssetsViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - Dpos
- (void)getApplyNodeDataWithStr:(NSString *)str
{
    [[HTTPManager shareManager] getDposApplyNodeDataWithQRcodeSessionId:str success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            DLog(@"json = %@", [JsonTool JSONStringWithDictionaryOrArray:[responseObject objectForKey:@"data"]]);
            self.confirmTransactionModel = [ConfirmTransactionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [self getDposData];
        } else if (code == ErrorQRCodeExpired) {
            ScanCodeFailureViewController * VC = [[ScanCodeFailureViewController alloc] init];
            VC.exceptionPromptStr = Localized(@"Overdue");
            VC.promptStr = Localized(@"RefreshQRCode");
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithNodeErrorCode:code] handler:nil];
        }
    } failure:^(NSError *error) {

    }];
}
- (void)getDposData
{
    BottomConfirmAlertView * confirmAlertView = [[BottomConfirmAlertView alloc] initWithIsShowValue:NO handlerType:HandlerTypeTransferDpos confirmModel:self.confirmTransactionModel confrimBolck:^{
    } cancelBlock:^{
        
    }];
    [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    /*
    ConfirmTransactionAlertView * confirmAlertView = [[ConfirmTransactionAlertView alloc] initWithDposConfrimBolck:^(NSString * _Nonnull transactionCost) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:self.confirmTransactionModel.amount];
            NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:transactionCost];
            NSDecimalNumber * totleAmount = [amount decimalNumberByAdding:minTransactionCost];
            NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:[totleAmount stringValue] ifShowLoading:NO];
            NSString * totleAmountStr = [amountNumber stringValue];
            if (!NotNULLString(totleAmountStr) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
            } else if ([totleAmountStr hasPrefix:@"-"]) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
            } else {
                if (![[HTTPManager shareManager] getTransactionHashWithModel: self.confirmTransactionModel]) return;
                [self showPWAlertView];
            }
        });
    } cancelBlock:^{
        
    }];
    confirmAlertView.confirmTransactionModel = self.confirmTransactionModel;
    [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
     */
}
/*
// Transaction confirmation and submission
- (void)getConfirmTransactionData
{
    [[HTTPManager shareManager] getContractTransactionWithModel:self.confirmTransactionModel  success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code || code == ErrorNotSubmitted) {
            NSString * dateStr = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"data"] objectForKey:@"expiryTime"]];
            if (code == Success_Code) {
                NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dateStr longLongValue] / 1000];
                NSTimeInterval time = [date timeIntervalSinceNow];
                if (time < 0) {
                    [Encapsulation showAlertControllerWithMessage:Localized(@"Overtime") handler:nil];
                } else {
                    [self submitTransaction];
                }
            } else {
                [Encapsulation showAlertControllerWithMessage:[NSString stringWithFormat:Localized(@"NotSubmitted%@"), [DateTool getTimeIntervalWithStr:dateStr]] handler:nil];
            }
        } else {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithNodeErrorCode:code] handler:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)showPWAlertView
{
    PasswordAlertView * PWAlertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"TransactionWalletPWPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        if (NotNULLString(password)) {
            if (self.confirmTransactionModel) {
                [self getConfirmTransactionData];
            } else if (self.dposModel) {
                [self submitDposTransaction];
            }
        }
    } cancelBlock:^{
        
    }];
    [PWAlertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [PWAlertView.PWTextField becomeFirstResponder];
}

- (void)submitTransaction
{
    [[HTTPManager shareManager] submitTransactionWithSuccess:^(TransactionResultModel *resultModel) {
        if (resultModel.errorCode == Success_Code) {
            NodeTransferSuccessViewController * VC = [[NodeTransferSuccessViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            ResultViewController * VC = [[ResultViewController alloc] init];
            VC.state = NO;
            VC.resultModel = resultModel;
            VC.confirmModel = self.confirmTransactionModel;
            [self.navigationController pushViewController:VC animated:YES];
        }
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        VC.transactionHash = resultModel.transactionHash;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
  */
#pragma mark 扫描调用底层合约操作
- (void)getDposTransactionWithStr:(NSString *)str
{
    NSString * scanStr = [str substringFromIndex:[Dpos_Prefix length]];
    NSDictionary * scanData = [JsonTool dictionaryOrArrayWithJSONSString:scanStr];
    if (scanData) {
        self.dposModel = [DposModel mj_objectWithKeyValues:scanData];
        if (!NotNULLString(self.dposModel.dest_address)) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"DestAddressNotNull")];
            return;
        }
        if (!NotNULLString(self.dposModel.tx_fee)) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"TxFeeNotNull")];
            return;
        }
        if (!NotNULLString(self.dposModel.amount)) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"AmountNotNull")];
            return;
        }
        if (!NotNULLString(self.dposModel.input)) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"InputNotNull")];
            return;
        }
        BOOL isCorrectAddress = [Keypair isAddressValid: self.dposModel.dest_address];
        if (!isCorrectAddress) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"BUAddressIsIncorrect")];
            return;
        }
        RegexPatternTool * regex = [[RegexPatternTool alloc] init];
        BOOL txFeeRegx = [regex validateIsPositiveFloatingPoint:self.dposModel.tx_fee];
        if (txFeeRegx == NO) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"TxFeeIsIncorrect")];
            return;
        }
        
        BOOL amountRegx = [regex validateIsNonNegativeFloatingPoint:self.dposModel.amount];
        if (amountRegx == NO) {
            [MBProgressHUD showTipMessageInWindow:Localized(@"AmountIsIncorrect")];
            return;
        }
        self.confirmTransactionModel = [[ConfirmTransactionModel alloc] init];
        self.confirmTransactionModel.transactionCost = self.dposModel.tx_fee;
        self.confirmTransactionModel.destAddress = self.dposModel.dest_address;
        self.confirmTransactionModel.amount = self.dposModel.amount;
        self.confirmTransactionModel.script = self.dposModel.input;
        self.confirmTransactionModel.qrRemarkEn = Localized(@"DposContract");
        BottomConfirmAlertView * confirmAlertView = [[BottomConfirmAlertView alloc] initWithIsShowValue:NO handlerType:HandlerTypeTransferDposCommand confirmModel:self.confirmTransactionModel confrimBolck:^{
        } cancelBlock:^{
            
        }];
        confirmAlertView.dposModel = self.dposModel;
        [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        /*
        ConfirmTransactionAlertView * confirmAlertView = [[ConfirmTransactionAlertView alloc] initWithDposConfrimBolck:^(NSString * _Nonnull transactionCost) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:self.dposModel.amount];
                NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:transactionCost];
                NSDecimalNumber * totleAmount = [amount decimalNumberByAdding:minTransactionCost];
                NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:[totleAmount stringValue] ifShowLoading:NO];
                NSString * totleAmountStr = [amountNumber stringValue];
                if (!NotNULLString(totleAmountStr) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
                } else if ([totleAmountStr hasPrefix:@"-"]) {
                    [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
                } else {
                    if (![[HTTPManager shareManager] getTransactionWithDposModel: self.dposModel isDonateVoucher:NO]) return;
                    [self showPWAlertView];
                }
            });
        } cancelBlock:^{
            
        }];
        confirmAlertView.dposModel = self.dposModel;
        [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        */
    } else {
        [MBProgressHUD showTipMessageInWindow:Localized(@"ScanFailure")];
    }
}
/*
- (void)submitDposTransaction
{
    [[HTTPManager shareManager] submitTransactionWithSuccess:^(TransactionResultModel *resultModel) {
        resultModel.remark = Localized(@"DposContract");
        ResultViewController * VC = [[ResultViewController alloc] init];
        if (resultModel.errorCode == Success_Code) {
            VC.state = YES;
        } else {
            VC.state = NO;
        }
        VC.resultModel = resultModel;
        VC.confirmModel = self.confirmTransactionModel;
//        VC.transferInfoArray = [NSMutableArray arrayWithObjects:self.dposModel.dest_address, [NSString stringAppendingBUWithStr:self.dposModel.amount], nil];
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        VC.transactionHash = resultModel.transactionHash;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(90);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        if (![defaults boolForKey:If_Backup] && _noBackup.selected == NO) {
        if (![defaults boolForKey:If_Backup]) {
//            if (iPhone6plus && [CurrentAppLanguage isEqualToString:ZhHans]) {
//                return 184;
////                return 165;
//            } else if (iPhone6plus && [CurrentAppLanguage isEqualToString:EN]) {
//                return 217;
////                return 195;
//            }
//            return ScreenScale(130) + [Encapsulation getSizeSpaceLabelWithStr:Localized(@"SafetyTips") font:FONT_TITLE width:Content_Width_Main height:CGFLOAT_MAX lineSpacing:LINE_SPACING].height;
            return ScreenScale(110) + self.safetyTipsTitle.size.height + self.safetyTips.size.height;
//            [Encapsulation rectWithText:Localized(@"SafetyTips") font:FONT_TITLE textWidth:DEVICE_WIDTH - Margin_40].size.height;
        } else {
            return Margin_Section_Header - Margin_5;
        }
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] init];
    if (section == 0) {
        UIButton * header = [UIButton createHeaderButtonWithTitle:Localized(@"MyAssets")];
        header.contentEdgeInsets = UIEdgeInsetsMake(Margin_5, Margin_Main, 0, Margin_Main);
        [headerView addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(headerView);
            make.height.mas_equalTo(Margin_Section_Header - Margin_5);
        }];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:If_Backup]) {
            UIView * backupBg = [[UIView alloc] init];
            backupBg.backgroundColor = [UIColor whiteColor];
            backupBg.layer.masksToBounds = YES;
            backupBg.layer.cornerRadius = BG_CORNER;
            [headerView addSubview:backupBg];
            [backupBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView.mas_top).offset(Margin_10);
                make.left.equalTo(headerView.mas_left).offset(Margin_Main);
                make.right.equalTo(headerView.mas_right).offset(- Margin_Main);
                make.bottom.equalTo(header.mas_top);
            }];
            [backupBg addSubview:self.safetyTipsTitle];
            [self.safetyTipsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(backupBg.mas_top).offset(Margin_15);
                make.left.equalTo(backupBg.mas_left).offset(Margin_10);
//                make.right.equalTo(backupBg.mas_right).offset(- Margin_10);
                make.size.mas_equalTo(self.safetyTipsTitle.size);
//                make.height.mas_equalTo(Margin_20);
            }];
            
            [backupBg addSubview:self.safetyTips];
            [self.safetyTips mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.safetyTipsTitle.mas_bottom).offset(Margin_10);
                make.left.equalTo(backupBg.mas_left).offset(Margin_10);
//                make.right.equalTo(backupBg.mas_right).offset(- Margin_10);
//                make.left.right.equalTo(self.safetyTipsTitle);
                make.size.mas_equalTo(self.safetyTips.size);
//                make.left.right.equalTo(safetyTipsTitle);
            }];
            /*
            CGFloat btnW = (DEVICE_WIDTH - ScreenScale(65)) / 2;
            _noBackup = [UIButton createButtonWithTitle:Localized(@"TemporaryBackup") TextFont:FONT_16 TextNormalColor:COLOR(@"9298BD") TextSelectedColor:COLOR(@"9298BD") Target:self Selector:@selector(noBackupAction:)];
            _noBackup.backgroundColor = COLOR(@"DADDF3");
            _noBackup.layer.masksToBounds = YES;
            _noBackup.layer.cornerRadius = MAIN_CORNER;
            [backupBg addSubview:_noBackup];
            [_noBackup mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(safetyTips.mas_bottom).offset(Margin_10);
                make.left.equalTo(safetyTipsTitle);
                make.bottom.equalTo(backupBg.mas_bottom).offset(-Margin_15);
                make.size.mas_equalTo(CGSizeMake(btnW, Margin_40));
            }];
             */
            CustomButton * backup = [[CustomButton alloc] init];
            [backup setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            backup.titleLabel.font = FONT_Bold(15);
            [backup setImage:[UIImage imageNamed:@"backup_arrow"] forState:UIControlStateNormal];
            [backup setTitle:Localized(@"ImmediateBackup") forState:UIControlStateNormal];
            [backup addTarget:self action:@selector(backupAction) forControlEvents:UIControlEventTouchUpInside];
            backup.layoutMode = HorizontalInverted;
//            [UIButton createButtonWithTitle:Localized(@"ImmediateBackup") TextFont:FONT_16 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(backupAction)];
            [backupBg addSubview:backup];
            [backup mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.safetyTips.mas_bottom);
                make.right.equalTo(backupBg.mas_right).offset(- Margin_10);
                make.height.mas_equalTo(MAIN_HEIGHT);
                make.bottom.equalTo(backupBg.mas_bottom);
//                make.right.equalTo(safetyTipsTitle);
//                make.size.bottom.equalTo(_noBackup);
            }];
        }
    }
    return headerView;
}
- (UILabel *)safetyTipsTitle
{
    if (!_safetyTipsTitle) {
        _safetyTipsTitle = [[UILabel alloc] init];
        _safetyTipsTitle.textColor = COLOR_6;
        _safetyTipsTitle.font = FONT_Bold(15);
        _safetyTipsTitle.text = Localized(@"SafetyTipsTitle");
        CGSize maximumSize = CGSizeMake(Content_Width_Main, CGFLOAT_MAX);
        CGSize expectSize = [_safetyTipsTitle sizeThatFits:maximumSize];
        _safetyTipsTitle.size = expectSize;
    }
    return _safetyTipsTitle;
}
- (UILabel *)safetyTips
{
    if (!_safetyTips) {
        _safetyTips = [[UILabel alloc] init];
        _safetyTips.numberOfLines = 0;
        _safetyTips.attributedText = [Encapsulation attrWithString:Localized(@"SafetyTips") font:FONT_TITLE color:COLOR_6 lineSpacing:LINE_SPACING];
        //            safetyTips.textColor = COLOR_6;
        //            safetyTips.font = FONT_TITLE;
        //            safetyTips.text = Localized(@"SafetyTips");
        CGSize maximumSize = CGSizeMake(Content_Width_Main, CGFLOAT_MAX);
        CGSize expectSize = [_safetyTips sizeThatFits:maximumSize];
        _safetyTips.size = expectSize;
    }
    return _safetyTips;
}
#pragma mark - backup
- (void)backupAction
{
//    [self.navigationController pushViewController:[[MyIdentityViewController alloc] init] animated:NO];
    BackUpWalletViewController * VC = [[BackUpWalletViewController alloc] init];
    VC.mnemonicType = MnemonicBackup;
    [self.navigationController pushViewController:VC animated:YES];
}
/*
- (void)noBackupAction:(UIButton *)button
{
    button.selected = YES;
    [self.tableView reloadData];
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:If_Skip];
//    [defaults synchronize];
}
 */

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
