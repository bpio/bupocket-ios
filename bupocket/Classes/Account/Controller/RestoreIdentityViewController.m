//
//  RestoreIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RestoreIdentityViewController.h"
#import "PlaceholderTextView.h"

@interface RestoreIdentityViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) PlaceholderTextView * memorizingWords;
@property (nonatomic, strong) UITextField * purseName;
@property (nonatomic, strong) UITextField * pursePassword;
@property (nonatomic, strong) UITextField * confirmPassword;
@property (nonatomic, strong) UIButton * createIdentity;

@end

@implementation RestoreIdentityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"RestoreIdentity");
    [self setupView];
}
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.memorizingWords];
    [self.memorizingWords mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Margin_30);
        make.left.equalTo(self.view.mas_left).offset(Margin_30);
        make.right.equalTo(self.view.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(ScreenScale(130));
    }];
    _purseName = [UITextField textFieldWithplaceholder:Localized(@"newWalletName")];
    _purseName.delegate = self;
    _purseName.enablesReturnKeyAutomatically = YES;
    [_purseName addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_purseName];
    
    _pursePassword = [self setupPWPlaceholder:Localized(@"SetPassword")];
    [self.view addSubview:_pursePassword];
    
    _confirmPassword = [self setupPWPlaceholder:Localized(@"ConfirmPassword")];
    [self.view addSubview:_confirmPassword];
    
    _createIdentity = [UIButton createButtonWithTitle:Localized(@"Create") isEnabled:NO Target:self Selector:@selector(createAction)];
    [self.view addSubview:_createIdentity];
    
    [_purseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memorizingWords.mas_bottom).offset(Margin_25);
        make.left.right.equalTo(self.memorizingWords);
        make.height.mas_equalTo(TEXTFIELD_HEIGHT);
    }];
    [_pursePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purseName.mas_bottom).offset(Margin_25);
        make.left.right.height.equalTo(self.purseName);
    }];
    
    [_confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pursePassword.mas_bottom).offset(Margin_25);
        make.left.right.height.equalTo(self.purseName);
    }];
    
    [_createIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPassword.mas_bottom).offset(MAIN_HEIGHT);
        make.left.right.equalTo(self.purseName);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (PlaceholderTextView *)memorizingWords
{
    if (!_memorizingWords) {
        _memorizingWords = [[PlaceholderTextView alloc] init];
        _memorizingWords.placeholder = Localized(@"MnemonicPrompt");
        _memorizingWords.delegate = self;
        _memorizingWords.layer.masksToBounds = YES;
        _memorizingWords.layer.cornerRadius = ScreenScale(5);
        _memorizingWords.backgroundColor = VIEWBG_COLOR;
    }
    return _memorizingWords;
}
- (UITextField *)setupPWPlaceholder:(NSString *)placeholder
{
    UITextField * textField = [UITextField textFieldWithplaceholder:placeholder];
    textField.secureTextEntry = YES;
    textField.delegate = self;
    UIButton * ifSecure = [UIButton createButtonWithNormalImage:@"password_ciphertext" SelectedImage:@"password_visual" Target:self Selector:@selector(secureAction:)];
    ifSecure.frame = CGRectMake(0, 0, Margin_20, TEXTFIELD_HEIGHT);
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = ifSecure;
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    return textField;
}
- (void)keyBoardHidden
{
    [self.view endEditing:YES];
}
- (void)textChange:(UITextField *)textField
{
    [self ifEnable];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self ifEnable];
}
- (void)ifEnable
{
    if (_purseName.text.length > 0 && _pursePassword.text.length > 0 && _confirmPassword.text.length > 0 && _memorizingWords.text.length > 0) {
        _createIdentity.enabled = YES;
        _createIdentity.backgroundColor = MAIN_COLOR;
    } else {
        _createIdentity.enabled = NO;
        _createIdentity.backgroundColor = DISABLED_COLOR;
    }
}
- (void)secureAction:(UIButton *)button
{
    button.selected = !button.selected;
    UITextField * textField = (UITextField *)button.superview;
    textField.secureTextEntry = !textField.secureTextEntry;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _purseName) {
        [_purseName resignFirstResponder];
        [_pursePassword becomeFirstResponder];
    } else if (textField == _pursePassword) {
        [_pursePassword resignFirstResponder];
        [_confirmPassword becomeFirstResponder];
    } else if (textField == _confirmPassword) {
        [_confirmPassword resignFirstResponder];
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
- (void)setData
{
    NSArray * words = [_memorizingWords.text componentsSeparatedByString:@" "];
    if (words.count != NumberOf_MnemonicWords) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"MnemonicIsIncorrect")];
        return;
    }
    NSData * random = [Mnemonic randomFromMnemonicCode: words];
    [[HTTPManager shareManager] setAccountDataWithRandom:random password:self.pursePassword.text identityName:self.purseName.text success:^(id responseObject) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:ifCreated];
        [defaults synchronize];
    } failure:^(NSError *error) {
        
    }];
}
- (void)confirmUpdate
{
    if ([RegexPatternTool validateUserName:_purseName.text] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"WalletNameFormatIncorrect")];
        return;
    }
    if ([RegexPatternTool validatePassword:_pursePassword.text] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"CryptographicFormat")];
        return;
    }
    if (![_pursePassword.text isEqualToString:_confirmPassword.text]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsDifferent")];
        return;
    }
    UIAlertController * alertController = [Encapsulation alertControllerWithCancelTitle:Localized(@"Cancel") title:nil message:Localized(@"ConfirmRecoveryID")];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setData];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//创建事件处理
- (void)createAction
{
    [self confirmUpdate];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
