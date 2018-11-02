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
    promptBg.backgroundColor = COLOR(@"F5F5F5");
    promptBg.layer.cornerRadius = ScreenScale(1);
    [self.view addSubview:promptBg];
    [promptBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NavBarH + Margin_30);
        make.left.equalTo(self.view.mas_left).offset(Margin_30);
        make.right.equalTo(self.view.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(ScreenScale(100));
    }];
    
    CustomButton * noScreenshot = [[CustomButton alloc] init];
    [noScreenshot setTitle:Localized(@"NoScreenshot") forState:UIControlStateNormal];
    [noScreenshot setTitleColor:COLOR(@"FF7272") forState:UIControlStateNormal];
    noScreenshot.titleLabel.font = FONT(14);
    [noScreenshot setImage:[UIImage imageNamed:@"noScreenshot"] forState:UIControlStateNormal];
    [promptBg addSubview:noScreenshot];
    [noScreenshot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptBg.mas_left).offset(Margin_10);
        make.top.equalTo(promptBg.mas_top).offset(ScreenScale(15));
        make.height.mas_equalTo(Margin_30);
    }];
    UILabel * prompt = [[UILabel alloc] init];
    prompt.font = FONT(14);
    prompt.textColor = COLOR(@"FF7272");
    prompt.numberOfLines = 0;
    prompt.text = Localized(@"MnemonicsPrompt");
    [promptBg addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noScreenshot);
        make.right.equalTo(promptBg.mas_right).offset(-ScreenScale(15));
        make.top.equalTo(noScreenshot.mas_bottom);
    }];
    UILabel * savePrompt = [[UILabel alloc] init];
    savePrompt.font = FONT(14);
    savePrompt.textColor = COLOR_9;
    savePrompt.text = Localized(@"MnemonicsSavePrompt");
    [self.view addSubview:savePrompt];
    [savePrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promptBg.mas_bottom).offset(30);
        make.left.right.equalTo(promptBg);
    }];
    CGFloat tagW = (DEVICE_WIDTH - ScreenScale(90)) / 4;
    CGFloat tagH = Margin_40;
    for (NSInteger i = 0; i < self.mnemonicArray.count; i ++) {
        UIButton * tagBtn = [UIButton createButtonWithTitle:self.mnemonicArray[i] TextFont:14 TextColor:COLOR_9 Target:nil Selector:nil];
        tagBtn.backgroundColor = COLOR(@"F5F5F5");
        tagBtn.layer.cornerRadius = ScreenScale(2);
        [self.view addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(promptBg.mas_left).offset((tagW + Margin_10) * (i % 4));
            make.top.equalTo(savePrompt.mas_bottom).offset(ScreenScale(15) + (tagH + Margin_10) * (i / 4));
            make.size.mas_equalTo(CGSizeMake(tagW, tagH));
        }];
    }
//    [self setupTagsViewWithArray:array];
//    [self.view addSubview:self.tagView];
//    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(savePrompt.mas_bottom).offset(ScreenScale(15));
//        make.left.right.equalTo(promptBg);
//    }];
//    self.tagView.backgroundColor = [UIColor redColor];
    
    UIButton * copied = [UIButton createButtonWithTitle:Localized(@"Copied") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(copiedAction)];
    copied.layer.masksToBounds = YES;
    copied.clipsToBounds = YES;
    copied.layer.cornerRadius = ScreenScale(4);
    copied.backgroundColor = MAIN_COLOR;
    [self.view addSubview:copied];
    [copied mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-ScreenScale(55) - SafeAreaBottomH);
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
- (UIView *)setupTagsViewWithArray:(NSArray *)array
{
    _tagView = [[UIView alloc] init];
    CGFloat tagViewW = (DEVICE_WIDTH - ScreenScale(60));
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.font = FONT(15);
        label.textColor = COLOR_9;
        label.backgroundColor = COLOR(@"F5F5F5");
        label.text = array[i];
        label.layer.cornerRadius = ScreenScale(2);
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.width += Margin_20;
//        label.height += 14;
        label.height = Margin_40;
        if (label.width > tagViewW - Margin_20) label.width = tagViewW - Margin_20;
        if (currentX + label.width + Margin_10 * countRow > tagViewW - Margin_20) {
            label.left = 0;
            label.top = (currentY += label.height) + Margin_10 * ++countCol;
            currentX = label.width;
            countRow = 1;
        } else {
            label.left = (currentX += label.width) - label.width + Margin_10 * countRow;
            label.top = currentY + Margin_10 * countCol;
            countRow ++;
        }
        [_tagView addSubview:label];
//        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
    }
    _tagView.frame = CGRectMake(0, 0, tagViewW, CGRectGetMaxY(_tagView.subviews.lastObject.frame));
    return _tagView;
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
