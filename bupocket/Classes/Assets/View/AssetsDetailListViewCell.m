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
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.purseAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_15);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.purseAddress);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_15);
    }];
    [self.assets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.purseAddress);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
    }];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.date);
        make.right.equalTo(self.assets);
    }];
    [self setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(75)) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
}

- (void)setListModel:(AssetsDetailModel *)listModel
{
    _listModel = listModel;
    NSString * outOrIn;
    NSString * addressStr;
    if (listModel.outinType == Transaction_Type_TurnOut) {
        addressStr = listModel.toAddress;
        outOrIn = @"-";
    } else {
        addressStr = listModel.fromAddress;
        outOrIn = @"+";
    }
    if (addressStr.length > 10) {
        self.purseAddress.text = [NSString stringEllipsisWithStr:addressStr];
    }
    self.date.text = [DateTool getDateProcessingWithTimeStr:listModel.txTime];
    self.assets.text = [listModel.amount isEqualToString:@"~"] ? listModel.amount : [NSString stringWithFormat:@"%@%@ %@", outOrIn, listModel.amount, self.assetCode];
    self.state.text = (listModel.txStatus == 0) ? Localized(@"Success") : Localized(@"Failure");
}
- (UILabel *)purseAddress
{
    if (!_purseAddress) {
        _purseAddress = [[UILabel alloc] init];
        _purseAddress.font = TITLE_FONT;
        _purseAddress.textColor = COLOR_6;
    }
    return _purseAddress;
}
- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = FONT(12);
        _date.textColor = COLOR_9;
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
        _state.textColor = COLOR_9;
    }
    return _state;
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
