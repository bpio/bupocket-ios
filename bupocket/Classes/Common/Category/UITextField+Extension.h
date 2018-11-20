//
//  UITextField+Extension.h
//  ArtBridge
//
//  Created by bupocket on 17/7/7.
//  Copyright © 2017年 xinghe.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

+ (UITextField *)textFieldTitleLabelText:(NSString *)titleLabelText placeholder:(NSString *)placeholder titleLabelHeight:(CGFloat)titleLabelHeight lineViewHidden:(BOOL)lineViewHidden;
+ (UITextField *)textFieldLeftImage:(NSString *)leftImage leftText:(NSString *)leftText placeholder:(NSString *)placeholder titleFieldHeight:(CGFloat)titleFieldHeight lineViewHidden:(BOOL)lineViewHidden;

+ (UITextField *)textFieldWithLeftImage:(NSString *)leftImage leftText:(NSString *)leftText placeholder:(NSString *)placeholder buttonTitle:(NSString *)title NormalImage:(NSString *)normalImage SelectedImage:(NSString *)SelectedImage Target:(id)target Selector:(SEL)selector titleFieldHeight:(CGFloat)titleFieldHeight;

+ (UITextField *)textFieldTitleLabelText:(NSString *)titleLabelText placeholder:(NSString *)placeholder buttonTitle:(NSString *)title titleFieldHeight:(CGFloat)titleFieldHeight NormalImage:(NSString *)normalImage SelectedImage:(NSString *)SelectedImage Target:(id)target Selector:(SEL)selector lineViewHidden:(BOOL)lineViewHidden;

+ (UITextField *)textFieldTitleLabel:(UILabel *)titleLabel text:(NSString *)text titleLabelHeight:(CGFloat)titleLabelHeight lineViewHidden:(BOOL)lineViewHidden;

+ (UITextField *)textFieldWithplaceholder:(NSString *)placeholder;

@end
