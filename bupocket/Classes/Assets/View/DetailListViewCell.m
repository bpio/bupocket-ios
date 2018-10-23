//
//  DetailListViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "DetailListViewCell.h"

@implementation DetailListViewCell

static NSString * const DetailListCellID = @"DetailListCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    DetailListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DetailListCellID];
    if (cell == nil) {
        cell = [[DetailListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DetailListCellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.infoTitle];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(ScreenScale(10));
        make.top.equalTo(self.contentView.mas_top).offset(ScreenScale(15));
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-ScreenScale(10));
        make.top.equalTo(self.title);
    }];
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(15);
        _title.textColor = COLOR(@"999999");
    }
    return _title;
}
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = FONT(15);
        _infoTitle.textColor = COLOR(@"666666");
        _infoTitle.numberOfLines = 0;
        _infoTitle.textAlignment = NSTextAlignmentRight;
        _infoTitle.preferredMaxLayoutWidth = ScreenScale(200);
    }
    return _infoTitle;
}
- (void)setFrame:(CGRect)frame
{
    CGFloat margin = ScreenScale(5);
    frame.origin.x = margin * 2;
    frame.size.width -= margin * 4;
//    frame.origin.y += margin;
//    frame.size.height -= margin * 2;
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
