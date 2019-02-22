//
//  SafetyReinforcementAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "SafetyReinforcementAlertView.h"

@interface SafetyReinforcementAlertView()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * promptLabel;
@property (nonatomic, strong) UIButton * confrimButton;

@end

@implementation SafetyReinforcementAlertView

- (instancetype)initWithTitle:(NSString *)title promptText:(NSString *)promptText confrim:(NSString *)confrim confrimBolck:(nonnull void (^)(void))confrimBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        [self setupView];
        self.titleLabel.text = title;
        self.promptLabel.text = promptText;
        [self.confrimButton setTitle:confrim forState:UIControlStateNormal];
        CGFloat height = [Encapsulation rectWithText:title font:self.titleLabel.font textWidth:DEVICE_WIDTH - ScreenScale(80)].size.height + [Encapsulation rectWithText:promptText font:self.promptLabel.font textWidth:DEVICE_WIDTH - ScreenScale(80)].size.height + ScreenScale(120);
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, height);
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.promptLabel];
    
    [self addSubview:self.confrimButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Margin_20);
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(self.titleLabel);
    }];
    [self.confrimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptLabel.mas_bottom).offset(Margin_20);
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(MAIN_HEIGHT);
//        make.bottom.equalTo(self.mas_bottom).offset(-Margin_20);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TITLE_COLOR;
        _titleLabel.font = FONT(18);
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.textColor = WARNING_COLOR;
        _promptLabel.font = TITLE_FONT;
        _promptLabel.numberOfLines = 0;
    }
    return _promptLabel;
}
- (UIButton *)confrimButton
{
    if (!_confrimButton) {
        _confrimButton = [UIButton createButtonWithTitle:@"" isEnabled:YES Target:self Selector:@selector(confirmClick)];
    }
    return _confrimButton;
}
- (void)confirmClick {
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
