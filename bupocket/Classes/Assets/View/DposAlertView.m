//
//  DposAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/3/27.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "DposAlertView.h"

@interface DposAlertView ()

@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UIScrollView * infoScrollView;
@property (nonatomic, strong) UIView * infoBg;
@property (nonatomic, strong) NSArray * infoTitleArray;
@property (nonatomic, strong) UIButton * details;
@property (nonatomic, strong) UIButton * back;
@property (nonatomic, strong) UIButton * confirm;

@end

@implementation DposAlertView

- (instancetype)initWithDpos:(ApplyNodeModel *)applyNodeModel confrimBolck:(void (^)(void))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        _applyNodeModel = applyNodeModel;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(460));
    
    [self addSubview:self.bgScrollView];
    
    [self.bgScrollView addSubview:self.closeBtn];
    
    [self.bgScrollView addSubview:self.title];
    
    [self.bgScrollView addSubview:self.lineView];
    
    [self.bgScrollView addSubview:self.infoBg];
    
    [self.infoBg addSubview:self.infoScrollView];
    
    [self.bgScrollView addSubview:self.amount];
    
    [self.bgScrollView addSubview:self.details];

    [self.bgScrollView addSubview:self.back];
    
    [self addSubview:self.confirm];
    
    _infoTitleArray = @[Localized(@"TransactionDetail"), Localized(@"CounterAccount"), Localized(@"MaximumTransactionCosts"), Localized(@"Initiator"), Localized(@"CounterAccount"), Localized(@"Number"), Localized(@"TransactionCosts"), Localized(@"Parameter")];
    
    
//    NSArray * infoArray = @[@"转入质押金5000000BU", @"buQXVJXpMZaxUpfuNRzaGUreDK1r6zYTFcTW", TransactionCost_MIN, CurrentWalletAddress, @"buQXVJXpMZaxUpfuNRzaGUreDK1r6zYTFcTW", @"5000000 BU", TransactionCost_MIN, @"{\"method\":\"apply\",\"params\":{\"role\":\"validator\",\"node\":\"buQXVJXpMZaxUpfuNRzaGUreDK1r6zYTFcTW\"}}"];
    NSArray * infoArray = @[self.applyNodeModel.qrRemark, self.applyNodeModel.destAddress, TransactionCost_MIN, CurrentWalletAddress, self.applyNodeModel.destAddress, [NSString stringAppendingBUWithStr:self.applyNodeModel.amount], TransactionCost_MIN, self.applyNodeModel.script];
    CGFloat infoLabelTotalH = 0;
    for (NSInteger i = 0; i < _infoTitleArray.count * 2; i++) {
        UILabel * infoLabel = [[UILabel alloc] init];
        infoLabel.tag = i;
        if (i < 6) {
            [self.infoBg addSubview:infoLabel];
        } else {
            [self.infoScrollView addSubview:infoLabel];
        }
        if (i % 2) {
            infoLabel.font = FONT(14);
            infoLabel.textColor = COLOR_6;
            infoLabel.text = infoArray[i / 2];
        } else {
            infoLabel.font = FONT(13);
            infoLabel.textColor = COLOR_9;
            infoLabel.text = self.infoTitleArray[i / 2];
        }
        CGFloat infoLabelX = 0;
        CGFloat infoLabelW = DEVICE_WIDTH - Margin_40;
        infoLabel.preferredMaxLayoutWidth = infoLabelW;
        infoLabel.numberOfLines = 0;
//        infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [infoLabel sizeToFit];
        CGFloat infoLabelH = ceil([Encapsulation rectWithText:infoLabel.text font:infoLabel.font textWidth:infoLabelW].size.height) + 1;
        if (i == 0) {
            infoLabelTotalH = self.amount.height;
        } else if (i == 6) {
            infoLabelTotalH = Margin_15;
        } else if (i % 2) {
            infoLabelTotalH += Margin_5;
        } else {
            infoLabelTotalH += Margin_15;
        }
//        infoLabel.frame = CGRectMake(infoLabelX, infoLabelTotalH, DEVICE_WIDTH - Margin_40, infoLabelH);
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(infoLabelX);
            make.top.mas_equalTo(infoLabelTotalH);
            make.size.mas_equalTo(CGSizeMake(infoLabelW, infoLabelH));
        }];
        infoLabelTotalH = infoLabelTotalH + infoLabelH;
    }
   
    infoLabelTotalH = infoLabelTotalH + Margin_15;
    _infoScrollView.contentSize = CGSizeMake(0, infoLabelTotalH);
