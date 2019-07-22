//
//  ScanCodeFailureViewController.m
//  bupocket
//
//  Created by bupocket on 2019/3/28.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ScanCodeFailureViewController.h"

@interface ScanCodeFailureViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation ScanCodeFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_close" SelectedImage:@"nav_close" Target:self Selector:@selector(cancelAction)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    CustomButton * exceptionPrompt = [[CustomButton alloc] init];
    exceptionPrompt.layoutMode = VerticalNormal;
    exceptionPrompt.titleLabel.font = FONT(16);
    [exceptionPrompt setTitle:self.exceptionPromptStr forState:UIControlStateNormal];
    [exceptionPrompt setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    exceptionPrompt.titleLabel.numberOfLines = 0;
    exceptionPrompt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [exceptionPrompt setImage:[UIImage imageNamed:@"assetsTimeout"] forState:UIControlStateNormal];
    exceptionPrompt.userInteractionEnabled = NO;
    [self.scrollView addSubview:exceptionPrompt];
    [exceptionPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScreenScale(120) + [Encapsulation rectWithText:self.exceptionPromptStr font:exceptionPrompt.titleLabel.font textWidth:DEVICE_WIDTH - Margin_40].size.height);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    
    UILabel * prompt = [[UILabel alloc] init];
    prompt.font = FONT(13);
    prompt.textColor = COLOR_9;
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.numberOfLines = 0;
    prompt.text = self.promptStr;
    [self.scrollView addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(exceptionPrompt);
        make.top.equalTo(exceptionPrompt.mas_bottom);
    }];
    
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT);
    UIButton * confirmBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:YES Target:self Selector:@selector(confirmAction)];
    [self.scrollView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prompt.mas_bottom).offset(Margin_50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
        
    }];
}

- (void)confirmAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
