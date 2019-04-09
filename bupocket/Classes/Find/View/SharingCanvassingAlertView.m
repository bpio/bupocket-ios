//
//  SharingCanvassingAlertView.m
//  bupocket
//
//  Created by huoss on 2019/4/4.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "SharingCanvassingAlertView.h"
#import <WXApi.h>
#import "HMScannerController.h"

@interface SharingCanvassingAlertView ()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * imageBg;
@property (nonatomic, strong) UIImageView * nodeLogo;
@property (nonatomic, strong) UILabel * nodeName;
@property (nonatomic, strong) UIButton * invitationPrompt;
@property (nonatomic, strong) UIImageView * QRCode;

@property (nonatomic, strong) UIView * shareBg;
@property (nonatomic, strong) UIButton * cancel;

@end

@implementation SharingCanvassingAlertView

- (instancetype)initWithNodePlanModel:(NodePlanModel *)nodePlanModel confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _confrimClick = confrimBlock;
        _cancleClick = cancelBlock;
        [self setupView];
        self.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(500));
        [_nodeLogo sd_setImageWithURL:[NSURL URLWithString:nodePlanModel.nodeLogo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _nodeName.text = nodePlanModel.nodeName;
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.imageBg];
    
    [self.imageBg addSubview:self.nodeLogo];
    
    [self.imageBg addSubview:self.nodeName];
    
    [self.imageBg addSubview:self.invitationPrompt];
    
    [self.imageBg addSubview:self.QRCode];
    
    [self addSubview:self.shareBg];
    
    [self addSubview:self.cancel];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(ScreenScale(380));
    }];
    
    [self.imageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
//        make.top.mas_equalTo(Margin_20);
    }];
    [self.nodeLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageBg.mas_centerY);
        make.centerX.equalTo(self.imageBg);
        make.size.mas_equalTo(CGSizeMake(Margin_60, Margin_60));
    }];
    [self.nodeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nodeLogo.mas_bottom).offset(Margin_10);
        make.centerX.equalTo(self.imageBg);
        make.width.mas_lessThanOrEqualTo(ScreenScale(210));
    }];
    [self.invitationPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.imageBg);
        make.height.mas_equalTo(ScreenScale(65));
        make.right.equalTo(self.imageBg.mas_right).offset(-ScreenScale(65));
    }];
    
    [self.QRCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imageBg.mas_right).offset(-Margin_15);
        make.size.mas_equalTo(CGSizeMake(Margin_50, Margin_50));
        make.centerY.equalTo(self.invitationPrompt);
    }];
    
    [self.cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(MAIN_HEIGHT);
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.shareBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cancel.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(ScreenScale(75));
    }];
    
    
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.contentSize = CGSizeMake(DEVICE_WIDTH * 2, ScreenScale(380));
    }
    return _scrollView;
}
- (UIImageView *)imageBg
{
    if (!_imageBg) {
        _imageBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_bg"]];
    }
    return _imageBg;
}
- (UIImageView *)nodeLogo
{
    if (!_nodeLogo) {
        _nodeLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];
        _nodeLogo.layer.masksToBounds = YES;
        _nodeLogo.layer.cornerRadius = Margin_30;
    }
    return _nodeLogo;
}
- (UILabel *)nodeName
{
    if (!_nodeName) {
        _nodeName = [[UILabel alloc] init];
        _nodeName.font = TITLE_FONT;
        _nodeName.textColor = MAIN_COLOR;
    }
    return _nodeName;
}
- (UIButton *)invitationPrompt
{
    if (!_invitationPrompt) {
        _invitationPrompt = [UIButton buttonWithType:UIButtonTypeCustom];
        _invitationPrompt.contentEdgeInsets = UIEdgeInsetsMake(Margin_10, Margin_10, Margin_10, Margin_10);
        _invitationPrompt.titleLabel.numberOfLines = 0;
        [_invitationPrompt setAttributedTitle:[Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"InvitationPrompt"), Localized(@"LongPressPrompt")] preFont:FONT(13) preColor:COLOR(@"BABCC9") index:[Localized(@"InvitationPrompt") length] sufFont:FONT(12) sufColor:COLOR(@"737791") lineSpacing:5.0] forState:UIControlStateNormal];
        _invitationPrompt.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _invitationPrompt;
}
- (UIImageView *)QRCode
{
    if (!_QRCode) {
        _QRCode = [[UIImageView alloc] init];
        _QRCode.backgroundColor = [UIColor whiteColor];
        _QRCode.layer.masksToBounds = YES;
        _QRCode.layer.cornerRadius = TAG_CORNER;
        _QRCode.image = [UIImage imageNamed:@"placeholderBg"];
        [HMScannerController cardImageWithCardName:@"https://www.baidu.com" avatar:nil scale:0.2 completion:^(UIImage *image) {
            self->_QRCode.image = image;
        }];
    }
    return _QRCode;
}
- (UIView *)shareBg
{
    if (!_shareBg) {
        _shareBg = [[UIView alloc] init];
        _shareBg.backgroundColor = COLOR(@"F8F8F8");
        NSArray * shareTitles = @[Localized(@"WeChat"), Localized(@"QQ"), Localized(@"CopyLink")];
        NSArray * shareImages = @[@"wechat", @"QQ", @"copy_link"];
        CGFloat shareW = (DEVICE_WIDTH - Margin_40) / shareTitles.count;
        for (NSInteger i = 0; i < shareTitles.count; i ++) {
            CustomButton * share = [[CustomButton alloc] init];
            share.layoutMode = VerticalNormal;
            share.titleLabel.font = FONT(13);
            [share setTitleColor:COLOR_6 forState:UIControlStateNormal];
            [share setTitle:shareTitles[i] forState:UIControlStateNormal];
            [share setImage:[UIImage imageNamed:shareImages[i]] forState:UIControlStateNormal];
            [share addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            [_shareBg addSubview:share];
            [share mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self->_shareBg);
                make.left.equalTo(self->_shareBg.mas_left).offset(Margin_20 + shareW * i);
                make.width.mas_equalTo(shareW);
            }];
        }
    }
    return _shareBg;
}
- (void)shareAction:(UIButton *)button
{
    UIImage * shareImage = [self mergedImage];
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    // 设置消息缩略图的方法
    [message setThumbImage:[UIImage imageNamed:@"logo"]];
    // 多媒体消息中包含的图片数据对象
    WXImageObject *imageObject = [WXImageObject object];
    
    // 图片真实数据内容
    NSData *data = UIImagePNGRepresentation(shareImage);
    imageObject.imageData = data;
    // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;// 分享到朋友圈
    [WXApi sendReq:req];
    
//    BOOL hasInstalledWechat = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
//    BOOL hasInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
//    BOOL hasInstalledTelegram = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tg://"]];
}

- (UIButton *)cancel
{
    if (!_cancel) {
        _cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:18 TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:self Selector:@selector(cancleBtnClick)];
    }
    return _cancel;
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

#pragma mark 多张图片合成一张
- (UIImage *)mergedImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.imageBg.size.width, self.imageBg.size.height), NO, 0);
    [self.imageBg.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
//    NSData * imageData = UIImagePNGRepresentation(resultImage);
//    [imageData writeToFile:@"/Users/huoss/Desktop/margeImage.png" atomically:YES];
//    UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil){
        DLog(@"已保存到本地相册");
    } else {
        DLog(@"保存失败，请重试!");
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