//    CGFloat maxH = MAX(infoLabelTotalH, detailTotalH);
//    self.infoBg.height = maxH;
//    _infoBg.frame = CGRectMake(Margin_20, ScreenScale(120), DEVICE_WIDTH - Margin_40, infoLabelTotalH);
//    [UIView setViewBorder:_infoBg color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeBottom];
//    CGFloat H = maxH + ScreenScale(140);
//    self.frame = CGRectMake(0, DEVICE_HEIGHT - H, DEVICE_WIDTH, H);
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(Margin_50, ScreenScale(55)));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(Margin_20);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - ScreenScale(70), Margin_50));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, LINE_WIDTH));
    }];
    
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.infoBg);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
        make.height.mas_equalTo(Margin_30);
    }];
    
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DEVICE_WIDTH + Margin_20);
        make.top.height.equalTo(self.title);
        make.width.mas_equalTo(Margin_50);
    }];
//    [self.amount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.title.mas_bottom);
//        make.left.width.equalTo(self.details);
//        make.height.mas_equalTo(ScreenScale(70));
//    }];
    
    [self.infoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom);
        make.left.equalTo(self.title);
        make.width.mas_equalTo(DEVICE_WIDTH * 2 - Margin_40);
        make.height.mas_equalTo(self.height - ScreenScale(140));
    }];
    [self.infoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DEVICE_WIDTH);
        make.width.equalTo(self.details);
        make.top.height.equalTo(self.infoBg);
    }];
    
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_25);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT));
    }];
}
- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(370))];
        _bgScrollView.contentSize = CGSizeMake(DEVICE_WIDTH * 2, 0);
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.scrollEnabled = NO;
    }
    return _bgScrollView;
}
- (UIScrollView *)infoScrollView
{
    if (!_infoScrollView) {
        _infoScrollView = [[UIScrollView alloc] init];
        _infoScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _infoScrollView;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = Localized(@"ConfirmTransaction");
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
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}

- (UILabel *)amount
{
    if (!_amount) {
        _amount = [[UILabel alloc] initWithFrame:CGRectMake(Margin_20, Margin_50, DEVICE_WIDTH - Margin_40, ScreenScale(70))];
        NSString * str = [NSString stringAppendingBUWithStr:self.applyNodeModel.amount];
        _amount.attributedText = [Encapsulation attrWithString:str preFont:FONT_Bold(32) preColor:TITLE_COLOR index:self.applyNodeModel.amount.length sufFont:FONT(16) sufColor:COLOR(@"151515") lineSpacing:0];
        _amount.textAlignment = NSTextAlignmentCenter;
        [UIView setViewBorder:_amount color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _amount;
}

- (UIView *)infoBg
{
    if (!_infoBg) {
        _infoBg = [[UIView alloc] init];
    }
    return _infoBg;
}
- (UIButton *)details
{
    if (!_details) {
        _details = [UIButton createButtonWithTitle:Localized(@"Details") TextFont:13 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(detailAction)];
        _details.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _details;
}
- (UIButton *)back
{
    if (!_back) {
        _back = [UIButton createButtonWithNormalImage:@"nav_goback_n" SelectedImage:@"nav_goback_n" Target:self Selector:@selector(backAction)];
        _back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _back;
}
- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
        _confirm.backgroundColor = MAIN_COLOR;
        [_confirm setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT) borderRadius:MAIN_CORNER corners:UIRectCornerAllCorners];
    }
    return _confirm;
}
- (void)detailAction
{
    [self.bgScrollView setContentOffset:CGPointMake(DEVICE_WIDTH, 0) animated:NO];
}
- (void)backAction
{
    [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
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
