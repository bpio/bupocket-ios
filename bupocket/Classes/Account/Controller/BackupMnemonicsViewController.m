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
    UIView * promptBg = [[UIView alloc] init];
    promptBg.backgroundColor = VIEWBG_COLOR;
    promptBg.layer.cornerRadius = ScreenScale(1);
    [self.view addSubview:promptBg];
    [promptBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Margin_20);
        make.left.equalTo(self.view.mas_left).offset(Margin_20);
        make.right.equalTo(self.view.mas_right).offset(-Margin_20);
    }];
    
    CustomButton * noScreenshot = [[CustomButton alloc] init];
    [noScreenshot setTitle:Localized(@"NoScreenshot") forState:UIControlStateNormal];
    [noScreenshot setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
    noScreenshot.titleLabel.font = TITLE_FONT;
    [noScreenshot setImage:[UIImage imageNamed:@"noScreenshot"] forState:UIControlStateNormal];
    [promptBg addSubview:noScreenshot];
    [noScreenshot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptBg.mas_left).offset(Margin_10);
        make.top.equalTo(promptBg.mas_top).offset(Margin_15);
        make.height.mas_equalTo(Margin_30);
    }];
    UILabel * prompt = [[UILabel alloc] init];
    prompt.font = TITLE_FONT;
    prompt.textColor = WARNING_COLOR;
    prompt.numberOfLines = 0;
    prompt.text = Localized(@"MnemonicsPrompt");
    [promptBg addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noScreenshot);
        make.right.equalTo(promptBg.mas_right).offset(-Margin_15);
        make.top.equalTo(noScreenshot.mas_bottom);
        make.bottom.equalTo(promptBg.mas_bottom).offset(-Margin_20);
    }];
    UILabel * savePrompt = [[UILabel alloc] init];
    savePrompt.font = TITLE_FONT;
    savePrompt.textColor = COLOR_9;
    savePrompt.numberOfLines = 0;
    savePrompt.text = Localized(@"MnemonicsSavePrompt");
    [self.view addSubview:savePrompt];
    [savePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBg.mas_bottom).offset(Margin_30);
        make.left.right.equalTo(promptBg);
    }];
    CGFloat tagW = (DEVICE_WIDTH - ScreenScale(70)) / 4;
    CGFloat tagH = Margin_40;
    for (NSInteger i = 0; i < self.mnemonicArray.count; i ++) {
        UIButton * tagBtn = [UIButton createButtonWithTitle:self.mnemonicArray[i] TextFont:14 TextColor:COLOR_9 Target:nil Selector:nil];
        tagBtn.backgroundColor = VIEWBG_COLOR;
        tagBtn.layer.cornerRadius = TAG_FILLET;
        [self.view addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(promptBg.mas_left).offset((tagW + Margin_10) * (i % 4));
            make.top.equalTo(savePrompt.mas_bottom).offset(Margin_15 + (tagH + Margin_10) * (i / 4));
            make.size.mas_equalTo(CGSizeMake(tagW, tagH));
        }];
    }
    
    UIButton * copied = [UIButton createButtonWithTitle:Localized(@"Copied") isEnabled:YES Target:self Selector:@selector(copiedAction)];
    [self.view addSubview:copied];
    [copied mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(- (SafeAreaBottomH + Margin_50));
        make.left.right.equalTo(promptBg);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (void)copiedAction
{
    ConfirmMnemonicViewController * VC = [[ConfirmMnemonicViewController alloc] init];
    VC.mnemonicArray = self.mnemonicArray;
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
