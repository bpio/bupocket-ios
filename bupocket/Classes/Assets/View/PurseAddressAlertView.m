//
//  PurseAddressAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "PurseAddressAlertView.h"
#import "HMScannerController.h"

@interface PurseAddressAlertView()

@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * purseAddressTitle;
@property (nonatomic, strong) UILabel * purseAddress;
@property (nonatomic, strong) UIButton * copyBtn;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * QRCodeImage;
@property (nonatomic, strong) UILabel * QRCodeTitle;

@end

@implementation PurseAddressAlertView

- (instancetype)initWithPurseAddress:(NSString *)purseAddress confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        self.purseAddress.text = purseAddress;
        [HMScannerController cardImageWithCardName:purseAddress avatar:nil scale:0.2 completion:^(UIImage *image) {
            self.QRCodeImage.image = image;
        }];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.purseAddressTitle];
    
    [self addSubview:self.purseAddress];
    
    [self addSubview:self.copyBtn];
    
    [self addSubview:self.lineView];
    
    [self addSubview:self.QRCodeImage];
    
    [self addSubview:self.QRCodeTitle];
    
    self.frame = CGRectMake(0, DEVICE_HEIGHT - ScreenScale(440) - SafeAreaBottomH, DEVICE_WIDTH, ScreenScale(440));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo([UIApplication sharedApplication].keyWindow);
        make.height.mas_equalTo(ScreenScale(440));
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom).offset(-SafeAreaBottomH);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_HEIGHT, MAIN_HEIGHT));
    }];
    
    [self.purseAddressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(42));
        make.left.equalTo(self).offset(Margin_20);
    }];
    
    [self.purseAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purseAddressTitle.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
    }];
    
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purseAddressTitle.mas_bottom).offset(Margin_60);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(220), MAIN_HEIGHT));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.purseAddress);
        make.top.equalTo(self.copyBtn.mas_bottom).offset(Margin_20);
    }];
    
    [self.QRCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.copyBtn.mas_bottom).offset(MAIN_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(180), ScreenScale(180)));
    }];
    
    [self.QRCodeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.QRCodeImage.mas_bottom).offset(Margin_10);
    }];
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton createButtonWithNormalImage:@"close" SelectedImage:@"close" Target:self Selector:@selector(cancleBtnClick)];
    }
    return _closeBtn;
}
- (UILabel *)purseAddressTitle
{
    if (!_purseAddressTitle) {
        _purseAddressTitle = [[UILabel alloc] init];
        _purseAddressTitle.textColor = COLOR_9;
        _purseAddressTitle.font = FONT(16);
        _purseAddressTitle.text = Localized(@"PurseAddressTitle");
    }
    return _purseAddressTitle;
}
- (UILabel *)purseAddress
{
    if (!_purseAddress) {
        _purseAddress = [[UILabel alloc] init];
        _purseAddress.textColor = TITLE_COLOR;
        _purseAddress.font = FONT(15);
        _purseAddress.numberOfLines = 0;
    }
    return _purseAddress;
}
- (UIButton *)copyBtn
{
    if (!_copyBtn) {
        _copyBtn = [UIButton createButtonWithTitle:Localized(@"DuplicateWalletAddress") isEnabled:YES Target:self Selector:@selector(copyClick)];
    }
    return _copyBtn;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, LINE_WIDTH);
        [_lineView drawDashLine];
    }
    return _lineView;
}
- (UIImageView *)QRCodeImage
{
    if (!_QRCodeImage) {
        _QRCodeImage = [[UIImageView alloc] init];
        _QRCodeImage.image = [UIImage imageNamed:@"placeholderBg"];
    }
    return _QRCodeImage;
}
- (UILabel *)QRCodeTitle
{
    if (!_QRCodeTitle) {
        _QRCodeTitle = [[UILabel alloc] init];
        _QRCodeTitle.textColor = COLOR(@"B2B2B2");
        _QRCodeTitle.font = FONT(15);
        _QRCodeTitle.text = Localized(@"WalletAddressQRCode");
    }
    return _QRCodeTitle;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)copyClick {
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
