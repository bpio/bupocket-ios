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
#import "WalletAddressAlertView.h"
#import "AssetsDetailViewController.h"
#import "AssetsListModel.h"
#import "AddAssetsViewController.h"
#import "HMScannerController.h"
#import "RegisteredAssetsViewController.h"
#import "DistributionOfAssetsViewController.h"
#import "TransferAccountsViewController.h"
#import "WalletManagementViewController.h"
#import "LoginConfirmViewController.h"
#import "ConfirmTransactionAlertView.h"
#import "ScanCodeFailureViewController.h"

#import "RegisteredModel.h"
#import "DistributionModel.h"

#import "LoginConfirmModel.h"
#import "ConfirmTransactionModel.h"


#import "UINavigationController+Extension.h"

#import "NodeTransferSuccessViewController.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"


@interface AssetsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * wallet;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView * headerBg;
@property (nonatomic, strong) UIView * headerViewBg;
@property (nonatomic, strong) UIImageView * headerImageView;
@property (nonatomic, strong) UIImage * headerImage;
//@property (nonatomic, strong) UIButton * noBackup;
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

//@property (nonatomic, strong) ConfirmTransactionAlertView * confirmAlertView;

@property (nonatomic, strong) NSMutableArray * transferInfoArray;

@end

@implementation AssetsViewController

static UIButton * _noBackup;

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)transferInfoArray
{
    if (!_transferInfoArray) {
        _transferInfoArray = [NSMutableArray array];
    }
    return _transferInfoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self setupNav];
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
- (void)setupNav
{
    self.wallet = [UIButton createButtonWithNormalImage:@"nav_wallet_n" SelectedImage:@"nav_wallet_s" Target:self Selector:@selector(walletAction)];
    self.wallet.frame = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    self.wallet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.wallet];
    self.navAlpha = 0;
    self.navBackgroundColor = [UIColor whiteColor];
    self.navTitleColor = self.navTintColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.navigationItem.title = CurrentWalletName ? CurrentWalletName : Current_WalletName;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
        // @(FONT(18).lineHeight)/2 + ((FONT(36).descender - FONT(18).descender)))
        [attr addAttribute:NSBaselineOffsetAttributeName value:@((FONT(18).lineHeight)/2) range:NSMakeRange(amountString.length - currencyUnit.length, currencyUnit.length)];
        self.totalAssets.attributedText = attr;
    }
    [self setNetworkEnvironment];
    [self.tableView reloadData];
}
#pragma mark - Switching Network Environment
- (void)setNetworkEnvironment
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork]) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"TestNetworkPrompt") Target:nil Selector:nil];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
        self.headerImageView.image = [UIImage imageNamed:@"assets_header_test"];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.headerImageView.image = self.headerImage;
    }
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
                [self.navigationController pushViewController:VC animated:NO];
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
            [self.navigationController pushViewController:VC animated:NO];
        } else {
            ScanCodeFailureViewController * VC = [[ScanCodeFailureViewController alloc] init];
            VC.exceptionPromptStr = Localized(@"Overdue");
            VC.promptStr = Localized(@"RefreshQRCode");
            [self.navigationController pushViewController:VC animated:NO];
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
    [self.navigationController pushViewController:VC animated:NO];
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
        [self.totalAssets mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerViewBg.mas_top).offset(StatusBarHeight + MAIN_HEIGHT);
            make.centerX.equalTo(self.headerViewBg);
            make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
        }];
        
        UILabel * totalAssetsTitle = [[UILabel alloc] init];
        totalAssetsTitle.font = FONT(15);
        totalAssetsTitle.textColor = [UIColor whiteColor];
        totalAssetsTitle.text = Localized(@"TotalAssets");
        [self.headerViewBg addSubview:totalAssetsTitle];
        [totalAssetsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.totalAssets.mas_bottom).offset(Margin_10);
            make.centerX.equalTo(self.headerViewBg);
        }];
        
        UIView * operationBtnBg = [[UIView alloc] init];
        operationBtnBg.backgroundColor = [UIColor whiteColor];
        operationBtnBg.layer.masksToBounds = YES;
        operationBtnBg.layer.cornerRadius = MAIN_CORNER;
        [self.headerViewBg addSubview:operationBtnBg];
        [operationBtnBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerViewBg.mas_left).offset(Margin_10);
            make.right.equalTo(self.headerViewBg.mas_right).offset(- Margin_10);
            make.bottom.equalTo(self.headerViewBg);
            make.height.mas_equalTo(ScreenScale(100));
        }];
        
        NSArray * operationArray = @[Localized(@"AssetsDetailScan"), Localized(@"PaymentCode"), Localized(@"AddAssets")];
        CGFloat operationBtnW = (DEVICE_WIDTH - (Margin_15 + Margin_10) * 2) / operationArray.count;
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
                make.left.equalTo(operationBtnBg.mas_left).offset(Margin_15 + operationBtnW * i);
                make.centerY.equalTo(operationBtnBg);
                make.size.mas_equalTo(CGSizeMake(operationBtnW, ScreenScale(80)));
            }];
        }
        _headerBg = headerBg;
    }
    return _headerBg;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    self.navAlpha = (offsetY + _headerViewH) / ScreenScale(80);
    if ((offsetY + _headerViewH) > ScreenScale(80)) {
        self.navTitleColor = self.navTintColor = TITLE_COLOR;
        self.wallet.selected = YES;
        _statusBarStyle = UIStatusBarStyleDefault;
    } else {
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
    WalletManagementViewController * VC = [[WalletManagementViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
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
        if ([stringValue hasPrefix:Account_Center_Prefix]) {
            [self getScanCodeLoginDataWithUUid:[stringValue substringFromIndex:[Account_Center_Prefix length]]];
            return;
        } else if ([stringValue hasPrefix:Dpos_Prefix]) {
            [self getApplyNodeDataWithStr:[stringValue substringFromIndex:[Dpos_Prefix length]]];
            return;
        }
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
                    [weakself.navigationController pushViewController:VC animated:NO];
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
    WalletAddressAlertView * alertView = [[WalletAddressAlertView alloc] initWithWalletAddress:CurrentWalletAddress confrimBolck:^{
        [[UIPasteboard generalPasteboard] setString:CurrentWalletAddress];
        [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}

#pragma mark - add Assets
- (void)addAssetsAcrion
{
    AddAssetsViewController * VC = [[AddAssetsViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
}
#pragma mark - Dpos
- (void)getApplyNodeDataWithStr:(NSString *)str
{
    [[HTTPManager shareManager] getDposApplyNodeDataWithQRcodeSessionId:str success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            ConfirmTransactionModel * confirmTransactionModel = [ConfirmTransactionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [self getDpos:confirmTransactionModel];
        } else if (code == ErrorNoVoteJurisdiction || code == ErrorCommitteeAuthority) {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithNodeErrorCode:code] handler:nil];
        } else {
            ScanCodeFailureViewController * VC = [[ScanCodeFailureViewController alloc] init];
            VC.exceptionPromptStr = Localized(@"Overdue");
            VC.promptStr = Localized(@"RefreshQRCode");
            [self.navigationController pushViewController:VC animated:NO];
        }
    } failure:^(NSError *error) {

    }];
}
- (void)getDpos:(ConfirmTransactionModel *)confirmTransactionModel
{
    ConfirmTransactionAlertView * confirmAlertView = [[ConfirmTransactionAlertView alloc] initWithDpos:confirmTransactionModel confrimBolck:^(NSString * _Nonnull transactionCost) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:confirmTransactionModel.amount];
            NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:transactionCost];
            NSDecimalNumber * totleAmount = [amount decimalNumberByAdding:minTransactionCost];
            NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:[totleAmount stringValue] ifShowLoading:NO];
            NSString * totleAmountStr = [amountNumber stringValue];
            if (!NULLString(totleAmountStr) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
            } else if ([totleAmountStr hasPrefix:@"-"]) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
            } else {
                [self getContractTransactionData:confirmTransactionModel];
            }
        });
    } cancelBlock:^{
        
    }];
    [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}

