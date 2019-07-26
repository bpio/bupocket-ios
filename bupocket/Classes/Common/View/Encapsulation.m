//
//  Encapsulation.m
//  Game News
//
//  Created by bupocket on 16/2/3.
//  Copyright © 2016年 bupocket. All rights reserved.
//

#import "Encapsulation.h"

@implementation Encapsulation

// Setting the adaptive width of label
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textWidth
{
    NSMutableParagraphStyle * style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
//    style.alignment = NSTextAlignmentLeft;

    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    CGSize size = CGSizeMake(textWidth, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect;
}
// Setting the adaptive height of label
+ (CGRect)rectWithText:(NSString *)text font:(UIFont *)font textHeight:(CGFloat)textHeight
{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGSize size = CGSizeMake(CGFLOAT_MAX, textHeight);
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect;
}
// Set line spacing and word spacing
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
    
    UIFont * font = (MAX(preFont.fontWeight, sufFont.fontWeight) == preFont.fontWeight) ? preFont : sufFont;
    NSMutableParagraphStyle * paragraphStyle = [Encapsulation setDefaultParagraphStyleWithStr:str font:font lineSpacing:lineSpacing];
    paraStyleDic[NSParagraphStyleAttributeName] = paragraphStyle;
    [attr addAttributes:paraStyleDic range:NSMakeRange(0, str.length)];
    return attr;
}
// Set line spacing and word spacing
+ (NSMutableAttributedString *)attrWithString:(NSString *)str font:(UIFont *)font color:(UIColor *)color lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = font;
    dic[NSForegroundColorAttributeName] = color;
    [attr addAttributes:dic range:NSMakeRange(0, str.length)];
    NSMutableDictionary * paraStyleDic = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle * paragraphStyle = [Encapsulation setDefaultParagraphStyleWithStr:str font:font lineSpacing:lineSpacing];
    paraStyleDic[NSParagraphStyleAttributeName] = paragraphStyle;
    [attr addAttributes:paraStyleDic range:NSMakeRange(0, str.length)];
    return attr;
}
// Setting Title Property text
+ (NSMutableAttributedString *)attrTitle:(NSString *)title ifRequired:(BOOL)ifRequired
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", title]];
    NSMutableDictionary * titleDic = [NSMutableDictionary dictionary];
//    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| %@", title]];
//    titleDic[NSFontAttributeName] = FONT_Bold(16);
//    titleDic[NSForegroundColorAttributeName] = COLOR_9;
    titleDic[NSFontAttributeName] = FONT(15);
    titleDic[NSForegroundColorAttributeName] = TITLE_COLOR;
    [attr addAttributes:titleDic range:NSMakeRange(0, attr.length)];
    /*
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = FONT_Bold(18);
    dic[NSForegroundColorAttributeName] = MAIN_COLOR;
    [attr addAttributes:dic range:NSMakeRange(0, 1)];
     */
    if (ifRequired == YES) {
        [attr addAttribute:NSForegroundColorAttributeName value:WARNING_COLOR range:NSMakeRange(attr.length - 1, 1)];
    }
    return attr;
}
//将HTML字符串转化为NSAttributedString富文本字符串
+ (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData * data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}
// Calculate the width and height of UILabel (with row spacing)
+ (CGSize)getSizeSpaceLabelWithStr:(NSString *)str font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle * paragraphStyle = [Encapsulation setDefaultParagraphStyleWithStr:str font:font lineSpacing:lineSpacing];
    NSDictionary * dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@1.0f};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}


+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString*)message cancelHandler:(void(^)(UIAlertAction * action))cancelHandler confirmHandler:(void(^)(UIAlertAction * action))confirmHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"Cancel") style:UIAlertActionStyleCancel handler:cancelHandler];
    [alertController addAction:cancelAction];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:confirmHandler];
    [alertController addAction:confirmAction];
    UIView * alertBg = alertController.view.subviews[0].subviews[0].subviews[0];
    alertBg.backgroundColor = [UIColor whiteColor];
    alertBg.layer.cornerRadius = BG_CORNER;
    if (title.length > 0) {
        UILabel * titleLabel = alertBg.subviews[0].subviews[0].subviews[1];
        titleLabel.height = ScreenScale(65);
        //    NSMutableAttributedString * attrTitle = [Encapsulation attrWithString:title preFont:FONT(18) preColor:TITLE_COLOR index:0 sufFont:FONT(18) sufColor:TITLE_COLOR lineSpacing:Margin_10];
        NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: FONT_Bold(18)}];
        [alertController setValue:attrTitle forKey:@"attributedTitle"];
    }
    if (NotNULLString(message)) {
//        UILabel * messageLabel = alertBg.subviews[0].subviews[0].subviews[2];
        NSMutableAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:@"\n%@", message] preFont:FONT_TITLE preColor:COLOR_6 index:0 sufFont:FONT_15 sufColor:COLOR_6 lineSpacing:Margin_5];
        [alertController setValue:attr forKey:@"attributedMessage"];
