//
//  WalletManagementViewController.m
//  bupocket
//
//  Created by huoss on 2019/1/7.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "WalletManagementViewController.h"
#import "WalletManagementViewCell.h"
#import "ExportViewController.h"
#import "WalletModel.h"

@interface WalletManagementViewController ()<UITableViewDelegate, UITableViewDataSource>
    
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) WalletModel * currentIdentityModel;

@end

static NSString * const WalletManagementCellID = @"WalletManagementCellID";

@implementation WalletManagementViewController

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
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * walletName = [[AccountTool account] walletName] == nil ? @"Wallet-1" : [[AccountTool account] walletName];
    NSDictionary * currentIdentity = @{
                                       @"walletName": walletName,
                                       @"walletAddress": [[AccountTool account] purseAccount],
                                       @"walletKeyStore": [[AccountTool account] purseKey]
                                       };
    self.currentIdentityModel = [WalletModel mj_objectWithKeyValues:currentIdentity];
    self.listArray = [WalletModel mj_objectArrayWithKeyValuesArray: @[@{
                                                                          @"walletName": @"Wallet-2",
                                                                          @"walletAddress": @"walletAddress-2",
                                                                          @"walletKeyStore": [[AccountTool account] purseKey]
                                                                          },
                                                                      @{
                                                                          @"walletName": @"Wallet-3",
                                                                          @"walletAddress": @"walletAddress-3",
                                                                          @"walletKeyStore": [[AccountTool account] purseKey]
                                                                          }]];
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
- (UIButton *)setupHeaderTitle:(NSString *)title
{
    UIButton * titleBtn = [UIButton createButtonWithTitle:title TextFont:15 TextColor:COLOR_6 Target:nil Selector:nil];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_15, 0, 0);
    titleBtn.frame = CGRectMake(0, 0, DEVICE_WIDTH, MAIN_HEIGHT);
    return titleBtn;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return MAIN_HEIGHT;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self setupHeaderTitle:Localized(@"CurrentIdentity")];
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
        return MAIN_HEIGHT;
    } else if (section == self.listArray.count) {
        return SafeAreaBottomH + Margin_10;
    } else {
        return CGFLOAT_MIN;
    }
}
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
- (void)importedAction
{
    
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
    WalletManagementViewCell * cell = [WalletManagementViewCell cellWithTableView:tableView identifier:WalletManagementCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * currentWalletAddress = [[NSUserDefaults standardUserDefaults] objectForKey:Current_WalletAddress];
    if (indexPath.section == 0) {
        cell.walletModel = self.currentIdentityModel;
        cell.currentUse.hidden = !(currentWalletAddress == nil || [cell.walletAddress.text isEqualToString:currentWalletAddress]);
    } else {
        cell.walletModel = self.listArray[indexPath.row];
    }
    __weak typeof (cell) weakCell = cell;
    cell.manageClick = ^{
        ExportViewController * VC = [[ExportViewController alloc] init];
        VC.walletModel = weakCell.walletModel;
        [self.navigationController pushViewController:VC animated:YES];
    };
    return cell;
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
