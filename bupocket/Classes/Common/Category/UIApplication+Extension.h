//
//  UIApplication+Extension.h
//  bupocket
//
//  Created by bupocket on 2018/10/20.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Extension)

+ (UIViewController *)topViewController:(UIViewController *)baseViewController;

@end

NS_ASSUME_NONNULL_END
