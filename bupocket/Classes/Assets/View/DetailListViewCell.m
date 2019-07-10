//
//  DetailListViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "DetailListViewCell.h"

@implementation DetailListViewCell

static NSString * const DefaultDetailCellID = @"DefaultDetailCellID";
static NSString * const NormalDetailCellID = @"NormalDetailCellID";
static NSString * const ResultDetailCellID = @"ResultDetailCellID";
static NSString * const SubtitleDetailCellID = @"SubtitleDetailCellID";
static NSString * const VersionLogCellID = @"VersionLogCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(DetailCellType)cellType
{
    NSString * identifier;
    if (cellType == DetailCellDefault) {
        identifier = DefaultDetailCellID;
    } else if (cellType == DetailCellNormal) {
        identifier = NormalDetailCellID;
    } else if (cellType == DetailCellResult) {
        identifier = ResultDetailCellID;
    } else if (cellType == DetailCellSubtitle) {
        identifier = SubtitleDetailCellID;
    } else if (cellType == DetailCellVersionLog) {
        identifier = VersionLogCellID;
    }
    DetailListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DetailListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:NormalDetailCellID] ) {
            [self.contentView addSubview:self.detailBg];
            [self.detailBg addSubview:self.title];
            [self.detailBg addSubview:self.infoTitle];
        } else {
            [self.contentView addSubview:self.title];
            [self.contentView addSubview:self.infoTitle];
            if ([reuseIdentifier isEqualToString:SubtitleDetailCellID]) {
                self.title.font = FONT(16);
                self.title.textColor = COLOR_6;
                self.infoTitle.font = FONT(14);
            } else if ([reuseIdentifier isEqualToString:VersionLogCellID]) {
                self.title.font = FONT(17);
                self.title.textColor = TITLE_COLOR;
            }
        }
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.reuseIdentifier isEqualToString:NormalDetailCellID]) {
        [self.detailBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
            make.top.equalTo(self.contentView);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.detailBg.mas_left).offset(Margin_10);
            make.top.equalTo(self.detailBg.mas_top).offset(Margin_15);
        }];
        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title);
            make.right.equalTo(self.detailBg.mas_right).offset(-Margin_10);
            make.top.equalTo(self.title.mas_bottom).offset(Margin_10);
            make.bottom.equalTo(self.detailBg.mas_bottom).offset(-Margin_10);
        }];
    } else {
        CGFloat titleX = Margin_10;
        CGFloat titleY = Margin_15;
        if ([self.reuseIdentifier isEqualToString:VersionLogCellID]) {
            titleX = Margin_15;
            titleY = Margin_20;
        }
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(titleX);
            make.top.equalTo(self.contentView.mas_top).offset(titleY);
            make.right.equalTo(self.contentView.mas_right).offset(-titleX);
        }];
        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.title);
//            make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        }];
        if ([self.reuseIdentifier isEqualToString:DefaultDetailCellID]) {
            self.infoTitle.textAlignment = NSTextAlignmentRight;
            self.infoTitle.preferredMaxLayoutWidth = Info_Width_Max;
            [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.title);
            }];
        } else {
            [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.title.mas_bottom).offset(Margin_10);
                make.left.equalTo(self.title);
            }];
        }
    }
}
- (UIView *)detailBg
{
    if (!_detailBg) {
        _detailBg = [[UIView alloc] init];
        _detailBg.backgroundColor = COLOR(@"F8F8F8");
    }
    return _detailBg;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT(15);
        _title.textColor = COLOR_9;
        _title.numberOfLines = 0;
    }
    return _title;
}
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = FONT(15);
        _infoTitle.textColor = COLOR_6;
        _infoTitle.numberOfLines = 0;
    }
    return _infoTitle;
}
- (void)setFrame:(CGRect)frame
{
    if (![self.reuseIdentifier isEqualToString:VersionLogCellID]) {
        frame.origin.x = Margin_10;
        frame.size.width -= Margin_20;
    }
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
