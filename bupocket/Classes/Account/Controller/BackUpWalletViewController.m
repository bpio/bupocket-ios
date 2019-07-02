//
//  BackUpWalletViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/17.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BackUpWalletViewController.h"
#import "BackupMnemonicsViewController.h"

@interface BackUpWalletViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation BackUpWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"BackupMnemonics");
    [self setupView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton createNavButtonWithTitle:Localized(@"Skip") Target:self Selector:@selector(skipAction)]];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    
    UILabel * title = [[UILabel alloc] init];
    title.font = FONT_15;
    title.textColor = COLOR_6;
    title.text = Localized(@"BackUpWalletTitle");
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(ScreenScale(Margin_30));
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    UIImageView * wallet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet"]];
    [self.scrollView addSubview:wallet];
    
    [wallet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(title.mas_bottom).offset(Margin_25);
    }];
    UILabel * note = [[UILabel alloc] init];
    note.font = FONT_Bold(15);
    note.textColor = TITLE_COLOR;
    note.text = Localized(@"Note");
    [self.scrollView addSubview:note];
    [note mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wallet.mas_bottom).offset(Margin_40);
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
    }];
    NSArray * noteArray = @[Localized(@"BackUpWalletNote1"), Localized(@"BackUpWalletNote2"), Localized(@"BackUpWalletNote3"), Localized(@"BackUpWalletNote4")];
    CGFloat noteLabelH = 0;
    for (NSInteger i = 0; i < noteArray.count; i++) {
        UILabel * noteLabel = [[UILabel alloc] init];
        noteLabel.numberOfLines = 0;
        noteLabel.attributedText = [Encapsulation attrWithString:noteArray[i] preFont:FONT_13 preColor:COLOR_6 index:0 sufFont:FONT_13 sufColor:COLOR_6 lineSpacing:Margin_5];
        [self.scrollView addSubview:noteLabel];
        if (i > 0) {
            noteLabelH += [self getNoteTextHeightWithText:noteArray[i - 1]] + Margin_10;
        }
        CGSize maximumSize = CGSizeMake(DEVICE_WIDTH - Margin_40, CGFLOAT_MAX);
        CGSize expectSize = [noteLabel sizeThatFits:maximumSize];
        [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(note.mas_bottom).offset(Margin_15 + noteLabelH);
            make.left.width.equalTo(note);
            make.height.mas_equalTo(expectSize.height);
        }];
    }
    noteLabelH += [self getNoteTextHeightWithText:noteArray[noteArray.count - 1]];
    UIButton * backupMnemonics = [UIButton createButtonWithTitle:Localized(@"BackupMnemonics") isEnabled:YES Target:self Selector:@selector(backupMnemonicsAction)];
    [self.scrollView addSubview:backupMnemonics];
    [backupMnemonics mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(note.mas_bottom).offset(Margin_15 + noteLabelH + Margin_60);
        make.left.width.equalTo(note);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(backupMnemonics.frame) + ContentSizeBottom + ScreenScale(100));
}
- (CGFloat)getNoteTextHeightWithText:(NSString *)text
{
    return [Encapsulation getSizeSpaceLabelWithStr:text font:FONT_13 width:DEVICE_WIDTH - Margin_40 height:CGFLOAT_MAX lineSpacing:Margin_5].height;
}

- (void)backupMnemonicsAction
{
    if (self.mnemonicArray.count > 0) {
        BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
        VC.mnemonicArray = self.mnemonicArray;
        [self.navigationController pushViewController:VC animated:NO];
    } else {
        PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"IdentityCipherPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
            if (words.count > 0) {
                BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
                VC.mnemonicArray = words;
                [self.navigationController pushViewController:VC animated:NO];
            }
        } cancelBlock:^{
        }];
        alertView.passwordType = PWTypeBackUpID;
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        [alertView.PWTextField becomeFirstResponder];
    }
}
- (void)skipAction
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:If_Skip];
    [defaults synchronize];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
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