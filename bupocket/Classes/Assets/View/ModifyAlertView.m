//
//  ModifyAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ModifyAlertView.h"

@interface ModifyAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * confirm;

@end

@implementation ModifyAlertView

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder modifyType:(ModifyType)modifyType confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
//        self.textField.placeholder = text;
//        title.text = Localized(@"ModifyWalletName");
//        self.textField.placeholder = Localized(@"EnterWalletName");
        if (modifyType == ModifyTypeNodeEdit) {
            self.textField.text = @"";
            [self.textField insertText:placeholder];
//            [self.textField setText:placeholder];
//            self.textField.text = placeholder;
        } else {
            self.textField.placeholder = placeholder;
        }
        self.titleLabel.text = title;
        
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_60, ScreenScale(190));
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Margin_20);
        make.centerX.equalTo(self);
    }];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin_20);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
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
    
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:FONT_BUTTON TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:self Selector:@selector(cancleBtnClick)];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH / 2 - Margin_30, ScreenScale(55)));
    }];
    [self addSubview:self.confirm];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.bottom.equalTo(cancel);
        make.right.equalTo(self);
    }];
    UIView * verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = LINE_COLOR;
    [self addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(cancel);
        make.size.mas_equalTo(CGSizeMake(LINE_WIDTH, Margin_20));
    }];
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_Bold(18);
        _titleLabel.textColor = TITLE_COLOR;
    }
    return _titleLabel;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.textColor = TITLE_COLOR;
        _textField.font = FONT_TITLE;
        _textField.layer.cornerRadius = ScreenScale(3);
//        _textField.layer.borderColor = LINE_COLOR.CGColor;
//        _textField.layer.borderWidth = LINE_WIDTH;
        _textField.backgroundColor = COLOR(@"F5F5F5");
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
        _textField.rightViewMode = UITextFieldViewModeAlways;
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:FONT_BUTTON TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(sureBtnClick)];
        _confirm.enabled = NO;
    }
    return _confirm;
}
- (void)textChange:(UITextField *)textField
{
    if (NotNULLString(textField.text)) {
        self.confirm.enabled = YES;
    } else {
        self.confirm.enabled = NO; 
    }
}
- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)sureBtnClick {
    [self hideView];
    if (_sureBlock) {
        _sureBlock(TrimmingCharacters(self.textField.text));
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
