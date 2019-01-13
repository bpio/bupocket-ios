//
//  PasswordAlertView.m
//  bupocket
//
//  Created by huoss on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "PasswordAlertView.h"

@interface PasswordAlertView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * PWTextField;
@property (nonatomic, assign) PasswordType passwordType;
@property (nonatomic, assign) CGFloat bgHeight;
@property (nonatomic, strong) UILabel * promptLabel;

@end

@implementation PasswordAlertView

- (instancetype)initWithPrompt:(NSString *)prompt isAutomaticClosing:(BOOL)isAutomaticClosing confrimBolck:(void (^)(NSString * password, NSArray * words))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        self.isAutomaticClosing = isAutomaticClosing;
        [self setupView];
        _promptLabel.text = prompt;
        if ([_promptLabel.text isEqualToString:Localized(@"IdentityCipherWarning")]) {
            _promptLabel.textColor = WARNING_COLOR;
        } else {
            _promptLabel.textColor = COLOR_6;
        }
        self.bgHeight = [Encapsulation rectWithText:self.promptLabel.text font:_promptLabel.font textWidth:DEVICE_WIDTH - ScreenScale(80)].size.height  + ScreenScale(255);
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, self.bgHeight);
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    if (self.isAutomaticClosing) {
        UIButton * closeBtn = [UIButton createButtonWithNormalImage:@"close" SelectedImage:@"close" Target:self Selector:@selector(cancleBtnClick)];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(MAIN_HEIGHT, MAIN_HEIGHT));
        }];
    }
    
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
    _promptLabel.font = TITLE_FONT;
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
    PWTextField.font = TITLE_FONT;
    PWTextField.placeholder = Localized(@"PWPlaceholder");
    PWTextField.layer.cornerRadius = ScreenScale(3);
    PWTextField.layer.borderColor = LINE_COLOR.CGColor;
    PWTextField.layer.borderWidth = LINE_WIDTH;
    PWTextField.secureTextEntry = YES;
    PWTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
    PWTextField.leftViewMode = UITextFieldViewModeAlways;
    PWTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
    PWTextField.rightViewMode = UITextFieldViewModeAlways;
    [self addSubview:PWTextField];
    [PWTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).offset(Margin_25);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.PWTextField = PWTextField;
    UIButton * sureBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:YES Target:self Selector:@selector(sureBtnClick)];
    [self addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_20);
        make.left.right.equalTo(PWTextField);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
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
    if ([RegexPatternTool validatePassword:self.PWTextField.text] == NO) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"CryptographicFormat")];
    } else {
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
        __block NSString * password = self.PWTextField.text;
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSData * random = [NSString decipherKeyStoreWithPW:password randomKeyStoreValueStr:[[AccountTool shareTool] account].randomNumber];
                if (random) {
                    NSArray * words = [Mnemonic generateMnemonicCode: random];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                        if (self->_sureBlock) {
                            self->_sureBlock(password, words);
                        }
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
                    });
                }
            }];
        }];
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
