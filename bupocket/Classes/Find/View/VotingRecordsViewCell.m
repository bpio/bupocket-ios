//
//  VotingRecordsViewCell.m
//  bupocket
//
//  Created by bupocket on 2019/3/22.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "VotingRecordsViewCell.h"

@implementation VotingRecordsViewCell

static NSString * const VotingRecordsCellID = @"VotingRecordsCellID";
static NSString * const NodeRecordsCellID = @"NodeRecordsCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    VotingRecordsViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VotingRecordsViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.listBg];
        [self.listBg addSubview:self.recordType];
        [self.listBg addSubview:self.title];
        [self.listBg addSubview:self.nodeType];
        [self.listBg addSubview:self.number];
        [self.listBg addSubview:self.state];
        [self.listBg addSubview:self.date];
        self.title.text = @"会飞的比特币会飞的比特币会飞的比特币会飞的比特币会飞的比特币";
        self.nodeType.text = Localized(@"ConsensusNode");
        //        "ConsensusNode" = "共识节点";
        //        "EcologicalNodes" = "生态节点";
        
        self.number.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n123456789", Localized(@"Number")] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"Number").length sufFont:FONT(13) sufColor:TITLE_COLOR lineSpacing:Margin_5];
        self.number.textAlignment = NSTextAlignmentLeft;
//        "Success" = "成功";
//        "Failure" = "失败";
        NSString * stateStr = Localized(@"Success");
        UIColor * stateColor;
        if ([stateStr isEqualToString:Localized(@"Success")]) {
            stateColor = MAIN_COLOR;
        } else {
            stateColor = WARNING_COLOR;
        }
//        "Failure" = "失败";
        self.state.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"State"),stateStr] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"State").length sufFont:FONT(13) sufColor:stateColor lineSpacing:Margin_5];
        self.state.textAlignment = NSTextAlignmentLeft;
        self.date.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n14:10:55 03/11/2019", Localized(@"Time")] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"Time").length sufFont:FONT(13) sufColor:TITLE_COLOR lineSpacing:Margin_5];
        self.date.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = (DEVICE_WIDTH - ScreenScale(70)) / 6;
    [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
    }];
    self.contentView.backgroundColor = self.contentView.superview.superview.backgroundColor;
    [self.recordType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(Margin_15);
        make.top.equalTo(self.listBg.mas_top).offset(Margin_15);
        make.width.height.mas_equalTo(ScreenScale(18));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recordType.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.recordType);
    }];
    if ([self.reuseIdentifier isEqualToString:NodeRecordsCellID]) {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.listBg.mas_right).offset(-Margin_10);
        }];
    } else if ([self.reuseIdentifier isEqualToString:VotingRecordsCellID]) {
        [self.nodeType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(Margin_10);
            make.centerY.equalTo(self.title);
            make.height.mas_equalTo(ScreenScale(16));
            make.right.mas_lessThanOrEqualTo(self.listBg.mas_right).offset(-Margin_10);
            make.width.mas_equalTo([Encapsulation rectWithText:self.nodeType.text font:self.nodeType.font textHeight:ScreenScale(16)].size.width + Margin_10);
        }];
        [self.nodeType setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordType.mas_bottom).offset(Margin_15);
        make.left.equalTo(self.recordType);
        make.width.mas_equalTo(width * 2);
        //        make.right.mas_lessThanOrEqualTo(self.nodeType.mas_left).offset(-Margin_15);
    }];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.number.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.number);
        make.width.mas_equalTo(width);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.state.mas_right).offset(Margin_10);
        make.right.equalTo(self.listBg.mas_right).offset(-Margin_15);
        make.centerY.equalTo(self.number);
        make.width.mas_equalTo(width * 3);
    }];
}
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
- (UIButton *)recordType
{
    if (!_recordType) {
        _recordType = [UIButton createButtonWithTitle:Localized(@"Throw") TextFont:13 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:nil Selector:nil];
        _recordType.backgroundColor = MAIN_COLOR;
        [_recordType setTitle:Localized(@"Withdraw") forState:UIControlStateSelected];
        _recordType.backgroundColor = WARNING_COLOR;
        _recordType.layer.masksToBounds = YES;
        _recordType.layer.cornerRadius = TAG_CORNER;
    }
    return _recordType;
}
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT_Bold(15);
        _title.textColor = TITLE_COLOR;
    }
    return _title;
}
- (UILabel *)nodeType
{
    if (!_nodeType) {
        _nodeType = [[UILabel alloc] init];
        _nodeType.font = FONT(11);
        _nodeType.textAlignment = NSTextAlignmentCenter;
        _nodeType.textColor = COLOR(@"B2B2B2");
        _nodeType.backgroundColor = COLOR(@"F2F2F2");
        _nodeType.layer.masksToBounds = YES;
        _nodeType.layer.cornerRadius = TAG_CORNER;
    }
    return _nodeType;
}
- (UILabel *)number
{
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.numberOfLines = 0;
    }
    return _number;
}
- (UILabel *)state
{
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.numberOfLines = 0;
    }
    return _state;
}
- (UILabel *)date
{
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.numberOfLines = 0;
    }
    return _date;
}

//- (void)setAddressBookModel:(AddressBookModel *)addressBookModel
//{
//    _addressBookModel = addressBookModel;
//    self.addressName.text = addressBookModel.nickName;
//    self.address.text = [NSString stringEllipsisWithStr:addressBookModel.linkmanAddress];
//    self.describe.text = addressBookModel.remark;
//    CGFloat addressNameH = [Encapsulation rectWithText:self.addressName.text font:self.addressName.font textWidth:DEVICE_WIDTH - Margin_50].size.height;
//    CGFloat describeH = 0;
//    if (NULLString(self.describe.text)) {
//        describeH = (Margin_5 + [Encapsulation rectWithText:self.describe.text font:self.describe.font textWidth:DEVICE_WIDTH - Margin_50].size.height);
//    }
//    addressBookModel.cellHeight = ScreenScale(72) + addressNameH + describeH + Margin_10;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
