//
//  TextInputAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/7/30.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "TextInputAlertView.h"

@interface TextInputAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * promptLabel;
@property (nonatomic, strong) UIButton * confirm;

@property (nonatomic, assign) InputType inputType;
@property (nonatomic, strong) NSString * text;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * prompt;
@property (nonatomic, strong) NSString * placeholder;


@end

@implementation TextInputAlertView

//InputTypeWalletName,
//InputTypeNodeAdd,
//InputTypeNodeEdit,
//PWTypeTransaction, // sign
//PWTypeBackUpID, // words ""
//PWTypeExitID, // null
//PWTypeDataReinforcement, // password, words ""
//PWTypeDeleteWallet, // null
//PWTypeExportKeystore, // null
//PWTypeExportPrivateKey, 

- (instancetype)initWithInputType:(InputType)inputType confrimBolck:(void (^)(NSString * text, NSArray * words))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        self.inputType = inputType;
        self.walletKeyStore = CurrentWalletKeyStore;
        self.title = Localized(@"IdentityCipherConfirm");
        self.placeholder = Localized(@"PWPlaceholder");
        if (inputType == InputTypeWalletName) {
            self.title = Localized(@"ModifyWalletName");
            self.placeholder = Localized(@"EnterWalletName");
        } else if (inputType == InputTypeNodeAdd) {
            self.title = Localized(@"AddNodePrompt");
            self.placeholder = self.title;
        } else if (inputType == InputTypeNodeEdit) {
            self.title = Localized(@"EditNodePrompt");
            self.confirm.enabled = YES;
        }
        if (inputType == PWTypeDataReinforcement) {
            self.prompt = Localized(@"BackupWalletPWPrompt");
        }
        if (inputType == PWTypeExitID) {
            self.prompt = Localized(@"IdentityCipherWarning");
        }
        if (inputType == PWTypeBackUpID) {
            self.prompt = Localized(@"BackupWalletPWPrompt");
        }
        if (inputType == PWTypeTransferAssets) {
            self.prompt = Localized(@"TransactionWalletPWPrompt");
        }
        if (inputType == PWTypeTransferVoucher) {
            self.prompt = Localized(@"TransferWalletPWPrompt");
        }
        if (inputType == PWTypeTransferRegistered) {
            self.prompt = Localized(@"RegistrationWalletPWPrompt");
        }
        if (inputType == PWTypeTransferDistribution) {
            self.prompt = Localized(@"DistributionWalletPWPrompt");
        }
        if (inputType == PWTypeDeleteWallet) {
            self.prompt = Localized(@"WalletPWPrompt");
        }
        if (inputType == PWTypeExportKeystore || inputType == PWTypeExportPrivateKey) {
            self.prompt = Localized(@"WalletPWPrompt");
        }
        if (inputType == PWTypeTransferDpos) {
            self.prompt = Localized(@"DposWalletPWPrompt");
        }
        [self setupView];
