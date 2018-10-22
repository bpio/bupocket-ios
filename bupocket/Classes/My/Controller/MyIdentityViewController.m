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

@interface MyIdentityViewController ()

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
    UIView * myIdentityBg = [[UIView alloc] initWithFrame:CGRectMake(ScreenScale(12), NavBarH + ScreenScale(10), DEVICE_WIDTH - ScreenScale(24), ScreenScale(110))];
    myIdentityBg.backgroundColor = [UIColor whiteColor];
    [myIdentityBg setViewSize:myIdentityBg.size borderWidth:0 borderColor:nil borderRadius:ScreenScale(5)];
    [self.view addSubview:myIdentityBg];
    
    UILabel * IDNameTitle = [[UILabel alloc] init];
    IDNameTitle.font = FONT(15);
    IDNameTitle.textColor = COLOR(@"999999");
    IDNameTitle.text = Localized(@"IdentityNameTitle");
    [myIdentityBg addSubview:IDNameTitle];
    [IDNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        make.top.equalTo(myIdentityBg.mas_top).offset(ScreenScale(17));
        make.left.equalTo(myIdentityBg.mas_left).offset(ScreenScale(10));
    }];
    
    UILabel * IDName = [[UILabel alloc] init];
    IDName.font = FONT(15);
    IDName.textColor = COLOR(@"666666");
    IDName.text = @"会飞的猪"; // Localized(@"IdentityName");
    [myIdentityBg addSubview:IDName];
    [IDName mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        make.top.equalTo(IDNameTitle);
        make.right.equalTo(myIdentityBg.mas_right).offset(-ScreenScale(10));
    }];
    
    UILabel * IdentityIDTitle = [[UILabel alloc] init];
    IdentityIDTitle.font = IDNameTitle.font;
    IdentityIDTitle.textColor = IDNameTitle.textColor;
    IdentityIDTitle.text = Localized(@"IdentityIDTitle");
    [myIdentityBg addSubview:IdentityIDTitle];
    [IdentityIDTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        make.top.equalTo(IDNameTitle.mas_bottom).offset(ScreenScale(25));
        make.left.equalTo(IDNameTitle);
    }];
    
    UILabel * IdentityID = [[UILabel alloc] init];
    IdentityID.font = IDName.font;
    IdentityID.textColor = IDName.textColor;
    IdentityID.text = @"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3"; // Localized(@"IdentityID");
    IdentityID.numberOfLines = 0;
    IdentityID.textAlignment = NSTextAlignmentRight;
    [myIdentityBg addSubview:IdentityID];
    [IdentityID mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.view);
        make.top.equalTo(IdentityIDTitle);
        make.right.equalTo(IDName);
        make.width.mas_equalTo(ScreenScale(200));
    }];
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - ScreenScale(24), MAIN_HEIGHT);
    UIButton * exitID = [UIButton createButtonWithTitle:Localized(@"ExitCurrentIdentity") TextFont:18 TextColor:COLOR(@"FF6363") Target:self Selector:@selector(exitIDAction)];
    [exitID setViewSize:btnSize borderWidth:0 borderColor:nil borderRadius:ScreenScale(4)];
    exitID.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:exitID];
    [exitID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(- (SafeAreaBottomH + ScreenScale(180)));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * backupIdentity = [UIButton createButtonWithTitle:Localized(@"BackupIdentity") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(backupIdentityAction)];
    [backupIdentity setViewSize:btnSize borderWidth:0 borderColor:nil borderRadius:ScreenScale(4)];
    backupIdentity.backgroundColor = MAIN_COLOR;
    [self.view addSubview:backupIdentity];
    [backupIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(exitID.mas_top).offset(- ScreenScale(20));
        make.size.centerX.equalTo(exitID);
    }];
}
- (void)backupIdentityAction
{
    PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithConfrimBolck:^{
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[BackupMnemonicsViewController alloc] init]];
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)exitIDAction
{
    UIAlertController * alertController = [Encapsulation alertControllerWithTitle:Localized(@"ExitCurrentIdentity") message:Localized(@"ExitCurrentIdentityPrompt")];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[IdentityViewController alloc] init]];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
