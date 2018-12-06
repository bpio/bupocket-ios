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
@property (nonatomic, strong) UIButton * restoreIdentity;

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
    [self.view addSubview:self.memorizingWords];
    [self.memorizingWords mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Margin_30);
        make.left.equalTo(self.view.mas_left).offset(Margin_20);
        make.right.equalTo(self.view.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(ScreenScale(130));
    }];
    _purseName = [UITextField textFieldWithplaceholder:Localized(@"newIdentityName")];
    _purseName.delegate = self;
    _purseName.enablesReturnKeyAutomatically = YES;
    [_purseName addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_purseName];
    
    _pursePassword = [self setupPWPlaceholder:Localized(@"SetPassword")];
    [self.view addSubview:_pursePassword];
    
    _confirmPassword = [self setupPWPlaceholder:Localized(@"ConfirmPassword")];
    [self.view addSubview:_confirmPassword];
    
    _restoreIdentity = [UIButton createButtonWithTitle:Localized(@"Restore") isEnabled:NO Target:self Selector:@selector(restoreAction)];
    [self.view addSubview:_restoreIdentity];
    
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
    
    [_restoreIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
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
        _memorizingWords.layer.cornerRadius = BG_CORNER;
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
        _restoreIdentity.enabled = YES;
        _restoreIdentity.backgroundColor = MAIN_COLOR;
    } else {
        _restoreIdentity.enabled = NO;
        _restoreIdentity.backgroundColor = DISABLED_COLOR;
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
    NSData * random = [Mnemonic randomFromMnemonicCode: words];
    [[HTTPManager shareManager] setAccountDataWithRandom:random password:self.pursePassword.text identityName:self.purseName.text success:^(id responseObject) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:If_Created];
        [defaults setBool:YES forKey:If_Backup];
        [defaults synchronize];
    } failure:^(NSError *error) {
        
    }];
}

- (void)restoreAction
{
    NSArray * words = [_memorizingWords.text componentsSeparatedByString:@" "];
    if (words.count != NumberOf_MnemonicWords) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"MnemonicIsIncorrect")];
        return;
    }
    if ([RegexPatternTool validateUserName:_purseName.text] == NO) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"WalletNameFormatIncorrect")];
        return;
    }
    if ([RegexPatternTool validatePassword:_pursePassword.text] == NO) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"CryptographicFormat")];
        return;
    }
    if (![_pursePassword.text isEqualToString:_confirmPassword.text]) {
        [[HUDHelper sharedInstance] syncStopLoadingMessage:Localized(@"PasswordIsDifferent")];
        return;
    }
    UIAlertController * alertController = [Encapsulation alertControllerWithCancelTitle:Localized(@"Cancel") title:nil message:Localized(@"ConfirmRecoveryID")];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setData];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
