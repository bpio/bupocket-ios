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
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIButton * sureBtn;

@end

@implementation CreateTipsAlertView

- (instancetype)initWithConfrimBolck:(void (^)(void))confrimBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        [self setupView];
        
        NSString * warnStr = Localized(@"CreatePWWarn");
        NSString * infoStr = Localized(@"CreatePWInfo");
        NSString * titleStr = [NSString stringWithFormat:@"%@\n%@", warnStr, infoStr];
        _title.attributedText = [Encapsulation attrWithString:titleStr preFont:FONT(15) preColor:WARNING_COLOR index:warnStr.length sufFont:FONT(15) sufColor:TITLE_COLOR lineSpacing:Margin_5];
        CGFloat height = [Encapsulation getSizeSpaceLabelWithStr:titleStr font:FONT(15) width:(DEVICE_WIDTH - ScreenScale(80)) height:CGFLOAT_MAX lineSpacing:Margin_5].height + ScreenScale(210);
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, height);
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    
    [self addSubview:self.promptBtn];
    
    [self addSubview:self.title];
    
    [self addSubview:self.sureBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.promptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Margin_10);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promptBtn.mas_bottom);
        make.left.equalTo(self).offset(Margin_20);
        make.right.equalTo(self).offset(-Margin_20);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(Margin_15);
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_20);
        make.left.right.equalTo(self.title);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (CustomButton *)promptBtn
{
    if (!_promptBtn) {
        _promptBtn = [[CustomButton alloc] init];
        _promptBtn.layoutMode = VerticalNormal;
        _promptBtn.titleLabel.font = FONT(21);
        [_promptBtn setTitle:Localized(@"CreatePWPrompt") forState:UIControlStateNormal];
        [_promptBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        [_promptBtn setImage:[UIImage imageNamed:@"createPrompt"] forState:UIControlStateNormal];
    }
    return _promptBtn;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.numberOfLines = 0;
        _title.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _title;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:YES Target:self Selector:@selector(sureBtnClick)];
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
