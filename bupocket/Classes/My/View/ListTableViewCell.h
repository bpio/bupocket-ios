//
//  MyListViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * detailTitle;
@property (nonatomic, strong) UIImageView * detailImage;

@end

NS_ASSUME_NONNULL_END
