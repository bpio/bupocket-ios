//
//  NodeSharingViewController.m
//  bupocket
//
//  Created by huoss on 2019/4/9.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodeSharingViewController.h"
#import "NodePlanViewCell.h"
#import "SharingCanvassingAlertView.h"

@interface NodeSharingViewController ()<UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@end

static NSString * const NodeSharingID = @"NodeSharingID";

@implementation NodeSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"InvitationToVote");
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self setupFooterView];
}
- (void)setupFooterView
{
    UIView * footerView = [[UIView alloc] init];
    UILabel * title = [[UILabel alloc] init];
    title.text = Localized(@"NodeIntroduction");
    title.font = FONT(13);
    title.textColor = COLOR_9;
    [footerView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.top.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_30, Margin_40));
    }];
    NSString * infoStr = self.nodePlanModel.introduce;
    /*
    UIButton * info = [UIButton createButtonWithTitle:nil TextFont:13 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
    NSAttributedString *htmlString = [Encapsulation attributedStringWithHTMLString:infoStr];
//    [info setAttributedTitle:[Encapsulation attrWithString:infoStr preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:5] forState:UIControlStateNormal];
    [info setAttributedTitle:htmlString forState:UIControlStateNormal];
    info.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    info.userInteractionEnabled = NO;
    info.titleLabel.numberOfLines = 0;
    info.layer.masksToBounds = YES;
    info.layer.cornerRadius = BG_CORNER;
    info.contentEdgeInsets = UIEdgeInsetsMake(Margin_15, Margin_10, Margin_15, Margin_10);
    info.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:info];
    //计算html字符串高度
//    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, htmlString.length)];
    
    CGFloat infoH = Margin_30 + [htmlString boundingRectWithSize:(CGSize){DEVICE_WIDTH - Margin_40, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
//    CGFloat infoH = Margin_30 + [Encapsulation getSizeSpaceLabelWithStr:infoStr font:FONT(13) width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:5].height;
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom);
        make.left.equalTo(footerView.mas_left).offset(Margin_10);
        make.right.equalTo(footerView.mas_right).offset(-Margin_10);
        make.height.mas_equalTo(infoH);
    }];
     */
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(Margin_10, Margin_40, DEVICE_WIDTH - Margin_20, CGFLOAT_MIN)];
//    webView.scrollView.contentInset = UIEdgeInsetsMake(Margin_15, Margin_10, Margin_15, Margin_10);
    webView.delegate = self;
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.URLString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
//    //加载网页
//    [self.wkWebView loadRequest:request];
    
    [webView loadHTMLString:infoStr baseURL:nil];
    [webView sizeToFit];
    webView.layer.masksToBounds = YES;
    webView.layer.cornerRadius = BG_CORNER;
    webView.height = webView.scrollView.contentSize.height;
    [footerView addSubview:webView];
//    footerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(40) + webView.height);
    self.tableView.tableFooterView = footerView;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // webView加载完成，让webView高度自适应内容
    webView.height = webView.scrollView.contentSize.height;
    self.tableView.tableFooterView.height = ScreenScale(40) + webView.height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(80);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodeSharingID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nodePlanModel = self.nodePlanModel;
    cell.shareClick = ^{
        [self shareAction];
    };
    return cell;
}
- (void)shareAction
{
    NSString * path = nil;
    if ([self.nodePlanModel.identityType isEqualToString:NodeType_Consensus]) {
        path = [NSString stringWithFormat:@"%@%@", Validate_Node_Path, self.nodePlanModel.nodeId];
    } else if ([self.nodePlanModel.identityType isEqualToString:NodeType_Ecological]) {
        path = [NSString stringWithFormat:@"%@%@", Kol_Node_Path, self.nodePlanModel.nodeId];
    }
    [[HTTPManager shareManager] getShortLinkDataWithType:@"1" path:path success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSString * shortLink = responseObject[@"data"][@"shortlink"];
            self.nodePlanModel.shortLink = shortLink;
            SharingCanvassingAlertView * alertView = [[SharingCanvassingAlertView alloc] initWithNodePlanModel:self.nodePlanModel confrimBolck:^(NSString * _Nonnull text) {
                
            } cancelBlock:^{
                
            }];
            [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithNodeErrorCode:code]];
        }
    } failure:^(NSError *error) {
    }];
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
