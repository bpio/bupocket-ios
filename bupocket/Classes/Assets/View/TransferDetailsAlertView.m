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

@property (nonatomic, strong) UILabel * reciprocalAccountTitle;
@property (nonatomic, strong) UILabel * amountOfTransferTitle;
@property (nonatomic, strong) UILabel * estimatedMaximumTitle;
@property (nonatomic, strong) UILabel * remarksTitle;
@property (nonatomic, strong) UILabel * reciprocalAccount;
@property (nonatomic, strong) UILabel * amountOfTransfer;
@property (nonatomic, strong) UILabel * estimatedMaximum;
@property (nonatomic, strong) UILabel * remarks;

@end

@implementation TransferDetailsAlertView

- (instancetype)initWithTransferInfoArray:(NSArray *)transferInfoArray confrimBolck:(nonnull void (^)(void))confrimBlock cancelBlock:(nonnull void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        _transferInfoArray = @[@[Localized(@"ReceivingAccount"), Localized(@"Value"), Localized(@"estimatedMaximum"), Localized(@"Remarks")], transferInfoArray];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = WHITE_BG_COLOR;
    [self addSubview:self.closeBtn];
    [self addSubview:self.confirmationOfTransfer];
    [self addSubview:self.transferPrompt];
    [self addSubview:self.lineView];
    [self addSubview:self.submission];
    for (NSInteger i = 0; i < [[_transferInfoArray firstObject] count]; i ++) {
        [self setUpTransferInfoWithIndex:i];
    }
}

- (void)setUpTransferInfoWithIndex:(NSInteger)index
{
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(15);
    titleLabel.textColor = COLOR_9;
    titleLabel.text = _transferInfoArray[0][index];
    [self addSubview:titleLabel];
    
    UILabel * infoLabel = [[UILabel alloc] init];
    infoLabel.font = FONT(15);
    infoLabel.textColor = COLOR_6;
    infoLabel.text = ([_transferInfoArray[1] count] - 1 < index) ? @"" : _transferInfoArray[1][index];
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:infoLabel];
    if ([titleLabel.text isEqualToString:Localized(@"ReceivingAccount")]) {
        infoLabel.copyable = YES;
    }
    switch (index) {
        case 0: {
            self.reciprocalAccountTitle = titleLabel;
            self.reciprocalAccount = infoLabel;
        }
            break;
        case 1:
        {
            self.amountOfTransferTitle = titleLabel;
            self.amountOfTransfer = infoLabel;
        }
            break;
        case 2:
        {
            self.estimatedMaximumTitle = titleLabel;
            self.estimatedMaximum = infoLabel;
        }
            break;
        case 3:
        {
            self.remarksTitle = titleLabel;
            self.remarks = infoLabel;
        }
            break;
        default:
            break;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.submission mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(- SafeAreaBottomH - Margin_30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT));
    }];
    
    [self.remarks mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.submission.mas_top).offset(-Margin_50);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
        make.left.mas_greaterThanOrEqualTo(self.remarksTitle.mas_right).offset(Margin_10);
        make.height.mas_greaterThanOrEqualTo(Margin_15);
    }];
    [self.remarksTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.remarksTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarks);
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.right.mas_lessThanOrEqualTo(self.remarks.mas_left).offset(-Margin_10);
    }];
    
    [self.estimatedMaximum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.remarks.mas_top).offset(-Margin_25);
        make.right.equalTo(self.remarks);
        make.left.mas_greaterThanOrEqualTo(self.estimatedMaximumTitle.mas_right).offset(Margin_10);
    }];
    [self.estimatedMaximumTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.estimatedMaximumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.estimatedMaximum);
        make.left.equalTo(self.remarksTitle);
        make.right.mas_lessThanOrEqualTo(self.estimatedMaximum.mas_left).offset(-Margin_10);
    }];
    
    [self.amountOfTransfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.estimatedMaximum.mas_top).offset(-Margin_25);
        make.right.equalTo(self.remarks);
        make.left.mas_greaterThanOrEqualTo(self.amountOfTransferTitle.mas_right).offset(Margin_10);
    }];
    [self.amountOfTransferTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.amountOfTransferTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountOfTransfer);
        make.left.equalTo(self.remarksTitle);
        make.right.mas_lessThanOrEqualTo(self.amountOfTransfer.mas_left).offset(-Margin_10);
    }];
    
    [self.reciprocalAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.amountOfTransfer.mas_top).offset(-Margin_25);
        make.right.equalTo(self.remarks);
        make.left.mas_greaterThanOrEqualTo(self.reciprocalAccountTitle.mas_right).offset(Margin_10);
    }];
    [self.reciprocalAccountTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.reciprocalAccountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reciprocalAccount);
        make.left.equalTo(self.remarksTitle);
        make.right.mas_lessThanOrEqualTo(self.reciprocalAccount.mas_left).offset(-Margin_10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
        make.bottom.equalTo(self.reciprocalAccount.mas_top).offset(-Margin_25);
    }];
    [self.transferPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.lineView.mas_top).offset(-Margin_30);
        make.left.right.equalTo(self.lineView);
    }];
    [self.confirmationOfTransfer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.transferPrompt.mas_top).offset(-ScreenScale(18));
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(ScreenScale(35));
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_HEIGHT, MAIN_HEIGHT));
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo([UIApplication sharedApplication].keyWindow);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom).offset(-SafeAreaBottomH);
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
        _transferPrompt.font = FONT_TITLE;
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
