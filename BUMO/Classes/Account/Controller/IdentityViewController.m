//
//  IdentityViewController.m
//  BUMO
//
//  Created by bubi on 2018/10/16.
//  Copyright © 2018年 bubi. All rights reserved.
//

#import "IdentityViewController.h"
#import "CreateIdentityViewController.h"

@interface IdentityViewController ()

@end

@implementation IdentityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    titleLabel.text = @"创建数字身份";
    [identityBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(identityBg);
        make.top.equalTo(logoImage.mas_bottom).offset(ScreenScale(25));
    }];
    UIButton * createIdentity = [UIButton createButtonWithTitle:@"立即创建" TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(createAction)];
    createIdentity.layer.masksToBounds = YES;
    createIdentity.clipsToBounds = YES;
    createIdentity.layer.cornerRadius = ScreenScale(4);
    createIdentity.backgroundColor = MAIN_COLOR;
    [identityBg addSubview:createIdentity];
    [createIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(ScreenScale(90));
//        make.left.equalTo(identityBg.mas_left).offset(ScreenScale(38));
//        make.right.equalTo(identityBg.mas_right).offset(-ScreenScale(38));
        make.centerX.equalTo(identityBg);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(300), ScreenScale(55)));
    }];
    
    UIButton * restoreIdentity = [UIButton createButtonWithTitle:@"恢复身份" TextFont:18 TextColor:[UIColor colorWithHexString:@"5745C3"] Target:self Selector:@selector(restoreAction)];
    restoreIdentity.layer.masksToBounds = YES;
    restoreIdentity.clipsToBounds = YES;
    restoreIdentity.layer.cornerRadius = ScreenScale(4);
    restoreIdentity.backgroundColor = [UIColor whiteColor];
    [identityBg addSubview:restoreIdentity];
    [restoreIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createIdentity.mas_bottom).offset(ScreenScale(35));
        make.size.centerX.equalTo(createIdentity);
    }];
}
- (void)createAction
{
    CreateIdentityViewController * VC = [[CreateIdentityViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)restoreAction
{
    
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
