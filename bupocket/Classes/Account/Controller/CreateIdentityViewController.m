//
//  CreateIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "CreateIdentityViewController.h"
#import "BackUpPurseViewController.h"
#import "CreateTipsAlertView.h"

@interface CreateIdentityViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * identityName;
@property (nonatomic, strong) UITextField * identityPassword;
@property (nonatomic, strong) UITextField * confirmPassword;
@property (nonatomic, strong) UIButton * createIdentity;

@end

@implementation CreateIdentityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"CreateIdentity");
    [self setupView];
    [self showCreateTips];
}

- (void)showCreateTips
{
    CreateTipsAlertView * alertView = [[CreateTipsAlertView alloc] initWithConfrimBolck:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];

    _identityName = [UITextField textFieldWithplaceholder:Localized(@"IdentityName")];
    _identityName.delegate = self;
    [_identityName addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    _identityName.enablesReturnKeyAutomatically = YES;
    [self.view addSubview:_identityName];
    
    _identityPassword = [self setupPWPlaceholder:Localized(@"SetPassword")];
    [self.view addSubview:_identityPassword];
    
    _confirmPassword = [self setupPWPlaceholder:Localized(@"ConfirmPassword")];
    [self.view addSubview:_confirmPassword];
    
    _createIdentity = [UIButton createButtonWithTitle:Localized(@"Create") isEnabled:NO Target:self Selector:@selector(createAction)];
    [self.view addSubview:_createIdentity];
    
    [_identityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(Margin_30);
        make.left.equalTo(self.view.mas_left).offset(Margin_20);
        make.right.equalTo(self.view.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(TEXTFIELD_HEIGHT);
    }];
    [_identityPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityName.mas_bottom).offset(Margin_25);
        make.left.right.height.equalTo(self.identityName);
    }];
    
    [_confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityPassword.mas_bottom).offset(Margin_25);
        make.left.right.height.equalTo(self.identityName);
    }];
    
    [_createIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPassword.mas_bottom).offset(MAIN_HEIGHT);
        make.left.right.equalTo(self.identityName);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
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
    if (_identityName.text.length > 0 && _identityPassword.text.length > 0 && _confirmPassword.text.length > 0) {
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
    if (textField == _identityName) {
        [_identityName resignFirstResponder];
        [_identityPassword becomeFirstResponder];
    } else if (textField == _identityPassword) {
        [_identityPassword resignFirstResponder];
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)getData
{
    NSMutableData *random = [NSMutableData dataWithLength: Random_Length];
    int status = SecRandomCopyBytes(kSecRandomDefault, random.length, random.mutableBytes);
    if (status == 0) {
        [[HTTPManager shareManager] setAccountDataWithRandom:random password:self.identityPassword.text identityName:self.identityName.text typeTitle:self.navigationItem.title success:^(id responseObject) {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:If_Created];
            [defaults synchronize];
            BackUpPurseViewController * VC = [[BackUpPurseViewController alloc] init];
            VC.mnemonicArray = responseObject;
            [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:VC];
        } failure:^(NSError *error) {
            
        }];
    } else {
        [MBProgressHUD showTipMessageInWindow:Localized(@"CreateIdentityFailure")];
    }
}

- (void)createAction
{
    if ([RegexPatternTool validateUserName:_identityName.text] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"IDNameFormatIncorrect")];
        return;
    }
    if ([RegexPatternTool validatePassword:_identityPassword.text] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"CryptographicFormat")];
        return;
    }
    if (![_confirmPassword.text isEqualToString:_identityPassword.text]) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsDifferent")];
        return;
    }
    [self getData];
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
