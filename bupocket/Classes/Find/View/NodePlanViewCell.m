//
//  NodePlanViewCell.m
//  bupocket
//
//  Created by bupocket on 2019/3/21.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodePlanViewCell.h"

@implementation NodePlanViewCell

static NSString * const NodeCellID = @"NodeCellID";
static NSString * const NodeDetailID = @"NodeDetailID";

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
        [self.listBg addSubview:self.slogan];
        [self.bottomBg addSubview:self.votesObtained];
        [self.bottomBg addSubview:self.numberOfVotes];
        if ([reuseIdentifier isEqualToString:NodeCellID]) {
            [self.listBg setViewSize:CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(130)) borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
            [self.listBg addSubview:self.bottomBg];
//            self.listBg.layer.masksToBounds = YES;
//            self.listBg.layer.cornerRadius = BG_CORNER;
//            [self setupMoreOperations];
        } else if ([self.reuseIdentifier isEqualToString:NodeDetailID]) {
            self.name.numberOfLines = 2;
            self.slogan.numberOfLines = 0;
        }
        self.backgroundColor = self.contentView.superview.backgroundColor;
    }
    return self;
}
/*
- (void)setupMoreOperations
{
    [self.listBg addSubview:self.moreOperations];
    NSMutableArray * titles = [NSMutableArray arrayWithObjects:Localized(@"InvitationToVote"), Localized(@"VotingRecords"), Localized(@"CancellationOfVotes"), nil];
    NSMutableArray * icons = [NSMutableArray arrayWithObjects:@"invitationToVote", @"votingRecords", @"cancellationOfVotes", nil];
    CGFloat operationBtnW = (DEVICE_WIDTH - Margin_20) / titles.count;
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
            make.left.equalTo(self->_moreOperations.mas_left).offset(operationBtnW * i);
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
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat numberW = 0;
    CGFloat marginW = Margin_10;
    if ([self.reuseIdentifier isEqualToString:NodeCellID]) {
//        numberW = (DEVICE_WIDTH - ScreenScale(100)) / 2;
        numberW = (DEVICE_WIDTH - ScreenScale(50)) / 2;
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
            make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
            make.top.equalTo(self.contentView.mas_top).offset(Margin_5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
        }];
        [self.votesObtained mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.bottomBg);
            //        make.height.mas_equalTo(ScreenScale(16));
            //        make.top.equalTo(self.name.mas_bottom).offset(Margin_10);
            make.width.mas_lessThanOrEqualTo(numberW);
        }];
        [self.numberOfVotes mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.left.mas_equalTo(ScreenScale(70) + numberW);
            //        make.top.width.equalTo(self.votesObtained);
            make.right.top.bottom.equalTo(self.bottomBg);
            make.width.mas_lessThanOrEqualTo(numberW);
        }];
    } else if ([self.reuseIdentifier isEqualToString:NodeDetailID]) {
//        numberW = (DEVICE_WIDTH - ScreenScale(80)) / 2;
        marginW = Margin_Main;
        [self.listBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    
//    self.contentView.backgroundColor = VIEWBG_COLOR;
    [self.listImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listBg.mas_left).offset(marginW);
        make.top.equalTo(self.listBg.mas_top).offset(Margin_15);
        make.width.height.mas_equalTo(Margin_40);
    }];
    [self.listImageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.listImage);
        make.width.height.mas_equalTo(ScreenScale(53));
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.listBg.mas_top).offset(Margin_20);
        make.top.equalTo(self.listImage.mas_top);
        make.left.equalTo(self.listImage.mas_right).offset(Margin_15);
    }];
    [self.nodeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(Margin_10);
        make.centerY.equalTo(self.name);
        make.size.mas_equalTo(self.nodeType.size);
        make.right.mas_lessThanOrEqualTo(self.listBg.mas_right).offset(- marginW);
//        make.height.mas_equalTo(ScreenScale(16));
//        make.width.mas_equalTo();
    }];
    [self.nodeType setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.slogan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(Margin_10);
        make.left.equalTo(self.name);
        make.right.equalTo(self.listBg.mas_right).offset(-marginW);
    }];
    
//    [self.numberOfVotes setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
        _listImageBg.size = CGSizeMake(ScreenScale(53), ScreenScale(53));
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
        _listImage.contentMode = UIViewContentModeScaleAspectFill;
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
        _nodeType.textColor = COLOR(@"B2B2B2");
        _nodeType.backgroundColor = TYPEBG_COLOR;
        _nodeType.layer.masksToBounds = YES;
        _nodeType.layer.cornerRadius = TAG_CORNER;
        _nodeType.textAlignment = NSTextAlignmentCenter;
    }
    return _nodeType;
}
- (UILabel *)slogan
{
    if (!_slogan) {
        _slogan = [[UILabel alloc] init];
        _slogan.font = FONT_13;
        _slogan.textColor = COLOR_9;
    }
    return _slogan;
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
        _moreOperations = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenScale(80), DEVICE_WIDTH - Margin_20, ScreenScale(70))];
        [UIView setViewBorder:_moreOperations color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _moreOperations;
}
- (UIView *)bottomBg
{
    if (!_bottomBg) {
        _bottomBg = [[UIView alloc] initWithFrame:CGRectMake(Margin_10, ScreenScale(85), DEVICE_WIDTH - Margin_40, MAIN_HEIGHT)];
        [UIView setViewBorder:_bottomBg color:LINE_COLOR border:LINE_WIDTH type:UIViewBorderLineTypeTop];
    }
    return _bottomBg;
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
- (void)setNodePlanModel:(NodePlanModel *)nodePlanModel
{
    _nodePlanModel = nodePlanModel;
    NSString * url;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        url = [defaults objectForKey:Server_Custom];
    } else if ([defaults boolForKey:If_Switch_TestNetwork] == YES) {
        url = WEB_SERVER_DOMAIN_TEST;
    } else {
        url = WEB_SERVER_DOMAIN;
    }
    NSString * imageUrl = [NSString stringWithFormat:@"%@%@%@", url, Node_Image_URL, nodePlanModel.nodeLogo];
    [self.listImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder_list"]];
    self.name.text = nodePlanModel.nodeName;
    if ([nodePlanModel.identityType integerValue] == NodeIDTypeConsensus) {
        self.nodeType.text = Localized(@"ConsensusNode");
    } else if ([nodePlanModel.identityType integerValue] == NodeIDTypeEcological) {
        self.nodeType.text = Localized(@"EcologicalNodes");
    }
    CGSize typeMaximumSize = CGSizeMake(CGFLOAT_MAX, ScreenScale(16));
    CGSize typeExpectSize = [self.nodeType sizeThatFits:typeMaximumSize];
//    CGFloat nodeTypeW = [Encapsulation rectWithText:self.nodeType.text font:self.nodeType.font textHeight:ScreenScale(16)].size.width + Margin_10;
    self.nodeType.size = CGSizeMake(typeExpectSize.width + Margin_10, typeExpectSize.height);
    
    self.slogan.text = nodePlanModel.slogan;
    NSString * vote = Localized(@"Votes");
    if ([nodePlanModel.nodeVote longLongValue] < 2) {
        vote = Localized(@"Vote");
    }
    self.votesObtained.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", vote, [NSString stringAmountSplitWith:nodePlanModel.nodeVote]] preFont:FONT(12) preColor:COLOR(@"B2B2B2") index:vote.length sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:0];
    NSString * myVote = Localized(@"My votes");
    if ([nodePlanModel.myVoteCount longLongValue] < 2) {
        myVote = Localized(@"My vote");
    }
    self.numberOfVotes.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@ %@", myVote, [NSString stringAmountSplitWith:nodePlanModel.myVoteCount]] preFont:FONT(12) preColor:COLOR(@"B2B2B2") index:myVote.length sufFont:FONT(14) sufColor:COLOR_6 lineSpacing:0];
    if ([self.reuseIdentifier isEqualToString:NodeDetailID]) {
//        CGFloat nameW = DEVICE_WIDTH - (ceil([Encapsulation rectWithText:self.nodeType.text font:self.nodeType.font textHeight:ScreenScale(16)].size.width) + 1 + Margin_10) - ScreenScale(80);
        CGFloat nameW = DEVICE_WIDTH - self.nodeType.size.width - ScreenScale(95);
        CGSize nameMaximumSize = CGSizeMake(nameW, CGFLOAT_MAX);
        CGSize nameExpectSize = [self.name sizeThatFits:nameMaximumSize];
        self.name.size = nameExpectSize;
        
        CGFloat sloganW = DEVICE_WIDTH - ScreenScale(85);
        CGSize sloganMaximumSize = CGSizeMake(sloganW, CGFLOAT_MAX);
        CGSize sloganExpectSize = [self.slogan sizeThatFits:sloganMaximumSize];
        self.slogan.size = sloganExpectSize;
        nodePlanModel.cellHeight = Margin_40 + nameExpectSize.height + sloganExpectSize.height;
//        nodePlanModel.cellHeight = ceil([Encapsulation rectWithText:self.name.text font:self.name.font textWidth:nameW].size.height) + 1 + ScreenScale(60);
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
