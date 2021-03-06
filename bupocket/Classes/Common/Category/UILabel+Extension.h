//
//  UILabel+Extension.h
//  bupocket
//
//  Created by bupocket on 2019/1/2.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Extension)

@property (nonatomic, assign) BOOL copyable;

// COLOR_6  FONT_15
+ (UILabel *)createTitleLabel;

@end

NS_ASSUME_NONNULL_END
