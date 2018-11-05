//
//  AddAssetsViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AddAssetsViewCell.h"

@implementation AddAssetsViewCell

static NSString * const AddAssetsCellID = @"AddAssetsCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    AddAssetsViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AddAssetsCellID];
    if (cell == nil) {
        cell = [[AddAssetsViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AddAssetsCellID];
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
        [self.contentView addSubview:self.addBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_15);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_15);
        make.width.height.mas_equalTo(Margin_40);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Margin_20);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_15);
    }];
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.title);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailTitle.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.title);
    }];
    CGSize size = CGSizeMake(ScreenScale(52), Margin_25);
    [self.addBtn setViewSize:size borderWidth:0 borderColor:nil borderRadius:ScreenScale(2)];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-ScreenScale(22));
        make.size.mas_equalTo(size);
    }];
}
- (void)setSearchAssetsModel:(SearchAssetsModel *)searchAssetsModel
{
    _searchAssetsModel = searchAssetsModel;
    [_listImage sd_setImageWithURL:[NSURL URLWithString:searchAssetsModel.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _title.text = searchAssetsModel.assetCode;
    _detailTitle.text = searchAssetsModel.assetName;
    _infoTitle.text = searchAssetsModel.issuer;
    _addBtn.hidden = searchAssetsModel.recommend;
}
//- (void)setListModel:(AssetsListModel *)listModel
//{
//    _listModel = listModel;
//    [self.listImage sd_setImageWithURL:[NSURL URLWithString:listModel.icon] placeholderImage:[UIImage imageNamed:@"BU"]];
//    self.title.text = listModel.assetCode;
//    //    cell.listImage.image = [UIImage imageNamed:self.listArray[indexPath.section]];
//    //    cell.title.text = self.listArray[indexPath.section];
//    self.detailTitle.text = listModel.amount;
//    self.infoTitle.text = [listModel.assetAmount isEqualToString:@"~"] ? listModel.assetAmount : [NSString stringWithFormat:@"≈￥%@", listModel.assetAmount];
//}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        _listImage.image = [UIImage imageNamed:@"placeholder"];
    }
    return _listImage;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(18);
        _title.textColor = TITLE_COLOR;
        _title.preferredMaxLayoutWidth = DEVICE_WIDTH - ScreenScale(80);
    }
    return _title;
}
- (UILabel *)detailTitle
{
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.font = FONT(16);
        _detailTitle.textColor = TITLE_COLOR;
        _detailTitle.preferredMaxLayoutWidth = _title.preferredMaxLayoutWidth;
    }
    return _detailTitle;
}
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = TITLE_FONT;
        _infoTitle.textColor = COLOR_9;
        _infoTitle.preferredMaxLayoutWidth = _title.preferredMaxLayoutWidth;
    }
    return _infoTitle;
}
- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton createButtonWithTitle:Localized(@"Add") TextFont:14 TextColor:[UIColor whiteColor] Target:self Selector:@selector(addAction:)];
        [_addBtn setTitle:Localized(@"Delete") forState:UIControlStateSelected];
//        [_addBtn setImage:[UIImage imageNamed:@"alreadyAdded"] forState:UIControlStateDisabled];
        _addBtn.backgroundColor = MAIN_COLOR;
    }
    return _addBtn;
}
- (void)addAction:(UIButton *)button
{
    button.selected = !button.selected;
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
