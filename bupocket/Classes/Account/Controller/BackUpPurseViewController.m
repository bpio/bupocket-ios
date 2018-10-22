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
    UIImageView * wallet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet"]];
    [self.view addSubview:wallet];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(15);
    titleLabel.textColor = COLOR(@"666666");
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = Localized(@"BackupInformation");
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(30));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(30));
        make.centerY.equalTo(self.view);
    }];
    
    [wallet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(titleLabel.mas_top).offset(ScreenScale(-30));
        //        make.bottom.equalTo(self.view.mas_centerY);
        //        make.top.equalTo(self.noNetWork).offset(StatusBarHeight + ScreenScale(115));
    }];
    
    UILabel * infoLabel = [[UILabel alloc] init];
    infoLabel.font = FONT(14);
    infoLabel.textColor = COLOR(@"999999");
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.text = Localized(@"BackupPrompt");
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLabel.mas_bottom).offset(ScreenScale(35));
        make.left.right.equalTo(titleLabel);
    }];
    
    UIButton * temporaryBackup = [UIButton createButtonWithTitle:Localized(@"TemporaryBackup") TextFont:18 TextColor:MAIN_COLOR Target:self Selector:@selector(temporaryBackupAction)];
    temporaryBackup.layer.masksToBounds = YES;
    temporaryBackup.clipsToBounds = YES;
    temporaryBackup.layer.cornerRadius = ScreenScale(4);
    temporaryBackup.layer.borderColor = MAIN_COLOR.CGColor;
    temporaryBackup.layer.borderWidth = ScreenScale(0.5);
    [self.view addSubview:temporaryBackup];
    [temporaryBackup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(- (SafeAreaBottomH + ScreenScale(55)));
        make.left.right.equalTo(titleLabel);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    UIButton * backupMnemonics = [UIButton createButtonWithTitle:Localized(@"BackupMnemonics") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(backupMnemonicsAction)];
    backupMnemonics.layer.masksToBounds = YES;
    backupMnemonics.clipsToBounds = YES;
    backupMnemonics.layer.cornerRadius = ScreenScale(4);
    backupMnemonics.backgroundColor = MAIN_COLOR;
    [self.view addSubview:backupMnemonics];
    [backupMnemonics mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(temporaryBackup.mas_top).offset(-ScreenScale(20));
        make.left.right.height.equalTo(temporaryBackup);
    }];
}

- (void)backupMnemonicsAction
{
    PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithConfrimBolck:^{
        BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)temporaryBackupAction
{
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
