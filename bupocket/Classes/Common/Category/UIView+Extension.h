//
//  UIView+Extension.h
//  Recruit
//
//  Created by bupocket on 2017/10/16.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIViewBorderLineType) {
    UIViewBorderLineTypeTop,
    UIViewBorderLineTypeRight,
    UIViewBorderLineTypeBottom,
    UIViewBorderLineTypeLeft,
};

@interface UIView (Extension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

// 设置边框 颜色 边框宽度  圆角半径
- (void)setViewSize:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderRadius:(CGFloat)borderRadius;

- (void)setViewSize:(CGSize)size borderRadius:(CGFloat)borderRadius corners:(UIRectCorner)corners;

// 通过CAShapeLayer 方式绘制虚线
/**
 ** lineView:      需要绘制成虚线的view
 ** lineLength:    虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/

- (void)drawDashLine;

// UIView 分开设置边框
+ (void)setViewBorder:(UIView *)view color:(UIColor *)color border:(float)border type:(UIViewBorderLineType)borderLineType;

// 设置旋转动画
- (void)setTransformAnimation;

@end
