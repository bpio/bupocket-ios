//
//  ExportKeystoreViewController.m
//  bupocket
//
//  Created by bupocket on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ExportKeystoreViewController.h"

@interface ExportKeystoreViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIButton * bottomBtn;

@end

@implementation ExportKeystoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ExportKeystore");
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    CustomButton * keystorePrompt = [[CustomButton alloc] init];
    keystorePrompt.layoutMode = VerticalNormal;
    [keystorePrompt setImage:[UIImage imageNamed:@"copyKeystore"] forState:UIControlStateNormal];
    [keystorePrompt setTitle:Localized(@"CopyKeystorePrompt") forState:UIControlStateNormal];
    [keystorePrompt setTitleColor:COLOR_9 forState:UIControlStateNormal];
    keystorePrompt.titleLabel.font = FONT_TITLE;
    keystorePrompt.titleLabel.numberOfLines = 0;
    keystorePrompt.userInteractionEnabled = NO;
    [self.scrollView addSubview:keystorePrompt];
    CGFloat promptH = [Encapsulation rectWithText:Localized(@"CopyKeystorePrompt") font:FONT_TITLE textWidth:DEVICE_WIDTH - Margin_40].size.height;
    [keystorePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(Margin_20);
        make.height.mas_equalTo(ScreenScale(130) + promptH);
        make.width.mas_lessThanOrEqualTo(View_Width_Main);
    }];
    UIButton * keystore = [UIButton createButtonWithTitle:self.walletModel.walletKeyStore TextFont:FONT_15 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
    keystore.titleLabel.numberOfLines = 0;
    keystore.contentEdgeInsets = UIEdgeInsetsMake(Margin_15, Margin_10, Margin_15, Margin_10);
    keystore.layer.borderColor = LINE_COLOR.CGColor;
    keystore.layer.borderWidth = LINE_WIDTH;
    keystore.layer.masksToBounds = YES;
    keystore.clipsToBounds = YES;
    keystore.layer.cornerRadius = MAIN_CORNER;
    keystore.backgroundColor = VIEWBG_COLOR;
    [self.scrollView addSubview:keystore];
    CGFloat keystoreH = [Encapsulation rectWithText:keystore.titleLabel.text font:keystore.titleLabel.font textWidth:Content_Width_Main].size.height + Margin_30;
    [keystore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keystorePrompt.mas_bottom).offset(Margin_10);
        make.left.mas_equalTo(Margin_Main);
        make.size.mas_equalTo(CGSizeMake(View_Width_Main, keystoreH));
    }];
    self.bottomBtn = [UIButton createFooterViewWithTitle:Localized(@"CopyKeystore") isEnabled:YES Target:self Selector:@selector(copyAction)];
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(keystore.frame) + ContentSize_Bottom + NavBarH + ContentInset_Bottom);
}

- (void)copyAction
{
    [[UIPasteboard generalPasteboard] setString:self.walletModel.walletKeyStore];
    [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
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
