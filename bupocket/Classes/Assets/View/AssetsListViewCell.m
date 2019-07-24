//
//  AssetsListViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AssetsListViewCell.h"

@implementation AssetsListViewCell

static NSString * const AssetsCellID = @"AssetsCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    AssetsListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AssetsCellID];
    if (cell == nil) {
        cell = [[AssetsListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AssetsCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.listImageBg];
        [self.contentView addSubview:self.listImage];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detailTitle];
        [self.contentView addSubview:self.infoTitle];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(Margin_50);
    }];
    [self.listImageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.listImage);
        make.width.height.mas_equalTo(ScreenScale(68));
    }];
    [self.title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.contentView);
        make.right.mas_lessThanOrEqualTo(self.detailTitle.mas_left).offset(-Margin_10);
    }];
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.top.equalTo(self.listImage);
//        make.top.equalTo(self.contentView.mas_top).offset(Margin_20);
        make.left.mas_greaterThanOrEqualTo(self.title.mas_right).offset(Margin_10);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.detailTitle);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_20);
        make.bottom.equalTo(self.listImage);
        make.left.mas_greaterThanOrEqualTo(self.title.mas_right).offset(Margin_10);
    }];
    [self setViewSize:CGSizeMake(View_Width_Main, ScreenScale(80)) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
}
- (void)setListModel:(AssetsListModel *)listModel
{
    _listModel = listModel;
    [self.listImage sd_setImageWithURL:[NSURL URLWithString:listModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder_list"]];
    self.title.text = listModel.assetCode;
    self.detailTitle.text = listModel.amount;
    NSString * currencyUnit = [AssetCurrencyModel getCurrencyUnitWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
    self.infoTitle.text = [listModel.assetAmount isEqualToString:@"~"] ? listModel.assetAmount : [NSString stringWithFormat:@"≈%@%@", currencyUnit, listModel.assetAmount];
}
- (UIImageView *)listImageBg
{
    if (!_listImageBg) {
        _listImageBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_bg_list"]];
    }
    return _listImageBg;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        [_listImage setViewSize:CGSizeMake(Margin_50, Margin_50) borderWidth:0 borderColor:nil borderRadius:Margin_25];
    }
    return _listImage;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(18);
        _title.textColor = TITLE_COLOR;
    }
    return _title;
}
- (UILabel *)detailTitle
{
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.font = FONT_Bold(18);
        _detailTitle.textColor = TITLE_COLOR;
    }
    return _detailTitle;
}
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = FONT_TITLE;
        _infoTitle.textColor = COLOR_9;
    }
    return _infoTitle;
}
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = Margin_Main;
    frame.size.width -= Margin_30;
    frame.origin.y += Margin_5;
    frame.size.height -= Margin_10;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
