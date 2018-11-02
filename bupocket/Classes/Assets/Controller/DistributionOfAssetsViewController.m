//
//  DistributionOfAssetsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "DistributionOfAssetsViewController.h"
#import "PurseCipherAlertView.h"
#import "DistributionResultsViewController.h"
@import SocketIO;

@interface DistributionOfAssetsViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) SocketManager * manager;
@property (nonatomic, strong) SocketIOClient * socket;
@property (nonatomic, strong) NSMutableArray * distributionArray;

@end

@implementation DistributionOfAssetsViewController

- (NSMutableArray *)distributionArray
{
    if (!_distributionArray) {
        _distributionArray = [NSMutableArray array];
    }
    return _distributionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"IssueAssetsConfirmation");
    [self setupView];
    [self connectSocket];
    // Do any additional setup after loading the view.
}
- (void)connectSocket
{
    NSURL* url = [[NSURL alloc] initWithString:URLPREFIX_Socket];
    //使用给定的url初始化一个socketIOClient，后面的config是对这个socket的一些配置，比如log设置为YES，控制台会打印连接时的日志等
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    self.socket = self.manager.defaultSocket;
    
    __weak typeof(self) weakself = self;
    //监听是否连接上服务器，正确连接走后面的回调
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        [[weakself.socket emitWithAck:@"join" with:@[@{@"uuID": weakself.uuid}]] timingOutAfter:0 callback:^(NSArray* data) {
            
            
            //            [socket emit:@"update" with:@[@{@"amount": @(cur + 2.50)}]];
        }];
        
        // 私钥验证
        //        [weakself.socket emit:@"processing" with:@[@"测试"]];
        //        [weakself.socket emit:@"releaseSuccess" with:@[@"测试"]];
        //            NSLog(@"连接成功：%@", data);
        //            [socket disconnect];
    }];
    
    //监听new message，这是socketIO官网提供的一个测试用例，大家都可以试试。如果成功连接，会收到data内容。
    [self.socket on:@"join" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"连接成功：%@", data);
        [weakself.socket emit:@"scanSuccess" with:@[@"测试"]];
        //                    double cur = [[data objectAtIndex:0] floatValue];
        //
        //
        //                    [ack with:@[@"Got your currentAmount, ", @"dude"]];
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
    [confirmationPrompt setTitle:Localized(@"ConfirmAssetInformation") forState:UIControlStateNormal];
    [confirmationPrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [confirmationPrompt setImage:[UIImage imageNamed:@"AssetsConfirmation"] forState:UIControlStateNormal];
    [self.scrollView addSubview:confirmationPrompt];
    [confirmationPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScreenScale(150));
    }];
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
    self.distributionArray = [NSMutableArray arrayWithObjects:@{Localized(@"TokenName"): self.distributionModel.assetName}, @{Localized(@"TokenCode"): self.distributionModel.assetCode}, @{Localized(@"TheIssueVolume"): amount}, @{Localized(@"CumulativeCirculation"): self.distributionModel.actualSupply}, @{Localized(@"DistributionCost"): Distribution_CostBU}, nil];
    if ([self.distributionModel.totalSupply longLongValue] == 0) {
    } else {
        [self.distributionArray insertObject:@{Localized(@"TotalAmountOfDistribution"): self.distributionModel.totalSupply} atIndex:4];
    }
    
    UIView * assetInfoBg = [[UIView alloc] init];
    [self.scrollView addSubview:assetInfoBg];
    CGSize size = CGSizeMake(DEVICE_WIDTH - Margin_24, Margin_10 + self.distributionArray.count * Margin_40);
    [assetInfoBg setViewSize:size borderWidth:LINE_WIDTH borderColor:COLOR(@"E3E3E3") borderRadius:ScreenScale(5)];
    [assetInfoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmationPrompt.mas_bottom).offset(Margin_20);
