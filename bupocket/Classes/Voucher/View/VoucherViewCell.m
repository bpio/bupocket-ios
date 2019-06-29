//
//  VoucherViewCell.m
//  bupocket
//
//  Created by huoss on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherViewCell.h"

@implementation VoucherViewCell

static NSString * const VoucherCellID = @"VoucherCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    VoucherViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VoucherViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
- (void)setupView
{
    self.contentView.backgroundColor = VIEWBG_COLOR;
    [self.contentView addSubview:self.listBg];
    
    [self.listBg addSubview:self.icon];
    [self.listBg addSubview:self.name];
    [self.listBg addSubview:self.listImage];
    [self.listBg addSubview:self.title];
    [self.listBg addSubview:self.value];
    [self.listBg addSubview:self.number];
    [self.listBg addSubview:self.date];
    self.name.text = @"贵州茅台";
    self.title.text = @"贵州茅台酒 53度茅台飞天精品500ml整箱12瓶 ";
    self.value.text = @"面值：¥3399 ";
    self.number.text = @"✖️30";
    self.date.text = @"有效期：2019-07-13至2019-09-20";
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(Margin_15);
        make.top.equalTo(self.listBg.mas_top).offset(Margin_15);
        make.width.height.mas_equalTo(Margin_20);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(Margin_10);
        make.right.mas_lessThanOrEqualTo(self.listBg.mas_right).offset(-Margin_15);
    }];
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.icon);
        make.width.height.mas_equalTo(ScreenScale(60));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listImage);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
        make.right.equalTo(self.listBg.mas_right).offset(-Margin_15);
    }];
    [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.listImage);
        make.height.mas_equalTo(Margin_15);
    }];
    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.title);
        make.bottom.equalTo(self.listImage);
        make.left.mas_lessThanOrEqualTo(self.value.mas_right).offset(Margin_10);
    }];
    [self.number setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon);
        make.bottom.equalTo(self.listBg);
        make.height.mas_equalTo(MAIN_HEIGHT);
        make.right.equalTo(self.title);
    }];
}
- (UIImageView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIImageView alloc] init];
        _listBg.image = [UIImage imageNamed:@"voucher_bg"];
    }
    return _listBg;
}
- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"icon_placehoder"];
        [_icon setViewSize:CGSizeMake(Margin_20, Margin_20) borderWidth:0 borderColor:nil borderRadius:Margin_10];
    }
    return _icon;
}
- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = FONT_13;
        _name.textColor = COLOR_9;
    }
    return _name;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        _listImage.image = [UIImage imageNamed:@"good_placehoder"];
    }
    return _listImage;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(13);
        _title.textColor = TITLE_COLOR;
        _title.numberOfLines = 2;
    }
    return _title;
}
- (UILabel *)value
{
    if (!_value) {
        _value = [[UILabel alloc] init];
        _value.font = FONT(12);
        _value.textColor = COLOR_9;
    }
    return _value;
}
- (UILabel *)number
{
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.font = FONT_Bold(20);
        _number.textColor = TITLE_COLOR;
    }
    return _number;
}

- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = FONT(11);
        _date.textColor = COLOR_9;
    }
    return _date;
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
