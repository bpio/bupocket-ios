//
//  CFCycleScrollViewCell.h
//  CFCycleScrollView
//
//  Created by Peak on 17/2/23.
//  Copyright © 2017年 陈峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityAwardsModel.h"

@interface CFCycleScrollViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UILabel * dateLabel;
@property (nonatomic, strong) UILabel * amountLabel;
@property (nonatomic, strong) UIImageView * luckyImage;

@property (nonatomic, strong) ActivityAwardsModel * activityAwardsModel;

@end
