//
//  ModifyAlertView.m
//  bupocket
//
//  Created by huoss on 2019/1/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ModifyAlertView.h"

@interface ModifyAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * confirm;

@end

@implementation ModifyAlertView

- (instancetype)initWithText:(NSString *)text confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        self.textField.placeholder = text;
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, ScreenScale(220));
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    
    UILabel * title = [UILabel new];
    title.font = FONT(18);
    title.textColor = TITLE_COLOR;
    title.text = Localized(@"ModifyWalletName");
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Margin_30);
        make.centerX.equalTo(self);
    }];
    
    self.textField = [[UITextField alloc] init];
    self.textField.delegate = self;
    self.textField.textColor = TITLE_COLOR;
    self.textField.font = TITLE_FONT;
    self.textField.layer.cornerRadius = ScreenScale(3);
    self.textField.layer.borderColor = LINE_COLOR.CGColor;
    self.textField.layer.borderWidth = LINE_WIDTH;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_10, MAIN_HEIGHT)];
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(Margin_25);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(Margin_25);
        make.left.right.equalTo(self.textField);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:18 TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:self Selector:@selector(cancleBtnClick)];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(self);
        make.left.equalTo(self.textField);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH / 2 - Margin_40, ScreenScale(55)));
    }];
    self.confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:18 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(sureBtnClick)];
    self.confirm.enabled = NO;
    [self addSubview:self.confirm];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.bottom.equalTo(cancel);
        make.right.equalTo(self.textField);
    }];
    UIView * verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = LINE_COLOR;
    [self addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textField);
        make.centerY.equalTo(cancel);
        make.size.mas_equalTo(CGSizeMake(LINE_WIDTH, Margin_20));
    }];
}
- (void)textChange:(UITextField *)textField
{
    if (textField.text.length > 0) {
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
    if (self.sureBlock) {
        self.sureBlock(self.textField.text);
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
