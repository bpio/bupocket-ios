//
//  UITextField+Extension.m
//  ArtBridge
//
//  Created by 霍双双 on 17/7/7.
//  Copyright © 2017年 xinghe.li. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

+ (UITextField *)textFieldTitleLabelText:(NSString *)titleLabelText placeholder:(NSString *)placeholder titleLabelHeight:(CGFloat)titleLabelHeight lineViewHidden:(BOOL)lineViewHidden
{
    UITextField * textField = [[UITextField alloc] init];
    textField.font = FONT(14);
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    textField.textAlignment = NSTextAlignmentRight;
    textField.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel = [[UILabel alloc] init];
    CGFloat titleLabelW = [titleLabelText boundingRectWithSize:CGSizeMake(MAXFLOAT, ScreenScale(titleLabelHeight)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size.width;
    if (titleLabelW < ScreenScale(90)) {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(100), ScreenScale(titleLabelHeight));
    } else {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(titleLabelW), ScreenScale(titleLabelHeight));
    }
    titleLabel.text = titleLabelText;
    titleLabel.font = FONT(14);
    titleLabel.textColor = TITLE_COLOR;
    textField.leftView = titleLabel;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenScale(15), ScreenScale(titleLabelHeight))];
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    lineView.hidden = lineViewHidden;
    [textField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textField);
        make.height.mas_equalTo(ScreenScale(1));
    }];
    return textField;
}
+ (UITextField *)textFieldTitleLabel:(UILabel *)titleLabel text:(NSString *)text titleLabelHeight:(CGFloat)titleLabelHeight lineViewHidden:(BOOL)lineViewHidden
{
    UITextField * textField = [[UITextField alloc]init];
    textField.font = titleLabel.font;
    textField.text = text;
    textField.leftViewMode = UITextFieldViewModeAlways;
//    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    textField.textAlignment = NSTextAlignmentRight;
    textField.leftView = titleLabel;
//    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, titleLabelHeight)];
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    lineView.hidden = lineViewHidden;
    [textField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textField);
        make.height.mas_equalTo(ScreenScale(1));
    }];
    return textField;
}

+ (UITextField *)textFieldLeftImage:(NSString *)leftImage leftText:(NSString *)leftText placeholder:(NSString *)placeholder titleFieldHeight:(CGFloat)titleFieldHeight lineViewHidden:(BOOL)lineViewHidden
{
    UITextField * textField = [[UITextField alloc]init];
    textField.font = FONT(14);
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor whiteColor];
    UIButton * left = [UIButton createButtonWithTitle:leftText TextFont:14 TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:leftImage SelectedImage:leftImage Target:nil Selector:nil];
    CGSize maxSize = [leftText boundingRectWithSize:CGSizeMake(MAXFLOAT, titleFieldHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    left.frame = CGRectMake(0, 0, ScreenScale(maxSize.width + 40), ScreenScale(titleFieldHeight));
    textField.leftView = left;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenScale(40), ScreenScale(titleFieldHeight))];
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    lineView.hidden = lineViewHidden;
    [textField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textField);
        make.height.mas_equalTo(ScreenScale(1));
    }];
    return textField;
}

+ (UITextField *)textFieldWithLeftImage:(NSString *)leftImage leftText:(NSString *)leftText placeholder:(NSString *)placeholder buttonTitle:(NSString *)title NormalImage:(NSString *)normalImage SelectedImage:(NSString *)SelectedImage Target:(id)target Selector:(SEL)selector titleFieldHeight:(CGFloat)titleFieldHeight
{
    UITextField * textField = [[UITextField alloc]init];
    textField.font = FONT(14);
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor whiteColor];
    UIButton * left = [UIButton createButtonWithTitle:leftText TextFont:14 TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:leftImage SelectedImage:leftImage Target:nil Selector:nil];
    CGSize maxSize = [leftText boundingRectWithSize:CGSizeMake(MAXFLOAT, ScreenScale(titleFieldHeight)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size;
    left.frame = CGRectMake(0, 0, ScreenScale(maxSize.width + 40), ScreenScale(titleFieldHeight));
    textField.leftView = left;
    
    UIButton * button = [UIButton createButtonWithTitle:title TextFont:14 TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:normalImage SelectedImage:SelectedImage Target:target Selector:selector];
    if (title && normalImage == nil) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, ScreenScale(12));
        button.frame = CGRectMake(0, 0, ScreenScale(90), ScreenScale(titleFieldHeight));
    } else if (title.length == 0 && normalImage) {
        button.frame = CGRectMake(0, 0, ScreenScale(40), ScreenScale(titleFieldHeight));
    } else {
        button.frame = CGRectMake(0, 0, ScreenScale(12), ScreenScale(titleFieldHeight));
    }
    textField.rightView = button;
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    // TIPMRGBColor(185, 193, 214);
    [textField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textField);
        make.height.mas_equalTo(ScreenScale(1));
    }];
    return textField;
}


+ (UITextField *)textFieldTitleLabelText:(NSString *)titleLabelText placeholder:(NSString *)placeholder buttonTitle:(NSString *)title titleFieldHeight:(CGFloat)titleFieldHeight NormalImage:(NSString *)normalImage SelectedImage:(NSString *)SelectedImage Target:(id)target Selector:(SEL)selector lineViewHidden:(BOOL)lineViewHidden
{
    UITextField * textField = [[UITextField alloc]init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = FONT(14);
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UILabel * titleLabel = [[UILabel alloc]init];
    CGFloat titleLabelW = [titleLabelText boundingRectWithSize:CGSizeMake(MAXFLOAT, ScreenScale(titleFieldHeight)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(14)} context:nil].size.width;
    if (titleLabelW < ScreenScale(90)) {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(90), ScreenScale(titleFieldHeight));
    } else {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(titleLabelW), ScreenScale(titleFieldHeight));
    }
    titleLabel.text = titleLabelText;
    titleLabel.font = FONT(14);
    titleLabel.textColor = TITLE_COLOR;
    textField.leftView = titleLabel;
    
    UIButton * button = [UIButton createButtonWithTitle:title TextFont:14 TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:normalImage SelectedImage:SelectedImage Target:target Selector:selector];
    if (title) {
        button.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(titleFieldHeight));
        if (title.length == 1) {
            button.frame = CGRectMake(0, 0, ScreenScale(40), ScreenScale(titleFieldHeight));
        }
    } else {
        button.frame = CGRectMake(0, 0, ScreenScale(40), ScreenScale(titleFieldHeight));
    }
    textField.rightView = button;
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
    lineView.hidden = lineViewHidden;
    [textField addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textField);
        make.height.mas_equalTo(ScreenScale(1));
    }];
    return textField;
}

+ (UITextField *)textFieldWithplaceholder:(NSString *)placeholder margin:(CGFloat)margin height:(CGFloat)height font:(CGFloat)font
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenScale(margin), 0, DEVICE_WIDTH - ScreenScale(margin * 2), ScreenScale(height))];
    textField.placeholder = placeholder;
    textField.font = FONT(font);
    textField.textColor = TITLE_COLOR;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.rightViewMode = UITextFieldViewModeAlways;
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"];;
    [textField addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(textField);
        make.height.mas_equalTo(ScreenScale(1));
    }];
    return textField;
}

@end
