//
//  MyListViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ListTableViewCell.h"

static NSString * const ListCellID = @"ListCellID";
static NSString * const SettingCellID = @"SettingCellID";
static NSString * const MonetaryUnitCellID = @"MonetaryUnitCellID";

@implementation ListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.listBg];
        [self.listBg addSubview:self.listImage];
        [self.listBg addSubview:self.title];
        [self.listBg addSubview:self.detailTitle];
        [self.listBg addSubview:self.detailImage];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    if ([self.reuseIdentifier isEqualToString:MonetaryUnitCellID]) {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listBg.mas_left).offset(Margin_20);
            make.top.height.equalTo(self.listBg);
        }];
    } else {
        [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_20);
            make.centerY.equalTo(self.listBg);
            make.width.height.mas_equalTo(Margin_20);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
            make.top.height.equalTo(self.listBg);
        }];
    }
    [self.detailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.listBg.mas_right).offset(-Margin_20);
        make.centerY.equalTo(self.listBg);
    }];
    if ([self.reuseIdentifier isEqualToString:SettingCellID]) {
        [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.detailImage.mas_left).offset(-Margin_10);
        }];
    } else {
        [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.listBg.mas_right).offset(-Margin_20);
        }];
    }
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listBg);
    }];
}
- (UIView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIView alloc] init];
        _listBg.backgroundColor = [UIColor whiteColor];
    }
    return _listBg;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        _listImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _listImage;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(15);
        _title.textColor = COLOR_6;
    }
    return _title;
}
- (UILabel *)detailTitle
{
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.font = FONT(15);
        _detailTitle.textColor = COLOR_9;
    }
    return _detailTitle;
}
- (UIImageView *)detailImage
{
    if (!_detailImage) {
        _detailImage = [[UIImageView alloc] init];
    }
    return _detailImage;
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
