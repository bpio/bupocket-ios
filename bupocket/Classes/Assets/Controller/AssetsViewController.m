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
#import "AssetsDetailViewController.h"
#import "AssetsListModel.h"
#import "AddAssetsViewController.h"
#import "HMScannerController.h"
#import "RegisteredAssetsViewController.h"
#import "DistributionOfAssetsViewController.h"
#import "TransactionViewController.h"
#import "WalletListViewController.h"
#import "LoginConfirmViewController.h"
#import "BottomConfirmAlertView.h"
#import "ScanCodeFailureViewController.h"
#import "ReceiveViewController.h"
#import "RegisteredModel.h"
#import "DistributionModel.h"
#import "BackUpWalletViewController.h"
#import "VoucherViewController.h"

#import "LoginConfirmModel.h"
#import "ConfirmTransactionModel.h"
#import "DposModel.h"

#import "UINavigationController+Extension.h"
#import "UITabBar+Extension.h"

#import "DeviceInfo.h"

#import "RedEnvelopesViewController.h"
#import "OpenRedEnvelopes.h"
#import "RedEnvelopesInfo.h"
#import "ActivityResultModel.h"
#import "ActivityInfoModel.h"
#import "DataBase.h"

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
@property (nonatomic, strong) UILabel * safetyTips;
@property (nonatomic, strong) UILabel * safetyTipsTitle;

@property (nonatomic, strong) ConfirmTransactionModel * confirmTransactionModel;
@property (nonatomic, strong) DposModel * dposModel;

@property (nonatomic, strong) UIButton * redEnvelopes;

@property (nonatomic, strong) NSString * redEnvelopesBgUrl;
@property (nonatomic, strong) NSString * activityID;
@property (nonatomic, assign) BOOL isReceived;
@property (nonatomic, assign) BOOL isActivityFinished;
@property (nonatomic, strong) ActivityInfoModel * activityInfoModel;
@property (nonatomic, strong) ActivityResultModel * activityResultModel;

@property (nonatomic, strong) NSString * currentWalletAddress;
@property (nonatomic, strong) NSString * currentCurrency;
@property (nonatomic, strong) NSArray * assetsArray;
@property (nonatomic, strong) NSArray * cacheArray;

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
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self setupNav];
    [self initData];
    [self setupView];
    [self setupRefresh];
    
    NSString * uuid = [KeychainWrapper searchDateWithService:Device_ID];
    NSArray * walletAddressArray = [DeviceInfo getWalletAddressArrayFromKeychain];
    if (!NotNULLString(uuid) || ![walletAddressArray containsObject:CurrentWalletAddress]) {
        [self getDeviceBind];
    } else {
        [self getActivityData];
    }

    [self getVersionData];
    // Do any additional setup after loading the view.
}
- (void)initData
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
    self.assetsArray = (assetsArray) ? assetsArray : [NSArray array];
    self.currentCurrency = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[defaults objectForKey:Current_Currency] integerValue]];
    self.currentWalletAddress = CurrentWalletAddress;
    if (!self.currentWalletAddress) {
        self.currentWalletAddress = [[[AccountTool shareTool] account] purseAccount];
    }
