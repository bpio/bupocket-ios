//
//  StatusViewCell.h
//  bupocket
//
//  Created by huoss on 2019/8/26.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatusViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UILabel * date;
@property (nonatomic, strong) UIButton * spot;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
