//
//  BackupMnemonicsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BackupMnemonicsViewController.h"
#import "ConfirmMnemonicViewController.h"


@interface BackupMnemonicsViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIButton * copied;

@end

@implementation BackupMnemonicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"BackupMnemonics");
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    UIView * promptBg = [[UIView alloc] init];
    promptBg.backgroundColor = VIEWBG_COLOR;
    promptBg.clipsToBounds = YES;
    promptBg.layer.masksToBounds = YES;
    promptBg.layer.cornerRadius = MAIN_CORNER;
    [self.scrollView addSubview:promptBg];
    [promptBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_Main);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(View_Width_Main);
    }];
    
    CustomButton * noScreenshot = [[CustomButton alloc] init];
    [noScreenshot setTitle:Localized(@"NoScreenshot") forState:UIControlStateNormal];
    [noScreenshot setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
    noScreenshot.titleLabel.font = FONT_TITLE;
    [noScreenshot setImage:[UIImage imageNamed:@"noScreenshot"] forState:UIControlStateNormal];
    [promptBg addSubview:noScreenshot];
    [noScreenshot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptBg.mas_left).offset(Margin_10);
        make.top.equalTo(promptBg.mas_top).offset(Margin_Main);
        make.height.mas_equalTo(Margin_20);
    }];
    UILabel * prompt = [[UILabel alloc] init];
    prompt.font = FONT_TITLE;
    prompt.textColor = WARNING_COLOR;
    prompt.numberOfLines = 0;
    prompt.text = Localized(@"MnemonicsPrompt");
    [promptBg addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noScreenshot);
        make.right.equalTo(promptBg.mas_right).offset(-Margin_10);
        make.top.equalTo(noScreenshot.mas_bottom).offset(Margin_5);
        make.bottom.equalTo(promptBg.mas_bottom).offset(-Margin_Main);
    }];
    UILabel * savePrompt = [UILabel createTitleLabel];
    savePrompt.text = Localized(@"MnemonicsSavePrompt");
    [self.scrollView addSubview:savePrompt];
    [savePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBg.mas_bottom).offset(Margin_30);
        make.left.right.equalTo(promptBg);
    }];
    CGFloat tagW = (View_Width_Main - Margin_30) / 4;
    CGFloat tagH = Margin_40;
    for (NSInteger i = 0; i < self.mnemonicArray.count; i ++) {
        UIButton * tagBtn = [UIButton createButtonWithTitle:self.mnemonicArray[i] TextFont:FONT_15 TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:nil Selector:nil];
        tagBtn.backgroundColor = VIEWBG_COLOR;
        tagBtn.layer.cornerRadius = TAG_CORNER;
        [self.scrollView addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(promptBg.mas_left).offset((tagW + Margin_10) * (i % 4));
            make.top.equalTo(savePrompt.mas_bottom).offset(Margin_Main + (tagH + Margin_10) * (i / 4));
            make.size.mas_equalTo(CGSizeMake(tagW, tagH));
        }];
    }
    
    self.copied = [UIButton createFooterViewWithTitle:Localized(@"Copied") isEnabled:YES Target:self Selector:@selector(copiedAction)];
//    [UIButton createButtonWithTitle:Localized(@"Copied") isEnabled:YES Target:self Selector:@selector(copiedAction)];
//    [self.scrollView addSubview:copied];
//    [copied mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(savePrompt.mas_bottom).offset(ScreenScale(135) + (tagH + Margin_10) * (self.mnemonicArray.count / 4));
//        make.left.right.equalTo(promptBg);
//        make.height.mas_equalTo(MAIN_HEIGHT);
//    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(savePrompt.frame) + ScreenScale(135) + (tagH + Margin_10) * (self.mnemonicArray.count / 4) + ContentInset_Bottom);
}
- (void)copiedAction
{
    ConfirmMnemonicViewController * VC = [[ConfirmMnemonicViewController alloc] init];
    VC.mnemonicArray = self.mnemonicArray;
    VC.mnemonicType = self.mnemonicType;
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
