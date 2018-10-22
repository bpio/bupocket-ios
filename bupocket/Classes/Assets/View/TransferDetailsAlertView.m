//
//  TransferDetailsAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TransferDetailsAlertView.h"

@interface TransferDetailsAlertView ()

@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * confirmationOfTransfer;
@property (nonatomic, strong) UILabel * transferPrompt;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * submission;

//@property (nonatomic, strong) UILabel * ReciprocalAccount;
//@property (nonatomic, strong) UILabel * account;
//@property (nonatomic, strong) UILabel * amountOfTransfer;
//@property (nonatomic, strong) UILabel * amount;
//@property (nonatomic, strong) UILabel * estimatedMaximum;

@end

@implementation TransferDetailsAlertView

//- (instancetype)initWithReciprocalAccount:(NSString *)reciprocalAccount amountOfTransfer:(NSString *)amountOfTransfer estimatedMaximum:(NSString *)estimatedMaximum remarks:(NSString *)remarks confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
- (instancetype)initWithConfrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.closeBtn];
    [self addSubview:self.confirmationOfTransfer];
    [self addSubview:self.transferPrompt];
    [self addSubview:self.lineView];
    NSArray * array = @[@[Localized(@"reciprocalAccount"), Localized(@"amountOfTransfer"), Localized(@"estimatedMaximum"), Localized(@"Remarks")], @[@"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"100 BU", @"0.01 BU", @"转账"]];
    //    NSArray * array = @[@[@"对方账户（BU地址） *", @"转账数量（BU） *", @"备注 ", @"预估最多支付费用（BU) *"], @[@"请输入手机号/接收方地址", @"单笔不可超过10000 BU", @"请输入备注", @"请输交易费用"]];
    for (NSInteger i = 0; i < [[array firstObject] count]; i ++) {
        [self setUpTransferInfoWithTitle:array[0][i] info:array[1][i] index:i];
    }
    [self addSubview:self.submission];
    
    //    CGFloat height = [Encapsulation rectWithText:Localized(@"PurseCipherPrompt") fontSize:15 textWidth:DEVICE_WIDTH - ScreenScale(110)].size.height + ScreenScale(255);
    self.frame = CGRectMake(0, DEVICE_HEIGHT - ScreenScale(440) - SafeAreaBottomH, DEVICE_WIDTH, ScreenScale(440));
}

- (void)setUpTransferInfoWithTitle:(NSString *)title info:(NSString *)info index:(NSInteger)index
{
    UILabel * infoLabel = [[UILabel alloc] init];
    infoLabel.font = FONT(15);
    infoLabel.textColor = COLOR(@"666666");
    infoLabel.text = info;
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:infoLabel];
    infoLabel.preferredMaxLayoutWidth = ScreenScale(205);
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(245) + ScreenScale(40) * index);
        make.right.equalTo(self.mas_right).offset(-ScreenScale(22));
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(15);
    titleLabel.textColor = COLOR(@"999999");
    titleLabel.text = title;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoLabel);
        make.left.equalTo(self.mas_left).offset(ScreenScale(22));
    }];
    
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
    
    [self.confirmationOfTransfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(35));
        make.centerX.equalTo(self);
    }];
    
    [self.transferPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmationOfTransfer.mas_bottom).offset(ScreenScale(18));
        make.left.equalTo(self.mas_left).offset(ScreenScale(15));
        make.right.equalTo(self.mas_right).offset(-ScreenScale(15));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.transferPrompt);
        make.top.equalTo(self.transferPrompt.mas_bottom).offset(ScreenScale(30));
        //        make.height.mas_equalTo(ScreenScale(1.5));
    }];
    
    [self.submission mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(- SafeAreaBottomH - ScreenScale(30));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - ScreenScale(40), MAIN_HEIGHT));
    }];
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton createButtonWithNormalImage:@"close" SelectedImage:@"close" Target:self Selector:@selector(cancleBtnClick)];
    }
    return _closeBtn;
}
- (UILabel *)confirmationOfTransfer
{
    if (!_confirmationOfTransfer) {
        _confirmationOfTransfer = [[UILabel alloc] init];
        _confirmationOfTransfer.textColor = TITLE_COLOR;
        _confirmationOfTransfer.font = FONT(27);
        _confirmationOfTransfer.text = Localized(@"ConfirmationOfTransfer");
    }
    return _confirmationOfTransfer;
}
- (UILabel *)transferPrompt
{
    if (!_transferPrompt) {
        _transferPrompt = [[UILabel alloc] init];
        _transferPrompt.textColor = COLOR(@"666666");
        _transferPrompt.font = FONT(14);
        _transferPrompt.numberOfLines = 0;
        _transferPrompt.text = Localized(@"TransferPrompt");
        _transferPrompt.textAlignment = NSTextAlignmentCenter;
    }
    return _transferPrompt;
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
- (UIButton *)submission
{
    if (!_submission) {
        _submission = [UIButton createButtonWithTitle:Localized(@"Submission") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(submissionClick)];
        [_submission setViewSize:CGSizeMake(DEVICE_WIDTH - ScreenScale(40), MAIN_HEIGHT) borderWidth:0 borderColor:nil borderRadius:ScreenScale(4)];
        _submission.backgroundColor = MAIN_COLOR;
    }
    return _submission;
}


- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)submissionClick {
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
