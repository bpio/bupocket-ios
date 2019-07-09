//
//  BottomConfirmAlertView.m
//  bupocket
//
//  Created by huoss on 2019/7/4.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BottomConfirmAlertView.h"
#import "DetailListViewCell.h"

@interface BottomConfirmAlertView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, strong) UILabel * amount;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UITableView * infoTableView;
@property (nonatomic, strong) UITableView * detailTableView;
//@property (nonatomic, strong) UIScrollView * infoScrollView;
//@property (nonatomic, strong) UIScrollView * transactionScrollView;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) UIButton * details;
@property (nonatomic, strong) UIButton * back;
@property (nonatomic, strong) UIButton * confirm;
@property (nonatomic, strong) NSString * transactionCost;

@property (nonatomic, assign) BOOL isShowValue;

@end

@implementation BottomConfirmAlertView

- (instancetype)initWithIsShowValue:(BOOL)isShowValue confrimBolck:(void (^)(NSString * transactionCost))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        _isShowValue = isShowValue;
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
    
    [self.bgScrollView addSubview:self.infoTableView];
    
    [self.bgScrollView addSubview:self.detailTableView];
    
    
    if (_isShowValue) {
        self.infoTableView.tableHeaderView = self.amount;
    }
    
    [self.bgScrollView addSubview:self.details];
    
    [self.bgScrollView addSubview:self.back];
    
    [self addSubview:self.confirm];
    
    [self.bgScrollView addSubview:self.line];
    _titleArray = @[@[Localized(@"TransactionDetail"), Localized(@"ReceivingAccount"), Localized(@"TransferQuantity"), Localized(@"TransactionCosts（BU）"), Localized(@"Remarks")], @[Localized(@"SendingAccount"), Localized(@"ReceivingAccount"), Localized(@"TransferQuantity"), Localized(@"TransactionCosts（BU）"), Localized(@"Parameter")]];
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
        make.bottom.equalTo(self.title.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, LINE_WIDTH));
    }];
    
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DEVICE_WIDTH + Margin_20);
        make.top.height.equalTo(self.title);
        make.width.mas_equalTo(Margin_50);
    }];
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.title.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, self.height - ScreenScale(140)));
    }];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.infoTableView);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
        make.height.mas_equalTo(Margin_30);
    }];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(DEVICE_WIDTH);
        make.size.top.equalTo(self.infoTableView);
    }];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-Margin_25);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.confirm.mas_top).offset(-Margin_20);
        make.size.centerX.equalTo(self.lineView);
    }];
}
/*
- (void)setConfirmTransactionModel:(ConfirmTransactionModel *)confirmTransactionModel
{
    _confirmTransactionModel = confirmTransactionModel;
    int transactionInfoCount = 6;
    NSArray * infoArray;
    self.transactionCost = TransactionCost_Check_MIN;
    if ([self.confirmTransactionModel.type integerValue] == TransactionTypeCooperate) {
        self.transactionCost = TransactionCost_Cooperate_MIN;
    }
    self.confirmTransactionModel.transactionCost = self.transactionCost;
    NSString * qrRemark = self.confirmTransactionModel.qrRemark;
    NSString * accountTag = self.confirmTransactionModel.accountTag;
    if ([CurrentAppLanguage isEqualToString:EN]) {
        if (self.confirmTransactionModel.qrRemarkEn) {
            qrRemark = self.confirmTransactionModel.qrRemarkEn;
        }
        if (self.confirmTransactionModel.accountTagEn) {
            accountTag = self.confirmTransactionModel.accountTagEn;
        }
    }
    if (NotNULLString(self.confirmTransactionModel.destAddress)) {
        _infoTitleArray = @[Localized(@"TransactionDetail"), Localized(@"ReceivingAccount"), Localized(@"MaximumTransactionCosts"), Localized(@"SendingAccount"), Localized(@"ReceivingAccount"), Localized(@"Number（BU）"), Localized(@"TransactionCosts（BU）"), Localized(@"Parameter")];
        NSString * destAddress;
        if (NotNULLString(accountTag)) {
            destAddress = [NSString stringWithFormat:@"%@%@", self.confirmTransactionModel.destAddress, accountTag];
        } else {
            destAddress = self.confirmTransactionModel.destAddress;
        }
        infoArray = @[qrRemark, destAddress, self.transactionCost, CurrentWalletAddress, destAddress, self.confirmTransactionModel.amount, self.transactionCost, self.confirmTransactionModel.script];
        
    } else {
        _infoTitleArray = @[Localized(@"TransactionDetail"), Localized(@"MaximumTransactionCosts"), Localized(@"SendingAccount"), Localized(@"Number（BU）"), Localized(@"TransactionCosts（BU）"), Localized(@"Parameter")];
        transactionInfoCount = 4;
        infoArray = @[qrRemark, self.transactionCost, CurrentWalletAddress, self.confirmTransactionModel.amount, self.transactionCost, self.confirmTransactionModel.script];
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
        [infoLabel sizeToFit];
        CGFloat infoLabelH = ceil([Encapsulation rectWithText:infoLabel.text font:infoLabel.font textWidth:infoLabelW].size.height) + 1;
        if (i == 0 && [_confirmTransactionModel.type integerValue] == TransactionTypeApplyNode) {
            infoLabelTotalH = self.amount.height;
        } else if (i == transactionInfoCount) {
            transactionTotalH = infoLabelTotalH + Margin_50;
            infoLabelTotalH = Margin_15;
        } else if (i % 2) {
            infoLabelTotalH += Margin_5;
        } else {
            infoLabelTotalH += Margin_15;
        }
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
}
- (void)setDposModel:(DposModel *)dposModel
{
    _dposModel = dposModel;
    int transactionInfoCount = 6;
    NSArray * infoArray;
    self.transactionCost = dposModel.tx_fee;
    NSString * destAddress = dposModel.dest_address;
    _infoTitleArray = @[Localized(@"TransactionDetail"), Localized(@"ReceivingAccount"), Localized(@"MaximumTransactionCosts"), Localized(@"SendingAccount"), Localized(@"ReceivingAccount"), Localized(@"Number（BU）"), Localized(@"TransactionCosts（BU）"), Localized(@"Parameter")];
    infoArray = @[Localized(@"DposContract"), destAddress, self.transactionCost, CurrentWalletAddress, destAddress, dposModel.amount, self.transactionCost, dposModel.input];
    
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
        [infoLabel sizeToFit];
        CGFloat infoLabelH = ceil([Encapsulation rectWithText:infoLabel.text font:infoLabel.font textWidth:infoLabelW].size.height) + 1;
        if (i == 0 && [_confirmTransactionModel.type integerValue] == TransactionTypeApplyNode) {
            infoLabelTotalH = self.amount.height;
        } else if (i == transactionInfoCount) {
            transactionTotalH = infoLabelTotalH + Margin_50;
            infoLabelTotalH = Margin_15;
        } else if (i % 2) {
            infoLabelTotalH += Margin_5;
        } else {
            infoLabelTotalH += Margin_15;
        }
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
}
 */
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
- (UITableView *)infoTableView
{
    if (!_infoTableView) {
        _infoTableView = [self setupTableView];
    }
    return _infoTableView;
}
- (UITableView *)detailTableView
{
    if (!_detailTableView) {
        _detailTableView = [self setupTableView];
    }
    return _detailTableView;
}

