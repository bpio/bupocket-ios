//
//  SharingCanvassingAlertView.m
//  bupocket
//
//  Created by huoss on 2019/4/4.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "SharingCanvassingAlertView.h"

@interface SharingCanvassingAlertView ()

@property (nonatomic, strong) UIImageView * imageBg;
@property (nonatomic, strong) UIButton * invitationPrompt;
@property (nonatomic, strong) UIView * shareBg;

@end

@implementation SharingCanvassingAlertView

- (instancetype)initWithConfrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _confrimClick = confrimBlock;
        _cancleClick = cancelBlock;
        [self setupView];
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(500));
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageBg];
    
    [self.imageBg addSubview:self.invitationPrompt];
    
    [self addSubview:self.shareBg];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(Margin_20);
    }];
    [self.invitationPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.imageBg);
        make.height.mas_equalTo(Margin_50);
        make.right.equalTo(self.imageBg.mas_right).offset(-ScreenScale(60));
    }];
}
- (UIImageView *)imageBg
{
    if (!_imageBg) {
        _imageBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_bg"]];
    }
    return _imageBg;
}
- (UIButton *)invitationPrompt
{
    if (!_invitationPrompt) {
        _invitationPrompt = [UIButton buttonWithType:UIButtonTypeCustom];
        _invitationPrompt.contentEdgeInsets = UIEdgeInsetsMake(Margin_10, Margin_10, Margin_10, Margin_10);
        _invitationPrompt.titleLabel.numberOfLines = 0;
        [_invitationPrompt setAttributedTitle:[Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"InvitationPrompt"), Localized(@"LongPressPrompt")] preFont:FONT(13) preColor:COLOR(@"BABCC9") index:[Localized(@"InvitationPrompt") length] sufFont:FONT(12) sufColor:COLOR(@"737791") lineSpacing:5.0] forState:UIControlStateNormal];
        
    }
    return _invitationPrompt;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleClick) {
        _cancleClick();
    }
}
- (void)sureBtnClick {
    [self hideView];
    if (_confrimClick) {
        _confrimClick(@"");
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