//        messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    [cancelAction setValue:COLOR_9 forKey:@"titleTextColor"];
    [confirmAction setValue:MAIN_COLOR forKey:@"titleTextColor"];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
}

/*
+ (void)showAlertControllerWithTitle:(NSString *)title messageAttr:(NSAttributedString *)messageAttr cancelHandler:(void(^)(UIAlertAction * action))cancelHandler confirmHandler:(void(^)(UIAlertAction * action))confirmHandler
{    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"UpdateLater") style:UIAlertActionStyleCancel handler:cancelHandler];
    [alertController addAction:cancelAction];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:Localized(@"UpdateImmediately") style:UIAlertActionStyleDefault handler:confirmHandler];
    [alertController addAction:confirmAction];
    UIView * alertBg = alertController.view.subviews[0].subviews[0].subviews[0];
    alertBg.backgroundColor = [UIColor whiteColor];
    alertBg.layer.cornerRadius = BG_CORNER;
    UILabel * messageLabel = alertBg.subviews[0].subviews[0].subviews[2];
    [alertController setValue:messageAttr forKey:@"attributedMessage"];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    [cancelAction setValue:COLOR_9 forKey:@"titleTextColor"];
    [confirmAction setValue:MAIN_COLOR forKey:@"titleTextColor"];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
}
 */
+ (void)showAlertControllerWithMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIView * alertBg = alertController.view.subviews[0].subviews[0].subviews[0];
    alertBg.backgroundColor = [UIColor whiteColor];
    alertBg.layer.cornerRadius = BG_CORNER;
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:handle];
    [cancelAction setValue:MAIN_COLOR forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
}
+ (void)showAlertControllerWithErrorMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle
{
    [Encapsulation showAlertControllerWithTitle:Localized(@"ErrorPrompt") message:message confirmHandler:handle];
    /*
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:Localized(@"ErrorPrompt") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIView * alertBg = alertController.view.subviews[0].subviews[0].subviews[0];
    alertBg.backgroundColor = [UIColor whiteColor];
    alertBg.layer.cornerRadius = BG_CORNER;
    
    UILabel * titleLabel = alertBg.subviews[0].subviews[0].subviews[1];
    titleLabel.height = ScreenScale(65);
    //    NSMutableAttributedString * attrTitle = [Encapsulation attrWithString:title preFont:FONT(18) preColor:TITLE_COLOR index:0 sufFont:FONT(18) sufColor:TITLE_COLOR lineSpacing:Margin_10];
    NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:Localized(@"ErrorPrompt") attributes:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: FONT_Bold(18)}];
    [alertController setValue:attrTitle forKey:@"attributedTitle"];
//    UILabel * messageLabel = alertBg.subviews[0].subviews[0].subviews[2];
    if (NotNULLString(message)) {
        NSMutableAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:@"\n%@", message] preFont:FONT_TITLE preColor:COLOR_6 index:0 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:Margin_5];
        //    messageLabel.textAlignment = NSTextAlignmentLeft;
        [alertController setValue:attr forKey:@"attributedMessage"];
    }
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:handle];
    [cancelAction setValue:MAIN_COLOR forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
     */
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString*)message confirmHandler:(void(^)(UIAlertAction * action))confirmHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleDefault handler:confirmHandler];
    [alertController addAction:confirmAction];
    UIView * alertBg = alertController.view.subviews[0].subviews[0].subviews[0];
    alertBg.backgroundColor = [UIColor whiteColor];
    alertBg.layer.cornerRadius = BG_CORNER;
    if (title.length > 0) {
        UILabel * titleLabel = alertBg.subviews[0].subviews[0].subviews[1];
        titleLabel.height = ScreenScale(65);
        NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: FONT_Bold(18)}];
        [alertController setValue:attrTitle forKey:@"attributedTitle"];
    }
    if (NotNULLString(message)) {
//        UILabel * messageLabel = alertBg.subviews[0].subviews[0].subviews[2];
//        messageLabel.textAlignment = NSTextAlignmentLeft;
//        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", message] attributes:@{NSForegroundColorAttributeName: COLOR_6, NSFontAttributeName: FONT(15)}];
        NSMutableAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:@"\n%@", message] preFont:FONT_TITLE preColor:COLOR_6 index:0 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:Margin_5];
        [alertController setValue:attr forKey:@"attributedMessage"];
    }
    [confirmAction setValue:MAIN_COLOR forKey:@"titleTextColor"];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
}
+ (UIButton *)showNoDataWithTitle:(NSString *)title imageName:(NSString *)imageName superView:(UIView *)superView frame:(CGRect)frame
{
    CustomButton * button = [[CustomButton alloc] init];
    button.layoutMode = VerticalNormal;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:COLOR_9 forState:UIControlStateNormal];
    button.titleLabel.font = FONT(15);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    button.frame = frame;
    [superView addSubview:button];
    return button;
}

