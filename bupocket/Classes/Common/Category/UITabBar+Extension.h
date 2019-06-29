//
//  UITabBar+Extension.h
//  bupocket
//
//  Created by huoss on 2019/6/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (Extension)

/**
 tabbar显示小红点
 
 @param index 第几个控制器显示，从0开始算起
 @param tabbarNum tabbarcontroller一共多少个控制器
 */
- (void)showBadgeOnItemIndex:(NSInteger)index tabbarNum:(NSInteger)tabbarNum;

/**
 隐藏红点
 
 @param index 第几个控制器隐藏，从0开始算起
 */
-(void)hideBadgeOnItemIndex:(NSInteger)index;

/**
 移除控件
 
 @param index 第几个控制器要移除控件，从0开始算起
 */
- (void)removeBadgeOnItemIndex:(NSInteger)index;
    

@end

NS_ASSUME_NONNULL_END
