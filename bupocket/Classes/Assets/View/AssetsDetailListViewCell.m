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
        [self.contentView addSubview:self.listImage];
        [self.contentView addSubview:self.walletAddress];
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.assets];
        [self.contentView addSubview:self.state];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat offsetY = Margin_5;
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(ScreenScale(36));
    }];
    [self.walletAddress setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
//        make.top.equalTo(self.listImage);
        make.top.equalTo(self.listImage.mas_top).offset(-offsetY);
        make.right.mas_lessThanOrEqualTo(self.assets.mas_left).offset(-Margin_10);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.walletAddress);
        make.bottom.equalTo(self.listImage.mas_bottom).offset(offsetY);
//        make.bottom.equalTo(self.listImage);
    }];
    [self.assets mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.walletAddress);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.left.mas_greaterThanOrEqualTo(self.walletAddress.mas_right).offset(Margin_10);
    }];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.date);
        make.right.equalTo(self.assets);
    }];
    [self setViewSize:CGSizeMake(View_Width_Main, ScreenScale(75)) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
}

- (void)setListModel:(AssetsDetailModel *)listModel
{
    _listModel = listModel;
    NSString * outOrIn;
    NSString * addressStr;
    if (listModel.outinType == Transaction_Type_TurnOut) {
        addressStr = listModel.toAddress;
        outOrIn = @"-";
        self.listImage.image = [UIImage imageNamed:@"payment"];
    } else {
        addressStr = listModel.fromAddress;
        outOrIn = @"+";
        self.listImage.image = [UIImage imageNamed:@"receivables"];
    }
    if (addressStr.length > 10) {
        self.walletAddress.text = [NSString stringEllipsisWithStr:addressStr subIndex:SubIndex_Address];
    }
    self.date.text = [DateTool getDateProcessingWithTimeStr:listModel.txTime];
    self.assets.text = ([listModel.amount isEqualToString:@"~"] || [listModel.amount isEqualToString:@"0"]) ? listModel.amount : [NSString stringWithFormat:@"%@%@", outOrIn, listModel.amount];
    if (listModel.txStatus == 0) {
        self.state.text = Localized(@"Success");
        self.state.textColor = COLOR_9;
    } else {
        self.state.text = Localized(@"Failure");
        self.state.textColor = WARNING_COLOR;
    }
}
- (void)setCooperateSupportModel:(CooperateSupportModel *)cooperateSupportModel
{
    _cooperateSupportModel = cooperateSupportModel;
    self.listImage.image = [UIImage imageNamed:@"user_placeholder"];
    self.walletAddress.text = [NSString stringEllipsisWithStr:cooperateSupportModel.initiatorAddress subIndex:SubIndex_Address];
    self.date.text = cooperateSupportModel.createTime;
    self.assets.text = [NSString stringAppendingBUWithStr:[NSString stringAmountSplitWith:cooperateSupportModel.amount]];
    if ([cooperateSupportModel.type isEqualToString:@"1"]) {
        self.state.text = Localized(@"Support");
        self.state.textColor = COLOR_6;
    } else if ([cooperateSupportModel.type isEqualToString:@"2"]) {
        self.state.text = Localized(@"Withdraw");
        self.state.textColor = COLOR_9;
    }
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        [_listImage setViewSize:CGSizeMake(ScreenScale(36), ScreenScale(36)) borderWidth:0 borderColor:nil borderRadius:ScreenScale(18)];
    }
    return _listImage;
}
- (UILabel *)walletAddress
{
    if (!_walletAddress) {
        _walletAddress = [[UILabel alloc] init];
        _walletAddress.font = FONT_TITLE;
        _walletAddress.textColor = COLOR_6;
    }
    return _walletAddress;
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
//    frame.origin.x = Margin_10;
//    frame.size.width -= Margin_20;
    frame.origin.x = Margin_15;
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
