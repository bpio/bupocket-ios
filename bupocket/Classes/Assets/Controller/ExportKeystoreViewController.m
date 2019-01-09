//
//  ExportKeystoreViewController.m
//  bupocket
//
//  Created by huoss on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ExportKeystoreViewController.h"

@interface ExportKeystoreViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

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
    keystorePrompt.titleLabel.font = TITLE_FONT;
    keystorePrompt.titleLabel.numberOfLines = 0;
    [self.scrollView addSubview:keystorePrompt];
    CGFloat promptH = [Encapsulation rectWithText:Localized(@"CopyKeystorePrompt") font:TITLE_FONT textWidth:DEVICE_WIDTH - Margin_40].size.height;
    [keystorePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(ScreenScale(Margin_20));
        make.height.mas_equalTo(ScreenScale(130) + promptH);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    
    UIButton * keystore = [UIButton createButtonWithTitle:self.walletModel.walletKeyStore TextFont:15 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
    keystore.titleLabel.numberOfLines = 0;
    keystore.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_15, 0, Margin_15);
    keystore.layer.borderColor = LINE_COLOR.CGColor;
    keystore.layer.borderWidth = LINE_WIDTH;
    keystore.layer.masksToBounds = YES;
    keystore.clipsToBounds = YES;
    keystore.layer.cornerRadius = MAIN_CORNER;
    keystore.backgroundColor = COLOR(@"F8F8F8");
    [self.scrollView addSubview:keystore];
    CGFloat keystoreH = [Encapsulation rectWithText:keystore.titleLabel.text font:keystore.titleLabel.font textWidth:DEVICE_WIDTH - ScreenScale(70)].size.height + Margin_30;
    [keystore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keystorePrompt.mas_bottom).offset(Margin_10);
        make.left.mas_equalTo(Margin_20);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, keystoreH));
    }];
    UIButton * copy = [UIButton createButtonWithTitle:Localized(@"CopyKeystore") isEnabled:YES Target:self Selector:@selector(copyAction)];
    [self.scrollView addSubview:copy];
    [copy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keystore.mas_bottom).offset(MAIN_HEIGHT);
        make.left.width.equalTo(keystore);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(copy.frame) + ContentSizeBottom + ScreenScale(100));
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
