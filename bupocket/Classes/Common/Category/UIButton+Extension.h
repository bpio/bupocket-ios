//
//  UIButton+Extension.h
//  bupocket
//
//  Created by bupocket on 17/7/14.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor Target:(id)target Selector:(SEL)selector;

+ (UIButton *)createButtonWithNormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage Target:(id)target Selector:(SEL)selector;

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage Target:(id)target Selector:(SEL)selector;
+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalBackgroundImage:(NSString *)normalBackgroundImage SelectedBackgroundImage:(NSString *)selectedBackgroundImage Target:(id)target Selector:(SEL)selector;
// Button
+ (UIButton *)createButtonWithTitle:(NSString *)title isEnabled:(BOOL)isEnabled Target:(id)target Selector:(SEL)selector;
// Nav_Button
+ (UIButton *)createNavButtonWithTitle:(NSString *)title Target:(id)target Selector:(SEL)selector;

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextColor:(UIColor *)textColor BackgroundImage:(NSString *)backgroundImage;

- (void)beginCountDownWithDuration:(NSTimeInterval)duration;

@end
