//
//  Encapsulation.m
//  Game News
//
//  Created by bupocket on 16/2/3.
//  Copyright © 2016年 bupocket. All rights reserved.
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
    paraStyle.lineSpacing = ScreenScale(lineSpacing); //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent =0.0;
    paraStyle.paragraphSpacingBefore =0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
//    paraStyleDic[NSFontAttributeName] = TITLE_FONT;
    paraStyleDic[NSParagraphStyleAttributeName] = paraStyle;
    //设置字间距 NSKernAttributeName:@1.5f
//    paraStyleDic[NSKernAttributeName] = @1.0f;
    [attr addAttributes:paraStyleDic range:NSMakeRange(0, str.length)];
    return attr;
}
// 设置标题属性文字
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
    NSDictionary * dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paraStyle,NSKernAttributeName:@1.0f};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

+ (UIAlertController *)alertControllerWithCancelTitle:(NSString *)cancelTitle title:(NSString *)title message:(NSString*)message
{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
//    UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    [alertController addAction:okAction];
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
    return alertController;
}
//+ (void)showAlertControllerWithMessage:(NSString *)message btnText:(NSString *)btnText handler:(void(^)(UIAlertAction * action))handle
//{
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"IGotIt") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

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

#pragma mark 连接服务器失败
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
    
    UIButton * reloadBtn = [UIButton createButtonWithTitle:Localized(@"Reload") TextFont:18 TextColor:[UIColor whiteColor] Target:target Selector:action];
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