#pragma mark - Connection server failed
+ (UIView *)showNoNetWorkWithSuperView:(UIView *)superView target:(id)target action:(SEL)action
{
    UIView * noNetWork = [[UIView alloc] init];
    noNetWork.backgroundColor = [UIColor whiteColor];
    [superView addSubview:noNetWork];
    [noNetWork mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    UIImageView * noNetWorkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noNetWork"]];
    [noNetWork addSubview:noNetWorkImage];
    [noNetWorkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(noNetWork);
        make.bottom.equalTo(noNetWork.mas_centerY);
        //        make.top.equalTo(self.noNetWork).offset(StatusBarHeight + ScreenScale(115));
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT(15);
    titleLabel.textColor = COLOR_9;
    titleLabel.text = Localized(@"NoNetWork");
    titleLabel.numberOfLines = 0;
    titleLabel.preferredMaxLayoutWidth = DEVICE_WIDTH - Margin_40;
    [noNetWork addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(noNetWork);
        make.top.equalTo(noNetWorkImage.mas_bottom).offset(ScreenScale(50));
    }];
    
    UIButton * reloadBtn = [UIButton createButtonWithTitle:Localized(@"Reload") TextFont:FONT_BUTTON TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:target Selector:action];
    reloadBtn.layer.masksToBounds = YES;
    reloadBtn.clipsToBounds = YES;
    reloadBtn.layer.cornerRadius = MAIN_CORNER;
    reloadBtn.backgroundColor = MAIN_COLOR;
    [noNetWork addSubview:reloadBtn];
    [reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(Margin_40);
        make.centerX.equalTo(noNetWork);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(170), MAIN_HEIGHT));
    }];
    noNetWork.hidden = YES;
    return noNetWork;
}
+ (NSAttributedString *)getAttrWithInfoStr:(NSString *)infoStr
{
    if (NotNULLString(infoStr)) {
        return [Encapsulation attrWithString:infoStr preFont:FONT(13) preColor:COLOR_6 index:0 sufFont:FONT(13) sufColor:COLOR_6 lineSpacing:Margin_10];
    }
    return nil;
}
+ (CGFloat)getAttrHeightWithInfoStr:(NSString *)infoStr
{
    return NotNULLString(infoStr) ? ceil([Encapsulation getSizeSpaceLabelWithStr:infoStr font:FONT_TITLE width:View_Width_Main height:CGFLOAT_MAX lineSpacing:Margin_10].height) + 1 + Margin_20 : CGFLOAT_MIN;
}

#pragma mark 多张图片合成一张
+ (UIImage *)mergedImageWithMainImage:(UIView *)mainImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(mainImage.size.width, mainImage.size.height), NO, 0);
    [mainImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
+ (NSMutableParagraphStyle *)setDefaultParagraphStyleWithStr:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    //   NSParagraphStyleAttributeName 段落的风格（设置首行，行间距，对齐方式）
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 省略方式
    //    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
//    paragraphStyle.alignment = NSTextAlignmentLeft;
    // 字体的行间距
    CGFloat lineH = lineSpacing - (font.lineHeight - font.pointSize);
    paragraphStyle.lineSpacing = (lineH < 0) ? 0 : lineH;
    // 连字属性 在iOS，唯一支持的值分别为0和1
    paragraphStyle.hyphenationFactor = 1.0;
    // 首行缩进
    paragraphStyle.firstLineHeadIndent = 0.0;
    // 段与段之间的间距
    if ([str containsString:@"\n"]) {
        paragraphStyle.paragraphSpacing = Margin_10;
    }
    // 段首行空白空间
    paragraphStyle.paragraphSpacingBefore = 0.0;
    // 整体缩进(首行除外)
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    // 最低行高
//    paragraphStyle.minimumLineHeight = 0;
//    // 最大行高
//    paragraphStyle.maximumLineHeight = Margin_20;
    // 从左到右的书写方向
    //    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    return paragraphStyle;
}
/*
 NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
 NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
 NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
 NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
 NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
 NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
 NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
 NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
 NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
*/
@end
