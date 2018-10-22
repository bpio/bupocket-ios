//
//  UIView+Extension.h
//  Recruit
//
//  Created by 霍双双 on 2017/10/16.
//  Copyright © 2017年 霍双双. All rights reserved.
//

#import <UIKit/UIKit.h>

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

// 通过CAShapeLayer 方式绘制虚线
/**
 ** lineView:      需要绘制成虚线的view
 ** lineLength:    虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/

- (void)drawDashLineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
