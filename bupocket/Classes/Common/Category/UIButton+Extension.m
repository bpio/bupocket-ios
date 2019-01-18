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

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:textFont];
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

+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalImage:(NSString *)normalImage SelectedImage:(NSString *)selectedImage Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT(textFont);
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
+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextNormalColor:(UIColor *)textNormalColor TextSelectedColor:(UIColor *)textSelectedColor NormalBackgroundImage:(NSString *)normalBackgroundImage SelectedBackgroundImage:(NSString *)selectedBackgroundImage Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT(textFont);
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
// Nav_Button
+ (UIButton *)createNavButtonWithTitle:(NSString *)title Target:(id)target Selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT(16);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    CGFloat buttonW = [Encapsulation rectWithText:title font:button.titleLabel.font textHeight:ScreenScale(44)].size.width;
    button.bounds = CGRectMake(0, 0, buttonW, ScreenScale(44));
//    [button setTitleColor:NAVITEM_COLOR forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton *)createButtonWithTitle:(NSString *)title TextFont:(CGFloat)textFont TextColor:(UIColor *)textColor BackgroundImage:(NSString *)backgroundImage
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT(textFont);
    //    button.contentHorizontalAlignment = 1;
    //    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    return button;
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
