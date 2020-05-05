//
//  ModifyIconAlertView.m
//  bupocket
//
//  Created by bupocket on 2019/6/25.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "ModifyIconAlertView.h"
#import "ModifyIconCollectionViewCell.h"

@interface ModifyIconAlertView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * confirm;
@property (nonatomic, strong) UICollectionView * collectView;

@end

static NSString * const ModifyIconCellID = @"ModifyIconCellID";

@implementation ModifyIconAlertView

- (instancetype)initWithTitle:(NSString *)title confrimBolck:(void (^)(NSInteger index))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        self.titleLabel.text = title;
        self.bounds = CGRectMake(0, 0, Alert_Width, ScreenScale(135) + self.collectView.size.height);
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = WHITE_BG_COLOR;
    self.layer.cornerRadius = BG_CORNER;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Margin_20);
        make.centerX.equalTo(self);
    }];
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:Alert_Button_Font TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:self Selector:@selector(cancleBtnClick)];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH / 2 - Margin_30, ScreenScale(55)));
    }];
    
    [self addSubview:self.confirm];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.bottom.equalTo(cancel);
        make.right.equalTo(self);
    }];
    UIView * verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = LINE_COLOR;
    [self addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(cancel);
        make.size.mas_equalTo(CGSizeMake(LINE_WIDTH, Margin_20));
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cancel.mas_top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    [self setupCollectionView];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin_20);
        make.left.equalTo(self.mas_left).offset(Margin_10);
        make.right.equalTo(self.mas_right).offset(-Margin_10);
        make.bottom.equalTo(line.mas_top).offset(-Margin_15);
    }];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = Margin_5;
    layout.minimumInteritemSpacing = 0.5;
//    layout.headerReferenceSize = CGSizeMake(DEVICE_WIDTH, MAIN_HEIGHT);
    layout.sectionInset = UIEdgeInsetsMake(Margin_5, Margin_5, 0, 0);
    CGFloat itemW = (DEVICE_WIDTH - ScreenScale(130)) / 5;
    layout.itemSize = CGSizeMake(itemW, itemW);
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(90), itemW * 2 + Margin_15) collectionViewLayout:layout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.backgroundColor = WHITE_BG_COLOR;
    [_collectView registerClass:[ModifyIconCollectionViewCell class] forCellWithReuseIdentifier:ModifyIconCellID];
    [self addSubview:_collectView];
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_Bold(18);
        _titleLabel.textColor = TITLE_COLOR;
    }
    return _titleLabel;
}

- (UIButton *)confirm
{
    if (!_confirm) {
        _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:Alert_Button_Font TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(sureBtnClick)];
    }
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
    if (_sureBlock) {
        _sureBlock(self.index);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ModifyIconCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ModifyIconCellID forIndexPath:indexPath];
    NSString * walletIconName = (indexPath.row == 0) ? Current_Wallet_IconName : [NSString stringWithFormat:@"%@_%zd", Current_Wallet_IconName, indexPath.row];
    cell.icon.image = [UIImage imageNamed:walletIconName];
    cell.selectBtn.hidden = (indexPath.row != self.index);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.index = indexPath.row;
    [self.collectView reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
