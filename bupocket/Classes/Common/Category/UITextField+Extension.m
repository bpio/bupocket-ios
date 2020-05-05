//
//  UITextField+Extension.m
//  bupocket
//
//  Created by bupocket on 17/7/7.
//  Copyright © 2017年 xinghe.li. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

+ (UITextField *)textFieldTitleLabelText:(NSString *)titleLabelText placeholder:(NSString *)placeholder titleLabelHeight:(CGFloat)titleLabelHeight lineViewHidden:(BOOL)lineViewHidden
{
    UITextField * textField = [[UITextField alloc] init];
    textField.font = FONT_TITLE;
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = WHITE_BG_COLOR;
    UILabel * titleLabel = [[UILabel alloc] init];
    CGFloat titleLabelW = [titleLabelText boundingRectWithSize:CGSizeMake(MAXFLOAT, ScreenScale(titleLabelHeight)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_TITLE} context:nil].size.width;
    if (titleLabelW < ScreenScale(90)) {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(100), ScreenScale(titleLabelHeight));
    } else {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(titleLabelW), ScreenScale(titleLabelHeight));
    }
    titleLabel.text = titleLabelText;
    titleLabel.font = FONT_TITLE;
    titleLabel.textColor = TITLE_COLOR;
    textField.leftView = titleLabel;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_15, ScreenScale(titleLabelHeight))];
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
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftView = titleLabel;
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
    textField.font = FONT_TITLE;
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = WHITE_BG_COLOR;
    UIButton * left = [UIButton createButtonWithTitle:leftText TextFont:FONT_TITLE TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:leftImage SelectedImage:leftImage Target:nil Selector:nil];
    CGSize maxSize = [leftText boundingRectWithSize:CGSizeMake(MAXFLOAT, titleFieldHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    left.frame = CGRectMake(0, 0, ScreenScale(maxSize.width + 40), ScreenScale(titleFieldHeight));
    textField.leftView = left;
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Margin_40, ScreenScale(titleFieldHeight))];
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
    textField.font = FONT_TITLE;
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = WHITE_BG_COLOR;
    UIButton * left = [UIButton createButtonWithTitle:leftText TextFont:FONT_TITLE TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:leftImage SelectedImage:leftImage Target:nil Selector:nil];
    CGSize maxSize = [leftText boundingRectWithSize:CGSizeMake(MAXFLOAT, ScreenScale(titleFieldHeight)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_TITLE} context:nil].size;
    left.frame = CGRectMake(0, 0, ScreenScale(maxSize.width + 40), ScreenScale(titleFieldHeight));
    textField.leftView = left;
    
    UIButton * button = [UIButton createButtonWithTitle:title TextFont:FONT_TITLE TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:normalImage SelectedImage:SelectedImage Target:target Selector:selector];
    if (title && normalImage == nil) {
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, Margin_10);
        button.frame = CGRectMake(0, 0, ScreenScale(90), ScreenScale(titleFieldHeight));
    } else if (title.length == 0 && normalImage) {
        button.frame = CGRectMake(0, 0, Margin_40, ScreenScale(titleFieldHeight));
    } else {
        button.frame = CGRectMake(0, 0, Margin_10, ScreenScale(titleFieldHeight));
    }
    textField.rightView = button;
    
    UIView * lineView = [[UIView alloc]init];
    lineView.backgroundColor = LINE_COLOR;
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
    textField.backgroundColor = WHITE_BG_COLOR;
    textField.font = FONT_TITLE;
    textField.placeholder = placeholder;
    textField.textColor = TITLE_COLOR;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UILabel * titleLabel = [[UILabel alloc]init];
    CGFloat titleLabelW = [titleLabelText boundingRectWithSize:CGSizeMake(MAXFLOAT, ScreenScale(titleFieldHeight)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_TITLE} context:nil].size.width;
    if (titleLabelW < ScreenScale(90)) {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(90), ScreenScale(titleFieldHeight));
    } else {
        titleLabel.frame = CGRectMake(0, 0, ScreenScale(titleLabelW), ScreenScale(titleFieldHeight));
    }
    titleLabel.text = titleLabelText;
    titleLabel.font = FONT_TITLE;
    titleLabel.textColor = TITLE_COLOR;
    textField.leftView = titleLabel;
    
    UIButton * button = [UIButton createButtonWithTitle:title TextFont:FONT_TITLE TextNormalColor:TITLE_COLOR TextSelectedColor:TITLE_COLOR NormalImage:normalImage SelectedImage:SelectedImage Target:target Selector:selector];
    if (title) {
        button.frame = CGRectMake(0, 0, Margin_60, ScreenScale(titleFieldHeight));
        if (title.length == 1) {
            button.frame = CGRectMake(0, 0, Margin_40, ScreenScale(titleFieldHeight));
        }
    } else {
        button.frame = CGRectMake(0, 0, Margin_40, ScreenScale(titleFieldHeight));
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

+ (UITextField *)textFieldWithplaceholder:(NSString *)placeholder
{
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(Margin_30, 0, DEVICE_WIDTH - Margin_30 * 2, TEXTFIELD_HEIGHT)];
    textField.placeholder = placeholder;
    textField.font = FONT(15);
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
