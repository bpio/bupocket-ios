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
        make.top.equalTo(self.view.mas_top).offset(NavBarH + Margin_30);
        make.left.equalTo(self.view.mas_left).offset(Margin_30);
        make.right.equalTo(self.view.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(ScreenScale(130));
    }];
    _purseName = [UITextField textFieldWithplaceholder:Localized(@"newWalletName") margin:30 height:35 font:15];
    _purseName.delegate = self;
//    _purseName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
        make.top.equalTo(self.memorizingWords.mas_bottom).offset(Margin_25);
        make.left.equalTo(self.view.mas_left).offset(Margin_30);
        make.right.equalTo(self.view.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(35);
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
        make.top.equalTo(self.confirmPassword.mas_bottom).offset(ScreenScale(48));
        make.left.equalTo(self.view.mas_left).offset(Margin_30);
        make.right.equalTo(self.view.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (PlaceholderTextView *)memorizingWords
{
    if (!_memorizingWords) {
        _memorizingWords = [[PlaceholderTextView alloc] init];
        _memorizingWords.font = FONT(14);
        _memorizingWords.textColor = COLOR_6;
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
    [HTTPManager setAccountDataWithRandom:random password:self.pursePassword.text identityName:self.purseName.text success:^(id responseObject) {
        [MBProgressHUD wb_showSuccess:@"身份恢复成功"];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:ifCreated];
        [defaults synchronize];
    } failure:^(NSError *error) {
        
    }];
    /*
//    NSLog(@"%@", [Tools dataToHexStr: random2]);
//    NSString * randomNumber = [Tools dataToHexStr: random];
//    // 随机数 -> 生成助记词
//    NSArray * words = [Mnemonic generateMnemonicCode: [random copy]];
//    NSLog(@"%@", [words componentsJoinedByString:@" "]);
    // 身份账户、钱包账户
    NSMutableArray * hdPaths = [NSMutableArray arrayWithObjects:@"M/44H/526H/0H/0/0", @"M/44H/526H/1H/0/0", nil];
    NSArray *privateKeys = [Mnemonic generatePrivateKeys: words : hdPaths];
    NSLog(@"%@", privateKeys);
    // 随机数data -> 随机数字符串
//    NSString * randomNumber  = [Tools dataToHexStr: random];
    // 存储随机数、身份账户、钱包账户、创建身份成功
    NSString * randomKey = [NSString generateKeyStoreWithPW:self.pursePassword.text randomKey:random];
    NSString * identityKey = [NSString generateKeyStoreWithPW:self.pursePassword.text key:[privateKeys firstObject]];
    NSString * identityAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys firstObject]]];
    NSString * purseKey = [NSString generateKeyStoreWithPW:self.pursePassword.text key:[privateKeys lastObject]];
    NSString * purseAddress = [Keypair getEncAddress : [Keypair getEncPublicKey: [privateKeys lastObject]]];
    if (randomKey == nil) {
        [MBProgressHUD wb_showError:@"随机数keyStore生成失败"];
    } else if (identityKey == nil) {
        [MBProgressHUD wb_showError:@"身份账户keyStore生成失败"];
    } else if (purseKey == nil) {
        [MBProgressHUD wb_showError:@"钱包账户keyStore生成失败"];
    } else {
        AccountModel * account = [[AccountModel alloc] init];
        account.identityName = self.purseName.text;
        account.randomNumber = randomKey;
        account.identityAccount = identityAddress;
        account.purseAccount = purseAddress;
        account.identityKey = identityKey;
        account.purseKey = purseKey;
        // 存储帐号模型
        [AccountTool save:account];
        [MBProgressHUD wb_hideHUD];
        //            [defaults setObject:randomKey forKey:RandomNumber];
        //            [defaults setObject:[NSString generateKeyStoreWithPW:self.identityPassword.text key:[privateKeys firstObject]] forKey:IdentityAccount];
        //            [defaults setObject:[NSString generateKeyStoreWithPW:self.identityPassword.text key:[privateKeys firstObject]] forKey:PurseAccount];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:ifBackup];
        [defaults synchronize];
    }
     */
}
- (void)confirmUpdate
{
    if ([RegexPatternTool validateUserName:_purseName.text] == NO) {
        [MBProgressHUD wb_showInfo:@"钱包名只允许输入字母、汉字、数字、下划线，并且长度不能超过20个字符"];
        return;
    }
    if ([RegexPatternTool validatePassword:_pursePassword.text] == NO) {
        [MBProgressHUD wb_showInfo:@"密码长度为8~20个字符，且内容仅限字母和数字"];
        return;
    }
    if (![_confirmPassword.text isEqualToString:_confirmPassword.text]) {
        [MBProgressHUD wb_showInfo:@"密码与确认密码不一致"];
        return;
    }
    UIAlertController * alertController = [Encapsulation alertControllerWithTitle:nil message:Localized(@"ConfirmRecoveryID")];
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
