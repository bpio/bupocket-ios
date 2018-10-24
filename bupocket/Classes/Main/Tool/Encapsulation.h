//
//  Encapsulation.h
//  Game News
//
//  Created by bupocket on 16/2/3.
//  Copyright © 2016年 huoss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Encapsulation : UIView

// 设置label的自适应宽度
+ (CGRect)rectWithText:(NSString *)text fontSize:(CGFloat)fontSize textWidth:(CGFloat)textWidth;
// 设置label的自适应高度
+ (CGRect)rectWithText:(NSString *)text fontSize:(CGFloat)fontSize textHeight:(CGFloat)textHeight;
// 设置行间距和字间距
+ (NSMutableAttributedString *)attrWithString:(NSString *)str preFont:(UIFont *)preFont preColor:(UIColor *)preColor index:(NSInteger)index sufFont:(UIFont *)sufFont sufColor:(UIColor *)sufColor lineSpacing:(CGFloat)lineSpacing;
//计算UILabel的宽度、高度(带有行间距的情况)
+ (CGSize)getSizeSpaceLabelWithStr:(NSString *)str font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height lineSpacing:(CGFloat)lineSpacing;

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString*)message;

+ (UIButton *)showNoTransactionRecordWithSuperView:(UIView *)superView frame:(CGRect)frame;
// 时间戳转时间
+ (NSString *)getDateStringWithTimeStr:(NSString *)str;

@end
