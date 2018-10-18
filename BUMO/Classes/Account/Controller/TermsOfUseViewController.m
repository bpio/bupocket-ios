//
//  TermsOfUseViewController.m
//  BUMO
//
//  Created by bubi on 2018/10/16.
//  Copyright © 2018年 bubi. All rights reserved.
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
    UIButton * ifReaded = [UIButton createButtonWithTitle:[NSString stringWithFormat:@"  %@", Localized(@"ReadAndAgree")] TextFont:14 TextNormalColor:COLOR(@"666666") TextSelectedColor:COLOR(@"666666") NormalImage:@"ifReaded_n" SelectedImage:@"ifReaded_s" Target:self Selector:@selector(agreeAction:)];
    ifReaded.contentEdgeInsets = UIEdgeInsetsMake(0, ScreenScale(10), 0, ScreenScale(10));
    ifReaded.backgroundColor = COLOR(@"FAFAFA");
    [self.view addSubview:ifReaded];
    [ifReaded mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(- SafeAreaBottomH);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(230), ScreenScale(55)));
    }];
    self.continueBtn = [UIButton createButtonWithTitle:Localized(@"Continue") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(continueAction:)];
    self.continueBtn.backgroundColor = COLOR(@"9AD9FF");
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
    self.continueBtn.enabled ? (self.continueBtn.backgroundColor = MAIN_COLOR) : (self.continueBtn.backgroundColor = COLOR(@"9AD9FF"));
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
