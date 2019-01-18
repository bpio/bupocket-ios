//
//  TextFieldViewCell.h
//  bupocket
//
//  Created by bupocket on 2019/1/10.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identifier:(NSString *)identifier;

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, copy) void (^textChange)(UITextField * textField);

@end

NS_ASSUME_NONNULL_END
