//
//  AddAssetsViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchAssetsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddAssetsViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) SearchAssetsModel * searchAssetsModel;

@property (nonatomic, strong) UIImageView * listImageBg;
@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * detailTitle;
@property (nonatomic, strong) UILabel * infoTitle;
@property (nonatomic, strong) UISwitch * switchControl;
@property (nonatomic, strong) UIView * lineView;

@end

NS_ASSUME_NONNULL_END
