//
//  MyViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MyViewController.h"
#import "ListTableViewCell.h"
#import "SubtitleListViewCell.h"

#import "MyIdentityViewController.h"
#import "AddressBookViewController.h"
#import "WalletListViewController.h"

#import "MonetaryUnitViewController.h"
#import "MultilingualViewController.h"
#import "NodeSettingsViewController.h"
#import "TermsOfUseViewController.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"

#import "SettingViewController.h"
#import "ChangePasswordViewController.h"
//#import "UINavigationController+Extension.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIImage * headerImage;
@property (nonatomic, strong) UIImageView * headerBg;
@property (nonatomic, strong) UIButton * networkPrompt;
@property (nonatomic, strong) NSArray * listArray;
// Repeat click interval
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;
// Last click timestamp
@property (nonatomic, assign) NSTimeInterval acceptEventTime;

@property (nonatomic, assign) NSInteger touchCounter;

@end

@implementation MyViewController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImage = [UIImage imageNamed:@"my_header"];
    self.touchCounter = 0;
//    self.listArray = @[Localized(@"Setting"), Localized(@"AddressBook"), Localized(@"WalletManagement"), Localized(@"ModifyIdentityPassword"), Localized(@"Feedback"), Localized(@"VersionNumber")];
    self.listArray = @[@[@""], @[Localized(@"MoneyOfAccount"), Localized(@"DisplayLanguage"), Localized(@"NodeSettings")], @[Localized(@"UserProtocol"), Localized(@"Feedback"), Localized(@"AboutUs")]];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork]) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"TestNetworkPrompt") Target:nil Selector:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
        self.headerBg.image = [UIImage imageNamed:@"my_header_test"];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
        self.headerBg.image = self.headerImage;
    }
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - TabBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
//    self.tableView.backgroundColor = [UIColor whiteColor];
//    [self setupHeaderView];
}
- (void)setupHeaderView
{
    self.headerBg = [[UIImageView alloc] initWithImage:self.headerImage];
    self.headerBg.userInteractionEnabled = YES;
    
//    self.networkPrompt = [[UILabel alloc] init];
//    self.networkPrompt.font = FONT(15);
//    self.networkPrompt.textColor = MAIN_COLOR;
//    self.networkPrompt.numberOfLines = 0;
//    self.networkPrompt.preferredMaxLayoutWidth = DEVICE_WIDTH - Margin_40;
//    [self.headerBg addSubview:self.networkPrompt];
//    [self.networkPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headerBg.mas_top).offset(StatusBarHeight + Margin_10);
//        make.centerX.equalTo(self.headerBg);
//    }];
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
    userName.text = [[AccountTool shareTool] account].identityName;
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
    [self.navigationController pushViewController:VC animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return Margin_10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return ScreenScale(100);
    } else if (section == self.listArray.count - 1) {
        return ContentSizeBottom;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(100))];
        footerView.backgroundColor = [UIColor whiteColor];
        NSArray * array = @[@[Localized(@"AddressBook"), COLOR(@"6D8BFF"), @"addressBookBg_icon"], @[Localized(@"WalletManagement"), COLOR(@"02CA71"), @"walletManageBg_icon"]];
        CGFloat btnW = (DEVICE_WIDTH - Margin_40) / 2;
        CGSize btnSize = CGSizeMake(btnW, ScreenScale(80));
        for (NSInteger i = 0; i < array.count; i ++) {
            UIButton * btn = [UIButton createButtonWithTitle:array[i][0] TextFont:FONT_Bold(18) TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(btnAction:)];
            btn.backgroundColor = array[i][1];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_15, 0, Margin_15);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.tag = i;
            [footerView addSubview:btn];
            [btn setViewSize:btnSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(footerView);
                make.left.equalTo(footerView.mas_left).offset(Margin_15 + (btnW + Margin_10) * i);
                make.size.mas_equalTo(btnSize);
            }];
            UIImageView * bgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:array[i][2]]];
            [btn addSubview:bgIcon];
            [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(btn);
            }];
        }
        return footerView;
    } else {
        return [[UIView alloc] init];
    }
}
- (void)btnAction:(UIButton *)button
{
    if (button.tag == 0) {
        AddressBookViewController * VC = [[AddressBookViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
    } else if (button.tag == 1) {
        WalletListViewController * VC = [[WalletListViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(110);
    } else {
        return ScreenScale(50);
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SubtitleListViewCell * cell = [SubtitleListViewCell cellWithTableView:tableView cellType:SubtitleCellNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.walletName.text = [[AccountTool shareTool] account].identityName;
        cell.walletAddress.text = [NSString stringEllipsisWithStr:[[AccountTool shareTool] account].identityAddress subIndex:SubIndex_Address];
        return cell;
    } else {
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeDetail];
        cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"my_list_%zd_%zd", indexPath.section, indexPath.row]];
//        [cell.detail setImage:[UIImage imageNamed:@"list_arrow"] forState:UIControlStateNormal];
        cell.title.text = self.listArray[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.detailTitle.text = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
            } else if (indexPath.row == 1) {
                if ([CurrentAppLanguage isEqualToString:ZhHans]) {
                    cell.detailTitle.text = Localized(@"SimplifiedChinese");
                } else {
                    // if ([CurrentAppLanguage isEqualToString:EN])
                    cell.detailTitle.text = Localized(@"English");
                }
            }
        }
        //    if (indexPath.row == self.listArray.count - 1) {
        //        cell.detailImage.hidden = YES;
        //        cell.detailTitle.text = [NSString stringWithFormat:@"V%@", App_Version];
        //    } else {
        //        cell.detailImage.hidden = NO;
        //        cell.detailTitle.text = nil;
        //    }
        return cell;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MyIdentityViewController * VC = [[MyIdentityViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MonetaryUnitViewController * VC = [[MonetaryUnitViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        } else if (indexPath.row == 1) {
            MultilingualViewController * VC = [[MultilingualViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        } else if (indexPath.row == 2) {
            NodeSettingsViewController * VC = [[NodeSettingsViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TermsOfUseViewController * VC = [[TermsOfUseViewController alloc] init];
            VC.userProtocolType = UserProtocolDefault;
            [self.navigationController pushViewController:VC animated:NO];
        } else if (indexPath.row == 1) {
            FeedbackViewController * VC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        } else if (indexPath.row == 2) {
            AboutUsViewController * VC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        }
    }
    /*
    if (indexPath.row == 0) {
        SettingViewController * VC = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
    } else if (indexPath.row == 1) {
     
    } else if (indexPath.row == 2) {
     
    } else if (indexPath.row == 3) {
        ChangePasswordViewController * VC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
    } else if (indexPath.row == 4) {
     
    } else if (indexPath.row == self.listArray.count - 1) {
        [self SwitchingNetwork];
    }
     */
}
- (void)SwitchingNetwork {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Show_Switch_Network]) return;
    if (self.acceptEventInterval <= 0) {
        self.acceptEventInterval = 2;
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
    if (self.touchCounter == 4) {
        self.touchCounter = 0;
        NSString * message = Localized(@"SwitchToTestNetwork");
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"NO") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SettingViewController * VC = [[SettingViewController alloc] init];
            [[HTTPManager shareManager] SwitchedNetworkWithIsTest:YES];
            [self.navigationController pushViewController:VC animated:NO];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
