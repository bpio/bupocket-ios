//
//  MyIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MyIdentityViewController.h"
#import "IdentityViewController.h"
#import "PurseCipherAlertView.h"
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
    [IDNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myIdentityBg.mas_top).offset(Margin_15);
        make.left.equalTo(myIdentityBg.mas_left).offset(Margin_10);
    }];
    
    UILabel * IDName = [[UILabel alloc] init];
    IDName.font = FONT(15);
    IDName.textColor = COLOR_6;
    IDName.text = [AccountTool account].identityName;
    [myIdentityBg addSubview:IDName];
    [IDName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNameTitle);
        make.right.equalTo(myIdentityBg.mas_right).offset(-Margin_10);
    }];
    
    self.identityIDTitle = [[CustomButton alloc] init];
    self.identityIDTitle.layoutMode = HorizontalInverted;
    self.identityIDTitle.titleLabel.font = IDNameTitle.font;
    [self.identityIDTitle setTitleColor:IDNameTitle.textColor forState:UIControlStateNormal];
    [self.identityIDTitle setTitle:Localized(@"IdentityIDTitle") forState:UIControlStateNormal];
    [self.identityIDTitle setImage:[UIImage imageNamed:@"identityIDInfo"] forState:UIControlStateNormal];
    [self.identityIDTitle addTarget:self action:@selector(identityIDInfo:) forControlEvents:UIControlEventTouchUpInside];
    [myIdentityBg addSubview:self.identityIDTitle];
    [self.identityIDTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNameTitle.mas_bottom).offset(Margin_25);
        make.left.equalTo(IDNameTitle);
    }];
    
    UILabel * IdentityID = [[UILabel alloc] init];
    IdentityID.font = IDName.font;
    IdentityID.textColor = IDName.textColor;
    IdentityID.text = [NSString stringEllipsisWithStr:[AccountTool account].identityAccount];
    IdentityID.numberOfLines = 0;
    IdentityID.textAlignment = NSTextAlignmentRight;
    [myIdentityBg addSubview:IdentityID];
    [IdentityID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityIDTitle);
        make.right.equalTo(IDName);
        make.width.mas_equalTo(ScreenScale(200));
    }];
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT);
    UIButton * exitID = [UIButton createButtonWithTitle:Localized(@"ExitCurrentIdentity") isEnabled:YES Target:self Selector:@selector(exitIDAction)];
    [exitID setTitleColor:COLOR(@"FF6363") forState:UIControlStateNormal];
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
    PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithPrompt:Localized(@"IdentityCipherPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
        VC.mnemonicArray = words;
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:VC];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)exitIDAction
{
    UIAlertController * alertController = [Encapsulation alertControllerWithCancelTitle:Localized(@"Cancel") title:Localized(@"ExitCurrentIdentity") message:Localized(@"ExitCurrentIdentityPrompt")];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithPrompt:Localized(@"IdentityCipherWarning") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
            NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:[AccountTool account].purseKey];
            if ([Tools isEmpty:privateKey]) {
                [MBProgressHUD showWarnMessage:Localized(@"PasswordIsIncorrect")];
                return;
            }
           [ClearCacheTool cleanCache:^{
               [ClearCacheTool cleanUserDefaults];
               [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[IdentityViewController alloc] init]];
            }];
        } cancelBlock:^{
            
        }];
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)identityIDInfo:(UIButton *)button
{
    NSString * title = Localized(@"IdentityIDInfo");
    CGFloat titleHeight = [Encapsulation rectWithText:title fontSize:14 textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    _popupMenu = [YBPopupMenu showRelyOnView:button.imageView titles:@[title] icons:nil menuWidth:DEVICE_WIDTH - ScreenScale(90) otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = titleHeight + Margin_30;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = 14;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR(@"56526D");
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.tableView.scrollEnabled = NO;
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
