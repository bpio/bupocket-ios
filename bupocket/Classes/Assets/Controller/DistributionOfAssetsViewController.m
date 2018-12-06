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

static NSString * const Issue_Join = @"token.issue.join";
static NSString * const Issue_ScanSuccess = @"token.issue.scanSuccess";
static NSString * const Issue_Processing = @"token.issue.processing";
static NSString * const Issue_Success = @"token.issue.success";
static NSString * const Issue_Failure = @"token.issue.failure";
static NSString * const Issue_Timeout = @"token.issue.timeout";
static NSString * const Issue_Cancel = @"token.issue.Cancel";
static NSString * const Issue_Leave = @"leaveRoomForApp";

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
        [weakself.socket emit:Issue_Join with:@[weakself.uuid]];
    }];
    [self.socket on:Issue_Join callback:^(NSArray* data, SocketAckEmitter* ack) {
        [weakself.socket emit:Issue_ScanSuccess with:@[]];
    }];
    [self.socket on:Issue_ScanSuccess callback:^(NSArray* data, SocketAckEmitter* ack) {
        
    }];
    [self.socket connect];
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
    [self.view addSubview:self.scrollView];
    
    CustomButton * confirmationPrompt = [[CustomButton alloc] init];
    confirmationPrompt.layoutMode = VerticalNormal;
    confirmationPrompt.titleLabel.font = TITLE_FONT;
    [confirmationPrompt setTitle:Localized(@"ConfirmAssetInformation") forState:UIControlStateNormal];
    [confirmationPrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [confirmationPrompt setImage:[UIImage imageNamed:@"assetsConfirmation"] forState:UIControlStateNormal];
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
    CGSize size = CGSizeMake(DEVICE_WIDTH - Margin_20, Margin_10 + self.distributionArray.count * Margin_40);
    [assetInfoBg setViewSize:size borderWidth:LINE_WIDTH borderColor:LINE_COLOR borderRadius:BG_CORNER];
    [assetInfoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmationPrompt.mas_bottom).offset(Margin_20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];
    
    for (NSInteger i = 0; i < self.distributionArray.count; i++) {
        NSString * titleStr = [[self.distributionArray[i] allKeys] firstObject];
        NSString * infoStr = [[self.distributionArray[i] allValues] firstObject];
        UIView * assetInfo = [self setAssetInfoWithTitle:titleStr info:infoStr];
        [assetInfoBg addSubview:assetInfo];
        [assetInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(assetInfoBg.mas_top).offset(Margin_5 + Margin_40 * i);
            make.left.right.equalTo(assetInfoBg);
            make.height.mas_equalTo(Margin_40);
        }];
    }
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_20, MAIN_HEIGHT);
    UIButton * confirmation = [UIButton createButtonWithTitle:Localized(@"ConfirmationOfDistribution") isEnabled:YES Target:self Selector:@selector(confirmationAction)];
    [self.scrollView addSubview:confirmation];
    [confirmation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(assetInfoBg.mas_bottom).offset(Margin_50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") isEnabled:YES Target:self Selector:@selector(cancelAction)];
    cancel.backgroundColor = COLOR(@"A4A8CE");
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
    __weak typeof(self) weakSelf = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        CGFloat amount = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:Distribution_Cost ifShowLoading:YES];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (amount < 0) {
                [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"DistributionNotSufficientFunds")];
                return;
            }
            [weakSelf.socket emit:Issue_Processing with:@[]];
            PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithPrompt:Localized(@"IssueIdentityCipherPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
                [weakSelf getIssueAssetDataWithPassword:password];
            } cancelBlock:^{
            }];
            [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
        }];
    }];
}
- (void)getIssueAssetDataWithPassword:(NSString *)password
{
    NSString * amount = [NSString stringWithFormat:@"%zd", self.registeredModel.amount];
    [[HTTPManager shareManager] getIssueAssetDataWithPassword:password assetCode: self.registeredModel.code assetAmount:amount decimals:self.distributionModel.decimals success:^(TransactionResultModel *resultModel) {
        self.distributionModel.transactionHash = resultModel.transactionHash;
        self.distributionModel.distributionFee = resultModel.actualFee;
        [self loadDataWithIsOvertime:NO resultModel:resultModel];
    } failure:^(TransactionResultModel *resultModel) {
        self.distributionModel.transactionHash = resultModel.transactionHash;
        self.distributionModel.distributionFee = resultModel.actualFee;
        [self loadDataWithIsOvertime:YES resultModel:resultModel];
    }];
}

- (void)loadDataWithIsOvertime:(BOOL)overtime resultModel:(TransactionResultModel *)resultModel
{
    [[HTTPManager shareManager] getTransactionDetailsDataWithHash:self.distributionModel.transactionHash success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.distributionModel.distributionFee = responseObject[@"data"][@"txDeatilRespBo"][@"fee"];
            DistributionResultsViewController * VC = [[DistributionResultsViewController alloc] init];
            if (overtime == NO) {
                if (resultModel.errorCode == Success_Code) { // 成功
                    VC.distributionResultState = DistributionResultSuccess;
                    NSString * json = [self setResultDataWithCode:0 message:@"issue success"];
                    [self.socket emit:Issue_Success with:@[json]];
                    [self.socket on:Issue_Success callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                } else {
                    VC.distributionResultState = DistributionResultFailure;
                    NSString * json = [self setResultDataWithCode:1 message:@"issue failure"];
                    [self.socket emit:Issue_Failure with:@[json]];
                    [self.socket on:Issue_Failure callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                    [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescription:resultModel.errorCode]];
                }
            } else {
                VC.distributionResultState = DistributionResultOvertime;
                NSString * json = [self setResultDataWithCode:2 message:@"issue timeout"];
                [self.socket emit:Issue_Timeout with:@[json]];
                [self.socket on:Issue_Timeout callback:^(NSArray* data, SocketAckEmitter* ack) {
                    [self.socket disconnect];
                }];
            }
            VC.registeredModel = self.registeredModel;
            VC.distributionModel = self.distributionModel;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [[HUDHelper sharedInstance] syncStopLoadingMessage:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
    } failure:^(NSError *error) {
    }];
}
- (NSString *)setResultDataWithCode:(NSInteger)code message:(NSString *)message
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setDictionary:@{
                         @"name": self.distributionModel.assetName,
                         @"code": self.distributionModel.assetCode,
                         @"total": self.distributionModel.totalSupply,
                         @"decimals": @(self.distributionModel.decimals),
                         @"version": self.distributionModel.version,
                         
                         @"fee": self.distributionModel.distributionFee,
                         @"hash": self.distributionModel.transactionHash,
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
    [self.socket emit:Issue_Cancel with:@[Localized(@"Cancel")]];
    [self.socket on:Issue_Cancel callback:^(NSArray* data, SocketAckEmitter* ack) {
        [self.socket emit:Issue_Leave with:@[self.uuid]];
    }];
    [self.socket on:Issue_Leave callback:^(NSArray* data, SocketAckEmitter* ack) {
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
    detailLabel.text = info;
    [assetInfo addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Margin_10);
        make.centerY.equalTo(titleLabel);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - ScreenScale(140));
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