//    是否显示New
//    if ([defaults objectForKey:If_Hidden_New]) {
//        [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex:1];
//    } else {
//        [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:1 tabbarNum:self.navigationController.tabBarController.viewControllers.count];
//    }
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
    if (self.listArray.count == 0) {
        [self getCacheData];
    }
    [[HTTPManager shareManager] getAssetsDataWithAddress:self.currentWalletAddress currencyType:self.currentCurrency tokenList:self.assetsArray success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * array = responseObject[@"data"] [@"tokenList"];
            self.listArray = [NSMutableArray arrayWithArray:[AssetsListModel mj_objectArrayWithKeyValuesArray:array]];
            if (![array isEqualToArray:self.cacheArray]) {
                [[DataBase shareDataBase] deleteCachedDataWithCacheType:CacheTypeAssets];
                [[DataBase shareDataBase] saveDataWithArray:array cacheType:CacheTypeAssets];
            }
            [self reloadUI];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = YES;
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
- (void)getCacheData
{
    self.cacheArray = [[DataBase shareDataBase] getCachedDataWithCacheType:CacheTypeAssets];
    if (self.cacheArray.count > 0) {
        self.listArray = [NSMutableArray arrayWithArray:[AssetsListModel mj_objectArrayWithKeyValuesArray:self.cacheArray]];
        [self reloadUI];
        [self.tableView.mj_header endRefreshing];
        self.noNetWork.hidden = YES;
    }
}
- (void)reloadUI
{
    [self.tableView addSubview:self.headerBg];
    [self.tableView insertSubview:self.headerBg atIndex:0];
    if (self.listArray.count > 0) {
        AssetsListModel * assetsModel = [self.listArray firstObject];
        NSString * amountStr = assetsModel.assetAmount;
        if ([amountStr isEqualToString:@"~"]) {
            self.totalAssets.text = amountStr;
        } else {
            NSString * currencyUnit = [AssetCurrencyModel getCurrencyUnitWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
            NSString * amountString = [NSString stringWithFormat:@"≈%@%@", amountStr, currencyUnit];
            NSMutableAttributedString * attr = [Encapsulation attrWithString:amountString preFont:FONT(36) preColor:[UIColor whiteColor] index:amountString.length - currencyUnit.length sufFont:FONT(18) sufColor:[UIColor whiteColor] lineSpacing:0];
            [attr addAttribute:NSBaselineOffsetAttributeName value:@((FONT(18).lineHeight)/2) range:NSMakeRange(amountString.length - currencyUnit.length, currencyUnit.length)];
            self.totalAssets.attributedText = attr;
        }
    }
    [self setNetworkEnvironment];
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
    [[HTTPManager shareManager] getDataWithURL:Version_Update success:^(id responseObject) {
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
// Device Bind
- (void)getDeviceBind
{
    [[HTTPManager shareManager] getDataWithURL:Device_Bind_Config success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSString * signData = [Tools dataToHexStr:[Keypair sign:[CurrentWalletAddress dataUsingEncoding:NSUTF8StringEncoding] :dataDic[@"sk"]]];
            [[HTTPManager shareManager] getDeviceBindDataWithURL:Device_Bind_Check identityAddress:[[AccountTool shareTool] account].identityAddress walletAddress:CurrentWalletAddress signData:signData publicKey:nil success:^(id responseObject) {
                NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
                if (code == Success_Code) {
                    // 红包数据
                    [self getActivityData];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark activity
- (void)getActivityData
{
    [self getActivityDataWithURL:Activity_Status];
}
- (void)getActivityDataWithURL:(NSString *)URL
{
    BOOL isActivityStatus = [URL isEqualToString:Activity_Status];
    BOOL isReceiveStatus = [URL isEqualToString:Activity_Bonus_Status];
    [[HTTPManager shareManager] getActivityDataWithURL:URL bonusCode:self.activityID success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        // 活动已关闭
        if (code == 100021) {
            self.redEnvelopes.hidden = YES;
        }
        // 活动是否开启
        if (isActivityStatus) {
            if (code == Success_Code) {
                // 已开启
                NSDictionary * dataDic = [responseObject objectForKey:@"data"];
                self.activityID = dataDic[@"bonusId"];
                [self getActivityDataWithURL:Activity_Bonus_Status];
                [self.redEnvelopes sd_setImageWithURL:[NSURL URLWithString:dataDic[@"bonusEntranceImage"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"grab_redEnvelopes"]];
                self.redEnvelopes.hidden = NO;
            }
        } else if (isReceiveStatus) {
            // 红包是否已领取
            if (code == Success_Code) {
                NSDictionary * dataDic = [responseObject objectForKey:@"data"];
                // 未领取
                self.isReceived = NO;
                self.redEnvelopesBgUrl = dataDic[@"topImage"];
                [self showOpenRedEnvelopes];
            } else if (code == 100022) {
                // 已领取
                self.isReceived = YES;
                [self.redEnvelopes.layer removeAnimationForKey:Shake_Animation];
            }
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
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithErrorCode:code] handler:nil];
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
    [self setupRedEnvelopes];
}
- (void)setupRedEnvelopes
{
    UIImage * image = [UIImage imageNamed:@"grab_redEnvelopes"];
    self.redEnvelopes = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.redEnvelopes addTarget:self action:@selector(redEnvelopesClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.redEnvelopes];
    [self.redEnvelopes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.mas_equalTo(-SafeAreaBottomH - Margin_30);
        make.size.mas_equalTo(image.size);
    }];
    self.redEnvelopes.hidden = YES;
    [self.redEnvelopes setShakeAnimation];
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
            make.bottom.equalTo(operationBtnBg.mas_top).offset(-Margin_20);
            make.size.mas_equalTo(CGSizeMake(btnW, Margin_20));
            make.centerX.equalTo(self.headerViewBg);
        }];
        
        [self.totalAssets mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (void)showOpenRedEnvelopes
{
    OpenRedEnvelopesType openType = (self.isActivityFinished) ? OpenRedEnvelopesNormal : OpenRedEnvelopesDefault;
    OpenRedEnvelopes * alertView = [[OpenRedEnvelopes alloc] initWithOpenType:openType redEnvelopes:self.redEnvelopesBgUrl activityID:self.activityID confrimBolck:^(id  _Nonnull responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self.activityInfoModel = [ActivityInfoModel mj_objectWithKeyValues:dataDic];
            // 已领取
            self.isReceived = YES;
            [self showRedEnvelopesInfo];
            [self.redEnvelopes.layer removeAnimationForKey:Shake_Animation];
        } else if (code == 100023) {
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            // 红包已被领完
            [self.redEnvelopes.layer removeAnimationForKey:Shake_Animation];
            self.isActivityFinished = YES;
            self.redEnvelopesBgUrl = dataDic[@"BonusOverImage"];
            [self showOpenRedEnvelopes];
        } else {
            [MBProgressHUD showTipMessageInWindow:[responseObject objectForKey:@"msg"]];
        }
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)showRedEnvelopesInfo
{
    RedEnvelopesInfo * alertView = [[RedEnvelopesInfo alloc] initWithRedEnvelopesType:RedEnvelopesTypeDefault confrimBolck:^{
        
    } cancelBlock:^{
        
    }];
    alertView.activityInfoModel = self.activityInfoModel;
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
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
//            DLog(@"json = %@", [JsonTool JSONStringWithDictionaryOrArray:[responseObject objectForKey:@"data"]]);
            self.confirmTransactionModel = [ConfirmTransactionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [self getDposData];
        } else if (code == ErrorQRCodeExpired) {
            ScanCodeFailureViewController * VC = [[ScanCodeFailureViewController alloc] init];
            VC.exceptionPromptStr = Localized(@"Overdue");
            VC.promptStr = Localized(@"RefreshQRCode");
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithErrorCode:code] handler:nil];
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
}

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
//        self.confirmTransactionModel.qrRemarkEn = Localized_Language(@"DposContract", EN);
        BottomConfirmAlertView * confirmAlertView = [[BottomConfirmAlertView alloc] initWithIsShowValue:NO handlerType:HandlerTypeTransferDposCommand confirmModel:self.confirmTransactionModel confrimBolck:^{
        } cancelBlock:^{
            
        }];
        confirmAlertView.dposModel = self.dposModel;
        [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    } else {
        [MBProgressHUD showTipMessageInWindow:Localized(@"ScanFailure")];
    }
}

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
        if (![defaults boolForKey:If_Backup]) {
            return ScreenScale(110) + self.safetyTipsTitle.size.height + self.safetyTips.size.height;
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
                make.left.equalTo(backupBg.mas_left).offset(Margin_10);
                make.size.mas_equalTo(self.safetyTipsTitle.size);
            }];
            
            [backupBg addSubview:self.safetyTips];
            [self.safetyTips mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.safetyTipsTitle.mas_bottom).offset(Margin_10);
                make.left.equalTo(backupBg.mas_left).offset(Margin_10);
                make.size.mas_equalTo(self.safetyTips.size);
            }];
            
            CustomButton * backup = [[CustomButton alloc] init];
            [backup setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            backup.titleLabel.font = FONT_Bold(15);
            [backup setImage:[UIImage imageNamed:@"backup_arrow"] forState:UIControlStateNormal];
            [backup setTitle:Localized(@"ImmediateBackup") forState:UIControlStateNormal];
            [backup addTarget:self action:@selector(backupAction) forControlEvents:UIControlEventTouchUpInside];
            backup.layoutMode = HorizontalInverted;
            [backupBg addSubview:backup];
            [backup mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.safetyTips.mas_bottom);
                make.right.equalTo(backupBg.mas_right).offset(- Margin_10);
                make.height.mas_equalTo(MAIN_HEIGHT);
                make.bottom.equalTo(backupBg.mas_bottom);
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
        CGSize maximumSize = CGSizeMake(Content_Width_Main, CGFLOAT_MAX);
        CGSize expectSize = [_safetyTips sizeThatFits:maximumSize];
        _safetyTips.size = expectSize;
    }
    return _safetyTips;
}
#pragma mark - backup
- (void)backupAction
{
    BackUpWalletViewController * VC = [[BackUpWalletViewController alloc] init];
    VC.mnemonicType = MnemonicBackup;
    [self.navigationController pushViewController:VC animated:YES];
}
// 点击红包
- (void)redEnvelopesClick:(UIButton *)button
{
    if (self.isReceived) {
        // 缓存中有红包id
        if (NotNULLString(self.activityID)) {
            RedEnvelopesViewController * VC = [[RedEnvelopesViewController alloc] init];
            VC.activityID = self.activityID;
            [self.navigationController pushViewController:VC animated:YES];
        }
    } else {
        [self showOpenRedEnvelopes];
    }
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
