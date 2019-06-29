//
//  UITabBar+Extension.m
//  bupocket
//
//  Created by huoss on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "UITabBar+Extension.h"

@implementation UITabBar (Extension)

/**
 tabbar显示小红点
 
 @param index 第几个控制器显示，从0开始算起
 @param tabbarNum tabbarcontroller一共多少个控制器
 */
- (void)showBadgeOnItemIndex:(NSInteger)index tabbarNum:(NSInteger)tabbarNum
{
    [self removeBadgeOnItemIndex:index];
    //label为小红点，并设置label属性
    UILabel *label = [[UILabel alloc]init];
    label.tag = 1000+index;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor redColor];
    label.font = FONT(10);
    label.textColor = [UIColor whiteColor];
    label.text = Localized(@"New");
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat labelW = [Encapsulation rectWithText:label.text font:label.font textHeight:Margin_10].size.width + ScreenScale(8);
    CGFloat labelH = ScreenScale(18);
    label.layer.cornerRadius = labelH / 2.0;
    CGRect tabFrame = self.frame;
    
    
    //计算小红点的X值，根据第index控制器，小红点在每个tabbar按钮的中部偏移0.1，即是每个按钮宽度的0.6倍
    CGFloat percentX = (index+0.55);
    CGFloat tabBarButtonW = CGRectGetWidth(tabFrame)/tabbarNum;
    CGFloat x = percentX*tabBarButtonW;
    CGFloat y = 0.05*CGRectGetHeight(tabFrame);
    //10为小红点的高度和宽度
    label.frame = CGRectMake(x, y, labelW, labelH);
    
    
    [self addSubview:label];
    //把小红点移到最顶层
    [self bringSubviewToFront:label];
}

/**
 隐藏红点
 
 @param index 第几个控制器隐藏，从0开始算起
 */
-(void)hideBadgeOnItemIndex:(NSInteger)index
{
    [self removeBadgeOnItemIndex:index];
}

/**
 移除控件
 
 @param index 第几个控制器要移除控件，从0开始算起
 */
- (void)removeBadgeOnItemIndex:(NSInteger)index
{
    for (UIView*subView in self.subviews) {
        if (subView.tag == 1000+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
