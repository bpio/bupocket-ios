//
//  InfoViewCell.m
//  bupocket
//
//  Created by bupocket on 2019/7/22.
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
        _info.contentEdgeInsets = UIEdgeInsetsMake(Margin_Main, Margin_Main, Margin_Main, Margin_Main);
    } else if ([self.reuseIdentifier isEqualToString:NormalCellID]) {
        [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(Margin_Main);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_Main);
//            make.width.mas_equalTo(View_Width_Main);
        }];
        self.info.contentEdgeInsets = UIEdgeInsetsMake(Margin_Main, Margin_10, Margin_Main, Margin_10);
        self.info.layer.masksToBounds = YES;
        self.info.layer.cornerRadius = BG_CORNER;
//        CGSize maximumSize = CGSizeMake(Content_Width_Main, CGFLOAT_MAX);
//        CGSize expectSize = [_info sizeThatFits:maximumSize];
//        _info.size = expectSize;
//        [self.info setViewSize:_info.size borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
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
- (void)setInfoModel:(InfoModel *)infoModel
{
    _infoModel = infoModel;
    [self.info setAttributedTitle:[Encapsulation getAttrWithInfoStr:infoModel.info] forState:UIControlStateNormal];
    CGFloat width = ([self.reuseIdentifier isEqualToString:DefaultCellID]) ? View_Width_Main : Content_Width_Main;
    CGSize maximumSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize expectSize = [self.info.titleLabel sizeThatFits:maximumSize];
    self.info.size = CGSizeMake(expectSize.width, expectSize.height + Margin_30);
    infoModel.cellHeight = expectSize.height + Margin_30;
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
