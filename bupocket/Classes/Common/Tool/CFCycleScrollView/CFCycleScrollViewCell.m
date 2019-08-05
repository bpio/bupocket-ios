//
//  CFCycleScrollViewCell.m
//  CFCycleScrollView
//
//  Created by Peak on 17/2/23.
//  Copyright © 2017年 陈峰. All rights reserved.
//

#import "CFCycleScrollViewCell.h"

@implementation CFCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.luckyImage];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Main);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_10);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(Margin_5);
        make.left.equalTo(self.addressLabel);
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Main);
        make.centerY.equalTo(self.addressLabel);
        make.left.mas_greaterThanOrEqualTo(self.addressLabel.mas_right).offset(Margin_10);
    }];
    [self.luckyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.amountLabel);
        make.centerY.equalTo(self.dateLabel);
    }];
}
- (void)setActivityAwardsModel:(ActivityAwardsModel *)activityAwardsModel
{
    _activityAwardsModel = activityAwardsModel;
    self.addressLabel.text = [NSString stringEllipsisWithStr:activityAwardsModel.receiver subIndex:SubIndex_Address];
    self.dateLabel.text = [DateTool getDateProcessingWithTimeStr:activityAwardsModel.date];
    NSString * amount = activityAwardsModel.amount;
    NSString * amountStr = [NSString stringWithFormat:@"%@ %@", amount, activityAwardsModel.tokenSymbol];
    self.amountLabel.attributedText = [Encapsulation attrWithString:amountStr preFont:FONT_TITLE preColor:MAIN_COLOR index:amount.length sufFont:FONT_TITLE sufColor:TITLE_COLOR lineSpacing:0];
    self.luckyImage.hidden = [activityAwardsModel.mvpFlag isEqualToString:@"0"];
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT_TITLE;
        _addressLabel.textColor = COLOR_6;
    }
    return _addressLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = FONT(12);
        _dateLabel.textColor = COLOR_9;
    }
    return _dateLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
    }
    return _amountLabel;
}

- (UIImageView *)luckyImage
{
    if (!_luckyImage) {
        _luckyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lucky"]];
        _luckyImage.hidden = YES;
    }
    return _luckyImage;
}

@end
