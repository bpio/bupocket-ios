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
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * updateContent;
@property (nonatomic, strong) UIButton * updateBtn;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, assign) CGFloat scrollViewH;

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * versionNumber;
@property (nonatomic, strong) NSString * versionSizeStr;
@property (nonatomic, assign) CGFloat contentW;

@end



@implementation VersionUpdateAlertView

- (instancetype)initWithUpdateVersionNumber:(NSString *)versionNumber versionSize:(NSString *)versionSize content:(NSString *)content verType:(NSInteger)verType confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        self.contentW = Alert_Width - Margin_30;
        _versionNumber = versionNumber;
        _versionSizeStr = versionSize;
        _content = content;
        [self setupView];
        CGFloat height = ScreenScale(210) + self.updateImage.height + self.versionUpdateTitle.height + self.scrollViewH;
        if (verType == 1) {
            self.lineView.hidden = YES;
            self.closeBtn.hidden = YES;
            height = height - ScreenScale(82);
        }
        
//        CGFloat updateContentH = [Encapsulation getSizeSpaceLabelWithStr:content font:FONT_TITLE width:contentW height:CGFLOAT_MAX lineSpacing:LINE_SPACING].height;
//        self.scrollView.contentSize = CGSizeMake(CGFLOAT_MIN, updateContentH);
//        self.updateContent.text = content;
//        ScreenScale(350)
        
//        CGFloat height = [Encapsulation rectWithText:self.versionUpdateTitle.text font:_versionUpdateTitle.font textWidth:self.contentW].size.height + [Encapsulation rectWithText:self.versionSize.text font:_versionSize.font textWidth:self.contentW].size.height + self.updateContent.height + ScreenScale(115) + self.updateImageH;
//        height = (verType == 0) ? height + ScreenScale(82) : height;
//        height = MIN(height, ScreenScale(360));
        self.bounds = CGRectMake(0, 0, Alert_Width, height);
    }
    return self;
}

- (void)setupView
{
    
    [self addSubview:self.updateBg];
    
    [self addSubview:self.updateImage];
    
    [self addSubview:self.versionUpdateTitle];
    
    [self addSubview:self.versionSize];
    
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.updateContent];
    
    [self addSubview:self.updateBtn];
    // Update type (0: non-mandatory, 1: mandatory)
    [self addSubview:self.lineView];
    [self addSubview:self.closeBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.updateBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(Margin_50);
        make.left.right.equalTo(self);
    }];
    [self.updateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_equalTo(self.updateImage.size);
    }];
    [self.versionUpdateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(ScreenScale(140));
        make.top.equalTo(self.updateImage.mas_bottom);
        make.left.equalTo(self.mas_left).offset(Margin_Main);
        make.right.equalTo(self.mas_right).offset(-Margin_Main);
//        make.height.mas_equalTo(self.versionUpdateTitle.height);
    }];
    
    [self.versionSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionUpdateTitle.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(self.versionUpdateTitle);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.versionSize.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.scrollViewH);
//        make.bottom.equalTo(self.updateBg.mas_bottom).offset(-Alert_Button_Height - Margin_20);
    }];
    [self.updateContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(Margin_Main);
        make.size.mas_equalTo(self.updateContent.size);
    }];
    self.scrollView.contentSize = CGSizeMake(CGFLOAT_MIN, self.updateContent.height);
    [self.updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.scrollView.mas_bottom).offset(Margin_20);
        make.top.equalTo(self.versionSize.mas_bottom).offset(ScreenScale(35) + self.scrollViewH);
        make.left.right.equalTo(self.versionUpdateTitle);
        make.height.mas_equalTo(MAIN_HEIGHT);
        make.bottom.equalTo(self.updateBg.mas_bottom).offset(-Margin_20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updateBg.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(1), MAIN_HEIGHT));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(32), ScreenScale(32)));
    }];
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

- (UILabel *)versionUpdateTitle
{
    if (!_versionUpdateTitle) {
        _versionUpdateTitle = [[UILabel alloc] init];
        _versionUpdateTitle.textColor = TITLE_COLOR;
        _versionUpdateTitle.font = FONT(18);
        _versionUpdateTitle.numberOfLines = 0;
        _versionUpdateTitle.text = [NSString stringWithFormat:@"%@ %@？", Localized(@"IfUpdate"), _versionNumber];
        CGSize maximumSize = CGSizeMake(Alert_Width - Margin_30, CGFLOAT_MAX);
        CGSize expectSize = [_versionUpdateTitle sizeThatFits:maximumSize];
        _versionUpdateTitle.size = expectSize;
    }
    return _versionUpdateTitle;
}
- (UILabel *)versionSize
{
    if (!_versionSize) {
        _versionSize = [[UILabel alloc] init];
        _versionSize.textColor = COLOR_6;
        _versionSize.font = FONT_TITLE;
        _versionSize.numberOfLines = 0;
        _versionSize.text = [NSString stringWithFormat:@"%@%@", Localized(@"AppSize"), _versionSizeStr];
        CGSize maximumSize = CGSizeMake(_contentW, CGFLOAT_MAX);
        CGSize expectSize = [_versionSize sizeThatFits:maximumSize];
        _versionSize.size = expectSize;
    }
    return _versionSize;
}
- (UILabel *)updateContent
{
    if (!_updateContent) {
        _updateContent = [[UILabel alloc] init];
        _updateContent.textColor = COLOR_6;
        _updateContent.font = FONT_TITLE;
        _updateContent.numberOfLines = 0;
        _updateContent.attributedText = [Encapsulation attrWithString:_content preFont:FONT_TITLE preColor:COLOR_6 index:0 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:LINE_SPACING];
        CGSize maximumSize = CGSizeMake(Alert_Width - Margin_30, CGFLOAT_MAX);
        CGSize expectSize = [_updateContent sizeThatFits:maximumSize];
        _updateContent.size = expectSize;
        _scrollViewH = MIN(ScreenScale(120), expectSize.height);
    }
    return _updateContent;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
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
        CGFloat updateImageH = Alert_Width * _updateImage.image.size.height / _updateImage.image.size.width;
        _updateImage.size = CGSizeMake(Alert_Width, updateImageH);
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
