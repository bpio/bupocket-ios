//
//  VersionUpdateAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/11/13.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "VersionUpdateAlertView.h"

@interface VersionUpdateAlertView()

@property (nonatomic, strong) UIView * updateBg;
@property (nonatomic, strong) UIImageView * updateImage;
@property (nonatomic, strong) UILabel * versionUpdateTitle;
@property (nonatomic, strong) UILabel * versionSize;
@property (nonatomic, strong) UILabel * updateContent;
@property (nonatomic, strong) UIButton * updateBtn;
//@property (nonatomic, strong) UIButton * closeBtn;
//@property (nonatomic, strong) UIView * lineView;

@end


@implementation VersionUpdateAlertView

- (instancetype)initWithUpdateVersionNumber:(NSString *)versionNumber versionSize:(NSString *)versionSize content:(NSString *)content confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        self.versionUpdateTitle.text = [NSString stringWithFormat:@"%@%@？", Localized(@"IfUpdate"), versionNumber];
        self.versionSize.text = [NSString stringWithFormat:@"%@%@", Localized(@"AppSize"), versionSize];
        self.updateContent.text = content;
        CGFloat height = [Encapsulation rectWithText:self.updateContent.text font:_updateContent.font textWidth:DEVICE_WIDTH - ScreenScale(80)].size.height + ScreenScale(370);
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, height);
    }
    return self;
}

- (void)setupView {
    
    [self addSubview:self.updateBg];
    
    [self addSubview:self.updateImage];
    
    [self addSubview:self.versionUpdateTitle];
    
    [self addSubview:self.versionSize];
    
    [self addSubview:self.updateContent];
    
    [self addSubview:self.updateBtn];
    
//    [self addSubview:self.lineView];
    
//    [self addSubview:self.closeBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.updateBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Margin_40);
        make.left.right.equalTo(self);
    }];
    [self.updateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    [self.versionUpdateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(140));
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
    }];
    
    [self.versionSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionUpdateTitle.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(self.versionUpdateTitle);
    }];
    
    [self.updateContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionSize.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(self.versionUpdateTitle);
    }];
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateContent.mas_bottom).offset(Margin_20);
        make.left.right.equalTo(self.versionUpdateTitle);
        make.height.mas_equalTo(MAIN_HEIGHT);
        make.bottom.equalTo(self.updateBg.mas_bottom).offset(-Margin_20);
    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.updateBg.mas_bottom);
//        make.centerX.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(ScreenScale(1), Margin_50));
//    }];
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView.mas_bottom);
//        make.centerX.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(ScreenScale(32), ScreenScale(32)));
//    }];
}
- (UIView *)updateBg
{
    if (!_updateBg) {
        _updateBg = [[UIView alloc] init];
        _updateBg.backgroundColor = [UIColor whiteColor];
        _updateBg.layer.masksToBounds = YES;
        _updateBg.layer.cornerRadius = BG_CORNER;
    }
    return _updateBg;
}
/*
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
*/
- (UILabel *)versionUpdateTitle
{
    if (!_versionUpdateTitle) {
        _versionUpdateTitle = [[UILabel alloc] init];
        _versionUpdateTitle.textColor = TITLE_COLOR;
        _versionUpdateTitle.font = FONT(18);
//        _versionUpdateTitle.text = Localized(@"VersionUpdate");
    }
    return _versionUpdateTitle;
}
- (UILabel *)versionSize
{
    if (!_versionSize) {
        _versionSize = [[UILabel alloc] init];
        _versionSize.textColor = COLOR_6;
        _versionSize.font = TITLE_FONT;
    }
    return _versionSize;
}
- (UILabel *)updateContent
{
    if (!_updateContent) {
        _updateContent = [[UILabel alloc] init];
        _updateContent.textColor = COLOR_6;
        _updateContent.font = TITLE_FONT;
        _updateContent.numberOfLines = 0;
    }
    return _updateContent;
}
- (UIButton *)updateBtn
{
    if (!_updateBtn) {
        _updateBtn = [UIButton createButtonWithTitle:Localized(@"UpdateVersion") isEnabled:YES Target:self Selector:@selector(updateClick)];
    }
    return _updateBtn;
}
- (UIImageView *)updateImage
{
    if (!_updateImage) {
        _updateImage = [[UIImageView alloc] init];
        _updateImage.image = [UIImage imageNamed:@"versionUpdate"];
    }
    return _updateImage;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)updateClick {
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
