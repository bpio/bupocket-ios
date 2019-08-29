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

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath identifier:(NSString *)identifier cellType:(StatusCellType)cellType
{
//    StatusViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    StatusViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[StatusViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.cellType = cellType;
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.date];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.spot];
        [self.contentView addSubview:self.title];
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
    
    if (self.cellType != StatusCellTypeNormal) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.spot.mas_centerX);
            make.width.mas_equalTo(LINE_WIDTH);
        }];
    }
    if (self.cellType == StatusCellTypeTop) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.spot.mas_centerY);
            make.bottom.equalTo(self.contentView);
        }];
    } else if (self.cellType == StatusCellTypeDefault) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
        }];
    } else if (self.cellType == StatusCellTypeBottom) {
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.spot.mas_centerY);
        }];
    }
    
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.spot.mas_right).offset(Margin_10);
        make.top.equalTo(self.date);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Main);
    }];
}

- (void)setStatusUpdateModel:(StatusUpdateModel *)statusUpdateModel
{
    _statusUpdateModel = statusUpdateModel;
    // @"08-28\n12:00"
    self.date.attributedText = [Encapsulation attrWithString:[DateTool getDateStrWithTimeStr:statusUpdateModel.createTime] preFont:FONT_TITLE preColor:COLOR_6 index:5 sufFont:FONT(12) sufColor:COLOR_9 lineSpacing:Margin_5];
    self.date.textAlignment = NSTextAlignmentRight;
    
    NSString * updateText;
    NSString * title;
    NSString * content;
    if ([CurrentAppLanguage hasPrefix:ZhHans]) {
        title = statusUpdateModel.title;
        content = statusUpdateModel.content;
    } else {
        title = statusUpdateModel.enTitle;
        content = statusUpdateModel.enContent;
    }
    updateText = (NotNULLString(title)) ? [NSString stringWithFormat:@"%@\n%@", title, content] : content;
    CGFloat width = DEVICE_WIDTH - ScreenScale(105);
    if ([updateText containsString:@"\n"]) {
        self.title.text = @"";
        self.title.attributedText = [Encapsulation attrWithString:updateText preFont:FONT_TITLE preColor:MAIN_COLOR index:title.length sufFont:FONT_13 sufColor:COLOR_6 lineSpacing:Margin_5];
//        statusUpdateModel.cellHeight = [Encapsulation getSizeSpaceLabelWithStr:updateText font:FONT_TITLE width:width height:CGFLOAT_MIN lineSpacing:Margin_5].height + Margin_30;
    } else {
        self.title.text = updateText;
//        statusUpdateModel.cellHeight = [Encapsulation rectWithText:updateText font:FONT_13 textWidth:width].size.height + Margin_30;
    }
    CGSize maximumSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize expectSize = [self.title sizeThatFits:maximumSize];
    self.title.size = expectSize;
    statusUpdateModel.cellHeight = MAX(ScreenScale(70), expectSize.height + Margin_30);
    self.spot.selected = [statusUpdateModel.type integerValue];
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
