//
//  RequestTimeoutViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RequestTimeoutViewController.h"
#import "ListTableViewCell.h"
#import "WechatTool.h"
#import "AdsModel.h"
#import "WKWebViewController.h"

@interface RequestTimeoutViewController ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

//@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITextView * queryLink;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIImageView * adImage;
@property (nonatomic, strong) AdsModel * adsModel;

@end

@implementation RequestTimeoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"TransactionStatus");
    [self setupView];
    [self getData];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
}
- (void)setupHeaderView
{
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    CustomButton * transactionStatus = [[CustomButton alloc] init];
    transactionStatus.layoutMode = VerticalNormal;
    transactionStatus.titleLabel.font = FONT(16);
    [transactionStatus setTitle:Localized(@"TransactionSuccessful") forState:UIControlStateNormal];
    [transactionStatus setTitleColor:COLOR_6 forState:UIControlStateNormal];
    transactionStatus.titleLabel.numberOfLines = 0;
    transactionStatus.titleLabel.textAlignment = NSTextAlignmentCenter;
    [transactionStatus setImage:[UIImage imageNamed:@"assetsSuccess"] forState:UIControlStateNormal];
    transactionStatus.userInteractionEnabled = NO;
    [headerView addSubview:transactionStatus];
//    CGFloat transactionStatusH = 60 + Margin_40 + [Encapsulation rectWithText:transactionStatus.titleLabel.text font:transactionStatus.titleLabel.font textWidth:DEVICE_WIDTH - Margin_60].size.height;
    CGFloat transactionStatusH = 60 + Margin_60;
    [transactionStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(transactionStatusH);
        make.width.mas_equalTo(View_Width_Main);
    }];
    
    self.queryLink = [[UITextView alloc] init];
    self.queryLink.font = FONT(13);
    self.queryLink.textColor = COLOR_9;
    NSString * link = Transaction_Query_Link_Test;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == NO && ![defaults boolForKey:If_Switch_TestNetwork]) {
        link = Transaction_Query_Link;
    }
    NSString * transactionQuery = [NSString stringWithFormat:@"%@ %@ %@", Localized(@"TransactionQueryPrompt"), link, Localized(@"Query")];
    NSMutableAttributedString * attr = [Encapsulation attrWithString:transactionQuery preFont:FONT(13) preColor:COLOR_9 index:Localized(@"transactionQueryPrompt").length sufFont:FONT(13) sufColor:COLOR_9 lineSpacing:LINE_SPACING];
    [attr addAttribute:NSLinkAttributeName value:link range:[transactionQuery rangeOfString:link]];
    self.queryLink.attributedText = attr;
    self.queryLink.linkTextAttributes = @{NSForegroundColorAttributeName: MAIN_COLOR};
    self.queryLink.delegate = self;
    self.queryLink.editable = NO;
    self.queryLink.scrollEnabled = NO;
    self.queryLink.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:self.queryLink];
    [self.queryLink mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(transactionStatus);
        make.top.equalTo(transactionStatus.mas_bottom);
    }];
    
    CGSize maximumSize = CGSizeMake(View_Width_Main, CGFLOAT_MAX);
    CGSize expectSize = [self.queryLink sizeThatFits:maximumSize];
    self.queryLink.size = expectSize;
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 60 + ScreenScale(80) + expectSize.height);
    self.tableView.tableHeaderView = headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return self.adImage.height;
    }
    return Margin_50;
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return Margin_10;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return ContentSizeBottom;
    }
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeWalletDetail];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.title.textColor = COLOR_9;
        cell.detailTitle.textColor = COLOR_6;
        cell.title.text = Localized(@"TransactionSummary");
        cell.detailTitle.text = [NSString stringEllipsisWithStr:self.transactionHash subIndex:SubIndex_hash];
        cell.detail.hidden = NO;
        [cell.detail setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
        cell.detail.userInteractionEnabled = YES;
        [cell.detail addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.detail.hidden = YES;
        [cell.contentView addSubview:self.adImage];
        [self.adImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineView.hidden = YES;
    return cell;
}
- (UIImageView *)adImage
{
    if (!_adImage) {
        _adImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_placehoder"]];
        _adImage.userInteractionEnabled = YES;
        [_adImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adAction)]];
        _adImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _adImage;
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
                [self.adImage sd_setImageWithURL:[NSURL URLWithString:self.adsModel.imageUrl] placeholderImage:[UIImage imageNamed:@"ad_placehoder"]];
            } else {
                self.adImage.hidden = YES;
            }
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
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
        [WechatTool enterWechatMiniProgram];
    } else if ([self.adsModel.type isEqualToString:@"2"]) {
        if (NotNULLString(self.adsModel.url)) {
            WKWebViewController * VC = [[WKWebViewController alloc] init];
            [VC loadWebURLSring: self.adsModel.url];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
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
