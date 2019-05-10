//
//  CooperateDetailViewCell.h
//  bupocket
//
//  Created by bupocket on 2019/4/24.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CooperateDetailViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * infoTitle;

@property (nonatomic, strong) UIButton * stateBtn;
//@property (nonatomic, strong) CustomButton * shareRatioBtn;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UILabel * votingRatio;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) CustomButton * bondButton;
//@property (nonatomic, strong) UIView * riskStatementBg;
@property (nonatomic, strong) UIButton * riskStatementBtn;

@end

NS_ASSUME_NONNULL_END
