//
//  BackupMnemonicsViewController.m
//  BUMO
//
//  Created by bubi on 2018/10/16.
//  Copyright © 2018年 bubi. All rights reserved.
//

#import "BackupMnemonicsViewController.h"
#import "TabBarViewController.h"

@interface BackupMnemonicsViewController ()

@end

@implementation BackupMnemonicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"备份钱包";
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
    titleLabel.text = @"没有妥善备份就无法保障资产安全，删除程序或钱包后，你需要备份文件来恢复钱包";
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
    infoLabel.text = @"请确保在四周无人，没有摄像头的安全环境下备份。";
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLabel.mas_bottom).offset(ScreenScale(35));
        make.left.right.equalTo(titleLabel);
    }];
    
    UIButton * temporaryBackup = [UIButton createButtonWithTitle:@"暂不备份" TextFont:18 TextColor:MAIN_COLOR Target:self Selector:@selector(temporaryBackupAction)];
    temporaryBackup.layer.masksToBounds = YES;
    temporaryBackup.clipsToBounds = YES;
    temporaryBackup.layer.cornerRadius = ScreenScale(4);
    temporaryBackup.layer.borderColor = MAIN_COLOR.CGColor;
    temporaryBackup.layer.borderWidth = ScreenScale(0.5);
    [self.view addSubview:temporaryBackup];
    [temporaryBackup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(- (SafeAreaBottomH + ScreenScale(55)));
        make.left.right.equalTo(titleLabel);
        make.height.mas_equalTo(ScreenScale(45));
    }];
    
    UIButton * backupMnemonics = [UIButton createButtonWithTitle:@"备份助记词" TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(backupMnemonicsAction)];
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
