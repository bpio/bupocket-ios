//
//  NodeTransferSuccessViewController.m
//  bupocket
//
//  Created by huoss on 2019/4/12.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodeTransferSuccessViewController.h"
#import <WXApi.h>

@interface NodeTransferSuccessViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

static NSString * const NodeTransferSuccessID = @"NodeTransferSuccessID";

@implementation NodeTransferSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"TransferSuccess");
    self.listArray = @[@[Localized(@"TransferSuccess"), Localized(@"BusinessData"), Localized(@"DataRefreshed")], @[Localized(@"TransferSuccessPrompt"), Localized(@"BusinessDataPrompt"), @""]];
    [self setupView];
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
}

- (void)setupFooterView
{
    UIView * footerView = [[UIView alloc] init];
    self.tableView.tableFooterView = footerView;
    UIButton * prompt = [UIButton buttonWithType:UIButtonTypeCustom];
    prompt.backgroundColor = COLOR(@"F8F8F8");
    [prompt setAttributedTitle:[Encapsulation attrWithString:Localized(@"NodeTransferPrompt") preFont:FONT(13) preColor:COLOR_9 index:0 sufFont:FONT(13) sufColor:COLOR_9 lineSpacing:5.0] forState:UIControlStateNormal];
    CGFloat promptH = [Encapsulation getSizeSpaceLabelWithStr:Localized(@"NodeTransferPrompt") font:FONT(13) width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:5.0].height;
    [footerView addSubview:prompt];
    prompt.contentEdgeInsets = UIEdgeInsetsMake(Margin_15, Margin_10, Margin_10, Margin_15);
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(Margin_15);
        make.left.equalTo(footerView.mas_left).offset(Margin_10);
        make.right.equalTo(footerView.mas_right).offset(-Margin_10);
        make.height.mas_equalTo(promptH);
    }];
    prompt.layer.masksToBounds = YES;
    prompt.layer.cornerRadius = MAIN_CORNER;
    
    UIButton * adImage = [UIButton createButtonWithNormalImage:@"banner_placehoder" SelectedImage:@"banner_placehoder" Target:self Selector:@selector(adAction)];
    [footerView addSubview:adImage];
    [adImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prompt.mas_bottom).offset(Margin_20);
        make.left.right.equalTo(prompt);
    }];
    
}

- (void)adAction
{
    WXLaunchMiniProgramReq * launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = SmallRoutine_Original_ID;
    //        launchMiniProgramReq.path = @"";//拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = 0;
    [WXApi sendReq:launchMiniProgramReq];
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
    return ScreenScale(120);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NodeTransferSuccessID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NodeTransferSuccessID];
    }
    //    cell.votingRecordsModel = self.listArray[index];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listArray[0][indexPath.row];
    cell.detailTextLabel.text = self.listArray[1][indexPath.row];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//"TransferSuccess" = "交易成功";
//"TransferSuccessPrompt" = "链上交易已成功";
//"BusinessData" = "业务数据处理中";
//"BusinessDataPrompt" = "业务数据根据链上交易元数据进行分析处理，预计20秒内处理完成";
//"DataRefreshed" = "数据已刷新";
//"NodeTransferPrompt" = "温馨提示：\n节点的投票、撤票等操作链上交易成功后，相关数据的统计有延迟，预计30秒内完成，此为正常现象。";
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
