//
//  AssetsListViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsListViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * detailTitle;
@property (nonatomic, strong) UILabel * infoTitle;

@property (nonatomic, strong) AssetsListModel * listModel;

@end

NS_ASSUME_NONNULL_END
