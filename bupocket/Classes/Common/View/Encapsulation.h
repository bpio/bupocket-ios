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
// Set line spacing and word spacing
+ (NSMutableAttributedString *)attrWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing;
// Setting Title Property text
+ (NSMutableAttributedString *)attrTitle:(NSString *)title ifRequired:(BOOL)ifRequired;
//将HTML字符串转化为NSAttributedString富文本字符串
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString;
// Calculate the width and height of UILabel (with row spacing)
+ (CGSize)getSizeSpaceLabelWithStr:(NSString *)str font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height lineSpacing:(CGFloat)lineSpacing;
// 标题   信息  取消  确认
+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString*)message cancelHandler:(void(^)(UIAlertAction * action))cancelHandler confirmHandler:(void(^)(UIAlertAction * action))confirmHandler;
// 标题   属性信息    取消  确认
//+ (void)showAlertControllerWithTitle:(NSString *)title messageAttr:(NSAttributedString *)messageAttr cancelHandler:(void(^)(UIAlertAction * action))cancelHandler confirmHandler:(void(^)(UIAlertAction * action))confirmHandler;
// 错误信息 我知道了
+ (void)showAlertControllerWithMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle;
// 标题：错误提示 错误信息居左 我知道了
+ (void)showAlertControllerWithErrorMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle;
// 标题   错误信息居左 我知道了
+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString*)message confirmHandler:(void(^)(UIAlertAction * action))confirmHandler;
+ (UIButton *)showNoDataWithTitle:(NSString *)title imageName:(NSString *)imageName superView:(UIView *)superView frame:(CGRect)frame;

#pragma mark - Connection server failed
+ (UIView *)showNoNetWorkWithSuperView:(UIView *)superView target:(id)target action:(SEL)action;

#pragma mark 多张图片合成一张
+ (UIImage *)mergedImageWithMainImage:(UIView *)mainImage;

@end
