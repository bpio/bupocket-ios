//
//  UIButton+Extension.m
//  bupocket
//
//  Created by bupocket on 17/7/14.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "UIButton+Extension.h"

static NSTimer *_countTimer;
static NSTimeInterval _count;
static NSString *_title;

@implementation UIButton (Extension)

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(UIFont *)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    [button setTitleColor:textNormalColor forState:UIControlStateNormal];
    [button setTitleColor:textSelectedColor forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithNormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(UIFont *)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    [button setTitleColor:textNormalColor forState:UIControlStateNormal];
    [button setTitleColor:textSelectedColor forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
//    if (title && normalImage) {
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, BG_CORNER, 0, 0);
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, BG_CORNER);
//    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    CGSize buttonSize = button.frame.size;
//    button.frame = CGRectMake(0, 0, buttonSize.width + 20, buttonSize.height);
    return button;
}
+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(UIFont *)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalBackgroundImage:(NSString *)normalBackgroundImage SelectedBackgroundImage:(NSString *)selectedBackgroundImage Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    [button setTitleColor:textNormalColor forState:UIControlStateNormal];
    [button setTitleColor:textSelectedColor forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:normalBackgroundImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedBackgroundImage] forState:UIControlStateSelected];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
// Button
+ (UIButton *)createButtonWithTitle:(NSString *)title isEnabled:(BOOL)isEnabled Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT(18);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = MAIN_CORNER;
    if (isEnabled == YES) {
        button.backgroundColor = MAIN_COLOR;
    } else {
        button.backgroundColor = DISABLED_COLOR;
    }
    button.enabled = isEnabled;
    return button;
}
+ (UIButton *)createCornerRadiusButtonWithTitle:(NSString *)title isEnabled:(BOOL)isEnabled Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton createButtonWithTitle:title isEnabled:isEnabled Target:target Selector:selector];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderColor = MAIN_COLOR.CGColor;
    button.layer.borderWidth = LINE_WIDTH;
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    return button;
}
// Nav_Button
+ (UIButton *)createNavButtonWithTitle:(NSString *)title Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT_NAV_TITLE;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    CGFloat buttonW = [Encapsulation rectWithText:title font:button.titleLabel.font textHeight:ScreenScale(44)].size.width;
    button.bounds = CGRectMake(0, 0, buttonW, ScreenScale(44));
//    [button setTitleColor:NAVITEM_COLOR forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(UIFont *)textFont TextColor:(UIColor *)textColor BackgroundImage:(NSString *)backgroundImage
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = textFont;
    //    button.contentHorizontalAlignment = 1;
    //    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)createHeaderButtonWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT_TITLE;
    [button setTitleColor:COLOR_9 forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_Main, 0, Margin_Main);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return button;
}
// 设置标题属性文字
+ (UIButton *)createAttrHeaderTitle:(NSString *)title
{
    NSString * titleStr = [NSString stringWithFormat:@"|  %@", title];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAttributedTitle:[Encapsulation attrWithString:titleStr preFont:FONT_Bold(14) preColor:MAIN_COLOR index:1 sufFont:FONT_TITLE sufColor:TITLE_COLOR lineSpacing:0] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_Main, 0, Margin_Main);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return button;
}
+ (UIButton *)createFooterViewWithTitle:(NSString *)title  isEnabled:(BOOL)isEnabled Target:(id)target Selector:(SEL)selector
{
    UIView * footerView = [[UIView alloc] init];
//                           WithFrame:CGRectMake(0, DEVICE_HEIGHT - ContentInset_Bottom - NavBarH, DEVICE_WIDTH, ContentInset_Bottom)];
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton createButtonWithTitle:title isEnabled:isEnabled Target:target Selector:selector];
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footerView.mas_bottom).offset(- Margin_30 - SafeAreaBottomH);
        make.left.equalTo(footerView.mas_left).offset(Margin_Main);
        make.right.equalTo(footerView.mas_right).offset(-Margin_Main);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    UIView * superView = [UIApplication currentViewController].view;
    [superView addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(superView);
        make.height.mas_equalTo(ContentInset_Bottom);
    }];
    return button;
}

+ (UIButton *)createExplainWithSuperView:(UIView *)superView title:(NSString *)title Target:(id)target Selector:(SEL)selector
{
    CustomButton * explain = [[CustomButton alloc] init];
    explain.layoutMode = HorizontalInverted;
    explain.titleLabel.font = FONT_13;
    [explain setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [explain setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
    [explain setTitle:title forState:UIControlStateNormal];
    [explain addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:explain];
    [explain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
        make.right.equalTo(superView.mas_right).offset(-Margin_Main);
    }];
    return explain;
}
- (void)beginCountDownWithDuration:(NSTimeInterval)duration {
    _title = self.titleLabel.text;
    _count = duration;
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_countTimer forMode:NSRunLoopCommonModes];
    self.userInteractionEnabled = NO;
    
    //    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    self.backgroundColor = [UIColor lightGrayColor];
    //    self.layer.borderColor = [UIColor clearColor].CGColor;
    //    self.clipsToBounds = YES;
}

- (void)stopCountDown {
    [_countTimer invalidate];
    _countTimer = nil;
    _count = 60.0;
    [self setTitle:_title forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
}

- (void)updateTitle {
    NSString *countString = [NSString stringWithFormat:@"%lis后可重新获取", (long)_count - 1];
    self.userInteractionEnabled = NO;
    [self setTitle:countString forState:UIControlStateNormal];
    if (_count -- <= 1.0) {
        [self stopCountDown];
    }
}

@end
