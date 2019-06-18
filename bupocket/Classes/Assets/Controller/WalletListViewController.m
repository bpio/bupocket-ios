//
//  WalletListViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/14.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "WalletListViewController.h"
#import "WalletListViewCell.h"
#import "WalletManagementViewController.h"
#import "ImportWalletViewController.h"
#import "MyViewController.h"
#import "BottomAlertView.h"
#import "CreateViewController.h"

@interface WalletListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) WalletModel * currentIdentityModel;

@end

static NSString * const WalletListCellID = @"WalletListCellID";

@implementation WalletListViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"WalletManagement");
    [self setupView];
    [self setupNav];
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    UIButton * imported = [UIButton createButtonWithNormalImage:@"import" SelectedImage:@"import" Target:self Selector:@selector(importedAction)];
    imported.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    imported.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imported];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * walletName = [[[AccountTool shareTool] account] walletName] == nil ? Current_WalletName : [[[AccountTool shareTool] account] walletName];
    NSDictionary * currentIdentity = @{
                                       @"walletName": walletName,
                                       @"walletAddress": [[[AccountTool shareTool] account] walletAddress],
                                       @"walletKeyStore": [[[AccountTool shareTool] account] walletKeyStore],
                                       @"randomNumber": [[[AccountTool shareTool] account] randomNumber]
                                       };
    self.currentIdentityModel = [WalletModel mj_objectWithKeyValues:currentIdentity];
    self.listArray = [NSMutableArray arrayWithArray:[[WalletTool shareTool] walletArray]];
    [self.tableView reloadData];
}
- (void)setupView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (UIButton *)setupHeaderTitle:(NSString *)title ifTopOffect:(BOOL)ifTopOffect
{
    UIButton * titleBtn = [UIButton createButtonWithTitle:title TextFont:FONT_15 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CGFloat top = ifTopOffect ? Margin_5 : 0;
    titleBtn.contentEdgeInsets = UIEdgeInsetsMake(top, Margin_15, 0, 0);
    titleBtn.frame = CGRectMake(0, 0, DEVICE_WIDTH, MAIN_HEIGHT);
    return titleBtn;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return ScreenScale(40);
    } else {
        return ScreenScale(35);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self setupHeaderTitle:Localized(@"CurrentIdentity") ifTopOffect: YES];
    } else if (section == 1) {
        return [self setupHeaderTitle:Localized(@"ImportedWallet") ifTopOffect: NO];
    } else {
        return [[UIView alloc] init];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return ContentSizeBottom;
    }
}
- (void)importedAction
{
    NSArray * titleArray = @[Localized(@"CreateWallet"), Localized(@"ImportWallet")];
    BottomAlertView * alertView = [[BottomAlertView alloc] initWithHandlerArray:titleArray handlerType:HandlerTypeWallet handlerClick:^(UIButton * _Nonnull btn) {
        if ([btn.titleLabel.text isEqualToString:titleArray[0]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CreateViewController * VC = [[CreateViewController alloc] init];
                VC.createType = CreateWallet;
                [self.navigationController pushViewController:VC animated:NO];    
            });
        } else if ([btn.titleLabel.text isEqualToString:titleArray[1]]) {
            ImportWalletViewController * VC = [[ImportWalletViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        }
    } cancleClick:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count > 0 ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.listArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletListViewCell * cell = [WalletListViewCell cellWithTableView:tableView identifier:WalletListCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * currentWalletAddress = CurrentWalletAddress;
    if (indexPath.section == 0) {
        cell.walletModel = self.currentIdentityModel;
        cell.currentUse.hidden = !(currentWalletAddress == nil || [cell.walletModel.walletAddress isEqualToString:currentWalletAddress]);
    } else {
        cell.walletModel = self.listArray[indexPath.row];
    }
    __weak typeof (cell) weakCell = cell;
    cell.manageClick = ^{
        WalletManagementViewController * VC = [[WalletManagementViewController alloc] init];
        VC.walletModel = weakCell.walletModel;
        [self.navigationController pushViewController:VC animated:NO];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WalletListViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cell.walletModel.walletAddress forKey:Current_WalletAddress];
    [defaults setObject:cell.walletModel.walletKeyStore forKey:Current_WalletKeyStore];
    [defaults setObject:cell.walletModel.walletName forKey:Current_WalletName];
    [defaults synchronize];
    
    [self.tableView reloadData];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MyViewController class]]) {
            [self.navigationController.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [self.navigationController popToRootViewControllerAnimated:NO];
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
