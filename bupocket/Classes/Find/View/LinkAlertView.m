//
//  LinkAlertView.m
//  bupocket
//
//  Created by huoss on 2019/4/10.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "LinkAlertView.h"

@interface LinkAlertView ()

@property (nonatomic, strong) UIView * linkBg;
@property (nonatomic, strong) UIImageView * linkImage;
@property (nonatomic, strong) UILabel * linkTitle;
@property (nonatomic, strong) UIButton * linkContent;
@property (nonatomic, strong) UIButton * copyBtn;

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation LinkAlertView

- (instancetype)initWithNodeName:(NSString *)nodeName link:(NSString *)link confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        NSString * subStr = Localized(@"LinkPerfix");
        NSString * title = Localized(@"BULink");
        
        NSString * linkStr = [NSString stringWithFormat:@"#%@#%@%@%@%@", title, subStr, nodeName, Localized(@"LinkSuffix"), link];
        NSMutableAttributedString * attr = [Encapsulation attrWithString:linkStr preFont:FONT(14) preColor:COLOR_6 index:linkStr.length - link.length sufFont:FONT(14) sufColor:MAIN_COLOR lineSpacing:5.0];
        NSRange titleRange = NSMakeRange(1, title.length);
        NSRange nodeNameRange = NSMakeRange(subStr.length + title.length + 2, nodeName.length);
        [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:titleRange];
        [attr addAttribute:NSForegroundColorAttributeName value:COLOR(@"151515") range:nodeNameRange];
        [attr addAttribute:NSFontAttributeName value:FONT_Bold(14) range:nodeNameRange];
        [self.linkContent setAttributedTitle:attr forState:UIControlStateNormal];
        self.contentHeight = [Encapsulation getSizeSpaceLabelWithStr:linkStr font:FONT(14) width:DEVICE_WIDTH - ScreenScale(80) height:CGFLOAT_MAX lineSpacing:5.0].height + Margin_20;
//        self.linkContent.height = height;
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, self.contentHeight + ScreenScale(170));
    }
    return self;
}

- (void)setupView
{
    
    [self addSubview:self.linkBg];
    
    [self addSubview:self.linkImage];
    
    [self.linkBg addSubview:self.linkTitle];
    
    [self.linkBg addSubview:self.linkContent];
    
    [self.linkBg addSubview:self.copyBtn];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.linkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.linkImage.width + Margin_10, self.linkImage.height + Margin_10));
    }];
    [self.linkBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linkImage.mas_centerY);
        make.left.right.equalTo(self);
    }];
    [self.linkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linkImage.mas_bottom);
        make.centerX.equalTo(self.linkBg);
    }];
    
    [self.linkContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linkTitle.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.linkBg.mas_left).offset(Margin_10);
        make.right.equalTo(self.linkBg.mas_right).offset(-Margin_10);
        make.height.mas_equalTo(self.contentHeight);
    }];
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linkContent.mas_bottom).offset(Margin_15);
        make.left.equalTo(self.linkBg.mas_left).offset(Margin_25);
        make.right.equalTo(self.linkBg.mas_right).offset(-Margin_25);
        make.height.mas_equalTo(MAIN_HEIGHT);
        make.bottom.equalTo(self.linkBg.mas_bottom).offset(-Margin_20);
    }];
}
- (UIView *)linkBg
{
    if (!_linkBg) {
        _linkBg = [[UIView alloc] init];
        _linkBg.backgroundColor = [UIColor whiteColor];
        _linkBg.layer.masksToBounds = YES;
        _linkBg.layer.cornerRadius = BG_CORNER;
    }
    return _linkBg;
}


- (UILabel *)linkTitle
{
    if (!_linkTitle) {
        _linkTitle = [[UILabel alloc] init];
        _linkTitle.textColor = COLOR_6;
        _linkTitle.font = TITLE_FONT;
        _linkTitle.text = Localized(@"LinkTitle");
    }
    return _linkTitle;
}

- (UIButton *)linkContent
{
    if (!_linkContent) {
        _linkContent = [UIButton createButtonWithTitle:@"" TextFont:14 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
        _linkContent.titleLabel.numberOfLines = 0;
        _linkContent.backgroundColor = COLOR(@"F8F8F8");
        _linkContent.contentEdgeInsets = UIEdgeInsetsMake(Margin_10, Margin_10, Margin_10, Margin_10);
    }
    return _linkContent;
}
- (UIButton *)copyBtn
{
    if (!_copyBtn) {
        _copyBtn = [UIButton createButtonWithTitle:Localized(@"CopyLink") isEnabled:YES Target:self Selector:@selector(updateClick)];
    }
    return _copyBtn;
}
- (UIImageView *)linkImage
{
    if (!_linkImage) {
        _linkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_icon"]];
        _linkImage.contentMode = UIViewContentModeCenter;
        _linkImage.layer.masksToBounds = YES;
        _linkImage.layer.cornerRadius = _linkImage.width / 2.0 + Margin_5;
        _linkImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _linkImage.layer.borderWidth = Margin_5;
    }
    return _linkImage;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)updateClick {
    [self hideView];
    if (_sureBlock) {
        _sureBlock();
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIPasteboard generalPasteboard] setString:self.linkContent.titleLabel.attributedText.string];
        [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
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
