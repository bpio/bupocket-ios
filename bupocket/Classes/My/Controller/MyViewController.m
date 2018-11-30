//
//  MyViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MyViewController.h"
#import "ListTableViewCell.h"
#import "MyIdentityViewController.h"
#import "SettingViewController.h"
#import "ChangePasswordViewController.h"
#import "FeedbackViewController.h"
#import "UINavigationController+Extension.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImage * headerImage;
@property (nonatomic, strong) UIImageView * headerBg;
@property (nonatomic, strong) UILabel * networkPrompt;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong)UITapGestureRecognizer * tapGestureRecognizer;
// Repeat click interval
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;
// Last click timestamp
@property (nonatomic, assign) NSTimeInterval acceptEventTime;

@property (nonatomic, assign) NSInteger touchCounter;

@end

static NSString * const ListCellID = @"ListCellID";

@implementation MyViewController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImage = [UIImage imageNamed:@"my_header"];
    self.touchCounter = 0;
    self.listArray = @[Localized(@"Setting"), Localized(@"ModifyPassword"), Localized(@"Feedback"), Localized(@"VersionNumber")];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork]) {
        self.networkPrompt.text = Localized(@"TestNetworkPrompt");
        self.headerBg.image = [UIImage imageNamed:@"my_header_test"];
    } else {
        self.networkPrompt.text = nil;
        self.headerBg.image = self.headerImage;
    }
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setupHeaderView];
}
- (void)setupHeaderView
{
    self.headerBg = [[UIImageView alloc] initWithImage:self.headerImage];
    self.headerBg.userInteractionEnabled = YES;
    
    self.networkPrompt = [[UILabel alloc] init];
    self.networkPrompt.font = FONT(15);
    self.networkPrompt.textColor = MAIN_COLOR;
    self.networkPrompt.numberOfLines = 0;
    self.networkPrompt.preferredMaxLayoutWidth = DEVICE_WIDTH - Margin_40;
    [self.headerBg addSubview:self.networkPrompt];
    [self.networkPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBg.mas_top).offset(StatusBarHeight + Margin_10);
        make.centerX.equalTo(self.headerBg);
    }];
    UIButton * userIcon = [UIButton createButtonWithNormalImage:@"userIcon_placeholder" SelectedImage:@"userIcon_placeholder" Target:self Selector:@selector(userIconAction)];
    userIcon.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.headerBg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerBg.mas_left).offset(ScreenScale(35));
        make.centerY.equalTo(self.headerBg.mas_bottom).offset(-ScreenScale(64));
        make.height.mas_equalTo(ScreenScale(100));
    }];
    UILabel * userName = [[UILabel alloc] init];
    userName.font = FONT_Bold(18);
    userName.textColor = TITLE_COLOR;
    userName.text = [AccountTool account].identityName;
    [self.headerBg addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userIcon.mas_bottom).offset(Margin_5);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    CGFloat userNameW = [Encapsulation rectWithText:userName.text font:userName.font textHeight:ScreenScale(20)].size.width;
    if (userNameW > ScreenScale(130)) {
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerBg.mas_left).offset(Margin_20);
        }];
    } else {
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(userIcon);
        }];
    }
    CGFloat headerH = ScreenScale(375 * self.headerImage.size.height / self.headerImage.size.width);
//    self.headerBg.bounds = CGRectMake(0, 0, DEVICE_WIDTH, headerH);
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, headerH + Margin_30)];
    [headerView addSubview:self.headerBg];
    [self.headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(headerView);
        make.height.mas_equalTo(headerH);
    }];
    self.tableView.tableHeaderView = headerView;
}
- (void)userIconAction
{
    MyIdentityViewController * VC = [[MyIdentityViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentSizeBottom;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(50);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView identifier:ListCellID];
    cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"my_list_%zd", indexPath.row]];
    cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
    cell.title.text = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.listArray.count - 1) {
        cell.detailImage.hidden = YES;
        NSString * currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        cell.detailTitle.text = [NSString stringWithFormat:@"V%@", currentVersion];
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTaps:)];
        self.tapGestureRecognizer.delegate = self;
        [cell.contentView addGestureRecognizer:self.tapGestureRecognizer];
        
    } else {
        cell.detailImage.hidden = NO;
        cell.detailTitle.text = nil;
    }
    return cell;
}
- (NSTimeInterval)acceptEventInterval
{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}
- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval
{
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)acceptEventTime
{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}
- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime
{
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)handleTaps:(UITapGestureRecognizer *)paramSender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Show_Switch_Network]) return;
    if (self.acceptEventInterval <= 0) {
        self.acceptEventInterval = 3;
    }
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.acceptEventTime >= self.acceptEventInterval);
    if (self.acceptEventInterval > 0) {
        self.acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    if (!needSendAction) {
        self.touchCounter += 1;
    } else {
        self.touchCounter = 0;
    }
//    if (self.touchCounter == 3) {
//        [MBProgressHUD showTipMessageInWindow:@"您已点击4次"];
//    }
    if (self.touchCounter == 4) {
        self.touchCounter = 0;
        NSString * message = Localized(@"SwitchToTestNetwork");
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"NO") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SettingViewController * VC = [[SettingViewController alloc] init];
            [[HTTPManager shareManager] SwitchedNetworkWithIsTest:YES];
            [self.navigationController pushViewController:VC animated:YES];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        SettingViewController * VC = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 1) {
        ChangePasswordViewController * VC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 2) {
        FeedbackViewController * VC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return YES;
    }
    return NO;
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
