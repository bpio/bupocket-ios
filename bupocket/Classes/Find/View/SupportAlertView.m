//
//  SupportAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/4/8.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "SupportAlertView.h"

@interface SupportAlertView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * purchaseAmount;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UILabel * supportNumber;
@property (nonatomic, strong) UIButton * reduce;
@property (nonatomic, strong) UITextField * numberText;
@property (nonatomic, strong) UIButton * plus;
@property (nonatomic, strong) UIButton * total;
@property (nonatomic, strong) UIButton * confirm;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) NSString * purchaseAmountStr;
@property (nonatomic, strong) NSString * totalTarget;
@property (nonatomic, strong) NSString * numberStr;

@end

@implementation SupportAlertView

- (instancetype)initWithTotalTarget:(NSString *)totalTarget purchaseAmount:(NSString *)purchaseAmount confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _confirmClick = confrimBlock;
        _cancleClick = cancelBlock;
        self.purchaseAmountStr = purchaseAmount;
        self.totalTarget = totalTarget;
        [self setupView];
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(210));
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.lineView];
    
    [self addSubview:self.purchaseAmount];
    
    [self addSubview:self.amount];
    
    [self addSubview:self.supportNumber];
    
    [self addSubview:self.reduce];
    
    [self addSubview:self.numberText];
    
    [self addSubview:self.plus];
    
    [self addSubview:self.total];
    
    [self addSubview:self.confirm];
    
    [self setTotalText];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.height.mas_equalTo(Margin_50);
        make.right.equalTo(self.closeBtn.mas_left).offset(-Margin_10);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Margin_50, Margin_50));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    [self.purchaseAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.height.equalTo(self.titleLabel);
    }];
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.purchaseAmount);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
    }];
    
    [self.supportNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purchaseAmount.mas_bottom);
        make.left.height.equalTo(self.purchaseAmount);
    }];
    
    [self.plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.supportNumber);
        make.right.equalTo(self.amount);
    }];
    
    [self.numberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plus.mas_left).offset(-Margin_15);
        make.top.height.equalTo(self.supportNumber);
        make.width.mas_equalTo(Margin_40);
    }];
    
    [self.reduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.supportNumber);
        make.right.equalTo(self.numberText.mas_left).offset(-Margin_15);
    }];
    
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(145), Margin_50));
    }];
    
    [self.total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.confirm);
        make.left.bottom.equalTo(self);
        make.right.equalTo(self.confirm.mas_left);
    }];
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT(16);
        _titleLabel.textColor = COLOR_6;
        _titleLabel.text = Localized(@"SupportProjects");
    }
    return _titleLabel;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton createButtonWithNormalImage:@"close" SelectedImage:@"close" Target:self Selector:@selector(cancleBtnClick)];
    }
    return _closeBtn;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
- (UILabel *)purchaseAmount
{
    if (!_purchaseAmount) {
        _purchaseAmount = [[UILabel alloc] init];
        _purchaseAmount.textColor = COLOR_9;
        _purchaseAmount.font = TITLE_FONT;
        _purchaseAmount.text = Localized(@"PurchaseAmount");
    }
    return _purchaseAmount;
}
- (UILabel *)amount
{
    if (!_amount) {
        _amount = [[UILabel alloc] init];
        NSString * perAmount = [NSString stringAmountSplitWith:self.purchaseAmountStr];
        _amount.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", perAmount, Localized(@"BU/Portion")] preFont:FONT(15) preColor:TITLE_COLOR index:perAmount.length sufFont:FONT(12) sufColor:COLOR(@"151515") lineSpacing:0];
    }
    return _amount;
}
- (UILabel *)supportNumber
{
    if (!_supportNumber) {
        _supportNumber = [[UILabel alloc] init];
        _supportNumber.textColor = COLOR_9;
        _supportNumber.font = TITLE_FONT;
        _supportNumber.text = Localized(@"SupportCopies");
    }
    return _supportNumber;
}