// Transaction confirmation and submission
- (void)getContractTransactionData:(ConfirmTransactionModel *)confirmTransactionModel
{
    [[HTTPManager shareManager] getContractTransactionWithModel:confirmTransactionModel  success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSString * dateStr = [[responseObject objectForKey:@"data"] objectForKey:@"expiryTime"];
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:[dateStr longLongValue] / 1000];
            NSTimeInterval time = [date timeIntervalSinceNow];
            if (time < 0) {
                [Encapsulation showAlertControllerWithMessage:Localized(@"Overtime") handler:nil];
//                [MBProgressHUD showTipMessageInWindow:Localized(@"Overtime")];
            } else {
                [self showPWAlertView:confirmTransactionModel];
            }
        } else {
            [Encapsulation showAlertControllerWithMessage:[ErrorTypeTool getDescriptionWithNodeErrorCode:code] handler:nil];
//            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
//            [Encapsulation showAlertControllerWithMessage:[NSString stringWithFormat:@"code=%@\nmsg:%@", responseObject[@"errCode"], responseObject[@"msg"]] handler:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)showPWAlertView:(ConfirmTransactionModel *)confirmTransactionModel
{
    PasswordAlertView * PWAlertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"TransactionWalletPWPrompt") walletKeyStore:CurrentWalletKeyStore isAutomaticClosing:YES confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        [self submitTransactionWithPassword:password confirmTransactionModel:confirmTransactionModel];
    } cancelBlock:^{
        
    }];
    [PWAlertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [PWAlertView.PWTextField becomeFirstResponder];
}
- (void)submitTransactionWithPassword:(NSString *)password confirmTransactionModel:(ConfirmTransactionModel *)confirmTransactionModel
{
    __weak typeof(self) weakSelf = self;
    [[HTTPManager shareManager] submitContractTransactionPassword:password success:^(TransactionResultModel *resultModel) {
        weakSelf.transferInfoArray = [NSMutableArray arrayWithObjects:confirmTransactionModel.destAddress, [NSString stringAppendingBUWithStr:confirmTransactionModel.amount], [NSString stringAppendingBUWithStr:resultModel.actualFee], nil];
        if (NULLString(confirmTransactionModel.qrRemark)) {
            [weakSelf.transferInfoArray addObject:confirmTransactionModel.qrRemark];
        }
        [self.transferInfoArray addObject:[DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", resultModel.transactionTime]]];
        if (resultModel.errorCode == Success_Code) {
            NodeTransferSuccessViewController * VC = [[NodeTransferSuccessViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        } else {
            TransferResultsViewController * VC = [[TransferResultsViewController alloc] init];
            VC.state = NO;
            VC.errorCode = resultModel.errorCode;
            VC.errorDesc = resultModel.errorDesc;
            //            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:resultModel.errorCode]];
            VC.transferInfoArray = weakSelf.transferInfoArray;
            [self.navigationController pushViewController:VC animated:NO];
        }
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
    }];
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
        if (![defaults boolForKey:If_Backup] && _noBackup.selected == NO) {
            return ScreenScale(150) + [Encapsulation rectWithText:Localized(@"SafetyTips") font:TITLE_FONT textWidth:DEVICE_WIDTH - Margin_40].size.height;
        } else {
            return Margin_40;
        }
    } else {
        return CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] init];
    if (section == 0) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:If_Backup] && _noBackup.selected == NO) {
            UIView * backupBg = [[UIView alloc] init];
            backupBg.backgroundColor = [UIColor whiteColor];
            backupBg.layer.masksToBounds = YES;
            backupBg.layer.cornerRadius = BG_CORNER;
            [headerView addSubview:backupBg];
            [backupBg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(headerView.mas_top).offset(Margin_10);
                make.left.equalTo(headerView.mas_left).offset(Margin_10);
                make.right.equalTo(headerView.mas_right).offset(- Margin_10);
            }];
            UILabel * safetyTipsTitle = [[UILabel alloc] init];
            safetyTipsTitle.textColor = COLOR_6;
            safetyTipsTitle.font = FONT_Bold(15);
            safetyTipsTitle.text = Localized(@"SafetyTipsTitle");
            [backupBg addSubview:safetyTipsTitle];
            [safetyTipsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(backupBg.mas_top).offset(Margin_15);
                make.left.equalTo(backupBg.mas_left).offset(Margin_10);
                make.right.equalTo(backupBg.mas_right).offset(- Margin_10);
            }];
            
            UILabel * safetyTips = [[UILabel alloc] init];
            safetyTips.textColor = COLOR_6;
            safetyTips.font = TITLE_FONT;
            safetyTips.text = Localized(@"SafetyTips");
            safetyTips.numberOfLines = 0;
            [backupBg addSubview:safetyTips];
            [safetyTips mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(safetyTipsTitle.mas_bottom).offset(Margin_10);
                make.left.right.equalTo(safetyTipsTitle);
            }];
            
            CGFloat btnW = (DEVICE_WIDTH - ScreenScale(65)) / 2;
            _noBackup = [UIButton createButtonWithTitle:Localized(@"TemporaryBackup") TextFont:16 TextNormalColor:COLOR(@"9298BD") TextSelectedColor:COLOR(@"9298BD") Target:self Selector:@selector(noBackupAction:)];
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
            UIButton * backup = [UIButton createButtonWithTitle:Localized(@"ImmediateBackup") TextFont:16 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(backupAction)];
            backup.backgroundColor = MAIN_COLOR;
            backup.layer.masksToBounds = YES;
            backup.layer.cornerRadius = MAIN_CORNER;
            [backupBg addSubview:backup];
            [backup mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(safetyTipsTitle);
                make.size.bottom.equalTo(_noBackup);
            }];
        }
        UILabel * header = [[UILabel alloc] init];
        header.font = FONT(15);
        header.textColor = COLOR_6;
        header.text = Localized(@"MyAssets");
        [headerView addSubview:header];
        [header mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(Margin_10);
            make.bottom.equalTo(headerView);
            make.height.mas_equalTo(Margin_30);
        }];
    }
    return headerView;
}
#pragma mark - backup
- (void)backupAction
{
    [self.navigationController pushViewController:[[MyIdentityViewController alloc] init] animated:NO];
}
- (void)noBackupAction:(UIButton *)button
{
    button.selected = YES;
    [self.tableView reloadData];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:If_Skip];
    [defaults synchronize];
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
    [self.navigationController pushViewController:VC animated:NO];
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
