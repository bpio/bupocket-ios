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
    // Do any additional setup after loading the view.
}

- (void)connectSocket
{
    NSURL* url = [[NSURL alloc] initWithString:URLPREFIX_Socket];
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    self.socket = self.manager.defaultSocket;
    __weak typeof(self) weakself = self;
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        [weakself.socket emit:@"token.register.join" with:@[weakself.uuid]];
    }];
    [self.socket on:@"token.register.join" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [weakself.socket emit:@"token.register.scanSuccess" with:@[]];
    }];
    [self.socket on:@"token.register.scanSuccess" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
    }];
    [self.socket connect];
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    //    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.showsHorizontalScrollIndicator = YES;
    //    self.scrollView.showsVerticalScrollIndicator = YES;
    //    scrollView.contentSize = imageView.image.size;
    self.scrollView.contentInset = UIEdgeInsetsMake(NavBarH, 0, SafeAreaBottomH, 0);
    self.scrollView.scrollsToTop = NO;
    //    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    //    self.noDataBtn = [Encapsulation showNoDataWithSuperView:self.view frame:self.view.frame];
    //    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view frame:self.view.frame target:self action:@selector(getDataWithtxt_text:pageindex:)];
    
    CustomButton * confirmationPrompt = [[CustomButton alloc] init];
    confirmationPrompt.layoutMode = VerticalNormal;
    confirmationPrompt.titleLabel.font = FONT(14);
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
//    NSInteger type = self.registeredModel.type;
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
//    NSString * typeName;
    if (self.registeredModel.amount == 0) {
        [self.registeredArray insertObject:@{Localized(@"TotalAmountOfToken"): Localized(@"UnrestrictedIssue")} atIndex:2];
    } else {
//        typeName = Localized(@"IncrementalIssue");
        [self.registeredArray insertObject:@{Localized(@"TotalAmountOfToken"): amount} atIndex:2];
    }
//    [self.registeredArray insertObject:@{Localized(@"DistributionMode"): typeName} atIndex:2];
//  @[@[Localized(@"TokenName"), Localized(@"TokenCode"), Localized(@"DistributionMode"), Localized(@"TotalAmountOfToken"), Localized(@"DistributionCost")], @[self.scanDic[@"data"][@"name"], self.scanDic[@"data"][@"code"], typeName, self.assetsDic[@"totalSupply"], @"0.01 BU"]];
    
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
   
//    // 登记资产确认
//    "ConfirmationOfRegisteredAssets" = "登记资产确认";
//    "ConfirmRegistrationInformation" = "请确认以下登记资产信息";
//    "ConfirmationOfRegistration" = "确认登记";
//    "RegistrationSuccess" = "登记成功";
//    "RegistrationFailure" = "登记失败";
//    "RegistrationTimeout" = "登记超时";
//    "DistributionMode" = "发行方式";
//    // 发行资产确认
//    "IssueAssetsConfirmation" = "发行资产确认";
//    "ConfirmAssetInformation" = "请确认以下发行资产信息";
//    "TokenName" = "Token 名称";
//    "TokenCode" = "Token 代码";
//    "TotalAmountOfToken" = "Token 总量";
//    "DistributionCost" = "发行费用";
//    "ConfirmationOfDistribution" = "确认发行";
//    "DistributionSuccess" = "发行成功";
//    "DistributionFailure" = "发行失败";
//    "DistributionTimeout" = "发行超时";
//    "DistributionPrompt" = "请复制下方哈希地址，前往BUMO浏览器中查询发行结果";
//    "TokenDecimalDigits" = "Token小数位数";
//    "ATPVersion" = "ATP版本";
//    "TokenDescription" = "Token描述";
//    "IssuerAddress" = "发行方地址";
//    "Hash" = "哈希";
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
    UIButton * confirmation = [UIButton createButtonWithTitle:Localized(@"ConfirmationOfRegistration") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(confirmationAction)];
    [confirmation setViewSize:btnSize borderWidth:0 borderColor:nil borderRadius:ScreenScale(4)];
    confirmation.backgroundColor = MAIN_COLOR;
    [self.scrollView addSubview:confirmation];
    [confirmation mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(DEVICE_HEIGHT - ScreenScale(145) - SafeAreaBottomH - NavBarH);
        make.top.equalTo(assetInfoBg.mas_bottom).offset(Margin_50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(cancelAction)];
    [cancel setViewSize:btnSize borderWidth:0 borderColor:nil borderRadius:ScreenScale(4)];
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
    int64_t balance = [HTTPManager getAccountBalance];
    NSInteger amount = balance - [HTTPManager getBlockFees] - [Tools BU2MO:Registered_Cost];
    if (amount < 0) {
        [MBProgressHUD wb_showInfo:@"您的余额不足，发行资产失败!"];
        return;
    }
    [self.socket emit:@"token.register.processing" with:@[]];
    PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithConfrimBolck:^(NSString * _Nonnull password) {
        [self getRegisteredDataWithPassword:password];
    } cancelBlock:^{
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)getRegisteredDataWithPassword:(NSString *)password
{
    [HTTPManager getRegisteredDataWithPassword:password registeredModel:self.registeredModel success:^(TransactionResultModel *resultModel) {
        self.registeredModel.transactionHash = resultModel.transactionHash;
        RegisteredResultViewController * VC = [[RegisteredResultViewController alloc] init];
        if (resultModel.errorCode == 0) {
            VC.state = 0;
            NSString * json = [self setResultDataWithCode:0 message:@"register success" hash: resultModel.transactionHash];
            [self.socket emit:@"token.register.success" with:@[json]];
        } else {
            VC.state = 1;
            NSString * json = [self setResultDataWithCode:1 message:@"register failure" hash: resultModel.transactionHash];
            [self.socket emit:@"token.register.failure" with:@[json]];
            [MBProgressHUD wb_showError:resultModel.errorDesc];
        }
        VC.registeredModel = self.registeredModel;
//        [VC.listArray addObject:self.registeredArray];
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(TransactionResultModel *resultModel) {
        RegisteredResultViewController * VC = [[RegisteredResultViewController alloc] init];
        VC.state = 2;
        NSString * json = [self setResultDataWithCode:2 message:@"register timeout" hash: resultModel.transactionHash];
        [self.socket emit:@"token.register.timeout" with:@[json]];
        VC.registeredModel = self.registeredModel;
//        [VC.listArray addObject:self.registeredArray];
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
- (NSString *)setResultDataWithCode:(NSInteger)code message:(NSString *)message hash:(NSString *)hash
{
    NSDictionary * dic = @{
                           @"name": self.registeredModel.name,
                           @"code": self.registeredModel.code,
//                           @"type": @(self.registeredModel.type),
                           @"total": @(self.registeredModel.amount),
                           @"decimals": @(self.registeredModel.decimals),
                           @"version": @"1.0",
                           @"desc": self.registeredModel.desc,
                           
                           @"fee": Registered_CostBU,
                           @"hash": hash,
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
    [self.socket emit:@"token.register.cancel" with:@[Localized(@"Cancel")]];
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
