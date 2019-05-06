//
//  Encapsulation.h
//  Game News
//
//  Created by bupocket on 16/2/3.
//  Copyright © 2016年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Encapsulation : UIView

// Setting the adaptive width of label
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textWidth;
// Setting the adaptive height of label
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font textHeight:(CGFloat)textHeight;
// Set line spacing and word spacing
+ (NSMutableAttributedString *)attrWithString:(NSString *)str preFont:(UIFont *)preFont preColor:(UIColor *)preColor index:(NSInteger)index sufFont:(UIFont *)sufFont sufColor:(UIColor *)sufColor lineSpacing:(CGFloat)lineSpacing;
// Setting Title Property text
+ (NSMutableAttributedString *)attrTitle:(NSString *)title ifRequired:(BOOL)ifRequired;
//将HTML字符串转化为NSAttributedString富文本字符串
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString;
// Calculate the width and height of UILabel (with row spacing)
+ (CGSize)getSizeSpaceLabelWithStr:(NSString *)str font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height lineSpacing:(CGFloat)lineSpacing;

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString*)message cancelHandler:(void(^)(UIAlertAction * action))cancelHandler confirmHandler:(void(^)(UIAlertAction * action))confirmHandler;
+ (void)showAlertControllerWithMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle;
+ (void)showAlertViewWithMessage:(NSString *)message;
+ (UIButton *)showNoDataWithTitle:(NSString *)title imageName:(NSString *)imageName superView:(UIView *)superView frame:(CGRect)frame;

#pragma mark - Connection server failed
+ (UIView *)showNoNetWorkWithSuperView:(UIView *)superView target:(id)target action:(SEL)action;

@end
