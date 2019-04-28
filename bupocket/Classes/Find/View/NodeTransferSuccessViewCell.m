//
//  NodeTransferSuccessViewCell.m
//  bupocket
//
//  Created by huoss on 2019/4/13.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodeTransferSuccessViewCell.h"

@implementation NodeTransferSuccessViewCell

static NSString * const NodeTransferSuccessID = @"NodeTransferSuccessID";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    NodeTransferSuccessViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NodeTransferSuccessViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detail];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_40);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_15);
        make.size.mas_equalTo(CGSizeMake(Margin_30, Margin_30));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.icon.mas_centerX);
        make.width.mas_equalTo(ScreenScale(1.5));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.icon);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_15);
    }];
    
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(Margin_10);
        make.left.right.equalTo(self.title);
    }];
}
- (void)setType:(NSInteger)type
{
    _type = type;
    if (type == 0) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_centerY);
            make.bottom.equalTo(self.contentView);
        }];
    } else if (type == 1) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
        }];
    } else if (type == 2) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.icon.mas_centerY);
        }];
    }
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
//        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeCenter;
    }
    return _icon;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = COLOR_6;
        _title.font = FONT(16);
    }
    return _title;
}
- (UILabel *)detail
{
    if (!_detail) {
        _detail = [[UILabel alloc] init];
        _detail.textColor = COLOR_9;
        _detail.font = FONT(13);
        _detail.numberOfLines = 0;
    }
    return _detail;
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
