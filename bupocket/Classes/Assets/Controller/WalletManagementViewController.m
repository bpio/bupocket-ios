//
//  WalletManagementViewController.m
//  bupocket
//
//  Created by bupocket on 2019/6/14.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "WalletManagementViewController.h"
#import "SubtitleListViewCell.h"
#import "ListTableViewCell.h"
#import "WalletDetailsViewController.h"
#import "ExportKeystoreViewController.h"
#import "ExportPrivateKeyViewController.h"
//#import "BackupMnemonicsViewController.h"
#import "BackUpWalletViewController.h"
#import "ChangePasswordViewController.h"

@interface WalletManagementViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

@implementation WalletManagementViewController

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
//    self.walletArray = [NSMutableArray arrayWithArray:[[WalletTool shareTool] walletArray]];
    if (self.walletModel.randomNumber) {
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    if (![self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        UIButton * deleteBtn = [UIButton createFooterViewWithTitle:Localized(@"DeleteWallet") isEnabled:YES Target:self Selector:@selector(deleteAction)];
        [deleteBtn setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        deleteBtn.superview.backgroundColor = self.tableView.backgroundColor;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(85);
    } else {
        return ScreenScale(60);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? CGFLOAT_MIN : Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        if (![self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
//             return ScreenScale(150) + SafeAreaBottomH;
            return ContentInset_Bottom;
        }
        return SafeAreaBottomH;
    } else {
        return CGFLOAT_MIN;
    }
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //    if (section == 0 || [self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
    if (section == 2 && ![self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(150))];
        CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT);
        UIButton * deleteBtn = [UIButton createButtonWithTitle:Localized(@"DeleteWallet") isEnabled:YES Target:self Selector:@selector(deleteAction)];
        [deleteBtn setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
//            make.bottom.equalTo(footerView);
            make.centerX.equalTo(footerView);
            make.size.mas_equalTo(btnSize);
        }];
        return footerView;
    } else {
        return [[UIView alloc] init];
    }
}
 */
- (void)deleteAction
{
    BOOL isCurrentWallet = [self.walletModel.walletAddress isEqualToString:CurrentWalletAddress];
    if (isCurrentWallet) {
        [Encapsulation showAlertControllerWithTitle:Localized(@"ConfirmDeleteWallet") message:Localized(@"DeleteCurrentWallet") confirmHandler:^{
            [self deleteDataIsCurrentWallet:isCurrentWallet];
        }];
    } else {
        [self deleteDataIsCurrentWallet:isCurrentWallet];
    }
}
- (void)deleteDataIsCurrentWallet:(BOOL)isCurrentWallet
{
    TextInputAlertView * alertView = [[TextInputAlertView alloc] initWithInputType:PWTypeDeleteWallet confrimBolck:^(NSString * _Nonnull text, NSArray * _Nonnull words) {
        [self.walletArray removeObject:self.walletModel];
        [[WalletTool shareTool] save:self.walletArray];
        if (isCurrentWallet) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[[AccountTool shareTool] account] walletAddress] forKey:Current_WalletAddress];
            [defaults setObject:[[[AccountTool shareTool] account] walletKeyStore] forKey:Current_WalletKeyStore];
            [defaults setObject:[[[AccountTool shareTool] account] walletName] forKey:Current_WalletName];
            [defaults setObject:[[[AccountTool shareTool] account] walletIconName] forKey:Current_Wallet_IconName];
            [defaults synchronize];
        }
        [Encapsulation showAlertControllerWithMessage:Localized(@"DeleteWalletSuccessfully") handler:^ {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } cancelBlock:^{
    }];
    alertView.walletKeyStore = self.walletModel.walletKeyStore;
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [alertView.textField becomeFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.listArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SubtitleListViewCell * cell = [SubtitleListViewCell cellWithTableView:tableView cellType:SubtitleCellManage];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.walletModel = self.walletModel;
        return cell;
    } else {
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
        if (indexPath.section == 1) {
            [cell.listImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"export_list_%zd", indexPath.row]] forState:UIControlStateNormal];
            cell.title.text = self.listArray[indexPath.row];
            cell.lineView.hidden = indexPath.row == self.listArray.count - 1;
        } else if (indexPath.section == 2) {
            cell.title.text = Localized(@"ModifyPassword");
            [cell.listImage setImage:[UIImage imageNamed:@"change_password"] forState:UIControlStateNormal];
            cell.lineView.hidden = YES;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SubtitleListViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        WalletDetailsViewController * VC = [[WalletDetailsViewController alloc] init];
        VC.walletModel = self.walletModel;
        VC.walletArray = self.walletArray;
        VC.index = self.index;
        VC.returnValueBlock = ^(WalletModel *walletModel) {
            if (NotNULLString(walletModel.walletIconName)) {
                cell.walletImage.image = [UIImage imageNamed:walletModel.walletIconName];
            }
            if (NotNULLString(walletModel.walletName)) {
                cell.walletName.text = walletModel.walletName;
            }
        };
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            BackUpWalletViewController * VC = [[BackUpWalletViewController alloc] init];
            VC.randomNumber = self.walletModel.randomNumber;
            VC.mnemonicType = MnemonicExport;
            [self.navigationController pushViewController:VC animated:YES];
//            if (words.count > 0) {
//                BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
//                VC.mnemonicArray = words;
//                [self.navigationController pushViewController:VC animated:YES];
//            }
            return;
        }
        InputType inputType = PWTypeExportPrivateKey;
        if (indexPath.row == 0) {
            inputType = PWTypeExportKeystore;
        }
//        else if (indexPath.row == 1) {
//            alertView.passwordType = PWTypeExportPrivateKey;
//        }
        TextInputAlertView * alertView = [[TextInputAlertView alloc] initWithInputType:inputType confrimBolck:^(NSString * _Nonnull text, NSArray * _Nonnull words) {
            if (indexPath.row == 0) {
                ExportKeystoreViewController * VC = [[ExportKeystoreViewController alloc] init];
                VC.walletModel = self.walletModel;
                [self.navigationController pushViewController:VC animated:YES];
            } else if (indexPath.row == 1) {
                if (NotNULLString(text)) {
                    ExportPrivateKeyViewController * VC = [[ExportPrivateKeyViewController alloc] init];
                    VC.walletModel = self.walletModel;
                    VC.password = text;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            }
//            else if (indexPath.row == 2) {
//                if (words.count > 0) {
//                    BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
//                    VC.mnemonicArray = words;
//                    [self.navigationController pushViewController:VC animated:YES];
//                }
//            }
        } cancelBlock:^{
        }];
//        if (indexPath.row == 2) {
//            alertView.passwordType = PWTypeBackUpID;
//            alertView.randomNumber = self.walletModel.randomNumber;
//        } else {
            alertView.walletKeyStore = self.walletModel.walletKeyStore;
        
//        }
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        [alertView.textField becomeFirstResponder];
    } else if (indexPath.section == 2) {
        ChangePasswordViewController * VC = [[ChangePasswordViewController alloc] init];
        VC.walletModel = self.walletModel;
        VC.walletArray = self.walletArray;
        VC.index = self.index;
        [self.navigationController pushViewController:VC animated:YES];
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
