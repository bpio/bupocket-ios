//
//  RegisteredAssetsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RegisteredAssetsViewController.h"
#import "PurseCipherAlertView.h"
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
    NSURL* url = [[NSURL alloc] initWithString:[HTTPManager shareManager].pushMessageSocketUrl];
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    self.socket = self.manager.defaultSocket;
    __weak typeof(self) weakself = self;
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [weakself.socket emit:Register_Join with:@[weakself.uuid]];
    }];
    [self.socket on:Register_Join callback:^(NSArray* data, SocketAckEmitter* ack) {
        [weakself.socket emit:Register_ScanSuccess with:@[]];
    }];
    [self.socket on:Register_ScanSuccess callback:^(NSArray* data, SocketAckEmitter* ack) {
        
    }];
    [self.socket connect];
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
//    self.scrollView.scrollsToTop = NO;
    //    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    //    self.noDataBtn = [Encapsulation showNoDataWithSuperView:self.view frame:self.view.frame];
    //    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view frame:self.view.frame target:self action:@selector(getDataWithtxt_text:pageindex:)];
    
    CustomButton * confirmationPrompt = [[CustomButton alloc] init];
    confirmationPrompt.layoutMode = VerticalNormal;
    confirmationPrompt.titleLabel.font = TITLE_FONT;
    [confirmationPrompt setTitle:Localized(@"ConfirmRegistrationInformation") forState:UIControlStateNormal];
    [confirmationPrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [confirmationPrompt setImage:[UIImage imageNamed:@"AssetsConfirmation"] forState:UIControlStateNormal];
    [self.scrollView addSubview:confirmationPrompt];
    [confirmationPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScreenScale(150));
    }];
    
    self.registeredArray = [NSMutableArray arrayWithArray:@[@{Localized(@"TokenName"): self.registeredModel.name}, @{Localized(@"TokenCode"): self.registeredModel.code}, @{Localized(@"DistributionCost"): Registered_CostBU}]];
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
    if (self.registeredModel.amount == 0) {
        [self.registeredArray insertObject:@{Localized(@"TotalAmountOfToken"): Localized(@"UnrestrictedIssue")} atIndex:2];
    } else {
        [self.registeredArray insertObject:@{Localized(@"TotalAmountOfToken"): amount} atIndex:2];
    }
    
    CGFloat assetInfoBgH = Margin_10 + [self.registeredArray count] * Margin_40;
    
    UIView * assetInfoBg = [[UIView alloc] init];
    [self.scrollView addSubview:assetInfoBg];
    CGSize size = CGSizeMake(DEVICE_WIDTH - Margin_24, assetInfoBgH);
    [assetInfoBg setViewSize:size borderWidth:LINE_WIDTH borderColor:COLOR(@"E3E3E3") borderRadius:ScreenScale(5)];
    [assetInfoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmationPrompt.mas_bottom).offset(Margin_20);
        //        make.left.mas_equalTo(Margin_12);
        //        make.right.mas_equalTo(-Margin_12);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];
    for (NSInteger i = 0; i < [self.registeredArray count]; i++) {
        NSString * titleStr = [[self.registeredArray[i] allKeys] firstObject];
        UIView * assetInfo = [self setAssetInfoWithTitle:titleStr info:self.registeredArray[i][titleStr]];
        [assetInfoBg addSubview:assetInfo];
        [assetInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(assetInfoBg.mas_top).offset(ScreenScale(5) + Margin_40 * i);
            make.left.right.equalTo(assetInfoBg);
            make.height.mas_equalTo(Margin_40);
        }];
    }
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_24, MAIN_HEIGHT);
    UIButton * confirmation = [UIButton createButtonWithTitle:Localized(@"ConfirmationOfRegistration") isEnabled:YES Target:self Selector:@selector(confirmationAction)];
//    [confirmation setViewSize:btnSize borderWidth:0 borderColor:nil borderRadius:MAIN_FILLET];
    [self.scrollView addSubview:confirmation];
    [confirmation mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(DEVICE_HEIGHT - ScreenScale(145) - SafeAreaBottomH - NavBarH);
        make.top.equalTo(assetInfoBg.mas_bottom).offset(Margin_50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel")isEnabled:YES Target:self Selector:@selector(cancelAction)];
//    [cancel setViewSize:btnSize borderWidth:0 borderColor:nil borderRadius:MAIN_FILLET];
    cancel.backgroundColor = COLOR(@"A4A8CE");
    [self.scrollView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmation.mas_bottom).offset(Margin_20);
        make.size.centerX.equalTo(confirmation);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, CGRectGetMaxY(cancel.frame) + Margin_50);
}

- (void)confirmationAction
{
    int64_t amount = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:Registered_Cost];
    if (amount < 0) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"RegisteredNotSufficientFunds")];
        return;
    }
    [self.socket emit:Register_Processing with:@[]];
    PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithType:PurseCipherNormalType confrimBolck:^(NSString * _Nonnull password) {
        [self getRegisteredDataWithPassword:password];
    } cancelBlock:^{
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)getRegisteredDataWithPassword:(NSString *)password
{
    [[HTTPManager shareManager] getRegisteredDataWithPassword:password registeredModel:self.registeredModel success:^(TransactionResultModel *resultModel) {
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
    [[HTTPManager shareManager] getOrderDetailsDataWithHash:self.registeredModel.transactionHash success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == 0) {
            self.registeredModel.registeredFee = responseObject[@"data"][@"txDeatilRespBo"][@"fee"];
            RegisteredResultViewController * VC = [[RegisteredResultViewController alloc] init];
            if (overtime == NO) {
                if (resultModel.errorCode == 0) {
                    VC.state = 0;
                    NSString * json = [self setResultDataWithCode:0 message:@"register success"];
                    [self.socket emit:Register_Success with:@[json]];
                    [self.socket on:Register_Success callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                } else {
                    VC.state = 1;
                    NSString * json = [self setResultDataWithCode:1 message:@"register failure"];
                    [self.socket emit:Register_Failure with:@[json]];
                    [self.socket on:Register_Failure callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                    [MBProgressHUD showTipMessageInWindow:resultModel.errorDesc];
                }
            } else {
                VC.state = 2;
                NSString * json = [self setResultDataWithCode:2 message:@"register timeout"];
                [self.socket emit:Register_Timeout with:@[json]];
                [self.socket on:Register_Timeout callback:^(NSArray* data, SocketAckEmitter* ack) {
                    [self.socket disconnect];
                }];
            }
            VC.registeredModel = self.registeredModel;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [MBProgressHUD showTipMessageInWindow:message];
        }
    } failure:^(NSError *error) {
    }];
}

- (NSString *)setResultDataWithCode:(NSInteger)code message:(NSString *)message
{
    NSDictionary * dic = @{
                           @"name": self.registeredModel.name,
                           @"code": self.registeredModel.code,
//                           @"type": @(self.registeredModel.type),
                           @"total": @(self.registeredModel.amount),
                           @"decimals": @(self.registeredModel.decimals),
                           @"version": ATP_Version,
                           @"desc": self.registeredModel.desc,
                           
                           @"fee": self.registeredModel.registeredFee,
                           @"hash": self.registeredModel.transactionHash,
                           @"address": [AccountTool account].purseAccount,
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
        [self.socket emit:Register_Leave with:@[self.uuid]];
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
        make.left.mas_equalTo(Margin_12);
        make.top.mas_equalTo(Margin_12);
    }];
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = COLOR_6;
    detailLabel.font = FONT(15);
    detailLabel.text = info;
    [assetInfo addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Margin_12);
        make.centerY.equalTo(titleLabel);
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
