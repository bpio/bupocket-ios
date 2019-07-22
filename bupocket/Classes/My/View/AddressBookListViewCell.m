//
//  AddressBookListViewCell.m
//  bupocket
//
//  Created by bubi on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "AddressBookListViewCell.h"

static NSString * const WalletCellID = @"WalletCellID";

@implementation AddressBookListViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    AddressBookListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AddressBookListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.listBg];
        [self.contentView addSubview:self.addressName];
        [self.contentView addSubview:self.address];
        [self.contentView addSubview:self.describe];
//        [self setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_20, _addressBookModel.cellHeight) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
//        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
//        make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
//    }];
    [self.addressName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Margin_20);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Main);
//        make.height.mas_equalTo(ScreenScale(16));
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Main);
//        make.right.mas_lessThanOrEqualTo(self.detailImage.mas_left).offset(-Margin_15);
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addressName);
        make.height.mas_equalTo(Margin_15);
        make.top.equalTo(self.addressName.mas_bottom).offset(Margin_10);
    }];
    [self.describe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addressName);
//        make.right.equalTo(self.listBg.mas_right).offset(-Margin_15);
        make.top.equalTo(self.address.mas_bottom).offset(Margin_5);
    }];
    
}
/*
- (UIView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIView alloc] init];
        _listBg.backgroundColor = [UIColor whiteColor];
        _listBg.layer.masksToBounds = YES;
        _listBg.layer.cornerRadius = BG_CORNER;
    }
    return _listBg;
}
 */
- (UILabel *)addressName
{
    if (!_addressName) {
        _addressName = [[UILabel alloc] init];
        _addressName.font = FONT_Bold(15);
        _addressName.textColor = TITLE_COLOR;
        _addressName.numberOfLines = 0;
    }
    return _addressName;
}
- (UILabel *)address
{
    if (!_address) {
        _address = [[UILabel alloc] init];
        _address.font = FONT_TITLE;
        _address.textColor = COLOR_6;
    }
    return _address;
}
- (UILabel *)describe
{
    if (!_describe) {
        _describe = [[UILabel alloc] init];
        _describe.font = FONT(13);
        _describe.textColor = COLOR_B2;
        _describe.numberOfLines = 0;
    }
    return _describe;
}
//- (UIImageView *)detailImage
//{
//    if (!_detailImage) {
//        _detailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked"]];
//    }
//    return _detailImage;
//}
- (void)setAddressBookModel:(AddressBookModel *)addressBookModel
{
    _addressBookModel = addressBookModel;
    self.addressName.text = addressBookModel.nickName;
    self.address.text = [NSString stringEllipsisWithStr:addressBookModel.linkmanAddress subIndex:SubIndex_Address];
    self.describe.text = addressBookModel.remark;
    CGFloat addressNameH = [Encapsulation rectWithText:self.addressName.text font:self.addressName.font textWidth:View_Width_Main].size.height;
    CGFloat describeH = 0;
    if (NotNULLString(self.describe.text)) {
        describeH = (Margin_5 + [Encapsulation rectWithText:self.describe.text font:self.describe.font textWidth:View_Width_Main].size.height);
    }
    addressBookModel.cellHeight = ScreenScale(70) + addressNameH + describeH;
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
