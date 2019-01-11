//
//  MyIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MyIdentityViewController.h"
#import "IdentityViewController.h"
#import "BackupMnemonicsViewController.h"
#import "ClearCacheTool.h"
#import "YBPopupMenu.h"

@interface MyIdentityViewController ()

@property (nonatomic, strong) YBPopupMenu *popupMenu;
@property (nonatomic, strong) CustomButton * identityIDTitle;

@end

@implementation MyIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"MyIdentity");
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.view.backgroundColor = COLOR(@"F2F2F2");
    UIView * myIdentityBg = [[UIView alloc] initWithFrame:CGRectMake(Margin_15, Margin_10, DEVICE_WIDTH - Margin_30, ScreenScale(90))];
    myIdentityBg.backgroundColor = [UIColor whiteColor];
    [myIdentityBg setViewSize:myIdentityBg.size borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
    [self.view addSubview:myIdentityBg];
    
    UILabel * IDNameTitle = [[UILabel alloc] init];
    IDNameTitle.font = FONT(15);
    IDNameTitle.textColor = COLOR_9;
    IDNameTitle.text = Localized(@"IdentityNameTitle");
    [myIdentityBg addSubview:IDNameTitle];
    UILabel * IDName = [[UILabel alloc] init];
    IDName.font = FONT(15);
    IDName.textColor = COLOR_6;
    IDName.text = [AccountTool account].identityName;
    [myIdentityBg addSubview:IDName];
    [IDNameTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [IDNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myIdentityBg.mas_top).offset(Margin_15);
        make.left.equalTo(myIdentityBg.mas_left).offset(Margin_10);
        make.right.mas_lessThanOrEqualTo(IDName.mas_left).offset(-Margin_10);
    }];
    
    [IDName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNameTitle);
        make.right.equalTo(myIdentityBg.mas_right).offset(-Margin_10);
        make.left.mas_greaterThanOrEqualTo(IDNameTitle.mas_right).offset(Margin_10);
    }];
    
    self.identityIDTitle = [[CustomButton alloc] init];
    self.identityIDTitle.layoutMode = HorizontalInverted;
    self.identityIDTitle.titleLabel.font = IDNameTitle.font;
    [self.identityIDTitle setTitleColor:IDNameTitle.textColor forState:UIControlStateNormal];
    [self.identityIDTitle setTitle:Localized(@"IdentityIDTitle") forState:UIControlStateNormal];
    [self.identityIDTitle setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
    [self.identityIDTitle addTarget:self action:@selector(identityIDInfo:) forControlEvents:UIControlEventTouchUpInside];
    [myIdentityBg addSubview:self.identityIDTitle];
    
    UILabel * IdentityID = [[UILabel alloc] init];
    IdentityID.font = IDName.font;
    IdentityID.textColor = IDName.textColor;
    IdentityID.text = [NSString stringEllipsisWithStr:[AccountTool account].identityAddress];
    IdentityID.numberOfLines = 0;
    IdentityID.textAlignment = NSTextAlignmentRight;
    [myIdentityBg addSubview:IdentityID];
    
    [self.identityIDTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.identityIDTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNameTitle.mas_bottom).offset(Margin_25);
        make.left.equalTo(IDNameTitle);
        make.right.mas_lessThanOrEqualTo(IdentityID.mas_left).offset(-Margin_10);
    }];
    [IdentityID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityIDTitle);
        make.right.equalTo(IDName);
        make.left.mas_greaterThanOrEqualTo(self.identityIDTitle.mas_right).offset(Margin_10);
    }];
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT);
    UIButton * exitID = [UIButton createButtonWithTitle:Localized(@"ExitCurrentIdentity") isEnabled:YES Target:self Selector:@selector(exitIDAction)];
    [exitID setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
    exitID.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:exitID];
    [exitID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(- (SafeAreaBottomH + ScreenScale(180)));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * backupIdentity = [UIButton createButtonWithTitle:Localized(@"BackupIdentity") isEnabled:YES Target:self Selector:@selector(backupIdentityAction)];
    [self.view addSubview:backupIdentity];
    [backupIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(exitID.mas_top).offset(- Margin_20);
        make.size.centerX.equalTo(exitID);
    }];
}
- (void)backupIdentityAction
{
    PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"IdentityCipherPrompt") isAutomaticClosing:YES confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
        VC.mnemonicArray = words;
        [self.navigationController pushViewController:VC animated:YES];
//        [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:VC];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)exitIDAction
{
    [Encapsulation showAlertControllerWithTitle:Localized(@"ExitCurrentIdentity") message:Localized(@"ExitCurrentIdentityPrompt") cancelHandler:^(UIAlertAction *action) {
        
    } confirmHandler:^(UIAlertAction *action) {
        PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"IdentityCipherWarning") isAutomaticClosing:YES confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
            [self exitIDDataWithPassword:password];
        } cancelBlock:^{
            
        }];
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
    }];
}
- (void)exitIDDataWithPassword:(NSString *)password
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [ClearCacheTool cleanCache:^{
            [ClearCacheTool cleanUserDefaults];
            [AccountTool clearCache];
            [[WalletTool shareTool] clearCache];
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
- (void)identityIDInfo:(UIButton *)button
{
    NSString * title = Localized(@"IdentityIDInfo");
    CGFloat titleHeight = [Encapsulation rectWithText:title font:TITLE_FONT textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    _popupMenu = [YBPopupMenu showRelyOnView:button.imageView titles:@[title] icons:nil menuWidth:DEVICE_WIDTH - ScreenScale(100) otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = titleHeight + Margin_30;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = TITLE_FONT;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR(@"56526D");
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