- (UIButton *)reduce
{
    if (!_reduce) {
        _reduce = [UIButton createButtonWithNormalImage:@"reduce" SelectedImage:@"reduce" Target:self Selector:@selector(reduceAction:)];
//        [_reduce setImage:[UIImage imageNamed:@"reduce_d"] forState:UIControlStateDisabled];
        _reduce.enabled = NO;
    }
    return _reduce;
}
- (void)reduceAction:(UIButton *)button
{
    self.numberText.text = [NSString stringWithFormat:@"%zd", [self.numberStr integerValue] - 1];
    self.numberStr = self.numberText.text;
    [self setTotalText];
    [self setButtonEnabled];
//    if ([self.numberStr integerValue] > 1) {
//        self.plus.enabled = YES;
//        if ([self.numberStr integerValue] == 1) {
//            button.enabled = NO;
//        }
//    }
}
//- (UILabel *)number
//{
//    if (!_number) {
//        _number = [[UILabel alloc] init];
//        _number.textColor = TITLE_COLOR;
//        _number.font = FONT(16);
//        _number.text = @"1";
//    }
//    return _number;
//}
- (UITextField *)numberText
{
    if (!_numberText) {
        _numberText = [[UITextField alloc] init];
        _numberText.textColor = TITLE_COLOR;
        _numberText.font = FONT(16);
        _numberText.text = @"1";
        _numberText.keyboardType = UIKeyboardTypeNumberPad;
        [_numberText addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        _numberText.textAlignment = NSTextAlignmentCenter;
        _numberStr = self.numberText.text;
    }
    return _numberText;
}
- (void)textChange:(UITextField *)textField
{
    self.numberStr = [self.numberText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self setButtonEnabled];
    if ([self.numberStr integerValue] < 1 || [self.numberStr integerValue] > [self.totalTarget doubleValue] / [self.purchaseAmountStr integerValue]) {
        self.confirm.enabled = NO;
        self.confirm.backgroundColor = DISABLED_COLOR;
    } else {
        self.confirm.enabled = YES;
        self.confirm.backgroundColor = MAIN_COLOR;
        [self setTotalText];
    }
}
- (void)setButtonEnabled
{
    if ([self.numberStr integerValue] <= 1) {
        self.reduce.enabled = NO;
        self.plus.enabled = YES;
    } else if ([self.numberStr integerValue] >= [self.totalTarget doubleValue] / [self.purchaseAmountStr integerValue]) {
        self.reduce.enabled = YES;
        self.plus.enabled = NO;
    } else if ([self.numberStr integerValue] <= 1 && [self.numberStr integerValue] >= [self.totalTarget doubleValue] / [self.purchaseAmountStr integerValue]) {
        self.reduce.enabled = NO;
        self.plus.enabled = NO;
    } else {
        self.reduce.enabled = YES;
        self.plus.enabled = YES;
    }
}
- (UIButton *)plus
{
    if (!_plus) {
        _plus = [UIButton createButtonWithNormalImage:@"plus" SelectedImage:@"plus" Target:self Selector:@selector(plusAction:)];
//        [_plus setImage:[UIImage imageNamed:@"plus_d"] forState:UIControlStateDisabled];
        if ([_purchaseAmountStr longLongValue] == [_totalTarget longLongValue]) {
            _plus.enabled = NO;
        }
    }
    return _plus;
}
- (void)plusAction:(UIButton *)button
{
    self.numberText.text = [NSString stringWithFormat:@"%zd", [self.numberStr integerValue] + 1];
    self.numberStr = self.numberText.text;
    [self setTotalText];
    [self setButtonEnabled];
//    if ([self.numberStr integerValue] < [self.totalTarget doubleValue] / [self.purchaseAmountStr integerValue]) {
//        self.reduce.enabled = YES;
//        if ([self.numberStr integerValue] == [self.totalTarget doubleValue] / [self.purchaseAmountStr integerValue]) {
//            button.enabled = NO;
//        }
//    }
}
- (void)setTotalText
{
//    int64_t fee = [[[NSDecimalNumber decimalNumberWithString:feeLimit] decimalNumberByMultiplyingByPowerOf10: Decimals_BU] longLongValue];
    NSString * totleAmount = [NSString stringWithFormat:@"%@%@ BU", Localized(@"Total"), [NSString stringAmountSplitWith:[NSString stringWithFormat:@"%lld", [self.numberStr longLongValue] * [self.purchaseAmountStr longLongValue]]]];
    NSMutableAttributedString * attr = [Encapsulation attrWithString:totleAmount preFont:FONT(13) preColor:TITLE_COLOR index:[Localized(@"Total") length] sufFont:FONT_Bold(18) sufColor:WARNING_COLOR lineSpacing:0];
    NSRange range = NSMakeRange(attr.length - 2, 2);
    [attr addAttribute:NSForegroundColorAttributeName value:WARNING_COLOR range:range];
    [attr addAttribute:NSFontAttributeName value:FONT(12) range:range];
    [self.total setAttributedTitle:attr forState:UIControlStateNormal];
}
- (UIButton *)total
{
    if (!_total) {
        _total = [UIButton buttonWithType:UIButtonTypeCustom];
        _total.backgroundColor = [UIColor whiteColor];
        _total.layer.shadowOffset = CGSizeMake(-ScreenScale(12), 0);
        _total.layer.shadowOpacity = 0.1;
        _total.layer.shadowColor = COLOR(@"656565").CGColor;
    }
    return _total;
}

- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"ConfirmSupport") TextFont:16 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
        _confirm.backgroundColor = MAIN_COLOR;
    }
    return _confirm;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleClick) {
        _cancleClick();
    }
}
- (void)sureBtnClick {
    [self hideView];
    if (_confirmClick) {
        NSString * totalAmount = [NSString stringWithFormat:@"%lld", [self.numberStr longLongValue] * [self.purchaseAmountStr longLongValue]];
        _confirmClick(totalAmount);
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
