//
//  CooperateViewCell.m
//  bupocket
//
//  Created by huoss on 2019/4/4.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "CooperateViewCell.h"

@implementation CooperateViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    CooperateViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CooperateViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.listBg];
        [self.listBg addSubview:self.title];
        [self.listBg addSubview:self.numberOfCopies];
        [self.listBg addSubview:self.purchaseAmount];
        [self.listBg addSubview:self.supportPortion];
        [self.listBg addSubview:self.residualPortion];
        [self.listBg addSubview:self.progressView];
        [self.listBg addSubview:self.shareRatioBg];
        [self.shareRatioBg addSubview:self.shareRatioBtn];
        [self.shareRatioBg addSubview:self.shareRatio];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
    }];
    self.contentView.backgroundColor = self.contentView.superview.superview.backgroundColor;
    [self.shareRatioBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.listBg.mas_right).offset(-Margin_10);
        make.top.equalTo(self.listBg);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(100), ScreenScale(66)));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(Margin_10);
        make.top.equalTo(self.listBg.mas_top).offset(Margin_15);
        make.right.mas_lessThanOrEqualTo(self.shareRatioBg.mas_left).offset(-Margin_10);
    }];
    [self.numberOfCopies mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(Margin_10);
        make.left.right.equalTo(self.title);
    }];
    [self.purchaseAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberOfCopies.mas_bottom).offset(Margin_5);
        make.left.right.equalTo(self.title);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purchaseAmount.mas_bottom).offset(Margin_15);
        make.left.equalTo(self.title);
        make.right.equalTo(self.shareRatioBg);
    }];
    
    CGFloat residualPortionW = (DEVICE_WIDTH - Margin_50) / 5;
    [self.supportPortion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title);
        make.top.equalTo(self.progressView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(residualPortionW * 3, MAIN_HEIGHT));
    }];
    [self.residualPortion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareRatioBg);
        make.centerY.equalTo(self.supportPortion);
        make.width.mas_equalTo(residualPortionW * 2);
    }];
    [self.shareRatioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shareRatioBg.mas_left).offset(Margin_5);
        make.right.equalTo(self.shareRatioBg.mas_right).offset(-Margin_5);
        make.top.equalTo(self.shareRatioBg);
        make.height.mas_equalTo(Margin_30);
    }];
    [self.shareRatio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareRatioBtn.mas_bottom);
        make.left.right.equalTo(self.shareRatioBg);
    }];
}
- (void)setCooperateModel:(CooperateModel *)cooperateModel
{
    _cooperateModel = cooperateModel;
    self.title.text = cooperateModel.title;
    NSString * str = [NSString stringWithFormat:@"%@ %@%@", [NSString stringAmountSplitWith:cooperateModel.perAmount], @"BU/", Localized(@"Shares")];
    self.numberOfCopies.attributedText = [Encapsulation attrWithString:str preFont:FONT_Bold(18) preColor:MAIN_COLOR index:str.length - 4 sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:0];
    self.purchaseAmount.text = Localized(@"PurchaseAmount");
    if (NULLString(cooperateModel.totalCopies)) {
        NSString * supported = [NSString stringWithFormat:@"%lld", [cooperateModel.cobuildCopies longLongValue] - [cooperateModel.leftCopies longLongValue]];
        self.progressView.progress = [[[NSDecimalNumber decimalNumberWithString:supported] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:cooperateModel.cobuildCopies]] doubleValue];
    }
//    NSString * targetAmount = [NSString stringWithFormat:@"%lld", [cooperateModel.cobuildCopies longLongValue] * [cooperateModel.perAmount longLongValue]];
//    NSString * targetNumberStr = [NSString stringWithFormat:@"%@ %@ BU", Localized(@"SupportPortion"), [NSString stringAmountSplitWith:targetAmount]];
    NSString * support = [NSString stringWithFormat:@"%@ %lld %@", Localized(@"SupportPortion"), [cooperateModel.cobuildCopies longLongValue] - [cooperateModel.leftCopies longLongValue], Localized(@"Shares")];
    self.supportPortion.attributedText = [Encapsulation attrWithString:support preFont:FONT(13) preColor:COLOR(@"B2B2B2") index:Localized(@"SupportPortion").length sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:0];
    NSString * residualPortionStr = [NSString stringWithFormat:@"%@ %@ %@", Localized(@"ResidualPortion"), cooperateModel.leftCopies, Localized(@"Shares")];
    self.residualPortion.attributedText = [Encapsulation attrWithString:residualPortionStr preFont:FONT(13) preColor:COLOR(@"B2B2B2") index:Localized(@"ResidualPortion").length sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:0];
    _residualPortion.textAlignment = NSTextAlignmentRight;
    self.shareRatio.text = [NSString stringWithFormat:@"%@%%", cooperateModel.rewardRate];
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
- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = FONT_Bold(15);
        _title.textColor = TITLE_COLOR;
    }
    return _title;
}

