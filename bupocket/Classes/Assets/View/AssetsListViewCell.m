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
        make.width.height.mas_equalTo(Margin_40);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.contentView);
    }];
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.top.equalTo(self.listImage);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.detailTitle);
        make.bottom.equalTo(self.listImage);
    }];
    [self setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(75)) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
}
- (void)setListModel:(AssetsListModel *)listModel
{
    _listModel = listModel;
    [self.listImage sd_setImageWithURL:[NSURL URLWithString:listModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.title.text = listModel.assetCode;
    //    cell.listImage.image = [UIImage imageNamed:self.listArray[indexPath.section]];
    //    cell.title.text = self.listArray[indexPath.section];
    self.detailTitle.text = listModel.amount;
    
    NSString * currencyUnit = [AssetCurrencyModel getCurrencyUnitWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
    self.infoTitle.text = [listModel.assetAmount isEqualToString:@"~"] ? listModel.assetAmount : [NSString stringWithFormat:@"≈%@%@", currencyUnit, listModel.assetAmount];
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        [_listImage setViewSize:CGSizeMake(Margin_40, Margin_40) borderWidth:LINE_WIDTH borderColor:LINE_COLOR borderRadius:Margin_20];
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
        _detailTitle.font = FONT(16);
        _detailTitle.textColor = TITLE_COLOR;
    }
    return _detailTitle;
}
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = TITLE_FONT;
        _infoTitle.textColor = COLOR_9;
    }
    return _infoTitle;
}
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = Margin_10;
    frame.size.width -= Margin_20;
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
