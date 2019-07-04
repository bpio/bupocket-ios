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

typedef NS_ENUM(NSInteger, TextFieldCellType) {
    TextFieldCellDefault,
    TextFieldCellPWDefault,
    TextFieldCellNormal, // 圆角
    TextFieldCellPWNormal,
    TextFieldCellAddress // 扫一扫 地址簿
};

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(TextFieldCellType)cellType;

@property (nonatomic, strong) UIView * listBg;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIButton * scan;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, copy) void (^textChange)(UITextField * textField);

@property (nonatomic, copy) void (^scanClick)(void);
@property (nonatomic, copy) void (^addressListClick)(void);


@end

NS_ASSUME_NONNULL_END
