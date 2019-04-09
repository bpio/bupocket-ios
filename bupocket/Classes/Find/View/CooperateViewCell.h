//
//  CooperateViewCell.h
//  bupocket
//
//  Created by huoss on 2019/4/4.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CooperateViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * numberOfCopies;
@property (nonatomic, strong) UILabel * purchaseAmount;
@property (nonatomic, strong) UILabel * targetNumber;
@property (nonatomic, strong) UILabel * residualPortion;
@property (nonatomic, strong) UIProgressView * proportion;
@property (nonatomic, strong) UIImageView * shareRatioBg;
@property (nonatomic, strong) CustomButton * shareRatioBtn;
@property (nonatomic, strong) UILabel * shareRatio;

@property (nonatomic, copy) void (^shareRatioBtnClick)(UIButton * btn);

@end

NS_ASSUME_NONNULL_END