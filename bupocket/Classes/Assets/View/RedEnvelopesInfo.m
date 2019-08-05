//
//  RedEnvelopesInfo.m
//  bupocket
//
//  Created by huoss on 2019/8/3.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "RedEnvelopesInfo.h"

@interface RedEnvelopesInfo()

@property (nonatomic, strong) UIView * infoBg;
@property (nonatomic, strong) UIImageView * headerImage;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UIImageView * iconImage;
@property (nonatomic, strong) UILabel * iconTitle;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UILabel * address;
@property (nonatomic, strong) UIImageView * downloadImage;
@property (nonatomic, strong) UIButton * saveAndShareBtn;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) RedEnvelopesType redEnvelopesType;
@property (nonatomic, assign) CGFloat headerImageH;
@property (nonatomic, assign) CGFloat downloadImageH;
@property (nonatomic, assign) CGFloat iconBtnH;

@property (nonatomic, strong) UIImage * header;
@property (nonatomic, strong) UIImage * download;
@property (nonatomic, strong) UIImage * icon;

@end

//#define ImagePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"downloadAppImage.png"]

@implementation RedEnvelopesInfo

- (instancetype)initWithRedEnvelopesType:(RedEnvelopesType)redEnvelopesType confrimBolck:(void (^ _Nullable)(void))confrimBlock cancelBlock:(void (^ _Nullable)(void))cancelBlock
{
    if (self = [super init]) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        _redEnvelopesType = redEnvelopesType;
        self.width = (self.redEnvelopesType == RedEnvelopesTypeNormal) ? DEVICE_WIDTH : Alert_Width;
        NSString * imageName = (_redEnvelopesType == RedEnvelopesTypeNormal) ? @"redEnvelopes_header_n" : @"redEnvelopes_header";
        self.header = [UIImage imageNamed: imageName];
        self.headerImageH = self.width * self.header.size.height / self.header.size.width;
        self.icon = [UIImage imageNamed:@"redEnvelopes_logo"];
        self.iconBtnH = self.icon.size.height;
        self.download = [UIImage imageNamed:@"download_QRCode"];
        self.downloadImageH = (_redEnvelopesType == RedEnvelopesTypeNormal) ? self.download.size.height : (self.width * self.download.size.height / self.download.size.width);
        [self setupView];
        self.closeBtn.hidden = (self.redEnvelopesType == RedEnvelopesTypeNormal);
//        self.headerImage.image = self.header;
//        _iconImage.image = self.icon;
//        self.downloadImage.image = self.download;
        self.bounds = CGRectMake(0, 0, self.width, self.headerImageH + self.downloadImageH + (self.iconBtnH / 2) + ScreenScale(225));
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = (self.redEnvelopesType == RedEnvelopesTypeNormal) ? 0 : BG_CORNER;
    self.clipsToBounds = YES;
    
    [self addSubview:self.infoBg];
    [self.infoBg addSubview:self.headerImage];
    [self addSubview:self.closeBtn];
    [self.infoBg addSubview:self.iconImage];
    [self.infoBg addSubview:self.iconTitle];
    [self.infoBg addSubview:self.amount];
    [self.infoBg addSubview:self.address];
    [self.infoBg addSubview:self.downloadImage];
    [self addSubview:self.saveAndShareBtn];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.infoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(60));
    }];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.infoBg);
        make.height.mas_equalTo(self.headerImageH);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Margin_40, Margin_40));
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.infoBg);
//        make.top.mas_equalTo(self.headerImageH);
        make.centerY.equalTo(self.headerImage.mas_bottom);
//        make.bottom.equalTo(self.headerImage.mas_bottom).offset(Margin_15);
//        make.bottom.equalTo(self.headerImage.mas_bottom).offset(Margin_20);
//        make.top.mas_equalTo(self.headerImageH - self.iconBtnH + Margin_20);
//        make.top.equalTo(self.headerImage.mas_bottom).offset(self.iconBtnH + Margin_10);
//        make.centerY.equalTo(self.headerImage.mas_bottom).offset(Margin_25);
        make.height.mas_equalTo(self.iconBtnH);
    }];
    [self.iconTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.infoBg);
        make.top.equalTo(self.iconImage.mas_bottom).offset(Margin_10);
        //        make.centerY.equalTo(self.headerImage.mas_bottom).offset(Margin_25);
        make.height.mas_equalTo(Margin_20);
    }];
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconTitle.mas_bottom).offset(Margin_15);
        make.left.equalTo(self.mas_left).offset(Margin_Main);
        make.right.equalTo(self.mas_right).offset(-Margin_Main);
        make.height.mas_equalTo(ScreenScale(60));
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amount.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(self.amount);
        make.height.mas_equalTo(ScreenScale(35));
    }];
    
    [self.downloadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.address.mas_bottom).offset(Margin_10);
        make.left.right.equalTo(self.infoBg);
        make.height.mas_equalTo(self.downloadImageH);
    }];
    [self.saveAndShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.downloadImage.mas_bottom).offset(Margin_10);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(150), ScreenScale(35)));
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-Margin_15);
    }];
