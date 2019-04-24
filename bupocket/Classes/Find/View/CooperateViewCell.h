//
//  CooperateViewCell.h
//  bupocket
//
//  Created by huoss on 2019/4/4.
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
//@property (nonatomic, strong) UILabel * targetNumber;
@property (nonatomic, strong) UILabel * supportPortion;
@property (nonatomic, strong) UILabel * residualPortion;
@property (nonatomic, strong) UIProgressView * progressView;
//@property (nonatomic, strong) UIImageView * shareRatioBg;
//@property (nonatomic, strong) CustomButton * shareRatioBtn;
//@property (nonatomic, strong) UILabel * shareRatio;

//@property (nonatomic, copy) void (^shareRatioBtnClick)(UIButton * btn);

@end

NS_ASSUME_NONNULL_END
