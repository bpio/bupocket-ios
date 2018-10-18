//
//  RestoreIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "RestoreIdentityViewController.h"
#import "PlaceholderTextView.h"
#import "TabBarViewController.h"

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
        make.top.equalTo(self.view.mas_top).offset(NavBarH + ScreenScale(30));
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(30));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(30));
        make.height.mas_equalTo(ScreenScale(130));
    }];
    _purseName = [UITextField textFieldWithplaceholder:Localized(@"newWalletName") margin:30 height:35 font:15];
    _purseName.delegate = self;
    _purseName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _purseName.enablesReturnKeyAutomatically = YES;
    [_purseName addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_purseName];
    
    _pursePassword = [self setupPWPlaceholder:Localized(@"SetPassword")];
    [self.view addSubview:_pursePassword];
    
    _confirmPassword = [self setupPWPlaceholder:Localized(@"ConfirmPassword")];
    [self.view addSubview:_confirmPassword];
    
    _createIdentity = [UIButton createButtonWithTitle:Localized(@"Create") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(createAction)];
    _createIdentity.layer.masksToBounds = YES;
    _createIdentity.clipsToBounds = YES;
    _createIdentity.layer.cornerRadius = ScreenScale(4);
    _createIdentity.enabled = NO;
    _createIdentity.backgroundColor = COLOR(@"9AD9FF");
    [self.view addSubview:_createIdentity];
    
    [_purseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memorizingWords.mas_bottom).offset(ScreenScale(25));
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(30));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(30));
        make.height.mas_equalTo(35);
    }];
    [_pursePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purseName.mas_bottom).offset(ScreenScale(25));
        make.left.right.height.equalTo(self.purseName);
    }];
    
    [_confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pursePassword.mas_bottom).offset(ScreenScale(25));
        make.left.right.height.equalTo(self.purseName);
    }];
    
    [_createIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPassword.mas_bottom).offset(ScreenScale(48));
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(30));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(30));
        make.height.mas_equalTo(ScreenScale(45));
    }];
}
- (PlaceholderTextView *)memorizingWords
{
    if (!_memorizingWords) {
        _memorizingWords = [[PlaceholderTextView alloc] init];
        _memorizingWords.font = FONT(14);
        _memorizingWords.textColor = COLOR(@"666666");
        _memorizingWords.placeholderColor = COLOR(@"B2B2B2");
        _memorizingWords.placeholder = Localized(@"MnemonicPrompt");
        _memorizingWords.delegate = self;
        CGFloat xMargin = ScreenScale(8), yMargin = ScreenScale(8);
        // 使用textContainerInset设置top、left、right
        _memorizingWords.textContainerInset = UIEdgeInsetsMake(yMargin, xMargin, 0, xMargin);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        _memorizingWords.contentInset = UIEdgeInsetsMake(0, 0, yMargin, 0);
        //防止在拼音打字时抖动
        _memorizingWords.layoutManager.allowsNonContiguousLayout = NO;
        _memorizingWords.layer.masksToBounds = YES;
        _memorizingWords.layer.cornerRadius = ScreenScale(5);
        _memorizingWords.backgroundColor = COLOR(@"F5F5F5");
    }
    return _memorizingWords;
}
- (UITextField *)setupPWPlaceholder:(NSString *)placeholder
{
    UITextField * textField = [UITextField textFieldWithplaceholder:placeholder margin:30 height:35 font:15];
    textField.secureTextEntry = YES;
    textField.delegate = self;
    UIButton * ifSecure = [UIButton createButtonWithNormalImage:@"password_ciphertext" SelectedImage:@"password_visual" Target:self Selector:@selector(secureAction:)];
    ifSecure.frame = CGRectMake(0, 0, 20, MAIN_HEIGHT);
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
        _createIdentity.backgroundColor = COLOR(@"9AD9FF");
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
//创建事件处理
- (void)createAction
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:Localized(@"CreatePWPrompt") message:Localized(@"ConfirmRecoveryID") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    /*
     [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
     if (self.usernameField.text.length == 0) {
     [MBProgressHUD showError:@"请输入账号"];
     return;
     }
     if (self.passwordField.text.length == 0) {
     [MBProgressHUD showError:@"请输入密码"];
     return;
     }
     [HTTPManager getAccountLoginDataWithtxt_usernum:self.usernameField.text txt_passnum:self.passwordField.text txt_type:1 success:^(id responseObject) {
     NSString * message = [responseObject objectForKey:@"txt_other"];
     NSInteger status =[[responseObject objectForKey:@"txt_code"] integerValue];
     if (status == 0){
     NSDictionary * userDic = responseObject[@"txt_mydata"];
     NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
     //            [defaults setObject: forKey:UserID];
     //            [defaults setObject: forKey:UserToken];
     [defaults synchronize];
     [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
     NSLog(@"%@", responseObject);
     }
     } failure:^(NSError *error) {
     
     }];
     */
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
