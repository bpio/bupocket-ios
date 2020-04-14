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
@property (nonatomic, strong) NSArray * listArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"Setting");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Show_Switch_Network]) {
        self.listArray = @[Localized(@"MonetaryUnit"), Localized(@"MultiLingual"), Localized(@"SwitchedNetwork")];
    } else {
       self.listArray = @[Localized(@"MonetaryUnit"), Localized(@"MultiLingual")];
    }
    [self setupView];
    
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeDetail];
    [cell.listImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"setting_list_%zd", indexPath.row]] forState:UIControlStateNormal];
    cell.title.text = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 2) {
        cell.detail.hidden = YES;
        cell.detailTitle.text = nil;
        [cell.contentView addSubview:self.switchControl];
        [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin_20);
        }];
    } else {
        cell.detail.hidden = NO;
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MonetaryUnitViewController * VC = [[MonetaryUnitViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.row == 1) {
        MultilingualViewController * VC = [[MultilingualViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (UISwitch *)switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [_switchControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [_switchControl setOn:[[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork] animated:YES];
    }
    return _switchControl;
}
- (void)switchChange:(UISwitch *)sender
{
    NSString * message = Localized(@"OpenedTestNetwork");
    if (sender.on == NO) {
        message = Localized(@"ClosedTestNetwork");
    }
    [Encapsulation showAlertControllerWithMessage:message handler:^ {
        [[HTTPManager shareManager] SwitchedNetworkWithIsTest:sender.on];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
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
