//
//  RequestTimeoutViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RequestTimeoutViewController.h"

@interface RequestTimeoutViewController ()

@end

@implementation RequestTimeoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    CustomButton * requestTimeout = [[CustomButton alloc] init];
    requestTimeout.layoutMode = VerticalNormal;
    [requestTimeout setTitle:Localized(@"RequestTimeout") forState:UIControlStateNormal];
    // TransferFailure
    [requestTimeout setTitleColor:COLOR_6 forState:UIControlStateNormal];
    requestTimeout.titleLabel.font = FONT(16);
    [requestTimeout setImage:[UIImage imageNamed:@"RequestTimeout"] forState:UIControlStateNormal];
    [self.view addSubview:requestTimeout];
    [requestTimeout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NavBarH);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    // IGotIt
    UIButton * gotIt = [UIButton createButtonWithTitle:Localized(@"IGotIt") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(gotItAction)];
    [gotIt setViewSize:CGSizeMake(DEVICE_WIDTH - ScreenScale(60), MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:ScreenScale(4)];
    gotIt.backgroundColor = MAIN_COLOR;
    [self.view addSubview:gotIt];
    [gotIt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(requestTimeout.mas_bottom).offset(ScreenScale(15));
        make.left.equalTo(self.view.mas_left).offset(Margin_30);
        make.right.equalTo(self.view.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (void)gotItAction
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
