//
//  WalletListViewController.m
//  bupocket
//
//  Created by bupocket on 2019/6/14.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "WalletListViewController.h"
#import "SubtitleListViewCell.h"
#import "WalletManagementViewController.h"
#import "ImportWalletViewController.h"
//#import "MyViewController.h"
#import "VoucherViewController.h"
#import "BottomAlertView.h"
#import "CreateViewController.h"

@interface WalletListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) WalletModel * currentIdentityModel;

@end

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
    UIButton * addWallet = [UIButton createButtonWithNormalImage:@"import" SelectedImage:@"import" Target:self Selector:@selector(addAction)];
    addWallet.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    addWallet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addWallet];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * walletName = [[[AccountTool shareTool] account] walletName] == nil ? Current_WalletName : [[[AccountTool shareTool] account] walletName];
    NSString * walletIconName = [[[AccountTool shareTool] account] walletIconName] == nil ? Current_Wallet_IconName : [[[AccountTool shareTool] account] walletIconName];
    NSDictionary * currentIdentity = @{
                                       @"walletName": walletName,
                                       @"walletIconName": walletIconName,
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
}
//- (UIButton *)setupHeaderTitle:(NSString *)title index:(NSInteger)index
//{
//    CGFloat top = (index == 0) ? Margin_5 : 0;
//    CGFloat height = Margin_Section_Header - top;
//    UIButton * titleBtn = [UIButton createHeaderButtonWithTitle:title];
//    titleBtn.contentEdgeInsets = UIEdgeInsetsMake(top, Margin_Main, 0, Margin_Main);
//    titleBtn.frame = CGRectMake(0, 0, DEVICE_WIDTH, height);
//    return titleBtn;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return Margin_Section_Header - Margin_5;
    } else {
        return self.listArray.count > 0 ? (Margin_Section_Header - Margin_10) : ScreenScale(180);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton * titleBtn;
    if (section == 0) {
//        return [self setupHeaderTitle:Localized(@"CurrentIdentity") index:section];
        titleBtn = [UIButton createHeaderButtonWithTitle:Localized(@"CurrentIdentity")];
        titleBtn.contentEdgeInsets = UIEdgeInsetsMake(Margin_5, Margin_Main, 0, Margin_Main);
        return titleBtn;
    } else if (section == 1) {
        if (self.listArray.count > 0) {
//            return [self setupHeaderTitle:Localized(@"ImportedWallet") index:section];
            titleBtn = [UIButton createHeaderButtonWithTitle:Localized(@"ImportedWallet")];
            return titleBtn;
        } else {
            UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(180))];
            titleBtn = [UIButton createHeaderButtonWithTitle:Localized(@"ImportedWallet")];
            titleBtn.frame = CGRectMake(0, 0, DEVICE_WIDTH, Margin_Section_Header - Margin_10);
//            UIButton * titleBtn = [self setupHeaderTitle:Localized(@"ImportedWallet") index:section];
            [headerView addSubview:titleBtn];
            UIButton * addBtn = [UIButton createButtonWithTitle:Localized(@"AddWallet") isEnabled:YES Target:self Selector:@selector(addAction)];
            [headerView addSubview:addBtn];
            [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleBtn.mas_bottom).offset(ScreenScale(90));
                make.left.equalTo(headerView.mas_left).offset(Margin_Main);
                make.right.equalTo(headerView.mas_right).offset(-Margin_Main);
                make.height.mas_equalTo(MAIN_HEIGHT);
            }];
            return headerView;
        }
    } else {
        return [[UIView alloc] init];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(95);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return SafeAreaBottomH + NavBarH;
    }
}
- (void)addAction
{
    NSArray * titleArray = @[Localized(@"CreateWallet"), Localized(@"ImportWallet")];
    BottomAlertView * alertView = [[BottomAlertView alloc] initWithHandlerArray:titleArray handlerType:HandlerTypeWallet handlerClick:^(UIButton * _Nonnull btn) {
        if ([btn.titleLabel.text isEqualToString:titleArray[0]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CreateViewController * VC = [[CreateViewController alloc] init];
                VC.createType = CreateWallet;
                [self.navigationController pushViewController:VC animated:YES];    
            });
        } else if ([btn.titleLabel.text isEqualToString:titleArray[1]]) {
            ImportWalletViewController * VC = [[ImportWalletViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    } cancleClick:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    SubtitleListViewCell * cell = [SubtitleListViewCell cellWithTableView:tableView cellType:SubtitleCellDefault];
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
        VC.walletArray = self.listArray;
        VC.index = indexPath.row;
        [self.navigationController pushViewController:VC animated:YES];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SubtitleListViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL isChanged = ![CurrentWalletAddress isEqualToString:cell.walletModel.walletAddress];
    if (isChanged) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:cell.walletModel.walletAddress forKey:Current_WalletAddress];
        [defaults setObject:cell.walletModel.walletKeyStore forKey:Current_WalletKeyStore];
        [defaults setObject:cell.walletModel.walletName forKey:Current_WalletName];
        [defaults setObject:cell.walletModel.walletIconName forKey:Current_Wallet_IconName];
//        [defaults setBool:cell.walletModel.isDeviceBind forKey:Current_Wallet_DecviceBind];
        [defaults synchronize];
        //    [self.tableView reloadData];
    }
    TabBarViewController * tabBarVC = [[TabBarViewController alloc] init];
    NSArray * VCs = self.navigationController.viewControllers;
    if ([[VCs firstObject] isKindOfClass:[VoucherViewController class]]) {
        [tabBarVC setSelectedIndex:1];
    }
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    if (self.changeWallet) {
//        self.changeWallet();
//    }
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
