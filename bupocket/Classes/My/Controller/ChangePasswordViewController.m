//
//  ChangePasswordViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UITextField * PWOld;
@property (nonatomic, strong) UITextField * PWNew;
@property (nonatomic, strong) UITextField * PWConfirm;
@property (nonatomic, strong) UIButton * confirm;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ModifyPassword");
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    NSArray * array = @[@[Localized(@"OldPassword"), Localized(@"NewPassword"), Localized(@"ConfirmedPassword")], @[Localized(@"PleaseEnterOldPW"), Localized(@"PleaseEnterNewPW"), Localized(@"ConfirmPassword")]];
    for (NSInteger i = 0; i < 3; i++) {
        UIView * PWView = [self setViewWithTitle:[array firstObject][i] placeholder:[array lastObject][i] index:i];
        [self.view addSubview:PWView];
        [PWView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(NavBarH + ScreenScale(15) + (ScreenScale(95) * i));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(ScreenScale(95));
        }];
    }
    
    _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(confirmAction)];
    _confirm.layer.masksToBounds = YES;
    _confirm.clipsToBounds = YES;
    _confirm.layer.cornerRadius = ScreenScale(4);
    _confirm.enabled = NO;
    _confirm.backgroundColor = DISABLED_COLOR;
    [self.view addSubview:_confirm];
    [_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin_30 - SafeAreaBottomH);
        make.left.equalTo(self.view.mas_left).offset(Margin_12);
        make.right.equalTo(self.view.mas_right).offset(-Margin_12);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (void)confirmAction
{
    if ([RegexPatternTool validatePassword:_PWOld.text] == NO) {
        [self showAlertControllerWithMessage:Localized(@"CryptographicFormat") handler:nil];
        return;
    }
    if ([RegexPatternTool validatePassword:_PWNew.text] == NO) {
        [self showAlertControllerWithMessage:Localized(@"CryptographicFormat") handler:nil];
        return;
    }
    if (![_PWNew.text isEqualToString:_PWConfirm.text]) {
        [self showAlertControllerWithMessage:Localized(@"NewPasswordIsDifferent") handler:nil];
        return;
    }
    NSData * random = [NSString decipherKeyStoreWithPW:_PWOld.text randomKeyStoreValueStr:[AccountTool account].randomNumber];
    if (random) {
        [HTTPManager setAccountDataWithRandom:random password:self.PWNew.text identityName:[AccountTool account].identityName success:^(id responseObject) {
            [self showAlertControllerWithMessage:Localized(@"PasswordModifiedSuccessfully") handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [self showAlertControllerWithMessage:Localized(@"OldPasswordIncorrect") handler:nil];
    }
//    NSArray * words = [Mnemonic generateMnemonicCode: random];
//    NSData * random = [Mnemonic randomFromMnemonicCode: words];
}
- (void)showAlertControllerWithMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:handle];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIView *)setViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder index:(NSInteger)index
{
    UIView * viewBg = [[UIView alloc] init];
    UILabel * header = [[UILabel alloc] init];
    header.font = FONT(16);
    header.textColor = COLOR_9;
    [viewBg addSubview:header];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| %@", title]];
    //        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //        dic[NSFontAttributeName] = FONT(15);
    //        dic[NSForegroundColorAttributeName] = TITLE_COLOR;
    //        [attr addAttributes:dic range:NSMakeRange(3, str.length - 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, 1)];
    [attr addAttribute:NSFontAttributeName value:FONT_Bold(18) range:NSMakeRange(0, 1)];
    header.attributedText = attr;
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBg.mas_top).offset(ScreenScale(33));
        make.left.equalTo(viewBg.mas_left).offset(ScreenScale(22));
        make.right.equalTo(viewBg.mas_right).offset(-ScreenScale(22));
//        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(16);
    textField.placeholder = placeholder;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewBg addSubview:textField];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(ScreenScale(5));
        make.left.equalTo(viewBg.mas_left).offset(Margin_30);
        make.right.equalTo(viewBg.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(ScreenScale(39));
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR(@"E3E3E3");
    [viewBg addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.right.equalTo(header);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    switch (index) {
        case 0:
            self.PWOld = textField;
            break;
        case 1:
            self.PWNew = textField;
            break;
        case 2:
            self.PWConfirm = textField;
            break;
        default:
            break;
    }
    return viewBg;
}
- (void)keyBoardHidden
{
    [self.view endEditing:YES];
}
- (void)textChange:(UITextField *)textField
{
    if (_PWOld.text.length > 0 && _PWNew.text.length > 0 && _PWConfirm.text.length > 0) {
        _confirm.enabled = YES;
        _confirm.backgroundColor = MAIN_COLOR;
    } else {
        _confirm.enabled = NO;
        _confirm.backgroundColor = DISABLED_COLOR;
    }
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
