//
//  NodeTransferSuccessViewController.m
//  bupocket
//
//  Created by huoss on 2019/4/12.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodeTransferSuccessViewController.h"
#import "NodeTransferSuccessViewCell.h"
#import <WXApi.h>
#import "AdsModel.h"
#import "WKWebViewController.h"

@interface NodeTransferSuccessViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) UIImageView * adImage;
@property (nonatomic, strong) AdsModel * adsModel;

@end

static NSString * const NodeTransferSuccessID = @"NodeTransferSuccessID";

@implementation NodeTransferSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"TransferSuccess");
    self.listArray = @[@[Localized(@"TransferSuccess"), Localized(@"BusinessData"), Localized(@"DataRefreshed")], @[Localized(@"TransferSuccessPrompt"), Localized(@"BusinessDataPrompt"), @""]];
    [self setupView];
    [self getData];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupFooterView];
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
                [self.adImage sd_setImageWithURL:[NSURL URLWithString:self.adsModel.imageUrl] placeholderImage:[UIImage imageNamed:@"ad_placehoder"]];
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
- (void)setupFooterView
{
    UIView * footerView = [[UIView alloc] init];
    self.tableView.tableFooterView = footerView;
    UIButton * prompt = [UIButton buttonWithType:UIButtonTypeCustom];
    prompt.backgroundColor = COLOR(@"F8F8F8");
    [prompt setAttributedTitle:[Encapsulation attrWithString:Localized(@"NodeTransferPrompt") preFont:FONT(13) preColor:COLOR_9 index:0 sufFont:FONT(13) sufColor:COLOR_9 lineSpacing:5.0] forState:UIControlStateNormal];
    prompt.titleLabel.numberOfLines = 0;
    CGFloat promptH = [Encapsulation getSizeSpaceLabelWithStr:Localized(@"NodeTransferPrompt") font:FONT(13) width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:5.0].height + Margin_30;
    [footerView addSubview:prompt];
    prompt.contentEdgeInsets = UIEdgeInsetsMake(Margin_15, Margin_10, Margin_10, Margin_15);
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top);
        make.left.equalTo(footerView.mas_left).offset(Margin_10);
        make.right.equalTo(footerView.mas_right).offset(-Margin_10);
        make.height.mas_equalTo(promptH);
    }];
    prompt.layer.masksToBounds = YES;
    prompt.layer.cornerRadius = MAIN_CORNER;
    
    self.adImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_placehoder"]];
    self.adImage.userInteractionEnabled = YES;
    [self.adImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adAction)]];
    self.adImage.contentMode = UIViewContentModeScaleAspectFit;
    [footerView addSubview:self.adImage];
    [self.adImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prompt.mas_bottom).offset(Margin_20);
        make.left.right.equalTo(prompt);
        make.height.mas_equalTo(self.adImage.height);
    }];
    
    footerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, promptH + SafeAreaBottomH + NavBarH + self.adImage.height + Margin_30);
}

- (void)adAction
{
    if ([self.adsModel.type isEqualToString:@"1"]) {
        WXLaunchMiniProgramReq * launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = XCX_YouPin_Original_ID;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listArray firstObject] count];
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
    return ScreenScale(60) + [Encapsulation rectWithText:self.listArray[1][indexPath.row] font:FONT(13) textWidth:DEVICE_WIDTH - ScreenScale(95)].size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodeTransferSuccessViewCell *cell = [NodeTransferSuccessViewCell cellWithTableView:tableView identifier:NodeTransferSuccessID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = indexPath.row;
    cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"node_transfer_success_%zd", indexPath.row]];
    cell.title.text = self.listArray[0][indexPath.row];
    cell.detail.text = self.listArray[1][indexPath.row];
    if (indexPath.row == [[self.listArray firstObject] count] - 1) {
        cell.lineView.backgroundColor = LINE_COLOR;
    } else {
        cell.lineView.backgroundColor = MAIN_COLOR;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
