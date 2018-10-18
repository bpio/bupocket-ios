//
//  AssetsListViewCell.h
//  BUMO
//
//  Created by bubi on 2018/10/17.
//  Copyright © 2018年 bubi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetsListViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * detailTitle;
@property (nonatomic, strong) UILabel * infoTitle;

@end

NS_ASSUME_NONNULL_END
