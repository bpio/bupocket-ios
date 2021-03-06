//
//  RegisteredAssetsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RegisteredAssetsViewController.h"
#import "RegisteredResultViewController.h"
#import "RegisteredModel.h"
@import SocketIO;

@interface RegisteredAssetsViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) SocketManager * manager;
@property (nonatomic, strong) SocketIOClient * socket;
@property (nonatomic, strong) NSMutableArray * registeredArray;

@end

static NSString * const Register_Join = @"token.register.join";
static NSString * const Register_ScanSuccess = @"token.register.scanSuccess";
static NSString * const Register_Processing = @"token.register.processing";
static NSString * const Register_Success = @"token.register.success";
static NSString * const Register_Failure = @"token.register.failure";
static NSString * const Register_Timeout = @"token.register.timeout";
static NSString * const Register_Cancel = @"token.register.Cancel";
static NSString * const Register_Leave = @"leaveRoomForApp";

@implementation RegisteredAssetsViewController

- (NSMutableArray *)registeredArray
{
    if (!_registeredArray) {
        _registeredArray = [NSMutableArray array];
    }
    return _registeredArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ConfirmationOfRegisteredAssets");
    [self setupView];
    [self connectSocket];
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_goback_n" SelectedImage:@"nav_goback_n" Target:self Selector:@selector(cancelAction)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    // Do any additional setup after loading the view.
}

- (void)connectSocket
{
    NSString * urlStr = [HTTPManager shareManager].pushMessageSocketUrl;
    if (NotNULLString(urlStr)) {
        NSURL* url = [[NSURL alloc] initWithString:urlStr];
        self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
        self.socket = self.manager.defaultSocket;
        __weak typeof(self) weakself = self;
        [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            [weakself.socket emit:Register_Join with:[NSArray arrayWithObjects:weakself.uuid, nil]];
        }];
        [self.socket on:Register_Join callback:^(NSArray* data, SocketAckEmitter* ack) {
            [weakself.socket emit:Register_ScanSuccess with:@[]];
        }];
        [self.socket on:Register_ScanSuccess callback:^(NSArray* data, SocketAckEmitter* ack) {
            
        }];
        [self.socket connect];
    }
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
    [self.view addSubview:self.scrollView];
    
    CustomButton * confirmationPrompt = [[CustomButton alloc] init];
    confirmationPrompt.layoutMode = VerticalNormal;
    confirmationPrompt.titleLabel.font = FONT_TITLE;
    [confirmationPrompt setTitle:Localized(@"ConfirmRegistrationInformation") forState:UIControlStateNormal];
    [confirmationPrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [confirmationPrompt setImage:[UIImage imageNamed:@"assetsConfirmation"] forState:UIControlStateNormal];
    confirmationPrompt.titleLabel.numberOfLines = 0;
    confirmationPrompt.titleLabel.textAlignment = NSTextAlignmentCenter;
    confirmationPrompt.userInteractionEnabled = NO;
    [self.scrollView addSubview:confirmationPrompt];
    [confirmationPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(90 + ScreenScale(60));
        make.width.mas_lessThanOrEqualTo(View_Width_Main);
    }];
    
    self.registeredArray = [NSMutableArray arrayWithArray:@[@{Localized(@"TokenName"): self.registeredModel.name}, @{Localized(@"TokenCode"): self.registeredModel.code}, @{Localized(@"DistributionCost"): [NSString stringAppendingBUWithStr:Registered_Cost]}]];
    if ([self.registeredModel.amount longLongValue] == 0) {
        [self.registeredArray insertObject:@{Localized(@"TotalAmountOfToken"): Localized(@"UnrestrictedIssue")} atIndex:2];
    } else {
        [self.registeredArray insertObject:@{Localized(@"TotalAmountOfToken"): self.registeredModel.amount} atIndex:2];
    }
    
    CGFloat assetInfoBgH = Margin_10 + [self.registeredArray count] * Margin_40;
    
    UIView * assetInfoBg = [[UIView alloc] init];
    [self.scrollView addSubview:assetInfoBg];
    CGSize size = CGSizeMake(View_Width_Main, assetInfoBgH);
    [assetInfoBg setViewSize:size borderWidth:LINE_WIDTH borderColor:LINE_COLOR borderRadius:BG_CORNER];
    [assetInfoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmationPrompt.mas_bottom).offset(Margin_20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];
    for (NSInteger i = 0; i < [self.registeredArray count]; i++) {
        NSString * titleStr = [[self.registeredArray[i] allKeys] firstObject];
        UIView * assetInfo = [self setAssetInfoWithTitle:titleStr info:self.registeredArray[i][titleStr]];
        [assetInfoBg addSubview:assetInfo];
        [assetInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(assetInfoBg.mas_top).offset(Margin_5 + Margin_40 * i);
            make.left.right.equalTo(assetInfoBg);
            make.height.mas_equalTo(Margin_40);
        }];
    }
    
    CGSize btnSize = CGSizeMake(View_Width_Main, MAIN_HEIGHT);
    UIButton * confirmation = [UIButton createButtonWithTitle:Localized(@"ConfirmationOfRegistration") isEnabled:YES Target:self Selector:@selector(confirmationAction)];
    [self.scrollView addSubview:confirmation];
    [confirmation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(assetInfoBg.mas_bottom).offset(Margin_50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * cancel = [UIButton createCornerRadiusButtonWithTitle:Localized(@"Cancel")isEnabled:YES Target:self Selector:@selector(cancelAction)];
    [self.scrollView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmation.mas_bottom).offset(Margin_20);
        make.size.centerX.equalTo(confirmation);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(cancel.frame) + ContentSizeBottom + ScreenScale(100));
}

