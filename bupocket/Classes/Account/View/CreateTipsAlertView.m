//
//  CreateTipsAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/11/14.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "CreateTipsAlertView.h"

@interface CreateTipsAlertView()

@property (nonatomic, strong) CustomButton * promptBtn;
@property (nonatomic, strong) UIButton * prompt1;
@property (nonatomic, strong) UIButton * prompt2;
@property (nonatomic, strong) UIButton * prompt3;
@property (nonatomic, strong) UIButton * sureBtn;

@end

@implementation CreateTipsAlertView

- (instancetype)initWithConfrimBolck:(void (^)(void))confrimBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        [self setupView];
//        NSString * prompt = [NSString stringWithFormat:@"%@\n%@\n%@", self.prompt1.titleLabel.attributedText.string, self.prompt2.titleLabel.attributedText.string, self.prompt3.titleLabel.attributedText.string];
//        CGFloat height = [Encapsulation getSizeSpaceLabelWithStr:prompt font:FONT(13) width:(DEVICE_WIDTH - ScreenScale(80)) height:CGFLOAT_MAX lineSpacing:Margin_5].height + ScreenScale(220);
        CGFloat height = self.prompt1.size.height + self.prompt2.size.height + self.prompt3.size.height + ScreenScale(210);
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_60, height);
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    
    [self addSubview:self.promptBtn];
    
    self.prompt1 = [self setupButtonWithTitle:Localized(@"PWPrompt1")];
    [self addSubview:self.prompt1];
    self.prompt2 = [self setupButtonWithTitle:Localized(@"PWPrompt2")];
    [self addSubview:self.prompt2];
    self.prompt3 = [self setupButtonWithTitle:Localized(@"PWPrompt3")];
    [self addSubview:self.prompt3];
    
    [self addSubview:self.sureBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Margin_15);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(ScreenScale(100));
    }];
    
    [self.prompt1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptBtn.mas_bottom).offset(Margin_5);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
        make.height.mas_equalTo(self.prompt1.height);
    }];
    
    [self.prompt2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.prompt1.mas_bottom).offset(Margin_10);
        make.left.right.equalTo(self.prompt1);
        make.height.mas_equalTo(self.prompt2.height);
    }];
    [self.prompt3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.prompt2.mas_bottom).offset(Margin_10);
        make.left.right.equalTo(self.prompt1);
        make.height.mas_equalTo(self.prompt3.height);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.prompt3.mas_bottom).offset(Margin_15);
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (CustomButton *)promptBtn
{
    if (!_promptBtn) {
        _promptBtn = [[CustomButton alloc] init];
        _promptBtn.layoutMode = VerticalNormal;
        _promptBtn.titleLabel.font = FONT_Bold(15);
        [_promptBtn setTitle:Localized(@"PromptTitle") forState:UIControlStateNormal];
        [_promptBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        [_promptBtn setImage:[UIImage imageNamed:@"PWPrompt"] forState:UIControlStateNormal];
    }
    return _promptBtn;
}
- (UIButton *)setupButtonWithTitle:(NSString *)title
{
    UIButton * prompt = [UIButton buttonWithType:UIButtonTypeCustom];
    [prompt setAttributedTitle:[Encapsulation attrWithString:title preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:Margin_5] forState:UIControlStateNormal];
    prompt.titleLabel.numberOfLines = 0;
    prompt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CGSize maximumSize = CGSizeMake(DEVICE_WIDTH - ScreenScale(100), CGFLOAT_MAX);
    CGSize expectSize = [prompt.titleLabel sizeThatFits:maximumSize];
    prompt.size = expectSize;
    return prompt;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton createButtonWithTitle:Localized(@"IGotIt") TextFont:FONT_16 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(sureBtnClick)];
        _sureBtn.size = CGSizeMake(DEVICE_WIDTH - Margin_60, MAIN_HEIGHT);
        [UIView setViewBorder:_sureBtn color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _sureBtn;
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
