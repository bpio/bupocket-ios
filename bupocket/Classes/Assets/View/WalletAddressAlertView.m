//
//  WalletAddressAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "WalletAddressAlertView.h"
#import "HMScannerController.h"

@interface WalletAddressAlertView()

@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * walletAddressTitle;
@property (nonatomic, strong) UILabel * walletAddress;
@property (nonatomic, strong) UIButton * copyBtn;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIImageView * QRCodeImage;
@property (nonatomic, strong) UILabel * QRCodeTitle;

@end

@implementation WalletAddressAlertView

- (instancetype)initWithWalletAddress:(NSString *)walletAddress confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        self.walletAddress.text = walletAddress;
        [HMScannerController cardImageWithCardName:walletAddress avatar:nil scale:0.2 completion:^(UIImage *image) {
            self.QRCodeImage.image = image;
        }];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = WHITE_BG_COLOR;
    
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.walletAddressTitle];
    
    [self addSubview:self.walletAddress];
    
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
    
    [self.walletAddressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(42));
        make.left.equalTo(self).offset(Margin_20);
    }];
    
    [self.walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletAddressTitle.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
    }];
    
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletAddressTitle.mas_bottom).offset(Margin_60);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(220), MAIN_HEIGHT));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.walletAddress);
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
- (UILabel *)walletAddressTitle
{
    if (!_walletAddressTitle) {
        _walletAddressTitle = [[UILabel alloc] init];
        _walletAddressTitle.textColor = COLOR_9;
        _walletAddressTitle.font = FONT(16);
        _walletAddressTitle.text = Localized(@"WalletAddressTitle");
    }
    return _walletAddressTitle;
}
- (UILabel *)walletAddress
{
    if (!_walletAddress) {
        _walletAddress = [[UILabel alloc] init];
        _walletAddress.textColor = TITLE_COLOR;
        _walletAddress.font = FONT(15);
        _walletAddress.numberOfLines = 0;
    }
    return _walletAddress;
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
        _QRCodeTitle.textColor = PLACEHOLDER_COLOR;
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
