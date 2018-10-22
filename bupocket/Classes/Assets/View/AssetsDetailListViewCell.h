//
//  AssetsDetailListViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetsDetailListViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UILabel * purseAddress;
@property (nonatomic, strong) UILabel * date;
@property (nonatomic, strong) UILabel * assets;
@property (nonatomic, strong) UILabel * state;

@end

NS_ASSUME_NONNULL_END
