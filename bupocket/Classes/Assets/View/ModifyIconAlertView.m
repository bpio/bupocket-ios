//
//  ModifyIconAlertView.m
//  bupocket
//
//  Created by huoss on 2019/6/25.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "ModifyIconAlertView.h"
#import "ModifyIconCollectionViewCell.h"

@interface ModifyIconAlertView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * confirm;
@property (strong, nonatomic) UICollectionView * collectView;

@end

static NSString * const ModifyIconCellID = @"ModifyIconCellID";

@implementation ModifyIconAlertView

- (instancetype)initWithTitle:(NSString *)title confrimBolck:(void (^)(NSString * text))confrimBlock cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        _sureBlock = confrimBlock;
        _cancleBlock = cancelBlock;
        [self setupView];
        self.titleLabel.text = title;
        
        self.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_40, ScreenScale(260));
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = MAIN_CORNER;
    
    [self addSubview:self.titleLabel];
    
    UIButton * cancel = [UIButton createButtonWithTitle:Localized(@"Cancel") TextFont:FONT_BUTTON TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:self Selector:@selector(cancleBtnClick)];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH / 2 - Margin_40, ScreenScale(55)));
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin_15);
        make.left.equalTo(self.mas_left).offset(Margin_10);
        make.right.equalTo(self.mas_right).offset(-Margin_10);
        make.bottom.equalTo(line.mas_top);
    }];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.minimumLineSpacing = 0.5;
    layout.minimumInteritemSpacing = 0.5;
//    layout.headerReferenceSize = CGSizeMake(DEVICE_WIDTH, MAIN_HEIGHT);
    layout.sectionInset = UIEdgeInsetsMake(Margin_5, Margin_5, 0, 0);
    CGFloat itemW = (DEVICE_WIDTH - ScreenScale(100)) / 5;
    layout.itemSize = CGSizeMake(itemW, itemW);
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(70), ScreenScale(135)) collectionViewLayout:layout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
//    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.backgroundColor = RandomColor;
    [_collectView registerClass:[ModifyIconCollectionViewCell class] forCellWithReuseIdentifier:ModifyIconCellID];
    [self addSubview:_collectView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Margin_30);
        make.centerX.equalTo(self);
    }];
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
        _confirm = [UIButton createButtonWithTitle:Localized(@"Confirm") TextFont:FONT_BUTTON TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(sureBtnClick)];
        _confirm.enabled = NO;
    }
    return _confirm;
}
- (void)textChange:(UITextField *)textField
{
    if (NotNULLString(textField.text)) {
        self.confirm.enabled = YES;
    } else {
        self.confirm.enabled = NO;
    }
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
//        _sureBlock();
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
    cell.contentView.backgroundColor = RandomColor;
    cell.icon.image = [UIImage imageNamed:@"wallet_list_placeholder"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DLog(@"点击索引：%zd", indexPath.row);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
