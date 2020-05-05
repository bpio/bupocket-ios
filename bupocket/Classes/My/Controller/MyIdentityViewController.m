//
//  MyIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MyIdentityViewController.h"
#import "IdentityViewController.h"
#import "BackUpWalletViewController.h"
#import "ClearCacheTool.h"
#import "YBPopupMenu.h"
#import "ListTableViewCell.h"
#import "Database.h"

@interface MyIdentityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@property (nonatomic, strong) YBPopupMenu *popupMenu;
@property (nonatomic, strong) CustomButton * identityIDTitle;

@end

@implementation MyIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"MyIdentity");
    self.listArray = @[@[Localized(@"IdentityNameTitle"), [[AccountTool shareTool] account].identityName], @[Localized(@"IdentityIDTitle"), [NSString stringEllipsisWithStr:[[AccountTool shareTool] account].identityAddress subIndex:SubIndex_Address]]];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:self.tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1) {
//        return ScreenScale(70);
//    }
    return Margin_50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentSizeBottom + ScreenScale(200);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
    
    CGSize btnSize = CGSizeMake(View_Width_Main, MAIN_HEIGHT);
    
    UIButton * backupIdentity = [UIButton createButtonWithTitle:Localized(@"BackupIdentity") isEnabled:YES Target:self Selector:@selector(backupIdentityAction)];
    [footerView addSubview:backupIdentity];
    [backupIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
        make.centerX.equalTo(footerView);
        make.size.mas_equalTo(btnSize);
    }];
    
    UIButton * exitID = [UIButton createButtonWithTitle:Localized(@"ExitCurrentIdentity") isEnabled:YES Target:self Selector:@selector(exitIDAction)];
    [exitID setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
    exitID.backgroundColor = WHITE_BG_COLOR;
    [footerView addSubview:exitID];
    [exitID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backupIdentity.mas_bottom).offset(Margin_20);
        make.centerX.equalTo(footerView);
        make.size.mas_equalTo(btnSize);
    }];
    return footerView;
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = self.listArray[indexPath.row][0];
    cell.detailTitle.text = self.listArray[indexPath.row][1];
    cell.detail.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineView.hidden = (indexPath.row == self.listArray.count - 1 );
    if (indexPath.row == self.listArray.count - 1) {
        cell.detailTitle.numberOfLines = 0;
        cell.detailTitle.textAlignment = NSTextAlignmentRight;
        [cell.listImage setImage:[UIImage imageNamed:@"explain_info"] forState:UIControlStateNormal];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        [self identityIDInfo:cell.listImage];
    }
}

- (void)backupIdentityAction
{
    BackUpWalletViewController * VC = [[BackUpWalletViewController alloc] init];
    VC.mnemonicType = MnemonicBackup;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)exitIDAction
{
    [Encapsulation showAlertControllerWithTitle:Localized(@"ExitCurrentID") message:Localized(@"ExitCurrentIdentityPrompt") confirmHandler:^{
        TextInputAlertView * alertView = [[TextInputAlertView alloc] initWithInputType:PWTypeExitID confrimBolck:^(NSString * _Nonnull text, NSArray * _Nonnull words) {
            [self exitIDData];
        } cancelBlock:^{
            
        }];
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        [alertView.textField becomeFirstResponder];
    }];
}
- (void)exitIDData
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [ClearCacheTool cleanCache:^{
            [ClearCacheTool cleanUserDefaults];
            [[AccountTool shareTool] clearCache];
            [[WalletTool shareTool] clearCache];
            [[DataBase shareDataBase] clearCache];
            //            [[LanguageManager shareInstance] setDefaultLocale];
            [[HTTPManager shareManager] initNetWork];
            // Minimum Asset Limitation
            [[HTTPManager shareManager] getBlockLatestFees];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD hideHUD];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[IdentityViewController alloc] init]];
            }];
        }];
    }];
}
- (void)identityIDInfo:(UIView *)view
{
    NSString * title = Localized(@"IdentityIDInfo");
    CGFloat titleHeight = [Encapsulation rectWithText:title font:FONT_TITLE textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    _popupMenu = [YBPopupMenu showRelyOnView:view titles:@[title] icons:nil menuWidth:DEVICE_WIDTH - ScreenScale(100) otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = titleHeight + Margin_30;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = FONT_TITLE;
        popupMenu.textColor = WHITE_BG_COLOR;
        popupMenu.backColor = COLOR_POPUPMENU;
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        popupMenu.tableView.scrollEnabled = NO;
        popupMenu.tableView.allowsSelection = NO;
        popupMenu.height = titleHeight + Margin_40;
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
