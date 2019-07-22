//
//  VoucherViewCell.m
//  bupocket
//
//  Created by huoss on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VoucherViewCell.h"

@implementation VoucherViewCell

static NSString * const VoucherCellID = @"VoucherCellID";
static NSString * const VoucherDetailCellID = @"VoucherDetailCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    VoucherViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VoucherViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
- (void)setupView
{
//    self.contentView.backgroundColor = VIEWBG_COLOR;
//    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.listBg];
    [self.listBg addSubview:self.checked];
    [self.listBg addSubview:self.icon];
    [self.listBg addSubview:self.name];
    [self.listBg addSubview:self.listImage];
    [self.listBg addSubview:self.title];
    [self.listBg addSubview:self.value];
    [self.listBg addSubview:self.date];
    [self.listBg addSubview:self.number];
    if ([self.reuseIdentifier isEqualToString:VoucherCellID]) {
        self.listBg.image = [UIImage imageNamed:@"voucher_bg"];
    } else if ([self.reuseIdentifier isEqualToString:VoucherDetailCellID]) {
        self.lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_60, LINE_WIDTH);
        [self.lineView drawDashLine];
        [self.listBg addSubview:self.lineView];
        self.value.textAlignment = NSTextAlignmentRight;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat left = Margin_30;
    CGFloat iconTop = iPhone5 ? Margin_25 : ScreenScale(21);
    CGFloat listImageTop = Margin_15;
    CGFloat dateBottom = iPhone5 ? Margin_20 : ScreenScale(18);
    if ([self.reuseIdentifier isEqualToString:VoucherCellID]) {
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_5);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_5);
            make.top.bottom.equalTo(self.contentView);
//            make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
        }];
        [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
    } else if ([self.reuseIdentifier isEqualToString:VoucherDetailCellID]) {
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        left = Margin_15;
        iconTop = Margin_15;
        listImageTop = Margin_30;
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(left);
            make.top.equalTo(self.listBg.mas_top).offset(Margin_50);
        }];
        [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.icon.mas_bottom).offset(listImageTop);
        }];
    }
    [self.checked mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listBg.mas_top).offset(ScreenScale(8));
        make.right.equalTo(self.listBg.mas_right).offset(-Margin_10);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(left);
        make.top.equalTo(self.contentView.mas_top).offset(iconTop);
        make.width.height.mas_equalTo(ScreenScale(22));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon);
        make.left.equalTo(self.icon.mas_right).offset(Margin_10);
        make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-left);
    }];
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.icon.mas_bottom).offset(listImageTop);
        make.left.equalTo(self.icon);
        make.width.height.mas_equalTo(ScreenScale(60));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listImage);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
        make.right.equalTo(self.contentView.mas_right).offset(-left);
    }];
    
    [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.bottom.equalTo(self.listImage);
        make.height.mas_equalTo(Margin_15);
    }];
    if ([self.reuseIdentifier isEqualToString:VoucherCellID]) {
        [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.number.mas_left).offset(-Margin_10);
        }];
        [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.title);
            make.bottom.equalTo(self.listImage);
        }];
        [self.number setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon);
            make.bottom.equalTo(self.listBg.mas_bottom).offset(-dateBottom);
            make.height.mas_equalTo(Margin_30);
            make.right.equalTo(self.title);
        }];
    } else if ([self.reuseIdentifier isEqualToString:VoucherDetailCellID]) {
        [self.value mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.title);
        }];
    }
}
- (void)setVoucherModel:(VoucherModel *)voucherModel
{
    _voucherModel = voucherModel;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:voucherModel.voucherAcceptance[@"icon"]] placeholderImage:[UIImage imageNamed:@"icon_placehoder"]];
    NSString * name = voucherModel.voucherAcceptance[@"name"];
    if ([self.reuseIdentifier isEqualToString:VoucherDetailCellID]) {
        self.name.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", name, Localized(@"ProvideAcceptance")] preFont:FONT_13 preColor:COLOR_9 index:name.length sufFont:FONT(12) sufColor:COLOR(@"B2B2B2") lineSpacing:0];
    } else {
        self.name.text = name;        
    }
    [self.listImage sd_setImageWithURL:[NSURL URLWithString:voucherModel.voucherIcon] placeholderImage:[UIImage imageNamed:@"good_placehoder"]];
//    self.title.text = voucherModel.voucherName;
    self.title.attributedText = [Encapsulation attrWithString:voucherModel.voucherName font:FONT_Bold(14) color:TITLE_COLOR lineSpacing:ScreenScale(3)];
    self.value.text = [NSString stringWithFormat:Localized(@"Value:%@"), voucherModel.faceValue];
    self.number.text = [NSString stringWithFormat:@"× %@", voucherModel.balance];
//    self.number.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"×%@", voucherModel.balance] preFont:FONT(18) preColor:TITLE_COLOR index:1 sufFont:FONT(18) sufColor:TITLE_COLOR lineSpacing:0];
    NSString * startTime = ([voucherModel.startTime isEqualToString:Voucher_Validity_Date]) ? @"~" : [DateTool getDateStringWithDataStr:voucherModel.startTime];
    NSString * endTime = ([voucherModel.endTime isEqualToString:Voucher_Validity_Date]) ? @"~" : [DateTool getDateStringWithDataStr:voucherModel.endTime];
    NSString * dateStr = ([self.voucherModel.startTime isEqualToString:Voucher_Validity_Date]) ? Localized(@"LongTerm") : [NSString stringWithFormat:Localized(@"%@ to %@"), startTime, endTime];
    self.date.text = [NSString stringWithFormat:@"%@：%@", Localized(@"Validity"), dateStr];
    [self.listBg sizeToFit];
    _voucherModel.cellHeight = self.listBg.height;
}
- (UIImageView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIImageView alloc] init];
    }
    return _listBg;
}
- (UIImageView *)checked
{
    if (!_checked) {
        _checked = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voucher_checked"]];
        _checked.hidden = YES;
    }
    return _checked;
}
- (UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"icon_placehoder"];
        [_icon setViewSize:CGSizeMake(ScreenScale(22), ScreenScale(22)) borderWidth:0 borderColor:nil borderRadius:ScreenScale(11)];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}
- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = FONT_13;
        _name.textColor = COLOR_9;
    }
    return _name;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        _listImage.image = [UIImage imageNamed:@"good_placehoder"];
        [_listImage setViewSize:CGSizeMake(ScreenScale(60), ScreenScale(60)) borderRadius:ScreenScale(3) corners:UIRectCornerAllCorners];
    }
    return _listImage;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT_Bold(14);
        _title.textColor = TITLE_COLOR;
        _title.numberOfLines = 2;
    }
    return _title;
}
- (UILabel *)value
{
    if (!_value) {
        _value = [[UILabel alloc] init];
        _value.font = FONT(12);
        _value.textColor = COLOR_6;
    }
    return _value;
}
- (UILabel *)number
{
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.font = FONT(18);
        _number.textColor = TITLE_COLOR;
    }
    return _number;
}

- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = FONT(11);
        _date.textColor = COLOR_9;
    }
    return _date;
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
