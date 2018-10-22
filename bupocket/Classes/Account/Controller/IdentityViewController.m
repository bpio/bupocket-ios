//
//  IdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "IdentityViewController.h"
#import "TermsOfUseViewController.h"
//#import "CreateIdentityViewController.h"
#import "RestoreIdentityViewController.h"

@interface IdentityViewController ()

@end

@implementation IdentityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView
{
    UIImageView * identityBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"identity_bg"]];
    identityBg.userInteractionEnabled = YES;
    [self.view addSubview:identityBg];
    [identityBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIImageView * logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [identityBg addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(identityBg);
        make.top.mas_equalTo(ScreenScale(75) + StatusBarHeight);
    }];
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(24);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = Localized(@"CreateDigitalIdentity");
    [identityBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(identityBg);
        make.top.equalTo(logoImage.mas_bottom).offset(ScreenScale(25));
    }];
    UIButton * createIdentity = [UIButton createButtonWithTitle:Localized(@"ImmediateCreation") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(createAction)];
    createIdentity.layer.masksToBounds = YES;
    createIdentity.clipsToBounds = YES;
    createIdentity.layer.cornerRadius = ScreenScale(4);
    createIdentity.backgroundColor = MAIN_COLOR;
    [identityBg addSubview:createIdentity];
    [createIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(ScreenScale(90));
        make.left.equalTo(identityBg.mas_left).offset(ScreenScale(30));
        make.right.equalTo(identityBg.mas_right).offset(-ScreenScale(30));
        make.height.mas_equalTo(MAIN_HEIGHT);
//        make.centerX.equalTo(identityBg);
//        make.size.mas_equalTo(CGSizeMake(ScreenScale(300), ScreenScale(55)));
    }];
    
    UIButton * restoreIdentity = [UIButton createButtonWithTitle:Localized(@"RestoreIdentity") TextFont:18 TextColor:[UIColor colorWithHexString:@"5745C3"] Target:self Selector:@selector(restoreAction)];
    restoreIdentity.layer.masksToBounds = YES;
    restoreIdentity.clipsToBounds = YES;
    restoreIdentity.layer.cornerRadius = ScreenScale(4);
    restoreIdentity.backgroundColor = [UIColor whiteColor];
    [identityBg addSubview:restoreIdentity];
    [restoreIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createIdentity.mas_bottom).offset(ScreenScale(35));
        make.left.right.height.equalTo(createIdentity);
    }];
}
- (void)createAction
{
    TermsOfUseViewController * VC = [[TermsOfUseViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
//    CreateIdentityViewController * VC = [[CreateIdentityViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
}
- (void)restoreAction
{
    RestoreIdentityViewController * VC = [[RestoreIdentityViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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
