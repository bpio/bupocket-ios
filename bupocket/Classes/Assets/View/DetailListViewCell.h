//
//  DetailListViewCell.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailListViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UIView * detailBg;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * infoTitle;

@end

NS_ASSUME_NONNULL_END
