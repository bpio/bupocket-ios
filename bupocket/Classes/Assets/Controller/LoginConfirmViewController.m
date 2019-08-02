//
//  LoginConfirmViewController.m
//  bupocket
//
//  Created by bupocket on 2019/3/25.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "LoginConfirmViewController.h"
#import "ScanCodeFailureViewController.h"

@interface LoginConfirmViewController ()
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation LoginConfirmViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_close" SelectedImage:@"nav_close" Target:self Selector:@selector(cancelAction)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    UIImageView * icon = [[UIImageView alloc] init];
    [icon sd_setImageWithURL:[NSURL URLWithString:self.loginConfirmModel.appPic] placeholderImage:[UIImage imageNamed:@"placeholderBg"]];
    [self.scrollView addSubview:icon];
    CGSize iconSize = CGSizeMake(ScreenScale(90), ScreenScale(90));
    [icon setViewSize:iconSize borderRadius:ScreenScale(15) corners:UIRectCornerAllCorners];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(iconSize);
    }];
    
    UILabel * title = [[UILabel alloc] init];
    title.font = FONT_Bold(18);
    title.textColor = TITLE_COLOR;
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.loginConfirmModel.appName;
    [self.scrollView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(Margin_15);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(View_Width_Main);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self.scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(title);
        make.top.equalTo(title.mas_bottom).offset(Margin_40);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    UILabel * confirmLoginPrompt = [[UILabel alloc] init];
    confirmLoginPrompt.numberOfLines = 0;
    [self.scrollView addSubview:confirmLoginPrompt];
    [confirmLoginPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(title);
        make.top.equalTo(line.mas_bottom).offset(Margin_25);
    }];
    NSString * confirmPrompt = [NSString stringWithFormat:Localized(@"Immediate login %@, please confirm that it is my operation."), self.loginConfirmModel.appName];
    confirmLoginPrompt.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", confirmPrompt, Localized(@"LoginPromptInfo")] preFont:FONT(15) preColor:COLOR_6 index:confirmPrompt.length sufFont:FONT(13) sufColor:COLOR_9 lineSpacing:LINE_SPACING];
    
    CGSize btnSize = CGSizeMake(View_Width_Main, MAIN_HEIGHT);
    UIButton * confirmBtn = [UIButton createButtonWithTitle:Localized(@"ConfirmLogin") isEnabled:YES Target:self Selector:@selector(confirmAction)];
    [self.scrollView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmLoginPrompt.mas_bottom).offset(Margin_40);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * cancelBtn = [UIButton createCornerRadiusButtonWithTitle:Localized(@"Cancel")isEnabled:YES Target:self Selector:@selector(cancelAction)];
    [self.scrollView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmBtn.mas_bottom).offset(Margin_30);
        make.size.centerX.equalTo(confirmBtn);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(cancelBtn.frame) + ContentSizeBottom);
}

- (void)confirmAction
{
    [[HTTPManager shareManager] getAccountCenterDataWithAppId:self.loginConfirmModel.appId uuid:self.loginConfirmModel.uuid success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            ScanCodeFailureViewController * VC = [[ScanCodeFailureViewController alloc] init];
            VC.exceptionPromptStr = Localized(@"Overdue");
            VC.promptStr = Localized(@"RefreshQRCode");
            [self.navigationController pushViewController:VC animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
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
