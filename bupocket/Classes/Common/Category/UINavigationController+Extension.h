//
//  UINavigationController+Extension.h
//  bupocket
//
//  Created by bubi on 2018/11/6.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Extension)<UINavigationBarDelegate>

- (UIStatusBarStyle)preferredStatusBarStyle;

@end

@interface UIViewController (Extension)

// Transparency of navigation bar
@property (nonatomic, assign) CGFloat navAlpha;

// Navigation bar background color
@property (null_resettable, nonatomic, strong) UIColor * navBackgroundColor;

// item font color
@property (null_resettable, nonatomic, strong) UIColor * navTintColor;

// title font color
@property (null_resettable, nonatomic, strong) UIColor * navTitleColor;

@end


NS_ASSUME_NONNULL_END
