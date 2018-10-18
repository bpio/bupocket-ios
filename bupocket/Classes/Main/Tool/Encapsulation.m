//
//  Encapsulation.m
//  Game News
//
//  Created by 康政 on 16/2/3.
//  Copyright © 2016年 huoss. All rights reserved.
//

#import "Encapsulation.h"

@implementation Encapsulation

// 设置label的自适应宽度
+ (CGRect)rectWithText:(NSString *)text fontSize:(CGFloat)fontSize textWidth:(CGFloat)textWidth
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = CGSizeMake(textWidth, 3000);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect;
}
// 设置label的自适应高度
+ (CGRect)rectWithText:(NSString *)text fontSize:(CGFloat)fontSize textHeight:(CGFloat)textHeight
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize size = CGSizeMake(CGFLOAT_MAX, textHeight);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect;
}
// 设置行间距和字间距
+ (NSMutableAttributedString *)attrWithString:(NSString *)str preFont:(UIFont *)preFont preColor:(UIColor *)preColor index:(NSInteger)index sufFont:(UIFont *)sufFont sufColor:(UIColor *)sufColor lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:preColor range:NSMakeRange(0, index)];
    [attr addAttribute:NSFontAttributeName value:preFont range:NSMakeRange(0, index)];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = sufFont;
    dic[NSForegroundColorAttributeName] = sufColor;
    [attr addAttributes:dic range:NSMakeRange(index, str.length - index)];
    NSMutableDictionary * paraStyleDic = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment =NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
//    paraStyleDic[NSFontAttributeName] = FONT(14);
    paraStyleDic[NSParagraphStyleAttributeName] = paraStyle;
    //设置字间距 NSKernAttributeName:@1.5f
    paraStyleDic[NSKernAttributeName] = @1.0f;
    [attr addAttributes:paraStyleDic range:NSMakeRange(0, str.length)];
    return attr;
}
//计算UILabel的高度(带有行间距的情况)
+ (CGSize)getSizeSpaceLabelWithStr:(NSString *)str font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic =@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f
                         };
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

@end
