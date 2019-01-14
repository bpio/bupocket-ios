//
//  Encapsulation.h
//  Game News
//
//  Created by bupocket on 16/2/3.
//  Copyright © 2016年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Encapsulation : UIView

// 设置label的自适应宽度
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textWidth;
// 设置label的自适应高度
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font textHeight:(CGFloat)textHeight;
// 设置行间距和字间距
+ (NSMutableAttributedString *)attrWithString:(NSString *)str preFont:(UIFont *)preFont preColor:(UIColor *)preColor index:(NSInteger)index sufFont:(UIFont *)sufFont sufColor:(UIColor *)sufColor lineSpacing:(CGFloat)lineSpacing;
// 设置标题属性文字
+ (NSMutableAttributedString *)attrTitle:(NSString *)title ifRequired:(BOOL)ifRequired;
//计算UILabel的宽度、高度(带有行间距的情况)
+ (CGSize)getSizeSpaceLabelWithStr:(NSString *)str font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height lineSpacing:(CGFloat)lineSpacing;

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString*)message cancelHandler:(void(^)(UIAlertAction * action))cancelHandler confirmHandler:(void(^)(UIAlertAction * action))confirmHandler;
+ (void)showAlertControllerWithMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle;

+ (UIButton *)showNoDataWithTitle:(NSString *)title imageName:(NSString *)imageName superView:(UIView *)superView frame:(CGRect)frame;

#pragma mark 连接服务器失败
+ (UIView *)showNoNetWorkWithSuperView:(UIView *)superView target:(id)target action:(SEL)action;

@end
