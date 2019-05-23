//
//  CooperateViewCell.h
//  bupocket
//
//  Created by bupocket on 2019/4/4.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CooperateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CooperateViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) CooperateModel * cooperateModel;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * numberOfCopies;
@property (nonatomic, strong) UILabel * purchaseAmount;
@property (nonatomic, strong) UILabel * supportPortion;
@property (nonatomic, strong) UILabel * residualPortion;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UILabel * votingRatio;

@end

NS_ASSUME_NONNULL_END