//        make.left.mas_equalTo(Margin_12);
//        make.right.mas_equalTo(-Margin_12);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];
    
    for (NSInteger i = 0; i < self.distributionArray.count; i++) {
        NSString * titleStr = [[self.distributionArray[i] allKeys] firstObject];
        NSString * infoStr = [[self.distributionArray[i] allValues] firstObject];
        UIView * assetInfo = [self setAssetInfoWithTitle:titleStr info:infoStr];
        [assetInfoBg addSubview:assetInfo];
        [assetInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(assetInfoBg.mas_top).offset(ScreenScale(5) + Margin_40 * i);
            make.left.right.equalTo(assetInfoBg);
            make.height.mas_equalTo(Margin_40);
        }];
    }
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_24, MAIN_HEIGHT);
    UIButton * confirmation = [UIButton createButtonWithTitle:Localized(@"ConfirmationOfDistribution") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(confirmationAction)];
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
    NSInteger amount = balance - [HTTPManager getBlockFees] - [Tools BU2MO:Distribution_Cost];
    if (amount < 0) {
        [MBProgressHUD wb_showInfo:@"您的余额不足，发行资产失败!"];
        return;
    }
    // 已登记
    CGFloat isOverFlow = [self.distributionModel.totalSupply floatValue] - [self.distributionModel.actualSupply floatValue] - self.registeredModel.amount;
    if (isOverFlow < 0) {
        [MBProgressHUD wb_showInfo:@"您发行Token的总量与登记总量不符"];
        return;
    }
    [self.socket emit:@"token.issue.processing" with:@[]];
    PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithConfrimBolck:^(NSString * _Nonnull password) {
        [self getIssueAssetDataWithPassword:password];
    } cancelBlock:^{
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)getIssueAssetDataWithPassword:(NSString *)password
{
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
    [HTTPManager getIssueAssetDataWithPassword:password assetCode: self.registeredModel.code assetAmount:amount decimals:self.distributionModel.decimals success:^(TransactionResultModel *resultModel) {
        self.distributionModel.transactionHash = resultModel.transactionHash;
        // 发行成功、失败
        DistributionResultsViewController * VC = [[DistributionResultsViewController alloc] init];
        // 0 失败  1 成功  2 超时
        if (resultModel.errorCode == 0) { // 成功
            VC.state = 0;
            NSString * json = [self setResultDataWithCode:0 message:@"issue success" hash: resultModel.transactionHash];
            [self.socket emit:@"token.issue.success" with:@[json]];
        } else {
            // 直接失败
            VC.state = 1;
            NSString * json = [self setResultDataWithCode:1 message:@"issue failure" hash: resultModel.transactionHash];
            [self.socket emit:@"token.issue.failure" with:@[json]];
            [MBProgressHUD wb_showError:resultModel.errorDesc];
        }
        VC.registeredModel = self.registeredModel;
        VC.distributionModel = self.distributionModel;
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(TransactionResultModel *resultModel) {
        DistributionResultsViewController * VC = [[DistributionResultsViewController alloc] init];
         VC.state = 2;
        NSString * json = [self setResultDataWithCode:2 message:@"issue timeout" hash: resultModel.transactionHash];
        [self.socket emit:@"token.issue.timeout" with:@[json]];
        VC.registeredModel = self.registeredModel;
        VC.distributionModel = self.distributionModel;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
- (NSString *)setResultDataWithCode:(NSInteger)code message:(NSString *)message hash:(NSString *)hash
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setDictionary:@{
                         @"name": self.distributionModel.assetName,
                         @"code": self.distributionModel.assetCode,
                         //                           @"type": @(self.distributionModel.tokenType),
                         @"total": self.distributionModel.totalSupply,
                         @"decimals": @(self.distributionModel.decimals),
                         @"version": self.distributionModel.version,
                         
                         @"fee": Distribution_CostBU,
                         @"hash": hash,
                         @"address": [AccountTool account].purseAccount,
                         @"issueTotal": @(self.registeredModel.amount)
                         }];
    if (self.distributionModel.tokenDescription) {
        [dic setValue:self.distributionModel.tokenDescription forKey:@"desc"];
    }
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
    [self.socket emit:@"token.issue.cancel" with:@[Localized(@"Cancel")]];
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
