//
//  RequestTimeoutViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RequestTimeoutViewController.h"
#import <WXApi.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "AdsModel.h"
#import "WKWebViewController.h"

@interface RequestTimeoutViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITextView * queryLink;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIButton * adImage;
@property (nonatomic, strong) AdsModel * adsModel;

@end

@implementation RequestTimeoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"TransactionStatus");
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    CustomButton * transactionStatus = [[CustomButton alloc] init];
    transactionStatus.layoutMode = VerticalNormal;
    transactionStatus.titleLabel.font = FONT(16);
    [transactionStatus setTitle:Localized(@"TransactionSuccessful") forState:UIControlStateNormal];
    [transactionStatus setTitleColor:COLOR_6 forState:UIControlStateNormal];
    transactionStatus.titleLabel.numberOfLines = 0;
    transactionStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [transactionStatus setImage:[UIImage imageNamed:@"assetsSuccess"] forState:UIControlStateNormal];
    transactionStatus.userInteractionEnabled = NO;
    [self.scrollView addSubview:transactionStatus];
    [transactionStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScreenScale(100) + [Encapsulation rectWithText:Localized(@"LoginException") font:transactionStatus.titleLabel.font textWidth:DEVICE_WIDTH - Margin_60].size.height);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_60);
    }];
    
    self.queryLink = [[UITextView alloc] init];
    self.queryLink.font = FONT(13);
    self.queryLink.textColor = COLOR_9;
    NSString * link = Transaction_Query_Link;
    NSString * transactionQuery = [NSString stringWithFormat:@"%@%@%@", Localized(@"TransactionQueryPrompt"), link, Localized(@"Query")];
    NSMutableAttributedString * attr = [Encapsulation attrWithString:transactionQuery preFont:FONT(13) preColor:COLOR_9 index:Localized(@"transactionQueryPrompt").length sufFont:FONT(13) sufColor:COLOR_9 lineSpacing:5.0];
    [attr addAttribute:NSLinkAttributeName value:link range:[transactionQuery rangeOfString:link]];
    self.queryLink.attributedText = attr;
    self.queryLink.linkTextAttributes = @{NSForegroundColorAttributeName: MAIN_COLOR};
    self.queryLink.delegate = self;
    self.queryLink.editable = NO;
    self.queryLink.scrollEnabled = NO;
    self.queryLink.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.queryLink];
    [self.queryLink mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(transactionStatus);
        make.top.equalTo(transactionStatus.mas_bottom);
    }];
    
    CustomButton * hash = [[CustomButton alloc] init];
    hash.layoutMode = HorizontalInverted;
    hash.titleLabel.font = TITLE_FONT;
    [hash setTitle:[NSString stringEllipsisWithStr:self.transactionHash subIndex:SubIndex_hash] forState:UIControlStateNormal];
    [hash setTitleColor:COLOR_6 forState:UIControlStateNormal];
    [hash setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
    [hash addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:hash];
    [hash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.queryLink.mas_bottom).offset(Margin_10);
        make.right.mas_equalTo(DEVICE_WIDTH - Margin_15);
        make.height.mas_equalTo(Margin_40);
    }];
    
    UILabel * transactionSummary = [[UILabel alloc] init];
    transactionSummary.font = FONT(13);
    transactionSummary.textColor = COLOR_9;
    transactionSummary.text = Localized(@"TransactionSummary");
    [self.scrollView addSubview:transactionSummary];
    [transactionSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hash);
        make.left.mas_equalTo(Margin_15);
        make.right.mas_lessThanOrEqualTo(hash.mas_left).offset(-Margin_10);
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR(@"F8F8F8");
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hash.mas_bottom).offset(Margin_10);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, Margin_10));
    }];
    
    self.adImage = [UIButton createButtonWithNormalImage:@"ad_placehoder" SelectedImage:@"ad_placehoder" Target:self Selector:@selector(adAction)];
    [self.scrollView addSubview:self.adImage];
    [self.adImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(Margin_15);
        make.left.equalTo(transactionSummary);
        make.right.equalTo(hash);
    }];
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.adImage.frame) + ContentSizeBottom + Margin_10);
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}
- (void)reloadData
{
    [self getData];
}
- (void)getData
{
    [[HTTPManager shareManager] getAdsDataWithURL:AD_URL success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.adsModel = [AdsModel mj_objectWithKeyValues:responseObject[@"data"][@"ad"]];
            if (self.adsModel.imageUrl) {
                [self.adImage sd_setImageWithURL:[NSURL URLWithString:self.adsModel.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ad_placehoder"]];
            } else {
                self.adImage.hidden = YES;
            }
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        self.noNetWork.hidden = NO;
    }];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange
{
    if ([URL.absoluteString isEqualToString:Transaction_Query_Link]) {
        [self copyWithStr:URL.absoluteString];
        return NO;
    }
    return YES;
}
- (void)copyAction
{
    [self copyWithStr:self.transactionHash];
}
- (void)copyWithStr:(NSString *)str
{
    if (str) {
        [[UIPasteboard generalPasteboard] setString:str];
        [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
    }
}
- (void)adAction
{
    if ([self.adsModel.type isEqualToString:@"1"]) {
        WXLaunchMiniProgramReq * launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = SmallRoutine_Original_ID;
        //        launchMiniProgramReq.path = @"";//拉起小程序页面的可带参路径，不填默认拉起小程序首页
        launchMiniProgramReq.miniProgramType = 0;
        [WXApi sendReq:launchMiniProgramReq];
    } else if ([self.adsModel.type isEqualToString:@"2"]) {
        if (NULLString(self.adsModel.url)) {
            WKWebViewController * VC = [[WKWebViewController alloc] init];
            //    VC.navigationItem.title = self.listArray[indexPath.section][indexPath.row];
            [VC loadWebURLSring: self.adsModel.url];
            [self.navigationController pushViewController:VC animated:NO];
        }
    }
}
/*
- (void)setupView
{
    CustomButton * requestTimeout = [[CustomButton alloc] init];
    requestTimeout.layoutMode = VerticalNormal;
    [requestTimeout setTitle:Localized(@"RequestTimeout") forState:UIControlStateNormal];
    // TransferFailure
    [requestTimeout setTitleColor:COLOR_6 forState:UIControlStateNormal];
    requestTimeout.titleLabel.font = FONT(16);
    [requestTimeout setImage:[UIImage imageNamed:@"requestTimeout"] forState:UIControlStateNormal];
    [self.view addSubview:requestTimeout];
    [requestTimeout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NavBarH);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, ScreenScale(120)));
    }];
    // IGotIt
    UIButton * gotIt = [UIButton createButtonWithTitle:Localized(@"IGotIt") isEnabled:YES Target:self Selector:@selector(gotItAction)];
    [self.view addSubview:gotIt];
    [gotIt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(requestTimeout.mas_bottom).offset(Margin_15);
        make.left.equalTo(self.view.mas_left).offset(Margin_20);
        make.right.equalTo(self.view.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (void)gotItAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
