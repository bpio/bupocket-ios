//
//  PasswordAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "PasswordAlertView.h"


@interface PasswordAlertView()<UITextFieldDelegate>

@property (nonatomic, assign) CGFloat bgHeight;
@property (nonatomic, strong) UILabel * promptLabel;
@property (nonatomic, strong) UIButton * sureBtn;

@property (nonatomic, copy) OnCancleButtonClick cancleBlock;
@property (nonatomic, copy) OnSureWalletPWClick sureBlock;
@property (nonatomic, strong) UIButton * closeBtn;

@end

@implementation PasswordAlertView

- (instancetype)initWithPrompt:(NSString *)prompt confrimBolck:(void (^)(NSString * password, NSArray * words))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        self.isAutomaticClosing = YES;
        self.walletKeyStore = CurrentWalletKeyStore;
        [self setupView];
        _promptLabel.text = prompt;
        if ([_promptLabel.text isEqualToString:Localized(@"IdentityCipherWarning")]) {
            _promptLabel.textColor = WARNING_COLOR;
        } else {
            _promptLabel.textColor = COLOR_6;
        }
        self.bgHeight = [Encapsulation rectWithText:self.promptLabel.text font:_promptLabel.font textWidth:DEVICE_WIDTH - ScreenScale(100)].size.height  + ScreenScale(255);
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_60, self.bgHeight);
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    self.closeBtn = [UIButton createButtonWithNormalImage:@"close" SelectedImage:@"close" Target:self Selector:@selector(cancleBtnClick)];
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_HEIGHT, MAIN_HEIGHT));
    }];
    self.closeBtn.hidden = YES;
    
    UILabel * title = [UILabel new];
    title.font = FONT(25);
    title.textColor = TITLE_COLOR;
    title.text = Localized(@"IdentityCipherConfirm");
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(35));
        make.centerX.equalTo(self);
    }];
    
    _promptLabel = [UILabel new];
    _promptLabel.font = FONT_TITLE;
    _promptLabel.numberOfLines = 0;
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(Margin_10);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
    }];
    
    UITextField * PWTextField = [[UITextField alloc] init];
    PWTextField.delegate = self;
    PWTextField.textColor = TITLE_COLOR;
    PWTextField.font = FONT_TITLE;
    PWTextField.layer.cornerRadius = ScreenScale(3);
    PWTextField.layer.borderColor = LINE_COLOR.CGColor;
    PWTextField.layer.borderWidth = LINE_WIDTH;
    PWTextField.secureTextEntry = YES;
    PWTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
    PWTextField.leftViewMode = UITextFieldViewModeAlways;
    PWTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
    PWTextField.rightViewMode = UITextFieldViewModeAlways;
    [PWTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:PWTextField];
    [PWTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).offset(Margin_25);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.PWTextField = PWTextField;
    self.sureBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:YES Target:self Selector:@selector(sureBtnClick)];
    [self addSubview:self.sureBtn];
    self.sureBtn.enabled = NO;
    self.sureBtn.backgroundColor = DISABLED_COLOR;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_20);
        make.left.right.equalTo(PWTextField);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}

- (void)textChange:(UITextField *)textField
{
    NSString * password = TrimmingCharacters(textField.text);
    if (password.length > 0) {
        self.sureBtn.enabled = YES;
        self.sureBtn.backgroundColor = MAIN_COLOR;
    } else {
        self.sureBtn.enabled = NO;
        self.sureBtn.backgroundColor = DISABLED_COLOR;
    }
}
- (void)setIsAutomaticClosing:(BOOL)isAutomaticClosing
{
    _isAutomaticClosing = isAutomaticClosing;
    self.closeBtn.hidden = !isAutomaticClosing;
}
- (void)setWalletKeyStore:(NSString *)walletKeyStore
{
    _walletKeyStore = walletKeyStore;
}
- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)sureBtnClick {
    if (self.isAutomaticClosing) {
        [self hideView];
    }
    NSString * password = TrimmingCharacters(self.PWTextField.text);
    if (password.length < PW_MIN_LENGTH || password.length > PW_MAX_LENGTH) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
    } else {
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Signature")];
        [self checkPassword:password];
    }
}
#pragma mark check password
- (void)checkPassword:(NSString *)password
{
    if (self.passwordType == PWTypeBackUpID || self.passwordType == PWTypeDataReinforcement) {
        if (!NotNULLString(self.randomNumber)) {
            self.randomNumber = [[AccountTool shareTool] account].randomNumber;
        }
        // Identity password
        NSData * random = [NSString decipherKeyStoreWithPW:password randomKeyStoreValueStr:self.randomNumber];
        if (random) {
            NSArray * words = [Mnemonic generateMnemonicCode: random];
            [MBProgressHUD hideHUD];
            if (_sureBlock) {
                _sureBlock(password, words);
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        }
    } else {
        // Password for Wallet
        NSString * privateKey = [NSString decipherKeyStoreWithPW:password keyStoreValueStr:self.walletKeyStore];
        if ([Tools isEmpty:privateKey]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        } else {
            [MBProgressHUD hideHUD];
            if (self.passwordType == PWTypeTransaction) {
                if (![[HTTPManager shareManager] getSignWithPrivateKey:privateKey]) {
                    password = @"";
                }
            }
            if (_sureBlock) {
                _sureBlock(password, [NSArray array]);
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
