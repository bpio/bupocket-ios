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
        make.left.equalTo(self.contentView.mas_left).offset(ScreenScale(10));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(ScreenScale(40));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImage.mas_right).offset(ScreenScale(10));
        make.centerY.equalTo(self.contentView);
    }];
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-ScreenScale(10));
        make.top.equalTo(self.listImage);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.detailTitle);
        make.bottom.equalTo(self.listImage);
    }];
    [self setViewSize:CGSizeMake(DEVICE_WIDTH - ScreenScale(20), ScreenScale(75)) borderWidth:0 borderColor:nil borderRadius:ScreenScale(5)];
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
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
        _infoTitle.font = FONT(14);
        _infoTitle.textColor = COLOR(@"999999");
    }
    return _infoTitle;
}
- (void)setFrame:(CGRect)frame
{
    CGFloat margin = ScreenScale(5);
    frame.origin.x = margin * 2;
    frame.size.width -= margin * 4;
    frame.origin.y += margin;
    frame.size.height -= margin * 2;
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
