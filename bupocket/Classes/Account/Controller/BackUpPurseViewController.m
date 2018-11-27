//
//  BackUpPurseViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/18.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BackUpPurseViewController.h"
#import "PurseCipherAlertView.h"
#import "BackupMnemonicsViewController.h"

@interface BackUpPurseViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation BackUpPurseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"BackUpPurse");
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    UIImageView * wallet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet"]];
    [self.scrollView addSubview:wallet];
    
    [wallet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(ScreenScale(Margin_60));
    }];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(15);
    titleLabel.textColor = COLOR_6;
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = Localized(@"BackupInformation");
    [self.scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wallet.mas_bottom).offset(Margin_30);
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
    }];
    
    UILabel * infoLabel = [[UILabel alloc] init];
    infoLabel.font = TITLE_FONT;
    infoLabel.textColor = COLOR_9;
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.text = Localized(@"BackupPrompt");
    [self.scrollView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(Margin_30);
        make.left.width.equalTo(titleLabel);
    }];
    
    UIButton * backupMnemonics = [UIButton createButtonWithTitle:Localized(@"BackupMnemonics") isEnabled:YES Target:self Selector:@selector(backupMnemonicsAction)];
    [self.scrollView addSubview:backupMnemonics];
    [backupMnemonics mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoLabel.mas_bottom).offset(MAIN_HEIGHT);
        make.left.width.equalTo(titleLabel);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    UIButton * temporaryBackup = [UIButton createButtonWithTitle:Localized(@"TemporaryBackup") isEnabled:YES Target:self Selector:@selector(temporaryBackupAction)];
    [temporaryBackup setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    temporaryBackup.layer.borderColor = MAIN_COLOR.CGColor;
    temporaryBackup.layer.borderWidth = LINE_WIDTH;
    temporaryBackup.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:temporaryBackup];
    [temporaryBackup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backupMnemonics.mas_bottom).offset(Margin_20);
        make.left.width.height.equalTo(backupMnemonics);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(temporaryBackup.frame) + ContentSizeBottom + Margin_50);
}

- (void)backupMnemonicsAction
{
    if (self.mnemonicArray.count > 0) {
        BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
        VC.mnemonicArray = self.mnemonicArray;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithPrompt:Localized(@"IdentityCipherPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
            BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
            VC.mnemonicArray = words;
            [self.navigationController pushViewController:VC animated:YES];
        } cancelBlock:^{
        }];
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
    }
}
- (void)temporaryBackupAction
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:If_Skip];
    [defaults synchronize];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
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
