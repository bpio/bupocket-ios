//
//  TransferDetailsAlertView.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TransferDetailsAlertView.h"

@interface TransferDetailsAlertView ()

@property (nonatomic, strong) NSArray * transferInfoArray;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * confirmationOfTransfer;
@property (nonatomic, strong) UILabel * transferPrompt;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * submission;

@end

@implementation TransferDetailsAlertView

- (instancetype)initWithTransferInfoArray:(NSArray *)transferInfoArray confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        _transferInfoArray = @[@[Localized(@"reciprocalAccount"), Localized(@"AmountOfTransfer"), Localized(@"estimatedMaximum"), Localized(@"Remarks")], transferInfoArray];
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
    for (NSInteger i = 0; i < [[_transferInfoArray firstObject] count]; i ++) {
        [self setUpTransferInfoWithIndex:i];
    }
    [self addSubview:self.submission];
    self.frame = CGRectMake(0, DEVICE_HEIGHT - ScreenScale(440) - SafeAreaBottomH, DEVICE_WIDTH, ScreenScale(440));
}

- (void)setUpTransferInfoWithIndex:(NSInteger)index
{
    UILabel * infoLabel = [[UILabel alloc] init];
    infoLabel.font = FONT(15);
    infoLabel.textColor = COLOR_6;
    infoLabel.text = ([_transferInfoArray[1] count] - 1 < index) ? @"" : _transferInfoArray[1][index];
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:infoLabel];
    infoLabel.preferredMaxLayoutWidth = ScreenScale(150);
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(245) + Margin_40 * index);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(15);
    titleLabel.textColor = COLOR_9;
    titleLabel.text = _transferInfoArray[0][index];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoLabel);
        make.left.equalTo(self.mas_left).offset(Margin_20);
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
        make.size.mas_equalTo(CGSizeMake(MAIN_HEIGHT, MAIN_HEIGHT));
    }];
    
    [self.confirmationOfTransfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScreenScale(35));
        make.centerX.equalTo(self);
    }];
    
    [self.transferPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmationOfTransfer.mas_bottom).offset(ScreenScale(18));
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.transferPrompt);
        make.top.equalTo(self.transferPrompt.mas_bottom).offset(Margin_30);
    }];
    
    [self.submission mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(- SafeAreaBottomH - Margin_30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT));
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
        _transferPrompt.textColor = COLOR_6;
        _transferPrompt.font = TITLE_FONT;
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
        _lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, LINE_WIDTH);
        [_lineView drawDashLine];
    }
    return _lineView;
}
- (UIButton *)submission
{
    if (!_submission) {
        _submission = [UIButton createButtonWithTitle:Localized(@"Submission") isEnabled:YES Target:self Selector:@selector(submissionClick)];
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
