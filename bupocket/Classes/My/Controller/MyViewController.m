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

#import "ChangePasswordViewController.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * networkPrompt;
@property (nonatomic, strong) NSMutableArray * listArray;


@end

@implementation MyViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.listArray = [NSMutableArray arrayWithArray:@[@[@""], @[Localized(@"MoneyOfAccount"), Localized(@"DisplayLanguage"), Localized(@"NodeSettings")], @[Localized(@"UserProtocol"), Localized(@"Feedback"), Localized(@"AboutUs")]]];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"CustomEnvironment") Target:nil Selector:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
        self.listArray = [NSMutableArray arrayWithArray:@[@[@""], @[Localized(@"MoneyOfAccount"), Localized(@"DisplayLanguage")], @[Localized(@"UserProtocol"), Localized(@"Feedback"), Localized(@"AboutUs")]]];
    } else if ([defaults boolForKey:If_Switch_TestNetwork]) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"TestNetworkPrompt") Target:nil Selector:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    [self.tableView reloadData];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - TabBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
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
        NSArray * array = @[@[Localized(@"AddressBook"), ADDRESS_COLOR, @"addressBookBg_icon"], @[Localized(@"WalletManagement"), MAIN_COLOR, @"walletManageBg_icon"]];
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
            UIImageView * bgIcon = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:array[i][2]]];
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
        [self.navigationController pushViewController:VC animated:YES];
    } else if (button.tag == 1) {
        WalletListViewController * VC = [[WalletListViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
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
        [cell.listImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"my_list_%zd_%zd", indexPath.section, indexPath.row]] forState:UIControlStateNormal];
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
        cell.lineView.hidden = (indexPath.row == [self.listArray[indexPath.section] count] - 1);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MyIdentityViewController * VC = [[MyIdentityViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MonetaryUnitViewController * VC = [[MonetaryUnitViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) {
            MultilingualViewController * VC = [[MultilingualViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 2) {
            NodeSettingsViewController * VC = [[NodeSettingsViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TermsOfUseViewController * VC = [[TermsOfUseViewController alloc] init];
            VC.userProtocolType = UserProtocolDefault;
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) {
            FeedbackViewController * VC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 2) {
            AboutUsViewController * VC = [[AboutUsViewController alloc] init];
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