//        CGFloat contentW = Alert_Width - Margin_40;
//        CGFloat titleH = [Encapsulation rectWithText:self.title font:self.titleLabel.font textWidth:contentW].size.height;
//        CGFloat promptH = 0;
//        if (NotNULLString(self.prompt)) {
//            promptH = [Encapsulation rectWithText:self.prompt font:self.promptLabel.font textWidth:contentW].size.height + Margin_15;
//        }
        CGFloat titleH = (NotNULLString(self.title)) ? self.titleLabel.height : 0;
        CGFloat promptH = (NotNULLString(self.prompt)) ? self.promptLabel.height + Margin_15 : 0;
        self.bounds = CGRectMake(0, 0, Alert_Width, ScreenScale(105) + titleH + Alert_Button_Height + promptH);
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = BG_CORNER;
    CGFloat marginX = Margin_20;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Margin_20);
        make.left.equalTo(self).offset(marginX);
        make.right.equalTo(self).offset(-marginX);
        //        make.centerX.equalTo(self);
        //        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - ScreenScale(80));
    }];
    [self addSubview:self.textField];
    if (self.inputType != InputTypeWalletName && self.inputType != InputTypeNodeAdd && self.inputType != InputTypeNodeEdit) {
        [self addSubview:self.promptLabel];
        [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin_15);
            make.left.right.equalTo(self.titleLabel);
        }];
        self.textField.secureTextEntry = YES;
    }
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-(Alert_Button_Height + Margin_20));
        make.left.equalTo(self).offset(marginX);
        make.right.equalTo(self).offset(-marginX);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(Margin_25);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    CGFloat btnW = Alert_Width;
    if (self.inputType != PWTypeDataReinforcement) {
        btnW = Alert_Width / 2;
        UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:Alert_Button_Font TextNormalColor:Alert_Button_Color TextSelectedColor:Alert_Button_Color Target:self Selector:@selector(cancleBtnClick)];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom);
            make.left.bottom.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(btnW, Alert_Button_Height));
        }];
    }
    [self addSubview:self.confirm];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.bottom.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnW, Alert_Button_Height));
    }];
    UIView * verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = LINE_COLOR;
    [self addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.confirm);
        make.size.mas_equalTo(CGSizeMake(LINE_WIDTH, Margin_20));
    }];
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = Alert_Title_Font;
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = _title;
        CGSize maximumSize = CGSizeMake(Alert_Width - Margin_40, CGFLOAT_MAX);
        CGSize expectSize = [_titleLabel sizeThatFits:maximumSize];
        _titleLabel.size = CGSizeMake(expectSize.width, expectSize.height);
    }
    return _titleLabel;
}
- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.font = FONT_13;
        _promptLabel.textColor = (_inputType == PWTypeExitID) ? WARNING_COLOR : COLOR_6;
        _promptLabel.numberOfLines = 0;
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = _prompt;
        CGSize maximumSize = CGSizeMake(Alert_Width - Margin_40, CGFLOAT_MAX);
        CGSize expectSize = [_promptLabel sizeThatFits:maximumSize];
        _promptLabel.size = CGSizeMake(expectSize.width, expectSize.height);
    }
    return _promptLabel;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.textColor = TITLE_COLOR;
        _textField.font = FONT_13;
        _textField.layer.cornerRadius = TEXT_CORNER;
        //        _textField.layer.borderColor = LINE_COLOR.CGColor;
        //        _textField.layer.borderWidth = LINE_WIDTH;
        _textField.backgroundColor = VIEWBG_COLOR;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
        _textField.rightViewMode = UITextFieldViewModeAlways;
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.placeholder = _placeholder;
    }
    return _textField;
}
- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:Alert_Button_Font TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(sureBtnClick)];
        _confirm.enabled = NO;
    }
    return _confirm;
}
- (void)textChange:(UITextField *)textField
{
    self.text = TrimmingCharacters(textField.text);
    if (NotNULLString(self.text)) {
        self.confirm.enabled = YES;
//        self.confirm.backgroundColor = MAIN_COLOR;
    } else {
        self.confirm.enabled = NO;
//        self.confirm.backgroundColor = DISABLED_COLOR;
    }
}
- (void)setWalletKeyStore:(NSString *)walletKeyStore
{
    _walletKeyStore = walletKeyStore;
}
//- (void)setText:(NSString *)text
//{
//    _text = text;
//    self.textField.text = text;
////    [self textChange:self.textField];
//}
- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)sureBtnClick {
    if (self.inputType != PWTypeDataReinforcement) {
        [self hideView];
    }
    if (self.inputType != InputTypeWalletName && self.inputType != InputTypeNodeAdd && self.inputType != InputTypeNodeEdit) {
        [self confirmPW];
    } else {
        if (_sureBlock) {
            _sureBlock(self.text , [NSArray array]);
        }
    }
}
- (void)confirmPW
{
    if (self.text.length < PW_MIN_LENGTH || self.text.length > PW_MAX_LENGTH) {
        [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
    } else {
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Signature")];
        [self checkPassword];
    }
}
#pragma mark check password
- (void)checkPassword
{
    if (self.inputType == PWTypeBackUpID || self.inputType == PWTypeDataReinforcement) {
        if (!NotNULLString(self.randomNumber)) {
            self.randomNumber = [[AccountTool shareTool] account].randomNumber;
        }
        // Identity password
        NSData * random = [NSString decipherKeyStoreWithPW:self.text randomKeyStoreValueStr:self.randomNumber];
        if (random) {
            NSArray * words = [Mnemonic generateMnemonicCode: random];
            [MBProgressHUD hideHUD];
            if (_sureBlock) {
                _sureBlock(self.text, words);
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        }
    } else {
        // Password for Wallet
        NSString * privateKey = [NSString decipherKeyStoreWithPW:self.text keyStoreValueStr:self.walletKeyStore];
        if ([Tools isEmpty:privateKey]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showTipMessageInWindow:Localized(@"PasswordIsIncorrect")];
        } else {
            [MBProgressHUD hideHUD];
            if (self.inputType == PWTypeTransferAssets ||
                self.inputType == PWTypeTransferVoucher ||
                self.inputType == PWTypeTransferRegistered ||
                self.inputType == PWTypeTransferDistribution ||
                self.inputType == PWTypeTransferDpos) {
                if (![[HTTPManager shareManager] getSignWithPrivateKey:privateKey]) {
                    self.text = @"";
                }
            }
            if (_sureBlock) {
                _sureBlock(self.text, [NSArray array]);
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
