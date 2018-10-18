//
//  BaseViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView * noNetWork;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNoNetWork];
    self.noNetWork.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:ChangeLanguageNotificationName object:nil];
    // Do any additional setup after loading the view.
}
- (void)changeLanguage
{
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setupNoNetWork
{
    _noNetWork = [[UIView alloc] init];
    [self.view addSubview:self.noNetWork];
    [self.noNetWork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIImageView * noNetWorkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noNetWork"]];
    [_noNetWork addSubview:noNetWorkImage];
    [noNetWorkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noNetWork);
        make.bottom.equalTo(self.noNetWork.mas_centerY);
//        make.top.equalTo(self.noNetWork).offset(StatusBarHeight + ScreenScale(115));
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(15);
    titleLabel.textColor = COLOR(@"999999");
    titleLabel.text = @"您的网络好像不太给力，请稍后再试";
    [_noNetWork addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noNetWork);
        make.top.equalTo(noNetWorkImage.mas_bottom).offset(ScreenScale(50));
    }];
    
    UIButton * reloadBtn = [UIButton createButtonWithTitle:@"重新加载" TextFont:18 TextColor:[UIColor whiteColor] Target:nil Selector:nil];
    reloadBtn.layer.masksToBounds = YES;
    reloadBtn.clipsToBounds = YES;
    reloadBtn.layer.cornerRadius = ScreenScale(4);
    reloadBtn.backgroundColor = MAIN_COLOR;
    [_noNetWork addSubview:reloadBtn];
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(ScreenScale(40));
        make.centerX.equalTo(self.noNetWork);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(170), ScreenScale(45)));
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
