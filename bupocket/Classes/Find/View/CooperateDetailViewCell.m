//
//  CooperateDetailViewCell.m
//  bupocket
//
//  Created by huoss on 2019/4/24.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "CooperateDetailViewCell.h"

@implementation CooperateDetailViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    CooperateDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CooperateDetailViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.infoTitle];
        
        [self.contentView addSubview:self.stateBtn];
//        [self.contentView addSubview:self.shareRatioBtn];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.bondButton];
//        [self.contentView addSubview:self.riskStatementBg];
        [self.contentView addSubview:self.riskStatementBtn];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView * leftView;
    UIView * rightView;
    if (self.title.text) {
        leftView = self.title;
        if (self.bondButton.hidden == YES && self.stateBtn.hidden == YES) {
            [self.title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        }
    }
    if (self.infoTitle.text) {
        rightView = self.infoTitle;
    }
    if (self.stateBtn.hidden == NO) {
        rightView = self.stateBtn;
        [self.stateBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    if (self.bondButton.hidden == NO) {
        leftView = self.bondButton;
        [self.bondButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.top.bottom.equalTo(self.contentView);
    }];
    [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
    }];
    if (rightView) {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(rightView.mas_left).offset(-Margin_10);
        }];
    } else {
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-Margin_10);
        }];
    }
    if (leftView) {
        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(leftView.mas_right).offset(Margin_10);
        }];
    } else {
        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(self.contentView.mas_left).offset(Margin_10);
        }];
    }
    
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.contentView);
    }];
    
//    [self.shareRatioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.contentView);
//        make.right.equalTo(self.infoTitle);
//    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
        make.left.equalTo(self.title);
        make.right.equalTo(self.infoTitle);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Margin_15);
        make.left.right.equalTo(self.lineView);
    }];
    [self.bondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-Margin_5);
        make.left.equalTo(self.title);
    }];
    
    if (self.bondButton.hidden == NO) {
        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bondButton);
        }];
    } else {
        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.title);
        }];
    }
    
//    [self.riskStatementBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    [self.riskStatementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(Margin_10);
        make.right.equalTo(self.contentView.mas_right).offset(-Margin_10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Margin_5);
    }];
//    if (self.title.text) {
//        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_greaterThanOrEqualTo(self.title.mas_right).offset(Margin_10);
//        }];
//    } else {
//        [self.infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_greaterThanOrEqualTo(self.contentView.mas_left).offset(Margin_10);
//        }];
//    }
//    if (self.infoTitle.text) {
//        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_lessThanOrEqualTo(self.infoTitle.mas_left).offset(-Margin_10);
//        }];
//    } else {
//        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_lessThanOrEqualTo(self.contentView.mas_left).offset(-Margin_10);
//        }];
//    }
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
- (UILabel *)infoTitle
{
    if (!_infoTitle) {
        _infoTitle = [[UILabel alloc] init];
        _infoTitle.font = FONT(13);
        _infoTitle.textColor = TITLE_COLOR;
    }
    return _infoTitle;
}
- (UIButton *)stateBtn
{
    if (!_stateBtn) {
        _stateBtn = [UIButton createButtonWithTitle:Localized(@"InProgress") TextFont:14 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] NormalBackgroundImage:@"cooperate_state" SelectedBackgroundImage:@"cooperate_state_s" Target:nil Selector:nil];
        [_stateBtn setTitle:Localized(@"Completed") forState:UIControlStateSelected];
        [_stateBtn setTitle:Localized(@"Quit") forState:UIControlStateDisabled];
        [_stateBtn setBackgroundImage:[UIImage imageNamed:@"cooperate_state_s"] forState:UIControlStateDisabled];
        _stateBtn.hidden = YES;
    }
    return _stateBtn;
}
/*
- (CustomButton *)shareRatioBtn
{
    if (!_shareRatioBtn) {
        _shareRatioBtn = [[CustomButton alloc] init];
        _shareRatioBtn.layoutMode = HorizontalInverted;
        _shareRatioBtn.titleLabel.font = FONT(12);
        [_shareRatioBtn setTitle:Localized(@"AwardSharingRatio") forState:UIControlStateNormal];
        [_shareRatioBtn setImage:[UIImage imageNamed:@"interdependent_node_explain"] forState:UIControlStateNormal];
        [_shareRatioBtn setTitleColor:COLOR(@"B2B2B2") forState:UIControlStateNormal];
        _shareRatioBtn.hidden = YES;
    }
    return _shareRatioBtn;
}
 */
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = MAIN_COLOR;
        _progressView.trackTintColor = COLOR(@"E7E8EC");
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        _progressView.hidden = YES;
    }
    return _progressView;
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
- (CustomButton *)bondButton
{
    if (!_bondButton) {
        _bondButton = [[CustomButton alloc] init];
        _bondButton.layoutMode = HorizontalInverted;
        _bondButton.titleLabel.font = FONT(13);
        [_bondButton setTitleColor:COLOR_6 forState:UIControlStateNormal];
        [_bondButton setTitle:Localized(@"Bond") forState:UIControlStateNormal];
        [_bondButton setImage:[UIImage imageNamed:@"interdependent_node_explain"] forState:UIControlStateNormal];
        _bondButton.hidden = YES;
    }
    return _bondButton;
}
- (UIButton *)riskStatementBtn
{
    if (!_riskStatementBtn) {
        _riskStatementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _riskStatementBtn.titleLabel.numberOfLines = 0;
        _riskStatementBtn.backgroundColor = [UIColor whiteColor];
        _riskStatementBtn.layer.masksToBounds = YES;
        _riskStatementBtn.layer.cornerRadius = BG_CORNER;
        _riskStatementBtn.contentEdgeInsets = UIEdgeInsetsMake(Margin_5, Margin_10, Margin_5, Margin_10);
        [_riskStatementBtn setAttributedTitle:[Encapsulation attrWithString:Localized(@"RiskStatementPrompt") preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:5.0] forState:UIControlStateNormal];
        _riskStatementBtn.hidden = YES;
    }
    return _riskStatementBtn;
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
