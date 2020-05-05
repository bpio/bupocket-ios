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
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * supportNumber;
@property (nonatomic, strong) UITextField * numberText;

@property (nonatomic, strong) UILabel * currentWallet;
@property (nonatomic, strong) UILabel * currentWalletName;
@property (nonatomic, strong) UILabel * availableBalance;

//@property (nonatomic, strong) UIButton * total;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIButton * confirm;

//@property (nonatomic, strong) NSString * purchaseAmountStr;
//@property (nonatomic, strong) NSString * totalTarget;
@property (nonatomic, strong) NSString * numberStr;
//@property (nonatomic, strong) NSString * availableStr;
@property (nonatomic, strong) NSDecimalNumber * amountNumber;

@end

@implementation NodeVotingAlertView

- (instancetype)initWithVoteAmountNumber:(NSDecimalNumber * )amountNumber confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _confirmClick = confrimBlock;
        _cancleClick = cancelBlock;
        _numberStr = @"0";
        _amountNumber = amountNumber;
        [self setupView];
        CGFloat height = ([CurrentAppLanguage hasPrefix:ZhHans]) ? ScreenScale(320) : ScreenScale(340);
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, height);
//        self.amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:@"0" ifShowLoading:NO];
//        NSString * availableStr = [NSString stringAppendingBUWithStr:[NSString stringWithFormat:@"%@ %@", Localized(@"AvailableBalance"), self.amountNumber]];
       
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = WHITE_BG_COLOR;
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.lineView];
    
    [self addSubview:self.supportNumber];
    
    [self addSubview:self.currentWallet];
    
    [self addSubview:self.currentWalletName];
    
    [self addSubview:self.availableBalance];
    
    [self addSubview:self.numberText];
    
    [self addSubview:self.bottomView];
//    [self addSubview:self.total];
    
    [self.bottomView addSubview:self.confirm];
    
//    [self setTotalText];
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
        make.top.equalTo(self.lineView.mas_bottom).offset(Margin_20);
        make.left.right.equalTo(self.lineView);
//        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    [self.numberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.top.equalTo(self.supportNumber.mas_bottom).offset(Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    [self.currentWallet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberText.mas_bottom).offset(Margin_20);
        make.left.equalTo(self.lineView);
    }];
    
    [self.currentWalletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineView);
        make.top.equalTo(self.currentWallet);
        make.left.mas_greaterThanOrEqualTo(self.currentWallet.mas_right).offset(Margin_50);
    }];
    [self.currentWallet setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.availableBalance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineView);
        make.top.equalTo(self.currentWalletName.mas_bottom).offset(Margin_15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, ScreenScale(90)));
    }];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(Margin_20);
        make.left.equalTo(self.bottomView.mas_left).offset(Margin_Main);
        make.size.mas_equalTo(CGSizeMake(View_Width_Main, Margin_50));
    }];
    /*
    [self.total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.confirm);
        make.left.bottom.equalTo(self);
        make.right.equalTo(self.confirm.mas_left);
    }];
     */
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
        _supportNumber.textColor = TITLE_COLOR;
        _supportNumber.font = FONT_13;
        _supportNumber.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@%@", Localized(@"NumberOfVotes"), Localized(@"NumberOfVotesInfo")] preFont:FONT_13 preColor:TITLE_COLOR index:[Localized(@"NumberOfVotes") length] sufFont:FONT_13 sufColor:COLOR_6 lineSpacing:CGFLOAT_MIN];
        ;
        _supportNumber.numberOfLines = 0;
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
        if ((number / 10 > 0) && (number % 10) == 0 && [self.numberStr longLongValue] < [SendingQuantity_MAX longLongValue] &&  [self.amountNumber floatValue] > [self.numberStr longLongValue]) {
            self.confirm.enabled = YES;
            self.confirm.backgroundColor = MAIN_COLOR;
        } else {
            self.confirm.enabled = NO;
            self.confirm.backgroundColor = DISABLED_COLOR;
        }
    }
//    [self setTotalText];
}

/*
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
        _total.backgroundColor = WHITE_BG_COLOR;
        _total.layer.shadowOffset = CGSizeMake(-ScreenScale(12), 0);
        _total.layer.shadowOpacity = 0.1;
        _total.layer.shadowColor = COLOR(@"656565").CGColor;
        _total.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_Main, 0, Margin_Main);
        _total.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _total;
}
*/
- (UILabel *)currentWallet
{
    if (!_currentWallet) {
        _currentWallet = [[UILabel alloc] init];
        _currentWallet.textColor = TITLE_COLOR;
        _currentWallet.font = FONT_13;
        _currentWallet.text = Localized(@"CurrentWallet");
    }
    return _currentWallet;
}
- (UILabel *)currentWalletName
{
    if (!_currentWalletName) {
        _currentWalletName = [[UILabel alloc] init];
        _currentWalletName.textColor = TITLE_COLOR;
        _currentWalletName.font = FONT_13;
        _currentWalletName.text = CurrentWalletName;
        _currentWalletName.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _currentWalletName;
}
- (UILabel *)availableBalance
{
    if (!_availableBalance) {
        _availableBalance = [[UILabel alloc] init];
        _availableBalance.textColor = TITLE_COLOR;
        _availableBalance.font = FONT_13;
        NSString * availableStr = [NSString stringAppendingBUWithStr:[NSString stringWithFormat:@"%@ %@", Localized(@"AvailableBalance"), _amountNumber]];
        _availableBalance.attributedText = [Encapsulation attrWithString:availableStr preFont:FONT(12) preColor:COLOR_9 index:[Localized(@"AvailableBalance") length] sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:CGFLOAT_MIN];
        _availableBalance.textAlignment = NSTextAlignmentRight;
    }
    return _availableBalance;
}
- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"ConfirmVote") isEnabled:NO Target:self Selector:@selector(sureBtnClick)];
//        [UIButton createButtonWithTitle:Localized(@"ConfirmVote") TextFont:FONT_16 TextNormalColor:WHITE_BG_COLOR TextSelectedColor:WHITE_BG_COLOR Target:self Selector:@selector(sureBtnClick)];
//        _confirm.enabled = NO;
//        _confirm.backgroundColor = DISABLED_COLOR;
    }
    return _confirm;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(90))];
        [UIView setViewBorder:_bottomView color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _bottomView;
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
