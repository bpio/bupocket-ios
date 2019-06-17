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
#import "WalletModel.h"
#import "ImportWalletViewController.h"
#import "MyViewController.h"

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
        //        if (self.listArray.count == 0) {
        //            return ScreenScale(115);
        //        } else {
        return MAIN_HEIGHT;
        //        }
    } else {
        return ContentSizeBottom;
    }
}
/*
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
 {
 if (section == 0) {
 UIButton * titleBtn = [self setupHeaderTitle:Localized(@"ImportedWallet")];
 if (self.listArray.count == 0) {
 UIView * importBg = [[UIView alloc] init];
 [importBg addSubview:titleBtn];
 CustomButton * importBtn = [[CustomButton alloc] init];
 [importBtn setTitle:Localized(@"ImmediateImport") forState:UIControlStateNormal];
 [importBtn setImage:[UIImage imageNamed:@"immediateImport"] forState:UIControlStateNormal];
 [importBg addSubview:importBtn];
 importBtn.backgroundColor = MAIN_COLOR;
 importBtn.layer.masksToBounds = YES;
 importBtn.clipsToBounds = YES;
 importBtn.layer.cornerRadius = MAIN_CORNER;
 [importBtn addTarget:self action:@selector(importedAction) forControlEvents:UIControlEventTouchUpInside];
 [importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.equalTo(titleBtn.mas_bottom).offset(Margin_25);
 make.centerX.equalTo(importBg);
 make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - ScreenScale(160), MAIN_HEIGHT));
 }];
 return importBg;
 } else {
 UIButton * importedBtn = [UIButton createButtonWithNormalImage:@"import" SelectedImage:@"import" Target:self Selector:@selector(importedAction)];
 [titleBtn addSubview:importedBtn];
 [importedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
 make.right.equalTo(titleBtn.mas_right).offset(-Margin_15);
 make.top.equalTo(titleBtn);
 make.height.mas_equalTo(MAIN_HEIGHT);
 }];
 return titleBtn;
 }
 } else {
 return [[UIView alloc] init];
 }
 }
 */
- (void)importedAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIView * alertBg = alertController.view.subviews[0].subviews[0].subviews[0];
    alertBg.backgroundColor = [UIColor whiteColor];
    alertBg.layer.cornerRadius = BG_CORNER;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        NSLog(@"点击了取消");
    }];
    [cancelAction setValue:TITLE_COLOR forKey:@"titleTextColor"];
    UIAlertAction * createAction = [UIAlertAction actionWithTitle:@"创建钱包" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [createAction setValue:TITLE_COLOR forKey:@"titleTextColor"];
    UIAlertAction * importAction = [UIAlertAction actionWithTitle:@"导入钱包" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        ImportWalletViewController * VC = [[ImportWalletViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
    }];
    [importAction setValue:TITLE_COLOR forKey:@"titleTextColor"];
    
    [alertController addAction:cancelAction];
    [alertController addAction:createAction];
    [alertController addAction:importAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
        VC.walletArray = self.listArray;
        VC.index = indexPath.row;
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
