//
//  InfoViewCell.h
//  bupocket
//
//  Created by huoss on 2019/7/22.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIButton * info;

@end

NS_ASSUME_NONNULL_END
