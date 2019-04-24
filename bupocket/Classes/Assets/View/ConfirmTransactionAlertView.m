//
//  ConfirmTransactionAlertView.m
//  bupocket
//
//  Created by huoss on 2019/3/30.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ConfirmTransactionAlertView.h"
//#import "NodeTransferSuccessViewController.h"
//#import "TransferResultsViewController.h"
//#import "RequestTimeoutViewController.h"

@interface ConfirmTransactionAlertView()

@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIScrollView * infoScrollView;
@property (nonatomic, strong) UIScrollView * transactionScrollView;
//@property (nonatomic, strong) UIView * infoBg;
@property (nonatomic, strong) NSArray * infoTitleArray;
@property (nonatomic, strong) UIButton * details;
@property (nonatomic, strong) UIButton * back;
@property (nonatomic, strong) UIButton * confirm;

@property (nonatomic, strong) NSString * transactionCost;
//@property (nonatomic, strong) NSMutableArray * transferInfoArray;
//@property (nonatomic, strong) PasswordAlertView * PWAlertView;

@end

@implementation ConfirmTransactionAlertView

- (instancetype)initWithDpos:(ConfirmTransactionModel *)confirmTransactionModel confrimBolck:(void (^)(NSString * transactionCost))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        _confirmTransactionModel = confirmTransactionModel;
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
    
    //    [self.bgScrollView addSubview:self.infoBg];
    [self.bgScrollView addSubview:self.transactionScrollView];
    
    [self.bgScrollView addSubview:self.infoScrollView];
    
    [self.bgScrollView addSubview:self.amount];
    
    [self.bgScrollView addSubview:self.details];
    
    [self.bgScrollView addSubview:self.back];
    
    [self addSubview:self.confirm];
    
    int transactionInfoCount = 6;
    NSArray * infoArray;
    self.transactionCost = TransactionCost_Check_MIN;
    if ([self.confirmTransactionModel.type isEqualToString:TransactionType_Cooperate]) {
        self.transactionCost = TransactionCost_Cooperate_MIN;
    }
    self.confirmTransactionModel.transactionCost = self.transactionCost;
    if (NULLString(self.confirmTransactionModel.destAddress)) {
        _infoTitleArray = @[Localized(@"TransactionDetail"), Localized(@"reciprocalAccount"), Localized(@"MaximumTransactionCosts"), Localized(@"Initiator"), Localized(@"reciprocalAccount"), Localized(@"Number（BU）"), Localized(@"TransactionCosts（BU）"), Localized(@"Parameter")];
        NSString * destAddress = [NSString stringWithFormat:@"%@%@", self.confirmTransactionModel.destAddress, self.confirmTransactionModel.accountTag];
        infoArray = @[self.confirmTransactionModel.qrRemark, destAddress, self.transactionCost, CurrentWalletAddress, destAddress, self.confirmTransactionModel.amount, self.transactionCost, self.confirmTransactionModel.script];
        
    } else {
        _infoTitleArray = @[Localized(@"TransactionDetail"), Localized(@"MaximumTransactionCosts"), Localized(@"Initiator"), Localized(@"Number（BU）"), Localized(@"TransactionCosts（BU）"), Localized(@"Parameter")];
        transactionInfoCount = 4;
        infoArray = @[self.confirmTransactionModel.qrRemark, self.transactionCost, CurrentWalletAddress, self.confirmTransactionModel.amount, self.transactionCost, self.confirmTransactionModel.script];
    }
    
    CGFloat infoLabelTotalH = 0;
    CGFloat transactionTotalH = 0;
    for (NSInteger i = 0; i < _infoTitleArray.count * 2; i++) {
        UILabel * infoLabel = [[UILabel alloc] init];
        infoLabel.tag = i;
        if (i < transactionInfoCount) {
            [self.transactionScrollView addSubview:infoLabel];
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
        CGFloat infoLabelX = Margin_20;
        CGFloat infoLabelW = DEVICE_WIDTH - Margin_40;
        infoLabel.preferredMaxLayoutWidth = infoLabelW;
        infoLabel.numberOfLines = 0;
        //        infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [infoLabel sizeToFit];
        CGFloat infoLabelH = ceil([Encapsulation rectWithText:infoLabel.text font:infoLabel.font textWidth:infoLabelW].size.height) + 1;
        if (i == 0 && [_confirmTransactionModel.type isEqualToString:TransactionType_ApplyNode]) {
            infoLabelTotalH = self.amount.height;
        } else if (i == transactionInfoCount) {
            transactionTotalH = infoLabelTotalH + Margin_50;
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
    _transactionScrollView.contentSize = CGSizeMake(0, transactionTotalH);
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
    
    //    [self.infoBg mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.title.mas_bottom);
    //        make.left.equalTo(self.title);
    //        make.width.mas_equalTo(DEVICE_WIDTH * 2 - Margin_40);
    //        make.height.mas_equalTo(self.height - ScreenScale(140));
    //    }];
    [self.transactionScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.title.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, self.height - ScreenScale(140)));
    }];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.transactionScrollView);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
        make.height.mas_equalTo(Margin_30);
    }];
    [self.infoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DEVICE_WIDTH);
        make.size.top.equalTo(self.transactionScrollView);
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
- (UIScrollView *)transactionScrollView
{
    if (!_transactionScrollView) {
        _transactionScrollView = [[UIScrollView alloc] init];
    }
    return _transactionScrollView;
}
- (UIScrollView *)infoScrollView
{
    if (!_infoScrollView) {
        _infoScrollView = [[UIScrollView alloc] init];
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
        if ([_confirmTransactionModel.type isEqualToString:TransactionType_ApplyNode]) {
            NSString * str = [NSString stringAppendingBUWithStr:_confirmTransactionModel.amount];
            _amount.attributedText = [Encapsulation attrWithString:str preFont:FONT_Bold(32) preColor:TITLE_COLOR index:self.confirmTransactionModel.amount.length sufFont:FONT(16) sufColor:COLOR(@"151515") lineSpacing:0];
            _amount.textAlignment = NSTextAlignmentCenter;
            [UIView setViewBorder:_amount color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
        }
    }
    return _amount;
}

//- (UIView *)infoBg
//{
//    if (!_infoBg) {
//        _infoBg = [[UIView alloc] init];
//    }
//    return _infoBg;
//}
- (UIButton *)details
{
    if (!_details) {
        _details = [UIButton createButtonWithTitle:Localized(@"Details") TextFont:13 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(detailAction)];
        _details.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _details.backgroundColor = [UIColor whiteColor];
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
    if (_sureBlock) {
        _sureBlock(self.transactionCost);
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
