//
//  NodePlanViewCell.m
//  bupocket
//
//  Created by bupocket on 2019/3/21.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodePlanViewCell.h"

@implementation NodePlanViewCell

static NSString * const NodePlanCellID = @"NodePlanCellID";
static NSString * const NodeCellID = @"NodeCellID";

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    NodePlanViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NodePlanViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.listBg];
        [self.listBg addSubview:self.listImageBg];
        [self.listBg addSubview:self.listImage];
        [self.listBg addSubview:self.name];
        [self.listBg addSubview:self.nodeType];
        [self.listBg addSubview:self.votesObtained];
        [self.listBg addSubview:self.numberOfVotes];
        [self.listBg addSubview:self.moreOperations];
        if ([reuseIdentifier isEqualToString:NodePlanCellID]) {
            _listBg.layer.masksToBounds = YES;
            _listBg.layer.cornerRadius = BG_CORNER;
        }
        self.name.text = @"股神688";
        self.nodeType.text = Localized(@"ConsensusNode");
//        "ConsensusNode" = "共识节点";
//        "EcologicalNodes" = "生态节点";
        
        self.votesObtained.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", Localized(@"VotesObtained"), @"12345678"] preFont:FONT(12) preColor:COLOR(@"B2B2B2") index:Localized(@"VotesObtained").length sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:0];
        self.numberOfVotes.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", Localized(@"NumberOfVotes"), @"1234567"] preFont:FONT(12) preColor:COLOR(@"B2B2B2") index:Localized(@"NumberOfVotes").length sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:0];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat numberW = 0;
    if ([self.reuseIdentifier isEqualToString:NodePlanCellID]) {
        numberW = (DEVICE_WIDTH - ScreenScale(100)) / 2;
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
            make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
        }];
    } else if ([self.reuseIdentifier isEqualToString:NodeCellID]) {
        numberW = (DEVICE_WIDTH - ScreenScale(80)) / 2;
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    self.contentView.backgroundColor = self.contentView.superview.superview.backgroundColor;
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(Margin_10);
        make.top.equalTo(self.listBg.mas_top).offset(Margin_15);
        make.width.height.mas_equalTo(Margin_40);
    }];
    [self.listImageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.listImage);
        make.width.height.mas_equalTo(ScreenScale(58));
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listBg.mas_top).offset(Margin_20);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
        make.height.mas_equalTo(Margin_15);
//        make.right.mas_lessThanOrEqualTo(self.nodeType.mas_left).offset(-Margin_15);
    }];
    [self.moreOperations mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.listBg.mas_right).offset(-Margin_10);
        make.centerY.equalTo(self.name);
        make.height.mas_equalTo(Margin_30);
    }];
    [self.nodeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.name);
        make.height.mas_equalTo(ScreenScale(16));
        make.right.mas_lessThanOrEqualTo(self.moreOperations.mas_left).offset(-Margin_10);
        make.width.mas_equalTo([Encapsulation rectWithText:self.nodeType.text font:self.nodeType.font textHeight:ScreenScale(16)].size.width + Margin_10);
    }];
    [self.nodeType setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//    [self.manage setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.votesObtained mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.height.mas_equalTo(ScreenScale(16));
        make.top.equalTo(self.name.mas_bottom).offset(Margin_10);
        make.width.mas_equalTo(numberW);
//        make.right.mas_lessThanOrEqualTo(self.numberOfVotes.mas_left).offset(-Margin_10);
    }];
    [self.numberOfVotes mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(ScreenScale(100) + (DEVICE_WIDTH - ScreenScale(120)) / 2);
        make.left.mas_equalTo(ScreenScale(70) + numberW);
        make.top.width.equalTo(self.votesObtained);
//        make.right.mas_lessThanOrEqualTo(self.listBg.mas_right).offset(-Margin_10);
    }];
    [self.numberOfVotes setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
}
- (UIView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIView alloc] init];
        _listBg.backgroundColor = [UIColor whiteColor];
    }
    return _listBg;
}
- (UIImageView *)listImageBg
{
    if (!_listImageBg) {
        _listImageBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_bg_list"]];
    }
    return _listImageBg;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_list"]];
        [_listImage setViewSize:CGSizeMake(Margin_50, Margin_50) borderWidth:0 borderColor:nil borderRadius:Margin_25];
    }
    return _listImage;
}
- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = FONT_Bold(15);
        _name.textColor = TITLE_COLOR;
    }
    return _name;
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
- (UILabel *)votesObtained
{
    if (!_votesObtained) {
        _votesObtained = [[UILabel alloc] init];
        _votesObtained.font = FONT(12);
        _votesObtained.textColor = COLOR(@"B2B2B2");
    }
    return _votesObtained;
}
- (UILabel *)numberOfVotes
{
    if (!_numberOfVotes) {
        _numberOfVotes = [[UILabel alloc] init];
        _numberOfVotes.font = FONT(12);
        _numberOfVotes.textColor = COLOR(@"B2B2B2");
    }
    return _numberOfVotes;
}
- (UIButton *)moreOperations
{
    if (!_moreOperations) {
        _moreOperations = [UIButton createButtonWithNormalImage:@"more_operations" SelectedImage:@"more_operations" Target:self Selector:@selector(operationAction:)];
    }
    return _moreOperations;
}
- (void)operationAction:(UIButton *)button
{
    if (self.operationClick) {
        self.operationClick(button);
    }
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
