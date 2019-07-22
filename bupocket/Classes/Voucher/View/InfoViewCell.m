//
//  InfoViewCell.m
//  bupocket
//
//  Created by huoss on 2019/7/22.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "InfoViewCell.h"

static NSString * const InfoCellID = @"InfoCellID";

@implementation InfoViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    InfoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoCellID];
    if (cell == nil) {
        cell = [[InfoViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InfoCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.info];
        self.backgroundColor = self.contentView.superview.backgroundColor;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(View_Width_Main);
    }];
}
- (UIButton *)info
{
    if (!_info) {
        _info = [UIButton buttonWithType:UIButtonTypeCustom];
        _info.titleLabel.numberOfLines = 0;
        _info.backgroundColor = [UIColor whiteColor];
        _info.layer.masksToBounds = YES;
        _info.layer.cornerRadius = BG_CORNER;
        _info.contentEdgeInsets = UIEdgeInsetsMake(Margin_5, Margin_10, Margin_5, Margin_10);
        _info.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        CGSize maximumSize = CGSizeMake(View_Width_Main, CGFLOAT_MAX);
        CGSize expectSize = [_info sizeThatFits:maximumSize];
        _info.size = expectSize;
    }
    return _info;
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
