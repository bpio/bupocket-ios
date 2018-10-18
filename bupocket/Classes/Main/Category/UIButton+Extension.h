//
//  UIButton+Extension.h
//  ArtBridge
//
//  Created by 霍双双 on 17/7/14.
//  Copyright © 2017年 霍双双. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextColor:(UIColor *)textColor Target:(id)target Selector:(SEL)selector;

+ (UIButton *)createButtonWithNormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage Target:(id)target Selector:(SEL)selector;

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage Target:(id)target Selector:(SEL)selector;
+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalBackgroundImage:(NSString *)normalBackgroundImage SelectedBackgroundImage:(NSString *)selectedBackgroundImage Target:(id)target Selector:(SEL)selector;

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextColor:(UIColor *)textColor BackgroundImage:(NSString *)backgroundImage;
- (void)beginCountDownWithDuration:(NSTimeInterval)duration;

@end
