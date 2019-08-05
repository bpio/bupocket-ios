//
//  OpenRedEnvelopes.m
//  bupocket
//
//  Created by huoss on 2019/8/3.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "OpenRedEnvelopes.h"

@interface OpenRedEnvelopes()

@property (nonatomic, strong) UIImageView * redEnvelopesImage;
@property (nonatomic, strong) UIButton * openBtn;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, assign) CGFloat imageH;
//@property (nonatomic, assign) OpenRedEnvelopesType openType;

@end

@implementation OpenRedEnvelopes

- (instancetype)initWithOpenType:(OpenRedEnvelopesType)openType redEnvelopes:(NSString *)redEnvelopes confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
//        _openType = openType;
        NSString * imageName = (openType == OpenRedEnvelopesNormal) ? @"redEnvelopes_finished" : @"open_redEnvelopes_bg";
        UIImage * image = [UIImage imageNamed:imageName];
        self.imageH = Alert_Width * image.size.height / image.size.width;
        [self setupView];
//        self.redEnvelopesImage.image = image;
        [self.redEnvelopesImage sd_setImageWithURL:[NSURL URLWithString:redEnvelopes] placeholderImage:image];
        self.openBtn.hidden = (openType == OpenRedEnvelopesNormal);
        self.bounds = CGRectMake(0, 0, Alert_Width, self.imageH + ScreenScale(52));
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.redEnvelopesImage];
    [self addSubview:self.openBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.closeBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.redEnvelopesImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(self.imageH);
    }];
    
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.redEnvelopesImage.mas_bottom).offset(-Margin_30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redEnvelopesImage.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(1), Margin_20));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(32), ScreenScale(32)));
    }];
}

- (UIButton *)openBtn
{
    if (!_openBtn) {
        _openBtn = [UIButton createButtonWithNormalImage:@"open" SelectedImage:@"open" Target:self Selector:@selector(openClick)];
    }
    return _openBtn;
}
- (UIImageView *)redEnvelopesImage
{
    if (!_redEnvelopesImage) {
        _redEnvelopesImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Alert_Width, self.imageH)];
        _redEnvelopesImage.contentMode = UIViewContentModeScaleAspectFit;
        _redEnvelopesImage.userInteractionEnabled = YES;
    }
    return _redEnvelopesImage;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton createButtonWithNormalImage:@"versionUpdate_cancel" SelectedImage:@"versionUpdate_cancel" Target:self Selector:@selector(cancleBtnClick)];
    }
    return _closeBtn;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)openClick {
    [self.openBtn setTransformAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideView];
        if (self->_sureBlock) {
            self->_sureBlock();
        }
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
