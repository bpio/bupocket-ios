//
//  CancellationOfVotingAlertView.m
//  bupocket
//
//  Created by huoss on 2019/3/25.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "CancellationOfVotingAlertView.h"

@interface CancellationOfVotingAlertView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UILabel * feeTips;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) UIView * infoBg;
@property (nonatomic, strong) UIButton * confirm;
@property (nonatomic, strong) UILabel * tips;


@end

@implementation CancellationOfVotingAlertView

- (instancetype)initWithText:(NSString *)text confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(300));
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.textField];
    
    [self addSubview:self.feeTips];
    
    [self addSubview:self.moreBtn];
    
    [self addSubview:self.infoBg];
    self.infoBg.hidden = YES;
    
    [self addSubview:self.confirm];
    
    [self addSubview:self.tips];
    
    NSString * transactionInitiator = [NSString stringWithFormat:@"%@\n%@", Localized(@"TransactionInitiator"), @"bujslk3i3kkdkladkl8dfkdfk3kl3kl3ldsjf"];
    NSString * contractingParty = [NSString stringWithFormat:@"%@\n%@", Localized(@"ContractingParty"), @"bujslk3i3kkdkladkl8dfkdfk3kl3kl3ldsjf"];
    NSString * contractCode = [NSString stringWithFormat:@"%@\n%@", Localized(@"ContractCode"), @"{'type':'1','method':'redemptionVotes'}"];
    NSArray * infoArray = @[transactionInitiator, contractingParty, contractCode];
    for (UILabel * infoLabel in self.infoBg.subviews) {
        infoLabel.attributedText = [Encapsulation attrWithString:infoArray[infoLabel.tag] preFont:FONT(13) preColor:COLOR_9 index:[infoArray[infoLabel.tag] length] sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:8];
    }
    self.tips.text = [NSString stringWithFormat:Localized(@"After successful withdrawal, the frozen BU is returned to the original purse\n（%@）"), @"buQoWe***s9TBRn"];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.height.mas_equalTo(Margin_50);
        make.right.mas_lessThanOrEqualTo(self.closeBtn.mas_left).offset(-Margin_10);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Margin_50, ScreenScale(55)));
    }];
    [self.feeTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom);
        make.left.right.equalTo(self.textField);
        make.height.mas_equalTo(Margin_15);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeTips.mas_bottom);
        make.left.right.equalTo(self.feeTips);
        make.height.mas_equalTo(Margin_40);
    }];
    
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(65));
        make.left.right.equalTo(self.textField);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    [self.tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirm.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(self.confirm);
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_15);
    }];
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        NSMutableAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@%@%@", Localized(@"Revoke"), @"username", Localized(@"Vote")] preFont:FONT_Bold(16) preColor:WARNING_COLOR index:Localized(@"Revoke").length sufFont:FONT_Bold(16) sufColor:COLOR(@"151515") lineSpacing:0];
        NSRange range = NSMakeRange(attr.length - Localized(@"Vote").length, Localized(@"Vote").length);
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR(@"2A2A2A") range:range];
        [attr addAttribute:NSFontAttributeName value:FONT(16) range:range];
        _titleLabel.attributedText = attr;
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

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.textColor = TITLE_COLOR;
        _textField.font = FONT(12);
        _textField.placeholder = [NSString stringWithFormat:Localized(@"Maximum revocable %@ votes"), @"100"];
        CGFloat leftViewW = [Encapsulation rectWithText:Localized(@"Number") font:FONT_Bold(16) textHeight:Margin_50].size.width + Margin_10;
        UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, leftViewW, Margin_50)];
        leftLabel.font = FONT_Bold(16);
        leftLabel.textColor = COLOR_6;
        leftLabel.text = Localized(@"Number");
        _textField.leftView = leftLabel;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        UIButton * rightBtn = [UIButton createButtonWithTitle:Localized(@"Whole") TextFont:14 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(WholeAction)];
        CGFloat rightViewW = [Encapsulation rectWithText:rightBtn.titleLabel.text font:rightBtn.titleLabel.font textHeight:Margin_50].size.width + Margin_10;
        rightBtn.size = CGSizeMake(rightViewW, Margin_50);
        _textField.rightView = rightBtn;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.frame = CGRectMake(Margin_20, Margin_50, DEVICE_WIDTH - Margin_40, Margin_50);
        [UIView setViewBorder:_textField color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _textField;
}
- (UILabel *)feeTips
{
    if (!_feeTips) {
        _feeTips = [[UILabel alloc] init];
        _feeTips.textColor = PLACEHOLDER_COLOR;
        _feeTips.font = FONT(12);
        _feeTips.text = [NSString stringWithFormat:Localized(@"The maximum transaction cost is about %@ BU"), @"0.01"];
        _feeTips.textAlignment = NSTextAlignmentRight;
    }
    return _feeTips;
}
- (UIButton *)moreBtn
{
    if (!_moreBtn) {
        _moreBtn = [UIButton createButtonWithTitle:Localized(@"More") TextFont:13 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(moreAction:)];
        [_moreBtn setTitle:Localized(@"Retract") forState:UIControlStateSelected];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _moreBtn.frame = CGRectMake(Margin_20, ScreenScale(115), DEVICE_WIDTH - Margin_40, Margin_40);
        [UIView setViewBorder:_moreBtn color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeBottom];
    }
    return _moreBtn;
}
- (UIView *)infoBg
{
    if (!_infoBg) {
        _infoBg = [[UIView alloc] initWithFrame:CGRectMake(Margin_20, ScreenScale(155), DEVICE_WIDTH - Margin_40, ScreenScale(165))];
        [UIView setViewBorder:_infoBg color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeBottom];
        for (NSInteger i = 0; i < 3 ; i++) {
            UILabel * infoLabel = [[UILabel alloc] init];
            infoLabel.numberOfLines = 0;
            infoLabel.tag = i;
            [_infoBg addSubview:infoLabel];
            [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self->_infoBg);
                make.top.equalTo(self->_infoBg.mas_top).offset(Margin_15 + Margin_50 * i);
                make.height.mas_equalTo(Margin_50);
            }];
        }
    }
    return _infoBg;
}
- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"ConfirmTicketWithdrawal") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
        _confirm.backgroundColor = MAIN_COLOR;
        [_confirm setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT) borderRadius:MAIN_CORNER corners:UIRectCornerAllCorners];
        _confirm.enabled = NO;
    }
    return _confirm;
}
- (UILabel *)tips
{
    if (!_tips) {
        _tips = [[UILabel alloc] init];
        _tips.numberOfLines = 0;
        _tips.textColor = PLACEHOLDER_COLOR;
        _tips.font = FONT(12);
        _tips.textAlignment = NSTextAlignmentCenter;
    }
    return _tips;
}
- (void)WholeAction
{
    NSLog(@"全部");
}
- (void)moreAction:(UIButton *)button
{
    button.selected = !button.selected;
    self.infoBg.hidden = !button.selected;
    if (button.selected) {
        self.frame = CGRectMake(0, DEVICE_HEIGHT - ScreenScale(460), DEVICE_WIDTH, ScreenScale(460));
    } else {
        self.frame = CGRectMake(0, DEVICE_HEIGHT - ScreenScale(300), DEVICE_WIDTH, ScreenScale(300));
    }
}
- (void)textChange:(UITextField *)textField
{
    if (textField.text) {
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
