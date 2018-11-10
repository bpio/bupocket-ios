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
#import "ChangePasswordViewController.h"
#import "FeedbackViewController.h"
#import "MultilingualViewController.h"
#import "UINavigationController+Extension.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.listArray = @[Localized(@"ModifyPassword"), Localized(@"Feedback"), Localized(@"MultiLingual"), Localized(@"VersionNumber")];
    
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStyleGrouped];
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
    UIImage * headerImage = [UIImage imageNamed:@"my_header"];
    UIImageView * headerBg = [[UIImageView alloc] initWithImage:headerImage];
    headerBg.userInteractionEnabled = YES;
    CustomButton * userIcon = [[CustomButton alloc] init];
    userIcon.layoutMode = VerticalNormal;
    [userIcon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    userIcon.titleLabel.font = FONT(16);
    [userIcon setTitle:[AccountTool account].identityName forState:UIControlStateNormal];
    [userIcon setImage:[UIImage imageNamed:@"userIcon_placeholder"] forState:UIControlStateNormal];
    [userIcon addTarget:self action:@selector(userIconAction) forControlEvents:UIControlEventTouchUpInside];
//    [UIButton createButtonWithTitle:@"用户名" TextFont:16 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] NormalImage:@"userIcon_placeholder" SelectedImage:@"userIcon_placeholder" Target:self Selector:@selector(userIconAction:)];
//    [VerticalButton buttonWithTitle:@"用户名" titleColor:[UIColor whiteColor] titleFont:16 imageName:@"userIcon_placeholder" target:self action:@selector(userIconAction:) btnTag:0];
    [headerBg addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(headerBg);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    CGFloat headerH = ScreenScale(375 * headerImage.size.height / headerImage.size.width);
    headerBg.bounds = CGRectMake(0, 0, DEVICE_WIDTH, headerH);
    self.tableView.tableHeaderView = headerBg;
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
    return SafeAreaBottomH + NavBarH + Margin_10;
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView];
    cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"my_list_%zd", indexPath.row]];
    cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
    cell.title.text = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && indexPath.row == self.listArray.count - 1) {
        cell.detailImage.hidden = YES;
        NSString * currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        cell.detailTitle.text = [NSString stringWithFormat:@"V%@", currentVersion];
    } else {
        cell.detailImage.hidden = NO;
        cell.detailTitle.text = nil;
    }
    /*
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCellID];;
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"my_list_%zd", indexPath.row]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(Margin_15);
        make.centerY.equalTo(cell.contentView);
        make.width.height.mas_equalTo(Margin_20);
    }];// 
    cell.textLabel.text = self.listArray[0][indexPath.row];
    cell.textLabel.font = FONT(15);
    cell.textLabel.textColor = COLOR_6;
    cell.detailTextLabel.font = FONT(15);
    cell.detailTextLabel.textColor = COLOR_6;
    if (indexPath.section == 0 && indexPath.row == [[self.listArray firstObject] count] - 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString * currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"V%@", currentVersion];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
     */
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ChangePasswordViewController * VC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 1) {
        FeedbackViewController * VC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 2) {
        MultilingualViewController * VC = [[MultilingualViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (void)changeLanguage
{
    self.listArray = @[Localized(@"ModifyPassword"), Localized(@"Feedback"), Localized(@"MultiLingual"), Localized(@"VersionNumber")];
    [self.tableView reloadData];
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
