//
//  WalletManagementViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/14.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "WalletManagementViewController.h"
#import "SubtitleListViewCell.h"
#import "ListTableViewCell.h"
#import "WalletDetailsViewController.h"
#import "ExportKeystoreViewController.h"
#import "ExportPrivateKeyViewController.h"
#import "BackupMnemonicsViewController.h"
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
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
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2 && ![self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
        return ScreenScale(200);
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //    if (section == 0 || [self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
    if (section == 2 && ![self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
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
    } else {
        return [[UIView alloc] init];
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
    PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"WalletPWPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        [self.walletArray removeObject:self.walletModel];
        [[WalletTool shareTool] save:self.walletArray];
        [Encapsulation showAlertControllerWithMessage:Localized(@"DeleteWalletSuccessfully") handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:NO];
        }];
    } cancelBlock:^{
    }];
    alertView.walletKeyStore = self.walletModel.walletKeyStore;
    alertView.passwordType = PWTypeDeleteWallet;
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [alertView.PWTextField becomeFirstResponder];
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
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
        CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(60));
        if (indexPath.section == 1) {
            cell.listImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"export_list_%zd", indexPath.row]];
            cell.title.text = self.listArray[indexPath.row];
            if (indexPath.row == 0) {
                [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
                cell.lineView.hidden = NO;
            } else if (indexPath.row == self.listArray.count - 1 || indexPath.section == 2) {
                [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
                cell.lineView.hidden = YES;
            }
        } else if (indexPath.section == 2) {
            cell.title.text = Localized(@"ModifyWalletPW");
            [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
            cell.listImage.image = [UIImage imageNamed:@"change_password"];
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
        VC.walletIcon = cell.walletImage.image;
        VC.walletModel = self.walletModel;
        VC.walletArray = self.walletArray;
        VC.index = self.index;
        VC.returnValueBlock = ^(UIImage *walletIcon, NSString *walletName) {
            cell.walletImage.image = walletIcon;
            cell.walletName.text = walletName;
        };
        [self.navigationController pushViewController:VC animated:NO];
    } else if (indexPath.section == 1) {
        PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"WalletPWPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
            if (indexPath.row == 0) {
                ExportKeystoreViewController * VC = [[ExportKeystoreViewController alloc] init];
                VC.walletModel = self.walletModel;
                [self.navigationController pushViewController:VC animated:NO];
            } else if (indexPath.row == 1) {
                if (NotNULLString(password)) {
                    ExportPrivateKeyViewController * VC = [[ExportPrivateKeyViewController alloc] init];
                    VC.walletModel = self.walletModel;
                    VC.password = password;
                    [self.navigationController pushViewController:VC animated:NO];
                }
            } else if (indexPath.row == 2) {
                if (words.count > 0) {
                    BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
                    VC.mnemonicArray = words;
                    [self.navigationController pushViewController:VC animated:NO];
                }
            }
        } cancelBlock:^{
        }];
        if (indexPath.row == 2) {
            alertView.passwordType = PWTypeBackUpID;
            alertView.randomNumber = self.walletModel.randomNumber;
        } else {
            alertView.walletKeyStore = self.walletModel.walletKeyStore;
            if (indexPath.row == 0) {
                alertView.passwordType = PWTypeExportKeystore;
            } else if (indexPath.row == 1) {
                alertView.passwordType = PWTypeExportPrivateKey;
            }
        }
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        [alertView.PWTextField becomeFirstResponder];
    } else if (indexPath.section == 2) {
        ChangePasswordViewController * VC = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:VC animated:NO];
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
