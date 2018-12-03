//
//  ChangePasswordViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    NSArray * array = @[@[Localized(@"OldPassword"), Localized(@"NewPassword"), Localized(@"ConfirmedPassword")], @[Localized(@"PleaseEnterOldPW"), Localized(@"PleaseEnterNewPW"), Localized(@"ConfirmPassword")]];
    for (NSInteger i = 0; i < 3; i++) {
        [self setViewWithTitle:[array firstObject][i] placeholder:[array lastObject][i] index:i];
    }
    
    _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:NO Target:self Selector:@selector(confirmAction)];
    [self.scrollView addSubview:_confirm];
    [_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(DEVICE_HEIGHT - Margin_30 - SafeAreaBottomH - NavBarH - MAIN_HEIGHT);
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
//        make.top.mas_equalTo(ScreenScale(33) + (ScreenScale(95) * 3) + ScreenScale(190));
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_confirm.frame) + ContentSizeBottom + ScreenScale(100));
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
        [[HTTPManager shareManager] setAccountDataWithRandom:random password:self.PWNew.text identityName:[AccountTool account].identityName success:^(id responseObject) {
            [self showAlertControllerWithMessage:Localized(@"PasswordModifiedSuccessfully") handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [self showAlertControllerWithMessage:Localized(@"OldPasswordIncorrect") handler:nil];
    }
}
- (void)showAlertControllerWithMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:handle];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder index:(NSInteger)index
{
//    UIView * viewBg = [[UIView alloc] init];
    UILabel * header = [[UILabel alloc] init];
    [self.scrollView addSubview:header];
    header.attributedText = [Encapsulation attrTitle:title ifRequired:NO];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScreenScale(33) + (ScreenScale(95) * index));
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
    }];
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(16);
    textField.placeholder = placeholder;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    [self.scrollView addSubview:textField];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(Margin_5);
        make.left.width.equalTo(header);
        make.height.mas_equalTo(Margin_40);
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_COLOR;
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.width.equalTo(header);
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _PWOld) {
        [_PWOld resignFirstResponder];
        [_PWNew becomeFirstResponder];
    } else if (textField == _PWNew) {
        [_PWNew resignFirstResponder];
        [_PWConfirm becomeFirstResponder];
    } else if (textField == _PWConfirm) {
        [_PWConfirm resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length == 0) {
        return YES;
    }
    if (str.length > MAX_LENGTH) {
        textField.text = [str substringToIndex:MAX_LENGTH];
        return NO;
    } else {
        return YES;
    }
    return YES;
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
