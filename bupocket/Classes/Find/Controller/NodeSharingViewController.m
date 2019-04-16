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

@interface NodeSharingViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    UIButton * info = [UIButton createButtonWithTitle:nil TextFont:13 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
    [info setAttributedTitle:[Encapsulation attrWithString:infoStr preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:5] forState:UIControlStateNormal];
    info.userInteractionEnabled = NO;
    info.titleLabel.numberOfLines = 0;
    info.layer.masksToBounds = YES;
    info.layer.cornerRadius = BG_CORNER;
    info.contentEdgeInsets = UIEdgeInsetsMake(Margin_15, Margin_10, Margin_15, Margin_10);
    info.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:info];
    CGFloat infoH = Margin_30 + [Encapsulation getSizeSpaceLabelWithStr:infoStr font:FONT(13) width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:5].height;
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom);
        make.left.equalTo(footerView.mas_left).offset(Margin_10);
        make.right.equalTo(footerView.mas_right).offset(-Margin_10);
        make.height.mas_equalTo(infoH);
    }];
    footerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(40) + infoH);
    self.tableView.tableFooterView = footerView;
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
    SharingCanvassingAlertView * alertView = [[SharingCanvassingAlertView alloc] initWithNodePlanModel:self.nodePlanModel confrimBolck:^(NSString * _Nonnull text) {
        
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
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
