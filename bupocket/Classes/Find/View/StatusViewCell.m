//
//  StatusViewCell.m
//  bupocket
//
//  Created by huoss on 2019/8/26.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "StatusViewCell.h"

@implementation StatusViewCell

//static NSString * const StatusID = @"StatusID";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    StatusViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[StatusViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.spot];
        [self.contentView addSubview:self.title];
        self.date.attributedText = [Encapsulation attrWithString:@"08-28\n12:00" preFont:FONT_TITLE preColor:COLOR_6 index:5 sufFont:FONT(12) sufColor:COLOR_9 lineSpacing:Margin_5];
        self.date.textAlignment = NSTextAlignmentRight;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Main);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_15);
        make.right.equalTo(self.spot.mas_left).offset(-Margin_15);
    }];
    [self.spot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(ScreenScale(80));
        make.centerY.equalTo(self.date.mas_top).offset(Margin_10);
        make.size.mas_equalTo(CGSizeMake(Margin_15, Margin_15));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.spot.mas_centerX);
        make.width.mas_equalTo(LINE_WIDTH);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spot.mas_right).offset(Margin_10);
        make.top.equalTo(self.date);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Main);
    }];
}
- (void)setType:(NSInteger)type
{
    _type = type;
    self.title.text = @"bumeme 申请退出竞选节点集合";
    if (type == 0) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.spot.mas_centerY);
            make.bottom.equalTo(self.contentView);
        }];
    } else if (type == 1) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
        }];
        self.title.text = @"";
        self.title.attributedText = [Encapsulation attrWithString:@"成为共识节点\nbumeme 成功加入共识竞选节点集合，成为共识节点" preFont:FONT_TITLE preColor:MAIN_COLOR index:6 sufFont:FONT_13 sufColor:COLOR_6 lineSpacing:Margin_5];
        self.spot.selected = YES;
    } else if (type == 2) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.spot.mas_centerY);
        }];
    }
}
- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.numberOfLines = 0;
    }
    return _date;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}
- (UIButton *)spot
{
    if (!_spot) {
        _spot = [UIButton createButtonWithNormalImage:@"status_spot" SelectedImage:@"status_ID" Target:nil Selector:nil];
        _spot.contentMode = UIViewContentModeCenter;
    }
    return _spot;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(13);
        _title.textColor = COLOR_6;
        _title.numberOfLines = 0;
    }
    return _title;
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
