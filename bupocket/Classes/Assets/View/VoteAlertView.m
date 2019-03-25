//
//  VoteAlertView.m
//  bupocket
//
//  Created by huoss on 2019/3/25.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "VoteAlertView.h"

@interface VoteAlertView ()

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * amount;

@property (nonatomic, strong) UIView * infoBg;
@property (nonatomic, strong) NSArray * infoTitleArray;
@property (nonatomic, strong) UIButton * confirm;


@end

@implementation VoteAlertView

- (instancetype)initWithText:(NSString *)text confrimBolck:(void (^)(void))confrimBlock cancelBlock:(void (^)(void))cancelBlock
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
    self.layer.cornerRadius = MAIN_CORNER;
    
    [self addSubview:self.title];
    
    [self addSubview:self.closeBtn];

    [self addSubview:self.amount];
    
    [self addSubview:self.infoBg];

    [self addSubview:self.confirm];
    
    
    NSArray * infoArray = @[@"向谷神668(buQk4h9Ygc5QSyDWCxgps6ZH)投票6894票", @"bujslk3i3kkdkladkl8dfkdfk3kl3kl3ldsjf", @"buQsD6rqLk7L75EtzqUGkr1Hme8GmAZ15XZV (投票合约账户)", @"0.001675"];
    CGFloat infoLabelTotalH = 0;
    for (UILabel * infoLabel in self.infoBg.subviews) {
        NSString * str = [NSString stringWithFormat:@"%@\n%@", self.infoTitleArray[infoLabel.tag], infoArray[infoLabel.tag]];
        infoLabel.attributedText = [Encapsulation attrWithString:str preFont:FONT(13) preColor:COLOR_9 index:[self.infoTitleArray[infoLabel.tag] length] sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:7];
        CGFloat infoLabelH = Margin_20 + [Encapsulation getSizeSpaceLabelWithStr:infoArray[infoLabel.tag] font:FONT(14) width:DEVICE_WIDTH - Margin_40 height:0 lineSpacing:7].height;
//        CGFloat infoLabelH = Margin_30 + [Encapsulation rectWithText:infoArray[infoLabel.tag] font:FONT(14) textWidth:DEVICE_WIDTH - Margin_40].size.height;
        infoLabel.frame = CGRectMake(0, infoLabelTotalH, DEVICE_WIDTH - Margin_40, infoLabelH);
//        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.infoBg);
//            make.top.mas_equalTo(infoLabelTotalH);
//            make.height.mas_equalTo(infoLabelH);
//        }];
        infoLabelTotalH = infoLabelTotalH + infoLabelH ;
    }
    _infoBg.frame = CGRectMake(Margin_20, ScreenScale(120), DEVICE_WIDTH - Margin_40, infoLabelTotalH);
    [UIView setViewBorder:_infoBg color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeBottom];
    CGFloat H = infoLabelTotalH + ScreenScale(210);
    self.frame = CGRectMake(0, DEVICE_HEIGHT - H, DEVICE_WIDTH, H);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Margin_50, ScreenScale(55)));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left).offset(Margin_20);
        make.height.mas_equalTo(Margin_50);
        make.right.mas_lessThanOrEqualTo(self.closeBtn.mas_left).offset(-Margin_10);
    }];

    
    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.left.equalTo(self.title);
        make.right.equalTo(self.mas_right).offset(-Margin_20);
        make.height.mas_equalTo(ScreenScale(70));
    }];
    
    
//    [self.infoBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.amount.mas_bottom);
//        make.left.right.equalTo(self.amount);
//        make.bottom.equalTo(self.mas_bottom).offset(-ScreenScale(90));
//    }];

    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_25);
        make.left.right.equalTo(self.amount);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = Localized(@"ConfirmationTurnOut");
        _title.textColor = COLOR_6;
        _title.font = FONT(16);
    }
    return _title;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton createButtonWithNormalImage:@"close" SelectedImage:@"close" Target:self Selector:@selector(cancleBtnClick)];
    }
    return _closeBtn;
}
- (UILabel *)amount
{
    if (!_amount) {
        _amount = [[UILabel alloc] init];
        NSString * str = [NSString stringWithFormat:@"%@ BU", @"123456"];
        _amount.attributedText = [Encapsulation attrWithString:str preFont:FONT_Bold(32) preColor:TITLE_COLOR index:str.length - 2 sufFont:FONT(16) sufColor:COLOR(@"151515") lineSpacing:0];
    }
    return _amount;
}

- (UIView *)infoBg
{
    if (!_infoBg) {
        _infoBg = [[UIView alloc] init];
        _infoTitleArray = @[Localized(@"TransactionDetail"), Localized(@"OriginatorAdress"), Localized(@"RecipientAddress"), Localized(@"MaximumTransactionCosts")];
        for (NSInteger i = 0; i < _infoTitleArray.count; i++) {
            UILabel * infoLabel = [[UILabel alloc] init];
            infoLabel.tag = i;
            infoLabel.numberOfLines = 0;
            [_infoBg addSubview:infoLabel];
        }
    }
    return _infoBg;
}
- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
        _confirm.backgroundColor = MAIN_COLOR;
        [_confirm setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT) borderRadius:MAIN_CORNER corners:UIRectCornerAllCorners];    }
    return _confirm;
}

- (void)cancleBtnClick {
    [self hideView];
    if (_cancleBlock) {
        _cancleBlock();
    }
}
- (void)sureBtnClick {
    [self hideView];
    if (self.sureBlock) {
        self.sureBlock();
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
