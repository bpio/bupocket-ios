//
//  NodeTransferSuccessViewCell.h
//  bupocket
//
//  Created by huoss on 2019/4/13.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeTransferSuccessViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * detail;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
