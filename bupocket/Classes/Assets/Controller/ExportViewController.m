//
//  ExportViewController.m
//  bupocket
//
//  Created by bupocket on 2019/1/7.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ExportViewController.h"
#import "WalletManagementViewCell.h"
#import "ListTableViewCell.h"
#import "ModifyAlertView.h"
#import "ExportKeystoreViewController.h"
#import "ExportPrivateKeyViewController.h"
#import "BackupMnemonicsViewController.h"

@interface ExportViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

static NSString * const WalletCellID = @"WalletCellID";
static NSString * const ExportCellID = @"ExportCellID";

@implementation ExportViewController

- (NSMutableArray *)walletArray
{
    if (!_walletArray) {
        _walletArray = [NSMutableArray array];
    }
    return _walletArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"Manage");
    if ([self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        self.listArray = @[Localized(@"ExportKeystore"), Localized(@"ExportPrivateKey"), Localized(@"BackupMnemonics")];
    } else {
        self.listArray = @[Localized(@"ExportKeystore"), Localized(@"ExportPrivateKey")];
    }
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(100);
    } else {
        return ScreenScale(60);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || [self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        return CGFLOAT_MIN;
    } else {
        return ScreenScale(200);
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || [self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        return [[UIView alloc] init];
    } else {
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
        CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT);
        UIButton * deleteBtn = [UIButton createButtonWithTitle:Localized(@"DeleteWallet") isEnabled:YES Target:self Selector:@selector(deleteAction)];
        [deleteBtn setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(footerView);
            make.centerX.equalTo(footerView);
            make.size.mas_equalTo(btnSize);
        }];
        return footerView;
    }
}
- (void)deleteAction
{
    if ([self.walletModel.walletAddress isEqualToString:CurrentWalletAddress]) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[[[AccountTool shareTool] account] walletAddress] forKey:Current_WalletAddress];
        [defaults setObject:[[[AccountTool shareTool] account] walletKeyStore] forKey:Current_WalletKeyStore];
        [defaults setObject:[[[AccountTool shareTool] account] walletName] forKey:Current_WalletName];
        [defaults synchronize];
    }
    PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"WalletPWPrompt") walletKeyStore:self.walletModel.walletKeyStore isAutomaticClosing:YES confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        [self.walletArray removeObject:self.walletModel];
        [[WalletTool shareTool] save:self.walletArray];
        [Encapsulation showAlertControllerWithMessage:Localized(@"DeleteWalletSuccessfully") handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    } cancelBlock:^{
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [alertView.PWTextField becomeFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WalletManagementViewCell * cell = [WalletManagementViewCell cellWithTableView:tableView identifier:WalletCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.walletModel = self.walletModel;
        return cell;
    } else {
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView identifier:ExportCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
        cell.title.text = self.listArray[indexPath.row];
        cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"export_list_%zd", indexPath.row]];
        CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(60));
        if (indexPath.row == 0) {
            [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        } else if (indexPath.row == self.listArray.count - 1) {
            [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSIndexPath * walletIndex = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        WalletManagementViewCell * cell = [tableView cellForRowAtIndexPath:walletIndex];
        ModifyAlertView * alertView = [[ModifyAlertView alloc] initWithText:cell.walletName.text confrimBolck:^(NSString * _Nonnull text) {
            if ([RegexPatternTool validateUserName:text]) {
                cell.walletName.text = text;
                if ([self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
                    AccountModel * account = [[AccountModel alloc] init];
                    account = [[AccountTool shareTool] account];
                    account.walletName = text;
                    [[AccountTool shareTool] save:account];
                } else {
                    self.walletModel.walletName = text;
                    [self.walletArray replaceObjectAtIndex:self.index withObject:self.walletModel];
                    [[WalletTool shareTool] save:self.walletArray];
                }
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:text forKey:Current_WalletName];
                [defaults synchronize];
            } else {
                [MBProgressHUD showTipMessageInWindow:Localized(@"WalletNameFormatIncorrect")];
            }
        } cancelBlock:^{
            
        }];
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    } else {
        NSString * walletKeyStore = self.walletModel.walletKeyStore;
        if (indexPath.row == 2) {
            walletKeyStore = @"";
        }
        PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"WalletPWPrompt") walletKeyStore:walletKeyStore isAutomaticClosing:YES confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
            if (indexPath.row == 0) {
                ExportKeystoreViewController * VC = [[ExportKeystoreViewController alloc] init];
                VC.walletModel = self.walletModel;
                [self.navigationController pushViewController:VC animated:NO];
            } else if (indexPath.row == 1) {
                ExportPrivateKeyViewController * VC = [[ExportPrivateKeyViewController alloc] init];
                VC.walletModel = self.walletModel;
                VC.password = password;
                [self.navigationController pushViewController:VC animated:NO];
            } else if (indexPath.row == 2) {
                BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
                VC.mnemonicArray = words;
                [self.navigationController pushViewController:VC animated:NO];
            }
        } cancelBlock:^{
        }];
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        [alertView.PWTextField becomeFirstResponder];
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
