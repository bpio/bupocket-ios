//
//  TipsAlertView.m
//  bupocket
//
//  Created by huoss on 2019/7/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "TipsAlertView.h"

@interface TipsAlertView()

@property (nonatomic, strong) CustomButton * promptBtn;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * promptStr;
@property (nonatomic, strong) UIButton * prompt;
@property (nonatomic, strong) UIButton * sureBtn;

@property (nonatomic, assign) TipsType tipsType;

@end

@implementation TipsAlertView

- (instancetype)initWithTipsType:(TipsType)tipsType title:(NSString *)title message:( NSString * _Nullable)message confrimBolck:(void (^ __nullable)(void))confrimBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        self.tipsType = tipsType;
        self.title = title;
        self.promptStr = message;
        [self setupView];
//        CGFloat promptBtnH = [Encapsulation rectWithText:self.title font:self.promptBtn.titleLabel.font textWidth:promptW].size.height + Margin_15;
        CGFloat H = self.prompt.height + _promptBtn.titleLabel.size.height + Alert_Button_Height;
        CGFloat height = (H + ScreenScale(50));
        if (!NotNULLString(self.promptStr)) {
            height = height + Margin_5;
        }
        if (self.tipsType == TipsTypeNormal) {
            _promptBtn.titleLabel.font = FONT_Bold(15);
            [_promptBtn setImage:[UIImage imageNamed:@"PWPrompt"] forState:UIControlStateNormal];
            height = (H + ScreenScale(120));
            height = MIN(height, ScreenScale(360));
        }
        self.bounds = CGRectMake(0, 0, Alert_Width, height);
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = BG_CORNER;
    
    [self addSubview:self.promptBtn];
    
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.prompt];
    [self addSubview:self.sureBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat promptBtnY = (NotNULLString(self.promptStr)) ? Margin_10 : Margin_25;
    CGFloat promptW = Alert_Width - Margin_50;
//    CGFloat promptBtnH = ScreenScale(35);
    CGFloat promptBtnH = _promptBtn.titleLabel.size.height;
    CGFloat scrollViewY = promptBtnY + promptBtnH + Margin_15;
    if (self.tipsType == TipsTypeNormal) {
        promptBtnH = ScreenScale(100);
        promptBtnY = Margin_15;
        scrollViewY = promptBtnY + promptBtnH + Margin_10;
    }
    [self.promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(promptBtnY);
        make.centerX.equalTo(self);
        make.width.mas_lessThanOrEqualTo(promptW);
        make.height.mas_equalTo(promptBtnH);
    }];
    if (NotNULLString(self.promptStr)) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(scrollViewY);
            make.left.equalTo(self).offset(Margin_Main);
            make.right.equalTo(self).offset(-Margin_Main);
            make.bottom.equalTo(self).offset(-Alert_Button_Height - Margin_20);
        }];
        [self.prompt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(promptW, self.prompt.height));
        }];
        self.scrollView.contentSize = CGSizeMake(CGFLOAT_MIN, self.prompt.height);
    } else {
        self.promptBtn.titleLabel.font = FONT(18);
    }
    
    CGFloat btnW = (self.tipsType == TipsTypeChoice) ? (Alert_Width / 2) : Alert_Width;
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(btnW, Alert_Button_Height));
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sureBtn.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    if (self.tipsType == TipsTypeChoice) {
        [self.sureBtn setTitle:Localized(@"Confirm") forState:UIControlStateNormal];
        UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:Alert_Button_Font TextNormalColor:Alert_Button_Color TextSelectedColor:Alert_Button_Color Target:self Selector:@selector(cancleBtnClick)];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self);
            make.size.equalTo(self.sureBtn);
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
}
- (CustomButton *)promptBtn
{
    if (!_promptBtn) {
        _promptBtn = [[CustomButton alloc] init];
        _promptBtn.layoutMode = VerticalNormal;
        _promptBtn.titleLabel.font = Alert_Title_Font;
        [_promptBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        _promptBtn.titleLabel.numberOfLines = 0;
        [_promptBtn setTitle:self.title forState:UIControlStateNormal];
        CGSize maximumSize = CGSizeMake(Alert_Width - Margin_50, CGFLOAT_MAX);
        CGSize expectSize = [_promptBtn.titleLabel sizeThatFits:maximumSize];
        _promptBtn.titleLabel.size = CGSizeMake(expectSize.width, expectSize.height + Margin_10);
    }
    return _promptBtn;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}
- (UIButton *)prompt
{
    if (!_prompt) {
        _prompt = [self setupButtonWithTitle:self.promptStr];
    }
    return _prompt;
}
- (UIButton *)setupButtonWithTitle:(NSString *)title
{
    UIButton * prompt = [UIButton buttonWithType:UIButtonTypeCustom];
    [prompt setAttributedTitle:[Encapsulation getAttrWithInfoStr:title] forState:UIControlStateNormal];
    prompt.titleLabel.numberOfLines = 0;
    prompt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CGSize maximumSize = CGSizeMake(Alert_Width - Margin_50, CGFLOAT_MAX);
    CGSize expectSize = [prompt.titleLabel sizeThatFits:maximumSize];
    prompt.size = expectSize;
    return prompt;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton createButtonWithTitle:Localized(@"IGotIt") TextFont:Alert_Button_Font TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(sureBtnClick)];
//        _sureBtn.size = CGSizeMake(Alert_Width, Alert_Button_Height);
//        [UIView setViewBorder:_sureBtn color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _sureBtn;
}
- (void)cancleBtnClick
{
    [self hideView];
}
- (void)sureBtnClick {
    [self hideView];
    if (_sureBlock) {
        _sureBlock();
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
