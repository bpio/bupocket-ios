//
//  IdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "IdentityViewController.h"
#import "TermsOfUseViewController.h"

@interface IdentityViewController ()

@end

@implementation IdentityViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:App_Version forKey:LastVersion];
    [defaults synchronize];
    [self setupView];
}

- (void)setupView
{
    UIImageView * identityBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"identity_bg"]];
    identityBg.userInteractionEnabled = YES;
    identityBg.contentMode = UIViewContentModeScaleAspectFill;
    identityBg.clipsToBounds = YES;
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
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.text = Localized(@"CreateDigitalIdentity");
    [identityBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(identityBg);
        make.top.equalTo(logoImage.mas_bottom).offset(Margin_25);
    }];
    UIButton * createIdentity = [UIButton createButtonWithTitle:Localized(@"CreateIdentity") isEnabled:YES Target:self Selector:@selector(IDAction:)];
    [identityBg addSubview:createIdentity];
    [createIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(ScreenScale(90));
        make.left.equalTo(identityBg.mas_left).offset(Margin_Main);
        make.right.equalTo(identityBg.mas_right).offset(-Margin_Main);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    UIButton * restoreIdentity = [UIButton createCornerRadiusButtonWithTitle:Localized(@"RestoreIdentity") isEnabled:YES Target:self Selector:@selector(IDAction:)];
    [identityBg addSubview:restoreIdentity];
    [restoreIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createIdentity.mas_bottom).offset(ScreenScale(35));
        make.left.right.height.equalTo(createIdentity);
    }];
}
- (void)IDAction:(UIButton *)button
{
    TermsOfUseViewController * VC = [[TermsOfUseViewController alloc] init];
    if ([button.titleLabel.text isEqualToString:Localized(@"CreateIdentity")]) {
        VC.userProtocolType = UserProtocolCreateID;
    } else if ([button.titleLabel.text isEqualToString:Localized(@"RestoreIdentity")]) {
        VC.userProtocolType = UserProtocolRestoreID;
    }
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
