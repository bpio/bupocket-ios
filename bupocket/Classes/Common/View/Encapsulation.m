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
    style.alignment = NSTextAlignmentLeft;

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
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment =NSTextAlignmentLeft;
    paraStyle.lineSpacing = ScreenScale(lineSpacing); //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
//    paraStyleDic[NSFontAttributeName] = TITLE_FONT;
    paraStyleDic[NSParagraphStyleAttributeName] = paraStyle;
    //word spacing NSKernAttributeName:@1.5f
//    paraStyleDic[NSKernAttributeName] = @1.0f;
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
// Calculate the width and height of UILabel (with row spacing)
+ (CGSize)getSizeSpaceLabelWithStr:(NSString *)str font:(UIFont *)font width:(CGFloat)width height:(CGFloat)height lineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode =NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary * dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f};
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
        UILabel * titleLabel = alertBg.subviews[0].subviews[0].subviews[0];
        titleLabel.height = ScreenScale(65);
        //    NSMutableAttributedString * attrTitle = [Encapsulation attrWithString:title preFont:FONT(18) preColor:TITLE_COLOR index:0 sufFont:FONT(18) sufColor:TITLE_COLOR lineSpacing:Margin_10];
        NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: TITLE_COLOR, NSFontAttributeName: FONT_Bold(18)}];
        [alertController setValue:attrTitle forKey:@"attributedTitle"];
    }
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", message] attributes:@{NSForegroundColorAttributeName: COLOR_6, NSFontAttributeName: FONT(15)}];
    [alertController setValue:attr forKey:@"attributedMessage"];
    [cancelAction setValue:COLOR_9 forKey:@"titleTextColor"];
    [confirmAction setValue:MAIN_COLOR forKey:@"titleTextColor"];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
}
+ (void)showAlertControllerWithMessage:(NSString *)message handler:(void(^)(UIAlertAction * action))handle
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:handle];
    [cancelAction setValue:MAIN_COLOR forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
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
    button.hidden = YES;
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
    
    UIButton * reloadBtn = [UIButton createButtonWithTitle:Localized(@"Reload") TextFont:18 TextNormalColor:[UIColor whiteColor] TextSelectedColor:[UIColor whiteColor] Target:target Selector:action];
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

@end