- (UILabel *)numberOfCopies
{
    if (!_numberOfCopies) {
        _numberOfCopies = [[UILabel alloc] init];
        _numberOfCopies.textColor = MAIN_COLOR;
    }
    return _numberOfCopies;
}
- (UILabel *)purchaseAmount
{
    if (!_purchaseAmount) {
        _purchaseAmount = [[UILabel alloc] init];
        _purchaseAmount.font = FONT(12);
        _purchaseAmount.textColor = COLOR(@"B2B2B2");
    }
    return _purchaseAmount;
}
- (UILabel *)supportPortion
{
    if (!_supportPortion) {
        _supportPortion = [[UILabel alloc] init];
        _supportPortion.font = FONT(12);
    }
    return _supportPortion;
}
- (UILabel *)residualPortion
{
    if (!_residualPortion) {
        _residualPortion = [[UILabel alloc] init];
        _residualPortion.font = FONT(12);
    }
    return _residualPortion;
}
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = MAIN_COLOR;
        _progressView.trackTintColor = COLOR(@"E7E8EC");
        _progressView.progressViewStyle = UIProgressViewStyleBar;
    }
    return _progressView;
}
- (UIImageView *)shareRatioBg
{
    if (!_shareRatioBg) {
        _shareRatioBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"award_sharing_ratio_bg"]];
        _shareRatioBg.userInteractionEnabled = YES;
    }
    return _shareRatioBg;
}
- (CustomButton *)shareRatioBtn
{
    if (!_shareRatioBtn) {
        _shareRatioBtn = [[CustomButton alloc] init];
        _shareRatioBtn.layoutMode = HorizontalInverted;
        _shareRatioBtn.titleLabel.font = FONT(12);
        [_shareRatioBtn setTitle:Localized(@"AwardSharingRatio") forState:UIControlStateNormal];
        [_shareRatioBtn setImage:[UIImage imageNamed:@"award_sharing_ratio_info"] forState:UIControlStateNormal];
        [_shareRatioBtn addTarget:self action:@selector(shareRatioAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareRatioBtn;
}
- (UILabel *)shareRatio
{
    if (!_shareRatio) {
        _shareRatio = [[UILabel alloc] init];
        _shareRatio.font = FONT_Bold(21);
        _shareRatio.textColor = [UIColor whiteColor];
        _shareRatio.textAlignment = NSTextAlignmentCenter;
    }
    return _shareRatio;
}
- (void)shareRatioAction:(UIButton *)button
{
    if (self.shareRatioBtnClick) {
        self.shareRatioBtnClick(button);
    }
}
//- (void)setVotingRecordsModel:(VotingRecordsModel *)votingRecordsModel
//{
//    _votingRecordsModel = votingRecordsModel;
//
//    if ([votingRecordsModel.type isEqualToString:@"1"]) {
//        _recordType.backgroundColor = MAIN_COLOR;
//    } else if ([votingRecordsModel.type isEqualToString:@"2"]) {
//        self.recordType.selected = YES;
//        _recordType.backgroundColor = WARNING_COLOR;
//    }
//    self.title.text = votingRecordsModel.nodeName;
//    if ([votingRecordsModel.identityType isEqualToString:NodeType_Consensus]) {
//        self.nodeType.text = Localized(@"ConsensusNode");
//    } else if ([votingRecordsModel.identityType isEqualToString:NodeType_Ecological]) {
//        self.nodeType.text = Localized(@"EcologicalNodes");
//    }
//    self.number.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"Number"), votingRecordsModel.amount] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"Number").length sufFont:FONT(13) sufColor:TITLE_COLOR lineSpacing:Margin_5];
//    self.number.textAlignment = NSTextAlignmentLeft;
//    NSString * stateStr;
//    UIColor * stateColor;
//    if ([votingRecordsModel.status isEqualToString: @"0"]) {
//        stateStr = Localized(@"InProcessing");
//        stateColor = COLOR(@"FF7C14");
//    } else if ([votingRecordsModel.status isEqualToString:@"1"]) {
//        stateStr = Localized(@"Success");
//        stateColor = MAIN_COLOR;
//    } else if ([votingRecordsModel.status isEqualToString:@"2"]) {
//        stateStr = Localized(@"Failure");
//        stateColor = WARNING_COLOR;
//    }
//    self.state.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"State"),stateStr] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"State").length sufFont:FONT(13) sufColor:stateColor lineSpacing:Margin_5];
//    self.state.textAlignment = NSTextAlignmentLeft;
//    self.date.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"Time"), [DateTool getDateWithTimeStr:votingRecordsModel.date]] preFont:FONT(12) preColor:COLOR_9 index:Localized(@"Time").length sufFont:FONT(13) sufColor:TITLE_COLOR lineSpacing:Margin_5];
//    self.date.textAlignment = NSTextAlignmentRight;
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
