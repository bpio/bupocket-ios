//
//  MyListViewCell.m
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ListTableViewCell.h"

static NSString * const DefaultCellID = @"DefaultCellID";
static NSString * const DetailCellID = @"DetailCellID";
static NSString * const NormalCellID = @"NormalCellID";
static NSString * const ChoiceCellID = @"ChoiceCellID";
static NSString * const WalletDetailCellID = @"WalletDetailCellID";
static NSString * const IdentifyCellID = @"IdentifyCellID";

@implementation ListTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(CellType)cellType
{
    NSString * identifier;
    if (cellType == CellTypeDefault) {
        // 图片，文字，文字/箭头
        identifier = DefaultCellID;
    } else if (cellType == CellTypeDetail) {
        // 图片，文字，文字，箭头
        identifier = DetailCellID;
    } else if (cellType == CellTypeNormal) {
        // 图片，文字，箭头 圆角
        identifier = NormalCellID;
    } else if (cellType == CellTypeChoice) {
        // 文字，图片
        identifier = ChoiceCellID;
    } else if (cellType == CellTypeWalletDetail) {
        // 文字，图片/文字，箭头 圆角
        identifier = WalletDetailCellID;
    } else if (cellType == CellTypeID) {
        // 文字，图片 文字 圆角
        identifier = IdentifyCellID;
    }
    ListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.listBg];
        [self.listBg addSubview:self.listImage];
        [self.listBg addSubview:self.title];
        [self.listBg addSubview:self.detailTitle];
        [self.listBg addSubview:self.detail];
        [self.listBg addSubview:self.lineView];
        if ([reuseIdentifier isEqualToString:WalletDetailCellID]) {
            _listImage.contentMode = UIViewContentModeScaleAspectFill;
        }
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.reuseIdentifier isEqualToString:NormalCellID] || [self.reuseIdentifier isEqualToString:WalletDetailCellID]|| [self.reuseIdentifier isEqualToString:IdentifyCellID]) {
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
            make.top.bottom.equalTo(self.contentView);
        }];
        self.contentView.backgroundColor = VIEWBG_COLOR;
    } else {
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.listBg);
    }];
    if ([self.reuseIdentifier isEqualToString:ChoiceCellID]) {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listBg.mas_left).offset(Margin_20);
        }];
    } else if ([self.reuseIdentifier isEqualToString:WalletDetailCellID]) {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listBg.mas_left).offset(Margin_15);
        }];
        [self.listImage setViewSize:CGSizeMake(Margin_30, Margin_30) borderWidth:0 borderColor:nil borderRadius:MAIN_CORNER];
        [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.detail.mas_left);
            make.centerY.equalTo(self.listBg);
            make.width.height.mas_equalTo(Margin_30);
        }];
    } else if ([self.reuseIdentifier isEqualToString:IdentifyCellID]) {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listBg.mas_left).offset(Margin_10);
        }];
        [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(Margin_10);
            make.centerY.equalTo(self.listBg);
        }];
    } else {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listImage.mas_right).offset(Margin_15);
        }];
        [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.listBg.mas_left).offset(Margin_15);
            make.centerY.equalTo(self.listBg);
            make.width.height.mas_equalTo(Margin_20);
        }];
    }
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.listBg.mas_right).offset(-Margin_20);
        make.right.top.bottom.equalTo(self.listBg);
//        make.width.mas_equalTo(Margin_40);
//        make.width.mas_equalTo(self.detail.imageView.width + ScreenScale(35));
    }];
    if ([self.reuseIdentifier isEqualToString:DetailCellID] || [self.reuseIdentifier isEqualToString:WalletDetailCellID]) {
        [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.detail.mas_left);
        }];
    } else {
        CGFloat right = ([self.reuseIdentifier isEqualToString:IdentifyCellID]) ? Margin_10 : Margin_20;
        [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.listBg.mas_right).offset(-right);
        }];
    }
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.listBg);
        make.left.mas_greaterThanOrEqualTo(self.title.mas_right).offset(Margin_10);
    }];
    [self.title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.detail setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(Margin_10);
        make.right.equalTo(self.listBg.mas_right).offset(-Margin_10);
        make.bottom.equalTo(self.listBg);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
}
- (UIView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIView alloc] init];
        _listBg.backgroundColor = [UIColor whiteColor];
    }
    return _listBg;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        _listImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _listImage;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT_15;
        _title.textColor = COLOR_6;
    }
    return _title;
}
- (UILabel *)detailTitle
{
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.font = FONT_15;
        _detailTitle.textColor = COLOR_9;
    }
    return _detailTitle;
}
- (UIButton *)detail
{
    if (!_detail) {
        _detail = [UIButton createButtonWithTitle:@"" TextFont:FONT(15) TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
        [_detail setImage:[UIImage imageNamed:@"list_arrow"] forState:UIControlStateNormal];
        _detail.userInteractionEnabled = NO;
        _detail.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, Margin_15);
        _detail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _detail;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LINE_COLOR;
        _lineView.hidden = YES;
    }
    return _lineView;
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
