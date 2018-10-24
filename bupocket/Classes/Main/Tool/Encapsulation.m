//
//  Encapsulation.m
//  Game News
//
//  Created by bupocket on 16/2/3.
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

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString*)message
{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
//    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [alertController addAction:okAction];
    UIView * alertBg = alertController.view.subviews[0].subviews[0].subviews[0];
    alertBg.backgroundColor = [UIColor whiteColor];
    alertBg.layer.cornerRadius = ScreenScale(5);
    if (title.length > 0) {
        UILabel * titleLabel = alertBg.subviews[0].subviews[0].subviews[0];
        titleLabel.height = ScreenScale(65);
        //    NSMutableAttributedString * attrTitle = [Encapsulation attrWithString:title preFont:FONT(18) preColor:TITLE_COLOR index:0 sufFont:FONT(18) sufColor:TITLE_COLOR lineSpacing:ScreenScale(10)];
        NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: FONT_Bold(18)}];
        [alertController setValue:attrTitle forKey:@"attributedTitle"];
    }
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", message] attributes:@{NSForegroundColorAttributeName: COLOR(@"666666"), NSFontAttributeName: FONT(15)}];
    [alertController setValue:attr forKey:@"attributedMessage"];
    [cancelAction setValue:COLOR(@"999999") forKey:@"titleTextColor"];
    return alertController;
}

+ (UIButton *)showNoTransactionRecordWithSuperView:(UIView *)superView frame:(CGRect)frame
{
    CustomButton * button = [[CustomButton alloc] init];
    button.layoutMode = VerticalNormal;
    [button setTitle:Localized(@"NoTransactionRecord") forState:UIControlStateNormal];
    [button setTitleColor:COLOR(@"999999") forState:UIControlStateNormal];
    button.titleLabel.font = FONT(15);
    [button setImage:[UIImage imageNamed:@"NoTransactionRecord"] forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    button.hidden = YES;
    button.frame = frame;
    [superView addSubview:button];
    return button;
}

+ (NSString *)getDateStringWithTimeStr:(NSString *)str
{
    if (str.length < 3) return nil;
    NSTimeInterval interval = [[str substringToIndex:str.length - 3] doubleValue] / 1000.0;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SS"];
    return [formatter stringFromDate:date];
    
    /*
     NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
     formatter.dateFormat = @"EEE yyyy MMM dd HH:mm:ss Z yyyy";
     // 真机调试的时候，必须加上这句
     formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
     // 获得具体时间
     NSDate *createDate = [formatter dateFromString:_txTime];
     
     // 判断是否为今年
     if (createDate.isThisYear) {
     if (createDate.isToday) { // 今天
     NSDateComponents *cmps = [createDate deltaWithNow];
     if (cmps.hour >= 1) { // 至少是1小时前
     return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
     } else if (cmps.minute >= 1) { // 1~59分钟之前
     return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
     } else { // 1分钟内
     return @"刚刚";
     }
     } else if (createDate.isYesterday) { // 昨天
     formatter.dateFormat = @"昨天 HH:mm";
     return [formatter stringFromDate:createDate];
     } else { // 至少是前天
     formatter.dateFormat = @"MM-dd HH:mm";
     return [formatter stringFromDate:createDate];
     }
     } else { // 非今年
     formatter.dateFormat = @"yyyy-MM-dd";
     return [formatter stringFromDate:createDate];
     }
     */
}


@end
