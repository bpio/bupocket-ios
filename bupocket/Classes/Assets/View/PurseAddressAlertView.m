//
//  PurseAddressAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "PurseAddressAlertView.h"

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
    
//    CGFloat height = [Encapsulation rectWithText:Localized(@"PurseCipherPrompt") fontSize:15 textWidth:DEVICE_WIDTH - ScreenScale(110)].size.height + ScreenScale(255);
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
        make.size.mas_equalTo(CGSizeMake(ScreenScale(45), 45));
    }];
    
    [self.purseAddressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(42));
        make.left.equalTo(self).offset(ScreenScale(20));
    }];
    
    [self.purseAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purseAddressTitle.mas_bottom).offset(ScreenScale(10));
        make.left.equalTo(self.mas_left).offset(ScreenScale(15));
        make.right.equalTo(self.mas_right).offset(-ScreenScale(15));
    }];
    
    [self.copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purseAddressTitle.mas_bottom).offset(ScreenScale(60));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(210), MAIN_HEIGHT));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.purseAddress);
        make.top.equalTo(self.copyBtn.mas_bottom).offset(ScreenScale(23));
        //        make.height.mas_equalTo(ScreenScale(1.5));
    }];
    
    [self.QRCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.copyBtn.mas_bottom).offset(MAIN_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(178), ScreenScale(178)));
    }];
    
    [self.QRCodeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.QRCodeImage.mas_bottom).offset(ScreenScale(10));
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
        _purseAddressTitle.textColor = COLOR(@"999999");
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
        _copyBtn = [UIButton createButtonWithTitle:Localized(@"DuplicateWalletAddress") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(copyClick)];
        [_copyBtn setViewSize:CGSizeMake(ScreenScale(210), MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:ScreenScale(4)];
        _copyBtn.backgroundColor = MAIN_COLOR;
    }
    return _copyBtn;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(30), ScreenScale(0.5));
        [_lineView drawDashLineLength:ScreenScale(3) lineSpacing:ScreenScale(1) lineColor:COLOR(@"E3E3E3")];
    }
    return _lineView;
}
- (UIImageView *)QRCodeImage
{
    if (!_QRCodeImage) {
        _QRCodeImage = [[UIImageView alloc] init];
        _QRCodeImage.image = [UIImage imageNamed:@"placeholder"];
        [_QRCodeImage setViewSize:CGSizeMake(ScreenScale(178), ScreenScale(178)) borderWidth:0.5 borderColor:MAIN_COLOR borderRadius:ScreenScale(4)];
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