- (UITableView *)setupTableView
{
//    self.height - ScreenScale(140)
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(290)) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    return tableView;
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
- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = LINE_COLOR;
    }
    return _line;
}

- (UILabel *)amount
{
    if (!_amount) {
        _amount = [[UILabel alloc] initWithFrame:CGRectMake(Margin_20, Margin_50, DEVICE_WIDTH - Margin_40, ScreenScale(70))];
        if ([_confirmTransactionModel.type integerValue] == TransactionTypeApplyNode) {
            NSString * str = [NSString stringAppendingBUWithStr:_confirmTransactionModel.amount];
            _amount.attributedText = [Encapsulation attrWithString:str preFont:FONT_Bold(32) preColor:TITLE_COLOR index:self.confirmTransactionModel.amount.length sufFont:FONT(16) sufColor:COLOR(@"151515") lineSpacing:0];
            _amount.textAlignment = NSTextAlignmentCenter;
            [UIView setViewBorder:_amount color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
        }
    }
    return _amount;
}
- (UIButton *)details
{
    if (!_details) {
        _details = [UIButton createButtonWithTitle:Localized(@"Details") TextFont:FONT_13 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(detailAction)];
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
        _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:FONT_BUTTON TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:self Selector:@selector(sureBtnClick)];
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
        _sureBlock(self.confirmTransactionModel.transactionCost);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [self infoStringWithTableView:tableView indexPath:indexPath];
    CGFloat cellHeight = [Encapsulation getSizeSpaceLabelWithStr:str font:FONT_TITLE width:(DEVICE_WIDTH - Margin_40) height:CGFLOAT_MAX lineSpacing:Margin_10].height + ScreenScale(40);
    return cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.infoTableView) {
        return Margin_50;
    }
    return Margin_15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.infoTableView) {
        return [[self.titleArray firstObject] count];
    } else {
        return [[self.titleArray lastObject] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView cellType: DetailCellSubtitle];
    if (tableView == self.infoTableView) {
        cell.title.text = [self.titleArray firstObject][indexPath.row];
    } else if (tableView == self.detailTableView) {
        cell.title.text = [self.titleArray lastObject][indexPath.row];
    }
    cell.title.font = FONT(13);
    cell.title.textColor = COLOR_9;
    NSString * str = [self infoStringWithTableView:tableView indexPath:indexPath];
    cell.infoTitle.attributedText = [Encapsulation attrWithString:str preFont:FONT_TITLE preColor:COLOR_6 index:0 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:Margin_10];
    return cell;
}
- (NSString *)infoStringWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSString * str;
    if (indexPath.row == 1) {
        str = self.confirmTransactionModel.destAddress;
    } else if (indexPath.row == 2) {
        str = self.confirmTransactionModel.amount;
    } else if (indexPath.row == 3) {
        str = self.confirmTransactionModel.transactionCost;
    }
    if (tableView == self.infoTableView) {
        if (indexPath.row == 0) {
            str = self.confirmTransactionModel.transactionDetail;
        }  else if (indexPath.row == 4) {
            str = self.confirmTransactionModel.qrRemark;
        }
    } else {
        if (indexPath.row == 0) {
            str = CurrentWalletAddress;
        }  else if (indexPath.row == 4) {
            str = self.confirmTransactionModel.script;
        }
    }
    return str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end