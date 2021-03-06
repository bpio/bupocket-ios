//
//  DistributionOfAssetsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "DistributionOfAssetsViewController.h"
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
    NSString * urlStr = [HTTPManager shareManager].pushMessageSocketUrl;
    if (NotNULLString(urlStr)) {
        NSURL* url = [[NSURL alloc] initWithString:urlStr];
        self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
        self.socket = self.manager.defaultSocket;
        __weak typeof(self) weakself = self;
        [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            [weakself.socket emit:Issue_Join with:[NSArray arrayWithObjects:weakself.uuid, nil]];
        }];
        [self.socket on:Issue_Join callback:^(NSArray* data, SocketAckEmitter* ack) {
            [weakself.socket emit:Issue_ScanSuccess with:@[]];
        }];
        [self.socket on:Issue_ScanSuccess callback:^(NSArray* data, SocketAckEmitter* ack) {
            
        }];
        [self.socket connect];
    }
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    CustomButton * confirmationPrompt = [[CustomButton alloc] init];
    confirmationPrompt.layoutMode = VerticalNormal;
    confirmationPrompt.titleLabel.font = FONT_TITLE;
    [confirmationPrompt setTitle:Localized(@"ConfirmAssetInformation") forState:UIControlStateNormal];
    [confirmationPrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [confirmationPrompt setImage:[UIImage imageNamed:@"assetsConfirmation"] forState:UIControlStateNormal];
    confirmationPrompt.userInteractionEnabled = NO;
    [self.scrollView addSubview:confirmationPrompt];
    [confirmationPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(90 + ScreenScale(60));
        make.width.mas_lessThanOrEqualTo(View_Width_Main);
    }];
    self.distributionArray = [NSMutableArray arrayWithObjects:@{Localized(@"TokenName"): self.distributionModel.assetName}, @{Localized(@"TokenCode"): self.distributionModel.assetCode}, @{Localized(@"TheIssueVolume"): self.registeredModel.amount}, @{Localized(@"CumulativeCirculation"): self.distributionModel.actualSupply}, @{Localized(@"DistributionCost"): [NSString stringAppendingBUWithStr:Distribution_Cost]}, nil];
    if ([self.distributionModel.totalSupply longLongValue] == 0) {
    } else {
        [self.distributionArray insertObject:@{Localized(@"TotalAmountOfDistribution"): self.distributionModel.totalSupply} atIndex:4];
    }
    
    UIView * assetInfoBg = [[UIView alloc] init];
    [self.scrollView addSubview:assetInfoBg];
    CGSize size = CGSizeMake(View_Width_Main, Margin_10 + self.distributionArray.count * Margin_40);
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
    
    CGSize btnSize = CGSizeMake(View_Width_Main, MAIN_HEIGHT);
    UIButton * confirmation = [UIButton createButtonWithTitle:Localized(@"ConfirmationOfDistribution") isEnabled:YES Target:self Selector:@selector(confirmationAction)];
    [self.scrollView addSubview:confirmation];
    [confirmation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(assetInfoBg.mas_bottom).offset(Margin_50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") isEnabled:YES Target:self Selector:@selector(cancelAction)];
    cancel.backgroundColor = DIST_ASSET_CANCEL_BG_COLOR;
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
    NSDecimalNumber * amountNumber = [[NSDecimalNumber decimalNumberWithString:self.registeredModel.amount] decimalNumberByMultiplyingByPowerOf10: self.distributionModel.decimals];
    NSDecimalNumber * actualSupplyNumber = [[NSDecimalNumber decimalNumberWithString:self.distributionModel.actualSupply] decimalNumberByMultiplyingByPowerOf10: self.distributionModel.decimals];
    NSString * issueAsset = [[amountNumber decimalNumberByAdding:actualSupplyNumber] stringValue];
    NSString * intMax = [NSString stringWithFormat: @"%lld", INT64_MAX];
    if ([issueAsset compare:intMax] == NSOrderedDescending) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"IssueNumberOverflowMax")];
        return;
    }
    CGFloat isOverFlow = [self.distributionModel.totalSupply longLongValue] - [self.distributionModel.actualSupply longLongValue] - [self.registeredModel.amount longLongValue];
    if ([self.distributionModel.totalSupply longLongValue] != 0 && isOverFlow < 0) {
        // Your tokens issued exceed the total amount of tokens registered
        [Encapsulation showAlertControllerWithMessage:Localized(@"CirculationExceeded") handler:^ {
            [self cancelAction];
        }];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:Distribution_Cost ifShowLoading:YES];
        NSString * amount = [amountNumber stringValue];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!NotNULLString(amount) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
                return;
            }
            if ([amount hasPrefix:@"-"]) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"DistributionNotSufficientFunds")];
                return;
            }
            int64_t issueAsset = [[[NSDecimalNumber decimalNumberWithString:self.registeredModel.amount] decimalNumberByMultiplyingByPowerOf10: self.distributionModel.decimals] longLongValue];
            if (![[HTTPManager shareManager] getIssueAssetDataWithAssetCode:self.registeredModel.code assetAmount:issueAsset decimals:self.distributionModel.decimals]) return;
            [weakSelf.socket emit:Issue_Processing with:@[]];
            TextInputAlertView * alertView = [[TextInputAlertView alloc] initWithInputType:PWTypeTransferDistribution confrimBolck:^(NSString * _Nonnull text, NSArray * _Nonnull words) {
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
                    [self.socket emit:Issue_Success with:[NSArray arrayWithObjects:json, nil]];
                    [self.socket on:Issue_Success callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                } else {
                    VC.distributionResultState = DistributionResultFailure;
                    NSString * json = [self setResultDataWithCode:1 message:@"issue failure"];
                    [self.socket emit:Issue_Failure with:[NSArray arrayWithObjects:json, nil]];
                    [self.socket on:Issue_Failure callback:^(NSArray* data, SocketAckEmitter* ack) {
                        [self.socket disconnect];
                    }];
                    [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescription:resultModel.errorCode]];
                }
            } else {
                VC.distributionResultState = DistributionResultOvertime;
                NSString * json = [self setResultDataWithCode:2 message:@"issue timeout"];
                [self.socket emit:Issue_Timeout with:[NSArray arrayWithObjects:json, nil]];
                [self.socket on:Issue_Timeout callback:^(NSArray* data, SocketAckEmitter* ack) {
                    [self.socket disconnect];
                }];
            }
            VC.registeredModel = self.registeredModel;
            VC.distributionModel = self.distributionModel;
            [self.navigationController pushViewController:VC animated:YES];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
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
                         @"address": CurrentWalletAddress,
                         @"issueTotal": self.registeredModel.amount
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
        [self.socket emit:Issue_Leave with:[NSArray arrayWithObjects:self.uuid, nil]];
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
