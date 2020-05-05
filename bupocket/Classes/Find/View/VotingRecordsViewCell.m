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
        self.backgroundColor = self.contentView.superview.backgroundColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat width = (DEVICE_WIDTH - ScreenScale(50)) / 6;
    CGFloat width = (View_Width_Main - Margin_30) / 6;
    [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
//        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_Main);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_Main);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
    }];
    CGFloat recordTypeW = [Encapsulation rectWithText:self.recordType.titleLabel.text font:self.recordType.titleLabel.font textHeight:ScreenScale(18)].size.width + Margin_5;
    [self.recordType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(Margin_10);
        make.top.equalTo(self.listBg.mas_top).offset(Margin_15);
        make.size.mas_equalTo(CGSizeMake(recordTypeW, ScreenScale(18)));
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
        make.width.mas_equalTo(width * 1.8);
    }];
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.number.mas_right).offset(Margin_5);
        make.centerY.equalTo(self.number);
        make.width.mas_equalTo(width * 1.2);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.state.mas_right).offset(Margin_5);
        make.centerY.equalTo(self.number);
        make.width.mas_equalTo(width * 3);
    }];
}
- (UIView *)listBg
{
    if (!_listBg) {
        _listBg = [[UIView alloc] init];
        _listBg.backgroundColor = WHITE_BG_COLOR;
        [_listBg setViewSize:CGSizeMake(View_Width_Main, ScreenScale(105)) borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
    }
    return _listBg;
}
- (UIButton *)recordType
{
    if (!_recordType) {
        _recordType = [UIButton createButtonWithTitle:Localized(@"Throw") TextFont:FONT_13 TextNormalColor:WHITE_BG_COLOR TextSelectedColor:WHITE_BG_COLOR Target:nil Selector:nil];
        _recordType.backgroundColor = MAIN_COLOR;
        [_recordType setTitle:Localized(@"withdraw") forState:UIControlStateSelected];
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
        _nodeType.textColor = NODE_TYPE_TEXT_COLOR;
        _nodeType.backgroundColor = TYPEBG_COLOR;
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
- (void)setVotingRecordsModel:(VotingRecordsModel *)votingRecordsModel
{
    _votingRecordsModel = votingRecordsModel;
    
    if ([votingRecordsModel.type integerValue] == VoteTypeThrow) {
        _recordType.backgroundColor = MAIN_COLOR;
    } else if ([votingRecordsModel.type integerValue] == VoteTypeWithdraw) {
        self.recordType.selected = YES;
        _recordType.backgroundColor = WARNING_COLOR;
    }
    if (![self.reuseIdentifier isEqualToString:NodeRecordsCellID]) {
        self.title.text = votingRecordsModel.nodeName;
    }
    if ([votingRecordsModel.identityType integerValue] == NodeIdentityConsensus) {
        self.nodeType.text = Localized(@"ConsensusNode");
    } else if ([votingRecordsModel.identityType integerValue] == NodeIdentityEcological) {
        self.nodeType.text = Localized(@"EcologicalNodes");
    }
    self.number.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"Value"), votingRecordsModel.amount] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"Value").length sufFont:FONT(13) sufColor:TITLE_COLOR lineSpacing:LINE_SPACING];
    self.number.textAlignment = NSTextAlignmentLeft;
    NSString * stateStr;
    UIColor * stateColor;
    if ([votingRecordsModel.status integerValue] == VoteStatusInProcessing) {
        stateStr = Localized(@"InProcessing");
        stateColor = VOTE_PROCESSING_COLOR;
    } else if ([votingRecordsModel.status integerValue] == VoteStatusSuccess) {
        stateStr = Localized(@"Success");
        stateColor = MAIN_COLOR;
    } else if ([votingRecordsModel.status integerValue] == VoteStatusFailure) {
        stateStr = Localized(@"Failure");
        stateColor = WARNING_COLOR;
    }
    self.state.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"State"),stateStr] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"State").length sufFont:FONT(13) sufColor:stateColor lineSpacing:LINE_SPACING];
    self.state.textAlignment = NSTextAlignmentLeft;
    self.date.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"Time"), votingRecordsModel.date] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"Time").length sufFont:FONT(13) sufColor:TITLE_COLOR lineSpacing:LINE_SPACING];
    self.date.textAlignment = NSTextAlignmentRight;
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
