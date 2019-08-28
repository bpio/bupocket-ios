//
//  NodeVotingAlertView.m
//  bupocket
//
//  Created by huoss on 2019/8/28.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "NodeVotingAlertView.h"

@interface NodeVotingAlertView()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * supportNumber;
@property (nonatomic, strong) UITextField * numberText;
@property (nonatomic, strong) UIButton * total;
@property (nonatomic, strong) UIButton * confirm;
@property (nonatomic, strong) UIView * lineView;

//@property (nonatomic, strong) NSString * purchaseAmountStr;
//@property (nonatomic, strong) NSString * totalTarget;
@property (nonatomic, strong) NSString * numberStr;

@end

@implementation NodeVotingAlertView

- (instancetype)initWithVoteConfrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _confirmClick = confrimBlock;
        _cancleClick = cancelBlock;
        _numberStr = @"0";
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
    
    [self addSubview:self.supportNumber];
    
    [self addSubview:self.numberText];
    
    [self addSubview:self.total];
    
    [self addSubview:self.confirm];
    
    [self setTotalText];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(Margin_Main);
        make.height.mas_equalTo(Margin_50);
        make.right.equalTo(self.closeBtn.mas_left).offset(-Margin_10);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Margin_50, Margin_50));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.titleLabel);
        make.right.equalTo(self.mas_right).offset(-Margin_Main);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    [self.supportNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.right.equalTo(self.lineView);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    [self.numberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.top.equalTo(self.supportNumber.mas_bottom);
        make.height.mas_equalTo(MAIN_HEIGHT);
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
        _titleLabel.text = Localized(@"NodeVoting");
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

- (UILabel *)supportNumber
{
    if (!_supportNumber) {
        _supportNumber = [[UILabel alloc] init];
        _supportNumber.textColor = COLOR_9;
        _supportNumber.font = FONT_13;
        _supportNumber.text = Localized(@"NumberOfVotes");
    }
    return _supportNumber;
}

- (UITextField *)numberText
{
    if (!_numberText) {
        _numberText = [[UITextField alloc] init];
        _numberText.textColor = TITLE_COLOR;
        _numberText.font = FONT(13);
        _numberText.keyboardType = UIKeyboardTypeNumberPad;
        [_numberText addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        _numberText.placeholder = Localized(@"NumberOfVotesPrompt");
        _numberText.backgroundColor = VIEWBG_COLOR;
        _numberText.layer.cornerRadius = TEXT_CORNER;
        _numberText.layer.masksToBounds = YES;
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_Main, MAIN_HEIGHT)];
        _numberText.leftView = view;
        _numberText.leftViewMode = UITextFieldViewModeAlways;
        _numberText.rightView = view;
        _numberText.rightViewMode = UITextFieldViewModeAlways;
    }
    return _numberText;
}
- (void)textChange:(UITextField *)textField
{
    self.numberStr = TrimmingCharacters(self.numberText.text);
    if (NotNULLString(self.numberStr)) {
        long long number = [self.numberStr longLongValue];
        if ((number / 10 > 0) && (number % 10) == 0 && [self.numberStr longLongValue] < [SendingQuantity_MAX longLongValue]) {
            self.confirm.enabled = YES;
            self.confirm.backgroundColor = MAIN_COLOR;
        } else {
            self.confirm.enabled = NO;
            self.confirm.backgroundColor = DISABLED_COLOR;
        }
    }
    [self setTotalText];
}

- (void)setTotalText
{
    NSString * totleAmount = [NSString stringWithFormat:Localized(@"Number %@ BU"), self.numberStr];
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
        _total.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_Main, 0, Margin_Main);
        _total.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _total;
}

- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"ConfirmVote") TextFont:FONT_16 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
        _confirm.enabled = NO;
        _confirm.backgroundColor = DISABLED_COLOR;
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
        _confirmClick(self.numberStr);
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
