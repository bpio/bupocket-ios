//
//  TermsOfUseViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TermsOfUseViewController.h"
#import "CreateIdentityViewController.h"

@interface TermsOfUseViewController ()

@property (nonatomic, strong) UIButton * continueBtn;

@end

@implementation TermsOfUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"TermsOfUse");
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.loadType = webloadLocalPath;
//    NSString * path = nil;
//    NSString * language = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
//    if ([language isEqualToString:@"zh-Hans"]) {
//        path = [[NSBundle mainBundle] pathForResource:@"小布口袋服务协议-汉语版" ofType:@"docx"];
//    } else if ([language isEqualToString:@"en"]) {
//        path = [[NSBundle mainBundle] pathForResource:@"小布口袋服务协议-英文版(Translated)" ofType:@"docx"];
//    }
    [self loadURLPathSring:[[NSBundle mainBundle] pathForResource:Localized(@"TermsOfUse") ofType:@"html"]];
    self.wkWebView.height = DEVICE_HEIGHT - SafeAreaBottomH - ScreenScale(55);
    UIButton * ifReaded = [UIButton createButtonWithTitle:[NSString stringWithFormat:@"  %@", Localized(@"ReadAndAgree")] TextFont:14 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 NormalImage:@"ifReaded_n" SelectedImage:@"ifReaded_s" Target:self Selector:@selector(agreeAction:)];
    ifReaded.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, Margin_10);
    ifReaded.backgroundColor = COLOR(@"FAFAFA");
    [self.view addSubview:ifReaded];
    [ifReaded mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(- SafeAreaBottomH);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(230), ScreenScale(55)));
    }];
    self.continueBtn = [UIButton createButtonWithTitle:Localized(@"Continue") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(continueAction:)];
    self.continueBtn.backgroundColor = DISABLED_COLOR;
    self.continueBtn.enabled = NO;
    [self.view addSubview:self.continueBtn];
    [self.continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ifReaded.mas_right);
        make.bottom.height.equalTo(ifReaded);
        make.right.equalTo(self.view);
    }];
}
- (void)agreeAction:(UIButton *)button
{
    button.selected = !button.selected;
    self.continueBtn.enabled = button.selected;
    self.continueBtn.enabled ? (self.continueBtn.backgroundColor = MAIN_COLOR) : (self.continueBtn.backgroundColor = DISABLED_COLOR);
}
- (void)continueAction:(UIButton *)button
{
    CreateIdentityViewController * VC = [[CreateIdentityViewController alloc] init];
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
