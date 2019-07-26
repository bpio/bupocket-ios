//
//  InfoViewCell.m
//  bupocket
//
//  Created by huoss on 2019/7/22.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "InfoViewCell.h"

static NSString * const DefaultCellID = @"DefaultCellID";
static NSString * const NormalCellID = @"NormalCellID";

@implementation InfoViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CellType)cellType
{
    NSString * identifier;
    if (cellType == CellTypeDefault) {
        identifier = DefaultCellID;
    } else if (cellType == CellTypeNormal) {
        identifier = NormalCellID;
    }
    InfoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[InfoViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
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
    if ([self.reuseIdentifier isEqualToString:DefaultCellID]) {
        [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        _info.contentEdgeInsets = UIEdgeInsetsMake(Margin_10, Margin_Main, Margin_10, Margin_Main);
    } else if ([self.reuseIdentifier isEqualToString:NormalCellID]) {
        [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(View_Width_Main);
        }];
        _info.contentEdgeInsets = UIEdgeInsetsMake(Margin_5, Margin_10, Margin_5, Margin_10);
        CGSize maximumSize = CGSizeMake(View_Width_Main, CGFLOAT_MAX);
        CGSize expectSize = [_info sizeThatFits:maximumSize];
        _info.size = expectSize;
        [self.info setViewSize:_info.size borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
    }
}
- (UIButton *)info
{
    if (!_info) {
        _info = [UIButton buttonWithType:UIButtonTypeCustom];
        _info.titleLabel.numberOfLines = 0;
        _info.backgroundColor = [UIColor whiteColor];
        _info.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
