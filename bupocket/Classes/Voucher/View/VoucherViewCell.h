//
//  VoucherViewCell.h
//  bupocket
//
//  Created by huoss on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoucherViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UIImageView * listBg;
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * name;
@property (nonatomic, strong) UIImageView * listImage;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * value;
@property (nonatomic, strong) UILabel * number;
@property (nonatomic, strong) UILabel * date;


@end

NS_ASSUME_NONNULL_END
