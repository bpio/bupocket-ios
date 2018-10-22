//
//  AssetsDetailListViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AssetsDetailListViewCell.h"

@implementation AssetsDetailListViewCell

static NSString * const AssetsDetailCellID = @"AssetsDetailCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    AssetsDetailListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AssetsDetailCellID];
    if (cell == nil) {
        cell = [[AssetsDetailListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AssetsDetailCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.purseAddress];
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.assets];
        [self.contentView addSubview:self.state];
        self.purseAddress.text = @"buQYxj3yVm***qcsMvLivDu";
        self.date.text = @"2018-09-30 19:45:36";
        self.assets.text = @"+50 BU";
        self.state.text = @"成功";
//        self.state.text = @"失败";
//        self.state.textColor = COLOR(@"FF7272");
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.purseAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(ScreenScale(10));
        make.top.equalTo(self.contentView.mas_top).offset(ScreenScale(15));
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.purseAddress);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-ScreenScale(15));
    }];
    [self.assets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.purseAddress);
        make.right.equalTo(self.contentView.mas_right).offset(-ScreenScale(10));
    }];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.date);
        make.right.equalTo(self.assets);
    }];
    [self setViewSize:CGSizeMake(DEVICE_WIDTH - ScreenScale(20), ScreenScale(75)) borderWidth:0 borderColor:nil borderRadius:ScreenScale(5)];
}
- (UILabel *)purseAddress
{
    if (!_purseAddress) {
        _purseAddress = [[UILabel alloc] init];
        _purseAddress.font = FONT(14);
        _purseAddress.textColor = COLOR(@"666666");
    }
    return _purseAddress;
}
- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = FONT(12);
        _date.textColor = COLOR(@"999999");
    }
    return _date;
}
- (UILabel *)assets
{
    if (!_assets) {
        _assets = [[UILabel alloc] init];
        _assets.font = FONT(16);
        _assets.textColor = TITLE_COLOR;
    }
    return _assets;
}
- (UILabel *)state
{
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.font = FONT(12);
        _state.textColor = COLOR(@"999999");
    }
    return _state;
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