- (void)confirmationAction
{
    NSString * totalAsset = [[[NSDecimalNumber decimalNumberWithString:self.registeredModel.amount] decimalNumberByMultiplyingByPowerOf10: self.registeredModel.decimals] stringValue];
    NSString * intMax = [NSString stringWithFormat: @"%lld", INT64_MAX];
    if ([totalAsset compare:intMax] == NSOrderedDescending) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"RegisteredNumberOverflowMax")];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:Registered_Cost ifShowLoading:YES];
        NSString * amount = [amountNumber stringValue];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!NotNULLString(amount) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
                return;
            }
            if ([amount hasPrefix:@"-"]) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"RegisteredNotSufficientFunds")];
                return;
            }
            [weakSelf.socket emit:Register_Processing with:@[]];
            if (![[HTTPManager shareManager] getRegisteredDataWithRegisteredModel:self.registeredModel]) return;
            TextInputAlertView * alertView = [[TextInputAlertView alloc] initWithInputType:PWTypeTransferRegistered confrimBolck:^(NSString * _Nonnull text, NSArray * _Nonnull words) {
                if (NotNULLString(text)) {
                    [weakSelf submitTransaction];
                }
            } cancelBlock:^{
            }];
            [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
            [alertView.textField becomeFirstResponder];
        }];
    }];
}
- (void)submitTransaction
{
    [[HTTPManager shareManager] submitTransactionWithSuccess:^(TransactionResultModel *resultModel) {
        self.registeredModel.transactionHash = resultModel.transactionHash;
        self.registeredModel.registeredFee = resultModel.actualFee;
        [self loadDataWithIsOvertime:NO resultModel:resultModel];
    } failure:^(TransactionResultModel *resultModel) {
        self.registeredModel.transactionHash = resultModel.transactionHash;
        self.registeredModel.registeredFee = resultModel.actualFee;
        [self loadDataWithIsOvertime:YES resultModel:resultModel];
    }];
}

- (void)loadDataWithIsOvertime:(BOOL)overtime resultModel:(TransactionResultModel *)resultModel
{
    [[HTTPManager shareManager] getTransactionDetailsDataWithHash:self.registeredModel.transactionHash success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.registeredModel.registeredFee = responseObject[@"data"][@"txDeatilRespBo"][@"fee"];
            RegisteredResultViewController * VC = [[RegisteredResultViewController alloc] init];
            if (overtime == NO) {
                if (resultModel.errorCode == Success_Code) {
                    VC.registeredResultState = RegisteredResultSuccess;
                    NSString * json = [self setResultDataWithCode:0 message:@"register success"];
                    [self.socket emit:Register_Success with:[NSArray arrayWithObjects:json, nil]];
                    [self.socket on:Register_Success callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                } else {
                    VC.registeredResultState = RegisteredResultFailure;
                    NSString * json = [self setResultDataWithCode:1 message:@"register failure"];
                    [self.socket emit:Register_Failure with:[NSArray arrayWithObjects:json, nil]];
                    [self.socket on:Register_Failure callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                    [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:resultModel.errorCode]];
                }
            } else {
                VC.registeredResultState = RegisteredResultOvertime;
                NSString * json = [self setResultDataWithCode:2 message:@"register timeout"];
                [self.socket emit:Register_Timeout with:[NSArray arrayWithObjects:json, nil]];
                [self.socket on:Register_Timeout callback:^(NSArray* data, SocketAckEmitter* ack) {
                    [self.socket disconnect];
                }];
            }
            VC.registeredModel = self.registeredModel;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
    } failure:^(NSError *error) {
    }];
}

- (NSString *)setResultDataWithCode:(NSInteger)code message:(NSString *)message
{
    NSDictionary * dic = @{
                           @"name": self.registeredModel.name,
                           @"code": self.registeredModel.code,
                           @"total": self.registeredModel.amount,
                           @"decimals": @(self.registeredModel.decimals),
                           @"version": ATP_Version,
                           @"desc": self.registeredModel.desc,
                           
                           @"fee": self.registeredModel.registeredFee,
                           @"hash": self.registeredModel.transactionHash,
                           @"address": CurrentWalletAddress,
                           };
    NSDictionary * data = @{
                            @"err_code": @(code),
                            @"err_msg": message,
                            @"data": dic
                            };
    NSString * jsonStr = [JsonTool JSONStringWithDictionaryOrArray:data];
    return jsonStr;
}
- (void)cancelAction
{
    [self.socket emit:Register_Cancel with:@[Localized(@"Cancel")]];
    [self.socket on:Register_Cancel callback:^(NSArray* data, SocketAckEmitter* ack) {
        [self.socket emit:Register_Leave with:[NSArray arrayWithObjects:self.uuid, nil]];
    }];
    [self.socket on:Register_Leave callback:^(NSArray* data, SocketAckEmitter* ack) {
        [self.socket disconnect];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)setAssetInfoWithTitle:(NSString *)title info:(NSString *)info
{
    UIView * assetInfo = [[UIView alloc] init];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = COLOR_9;
    titleLabel.font = FONT(15);
    titleLabel.text = title;
    [assetInfo addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Margin_10);
        make.top.mas_equalTo(Margin_10);
    }];
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = COLOR_6;
    detailLabel.font = FONT(15);
    detailLabel.numberOfLines = 2;
    detailLabel.text = info;
    [assetInfo addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Margin_10);
        make.centerY.equalTo(titleLabel);
        make.width.mas_lessThanOrEqualTo(Content_Width_Main - ScreenScale(90));
    }];
    return assetInfo;
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