//    [self layoutIfNeeded];
//    self.bounds = CGRectMake(0, 0, self.width, CGRectGetMaxY(self.saveAndShareBtn.frame) + Margin_15);
}
- (void)setActivityInfoModel:(ActivityInfoModel *)activityInfoModel
{
    _activityInfoModel = activityInfoModel;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:activityInfoModel.topImage] placeholderImage:self.header];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:activityInfoModel.issuerPhoto] placeholderImage:self.icon];
    [self.downloadImage sd_setImageWithURL:[NSURL URLWithString:activityInfoModel.bottomImage] placeholderImage:self.download];
    NSString * amountStr = activityInfoModel.amount;
    if (NotNULLString(amountStr)) {
        self.amount.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", amountStr, activityInfoModel.tokenSymbol] preFont:FONT_Bold(44) preColor:TITLE_COLOR index:amountStr.length sufFont:FONT(20) sufColor:TITLE_COLOR lineSpacing:0];
        self.amount.textAlignment = NSTextAlignmentCenter;
    }
    NSString * prompt = (self.redEnvelopesType == RedEnvelopesTypeNormal) ? @"已存入钱包" : @"已存入钱包，稍后到账";
    self.address.text = [NSString stringWithFormat:@"%@\n（%@）", prompt, [NSString stringEllipsisWithStr:activityInfoModel.receiver subIndex:SubIndex_Address]];
}
- (UIView *)infoBg
{
    if (!_infoBg) {
        _infoBg = [[UIView alloc] init];
    }
    return _infoBg;
}
- (UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, 0)];
        _headerImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _headerImage;
}
- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}
- (UILabel *)iconTitle
{
    if (!_iconTitle) {
        _iconTitle = [[UILabel alloc] init];
        _iconTitle.font = FONT_TITLE;
        _iconTitle.textColor = COLOR_6;
        _iconTitle.text = @"小布口袋";
    }
    return _iconTitle;
}
//- (CustomButton *)iconBtn
//{
//    if (!_iconBtn) {
//        _iconBtn = [[CustomButton alloc] init];
//        _iconBtn.layoutMode = VerticalNormal;
//        _iconBtn.titleLabel.font = FONT_TITLE;
//        [_iconBtn setTitleColor:COLOR_6 forState:UIControlStateNormal];
//        [_iconBtn setTitle:@"小布口袋" forState:UIControlStateNormal];
//    }
//    return _iconBtn;
//}
- (UILabel *)amount
{
    if (!_amount) {
        _amount = [[UILabel alloc] init];
    }
    return _amount;
}
- (UILabel *)address
{
    if (!_address) {
        _address = [[UILabel alloc] init];
        _address.numberOfLines = 0;
        _address.textColor = COLOR_6;
        _address.font = FONT(12);
        _address.textAlignment = NSTextAlignmentCenter;
    }
    return _address;
}
- (UIImageView *)downloadImage
{
    if (!_downloadImage) {
        _downloadImage = [[UIImageView alloc] init];
        _downloadImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _downloadImage;
}
- (UIButton *)saveAndShareBtn
{
    if (!_saveAndShareBtn) {
        _saveAndShareBtn = [UIButton createButtonWithTitle:@"保存图片并分享" TextFont:FONT_Bold(14) TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(saveAndShare)];
        _saveAndShareBtn.backgroundColor = Valentine_COLOR;
        _saveAndShareBtn.layer.masksToBounds = YES;
        _saveAndShareBtn.layer.cornerRadius = TAG_CORNER;
    }
    return _saveAndShareBtn;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton createButtonWithNormalImage:@"close_w" SelectedImage:@"close_w" Target:self Selector:@selector(cancleBtnClick)];
    }
    return _closeBtn;
}
- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)saveAndShare {
    if (self.redEnvelopesType == RedEnvelopesTypeDefault) {
        [self hideView];
    }
    if (_sureBlock) {
        _sureBlock();
    }
    [self shareAction];
}
- (void)shareAction
{
    UIImage * walletImage = [Encapsulation mergedImageWithMainImage:self.infoBg];
//    NSData * imageData = UIImagePNGRepresentation(walletImage);
//    [imageData writeToFile:ImagePath atomically:YES];
    UIImageWriteToSavedPhotosAlbum(walletImage, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    NSArray * activityItems = @[walletImage];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    // excludedActivityTypes 用于指定不需要提供的服务
    if (@available(iOS 11.0, *)) {
        activity.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                           UIActivityTypePostToTwitter,
                                           UIActivityTypePostToWeibo,
                                           UIActivityTypeMessage,
                                           UIActivityTypeMail,
                                           UIActivityTypePrint,
                                           UIActivityTypeCopyToPasteboard,
                                           UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList,
                                           UIActivityTypePostToVimeo,
                                           UIActivityTypePostToTencentWeibo,
                                           UIActivityTypeAirDrop,
                                           UIActivityTypeOpenInIBooks,
                                           UIActivityTypeMarkupAsPDF];
    } else {
        // Fallback on earlier versions
    }
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
        popover.sourceView = [UIApplication currentViewController].view;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [[UIApplication currentViewController] presentViewController:activity animated:YES completion:nil];
    activity.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"系统分享成功");
        } else {
            NSLog(@"系统分享失败");
        }
    };
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
