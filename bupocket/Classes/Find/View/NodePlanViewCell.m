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
static NSString * const NodeSharingID = @"NodeSharingID";

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
        if ([reuseIdentifier isEqualToString:NodePlanCellID]) {
            _listBg.layer.masksToBounds = YES;
            _listBg.layer.cornerRadius = BG_CORNER;
            [self setupMoreOperations];
        }
        
        [self.listBg addSubview:self.shareBtn];
    }
    return self;
}
- (void)setupMoreOperations
{
    [self.listBg addSubview:self.moreOperations];
    NSMutableArray * titles = [NSMutableArray arrayWithObjects:Localized(@"InvitationToVote"), Localized(@"VotingRecords"), Localized(@"CancellationOfVotes"), nil];
    NSMutableArray * icons = [NSMutableArray arrayWithObjects:@"invitationToVote", @"votingRecords", @"cancellationOfVotes", nil];
    CGFloat operationBtnW = (DEVICE_WIDTH - Margin_40) / titles.count;
    for (NSInteger i = 0; i < titles.count; i++) {
        CGFloat offsetY = i == 2 ? 1.5 : 0;
        CustomButton * operationBtn = [[CustomButton alloc] init];
        operationBtn.layoutMode = VerticalNormal;
        [operationBtn setTitle:titles[i] forState:UIControlStateNormal];
        [operationBtn setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        [operationBtn setTitleColor:COLOR_9 forState:UIControlStateNormal];
        operationBtn.titleLabel.font = FONT(13);
        [self.moreOperations addSubview:operationBtn];
        [operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_moreOperations).offset(offsetY);
            make.left.equalTo(self->_moreOperations.mas_left).offset(Margin_10 + operationBtnW * i);
            make.size.mas_equalTo(CGSizeMake(operationBtnW, ScreenScale(60)));
        }];
        if (i < 2) {
            UIView * lineView = [[UIView alloc] init];
            lineView.backgroundColor = LINE_COLOR;
            [_moreOperations addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.centerY.equalTo(operationBtn);
                make.size.mas_equalTo(CGSizeMake(LINE_WIDTH, Margin_25));
            }];
        }
        switch (i) {
            case 0:
                [operationBtn addTarget:self action:@selector(invitationVoteAction) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                [operationBtn addTarget:self action:@selector(votingRecordAction) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                [operationBtn addTarget:self action:@selector(cancellationVotesAction) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                break;
        }
    }
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
    } else if ([self.reuseIdentifier isEqualToString:NodeCellID] || [self.reuseIdentifier isEqualToString:NodeSharingID]) {
        numberW = (DEVICE_WIDTH - ScreenScale(80)) / 2;
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        if ([self.reuseIdentifier isEqualToString:NodeSharingID]) {
            
            [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.name);
                make.right.equalTo(self.listBg);
            }];
        }
    }
    self.contentView.backgroundColor = self.contentView.superview.superview.backgroundColor;
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(Margin_10);
        make.top.equalTo(self.listBg.mas_top).offset(Margin_15);
        make.width.height.mas_equalTo(Margin_40);
    }];
    [self.listImageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.listImage);
        make.width.height.mas_equalTo(ScreenScale(55));
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listBg.mas_top).offset(Margin_20);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_10);
        make.height.mas_equalTo(Margin_15);
    }];
    [self.nodeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.name);
        make.height.mas_equalTo(ScreenScale(16));
        make.width.mas_equalTo([Encapsulation rectWithText:self.nodeType.text font:self.nodeType.font textHeight:ScreenScale(16)].size.width + Margin_10);
    }];
    if ([self.reuseIdentifier isEqualToString:NodeSharingID]) {
        [self.nodeType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.shareBtn.mas_left).offset(-Margin_10);
        }];
    } else {
        [self.nodeType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.listBg.mas_right).offset(-Margin_10);
        }];
    }
    [self.nodeType setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.votesObtained mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name);
        make.height.mas_equalTo(ScreenScale(16));
        make.top.equalTo(self.name.mas_bottom).offset(Margin_10);
        make.width.mas_equalTo(numberW);
    }];
    [self.numberOfVotes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ScreenScale(70) + numberW);
        make.top.width.equalTo(self.votesObtained);
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
        _listImageBg = [[UIImageView alloc] init];
        _listImageBg.size = CGSizeMake(ScreenScale(55), ScreenScale(55));
        _listImageBg.image = [UIImage imageNamed:@"placeholder_bg_list"];
    }
    return _listImageBg;
}
- (UIImageView *)listImage
{
    if (!_listImage) {
        _listImage = [[UIImageView alloc] init];
        _listImage.size = CGSizeMake(Margin_40, Margin_40);
        _listImage.backgroundColor = [UIColor whiteColor];
        [_listImage setViewSize:_listImage.size borderWidth:0 borderColor:nil borderRadius:Margin_20];
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
- (UIView *)moreOperations
{
    if (!_moreOperations) {
        _moreOperations = [[UIView alloc] initWithFrame:CGRectMake(Margin_10, ScreenScale(80), DEVICE_WIDTH - Margin_40, ScreenScale(70))];
        [UIView setViewBorder:_moreOperations color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _moreOperations;
}
- (CustomButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [[CustomButton alloc] init];
        _shareBtn.layoutMode = HorizontalNormal;
        _shareBtn.titleLabel.font = FONT(14);
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"sharing_canvassing_bg"] forState:UIControlStateNormal];
        [_shareBtn setTitle:Localized(@"Share") forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"sharing_canvassing"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (void)invitationVoteAction
{
    if (self.invitationVoteClick) {
        self.invitationVoteClick();
    }
}
- (void)votingRecordAction
{
    if (self.votingRecordClick) {
        self.votingRecordClick();
    }
}
- (void)cancellationVotesAction
{
    if (self.cancellationVotesClick) {
        self.cancellationVotesClick();
    }
}
- (void)shareAction
{
    if (self.shareClick) {
        self.shareClick();
    }
}
- (void)setNodePlanModel:(NodePlanModel *)nodePlanModel
{
    _nodePlanModel = nodePlanModel;
    [self.listImage sd_setImageWithURL:[NSURL URLWithString:nodePlanModel.nodeLogo] placeholderImage:[UIImage imageNamed:@"placeholder_list"]];
    self.name.text = nodePlanModel.nodeName;
    if ([nodePlanModel.identityType isEqualToString:NodeType_Consensus]) {
        self.nodeType.text = Localized(@"ConsensusNode");
    } else if ([nodePlanModel.identityType isEqualToString:NodeType_Ecological]) {
        self.nodeType.text = Localized(@"EcologicalNodes");
    }
    if ([self.reuseIdentifier isEqualToString:NodeSharingID]) {
        NSString * votesObtainedStr = [NSString stringWithFormat:@"%@ %@", nodePlanModel.nodeVote, Localized(@"Votes")];
        self.votesObtained.attributedText = [Encapsulation attrWithString:votesObtainedStr preFont:FONT(14) preColor:COLOR_6 index:votesObtainedStr.length - Localized(@"Votes").length sufFont:FONT(12) sufColor:COLOR(@"B2B2B2") lineSpacing:0];
        self.numberOfVotes.text = [NSString stringWithFormat:@"%@%@", nodePlanModel.support, Localized(@"SupportNumber")];
    } else {
        self.votesObtained.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", Localized(@"VotesObtained"), nodePlanModel.nodeVote] preFont:FONT(12) preColor:COLOR(@"B2B2B2") index:Localized(@"VotesObtained").length sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:0];
        self.numberOfVotes.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", Localized(@"NumberOfVotes"), nodePlanModel.myVoteCount] preFont:FONT(12) preColor:COLOR(@"B2B2B2") index:Localized(@"NumberOfVotes").length sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:0];
    }
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
