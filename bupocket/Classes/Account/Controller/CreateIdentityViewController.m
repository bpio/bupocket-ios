//
//  CreateIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "CreateIdentityViewController.h"
#import "BackUpPurseViewController.h"
#import "CreatePromptAlertView.h"

@interface CreateIdentityViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * identityName;
@property (nonatomic, strong) UITextField * identityPassword;
@property (nonatomic, strong) UITextField * confirmPassword;
@property (nonatomic, strong) UIButton * createIdentity;

@end

@implementation CreateIdentityViewController

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
    self.navigationItem.title = Localized(@"CreateIdentity");
    [self setupView];
}
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    _identityName = [UITextField textFieldWithplaceholder:Localized(@"IdentityName") margin:30 height:35 font:15];
    _identityName.delegate = self;
    [_identityName addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    _identityName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _identityName.enablesReturnKeyAutomatically = YES;
    [self.view addSubview:_identityName];
    
    _identityPassword = [self setupPWPlaceholder:Localized(@"SetPassword")];
    [self.view addSubview:_identityPassword];
    
    _confirmPassword = [self setupPWPlaceholder:Localized(@"ConfirmPassword")];
    [self.view addSubview:_confirmPassword];
    
    _createIdentity = [UIButton createButtonWithTitle:Localized(@"Create") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(createAction)];
    _createIdentity.layer.masksToBounds = YES;
    _createIdentity.clipsToBounds = YES;
    _createIdentity.layer.cornerRadius = ScreenScale(4);
    _createIdentity.backgroundColor = COLOR(@"9AD9FF");
    _createIdentity.enabled = NO;
    [self.view addSubview:_createIdentity];
    
    [_identityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavBarH + ScreenScale(40));
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(30));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(30));
        make.height.mas_equalTo(35);
    }];
    [_identityPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityName.mas_bottom).offset(ScreenScale(25));
        make.left.right.height.equalTo(self.identityName);
    }];
    
    [_confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityPassword.mas_bottom).offset(ScreenScale(25));
        make.left.right.height.equalTo(self.identityName);
    }];
    
    [_createIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPassword.mas_bottom).offset(ScreenScale(48));
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(30));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(30));
        make.height.mas_equalTo(ScreenScale(45));
    }];
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
- (void)textChange:(UITextField *)textField
{
    if (_identityName.text.length > 0 && _identityPassword.text.length > 0 && _confirmPassword.text.length > 0) {
        _createIdentity.enabled = YES;
        _createIdentity.backgroundColor = MAIN_COLOR;
    } else {
        _createIdentity.enabled = NO;
        _createIdentity.backgroundColor = COLOR(@"9AD9FF");
    }
}
- (void)keyBoardHidden
{
    [self.view endEditing:YES];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CreatePromptAlertView * alertView = [[CreatePromptAlertView alloc] init];
    
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
}

//创建事件处理
- (void)createAction
{
    
    BackUpPurseViewController * VC = [[BackUpPurseViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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
