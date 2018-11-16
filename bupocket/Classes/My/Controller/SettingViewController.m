//
//  SettingViewController.m
//  bupocket
//
//  Created by bupocket on 2018/11/12.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "SettingViewController.h"
#import "MultilingualViewController.h"
#import "MonetaryUnitViewController.h"
#import "ListTableViewCell.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UISwitch * switchControl;

@end

static NSString * const SettingCellID = @"SettingCellID";

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"Setting");
    [self setupView];
    
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView identifier:SettingCellID];
    cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"setting_list_%zd", indexPath.row]];
    cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
    cell.title.text = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 2) {
        cell.detailImage.hidden = YES;
        cell.detailTitle.text = nil;
        [cell.contentView addSubview:self.switchControl];
        [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin_20);
        }];
    } else {
        cell.detailImage.hidden = NO;
        if (indexPath.row == 0) {
            if ([CurrentAppLanguage isEqualToString:ZhHans]) {
                cell.detailTitle.text = Localized(@"SimplifiedChinese");
            } else if ([CurrentAppLanguage isEqualToString:EN]) {
                cell.detailTitle.text = Localized(@"English");
            }
        } else if (indexPath.row == 1) {
            cell.detailTitle.text = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MultilingualViewController * VC = [[MultilingualViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 1) {
        MonetaryUnitViewController * VC = [[MonetaryUnitViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (UISwitch *)switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [_switchControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [_switchControl setOn:YES animated:YES];
        [[HTTPManager shareManager] SwitchedNetworkWithIsTest:YES];
    }
    return _switchControl;
}
- (void)switchChange:(UISwitch *)sender
{
    if (sender.on == YES) {
        [self showAlertWithMessage:Localized(@"OpenedTestNetwork") handler:^(UIAlertAction *action) {
            [[HTTPManager shareManager] SwitchedNetworkWithIsTest:YES];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
        }];
    } else {
        [self showAlertWithMessage:Localized(@"ClosedTestNetwork") handler:^(UIAlertAction *action) {
            [[HTTPManager shareManager] SwitchedNetworkWithIsTest:NO];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
        }];
    }
    sender.on = !sender.on;
}
- (void)showAlertWithMessage:(NSString *)message handler:(void (^)(UIAlertAction * action))handler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleDefault handler:handler];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
