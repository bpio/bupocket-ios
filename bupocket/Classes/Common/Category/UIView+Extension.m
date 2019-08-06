//
//  UIView+Extension.m
//  Recruit
//
//  Created by bupocket on 2017/10/16.
//  Copyright © 2017年 bupocket. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGSize)size
{
    return self.frame.size;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (CGFloat)centerX
{
    return self.center.x;
}
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setViewSize:(CGSize)size borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderRadius:(CGFloat)borderRadius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    CAShapeLayer * borderLayer = [CAShapeLayer layer];
    borderLayer.frame = rect;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.fillColor = nil;
    borderLayer.lineWidth = borderWidth;
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(borderRadius, borderRadius)];
    maskLayer.path = bezierPath.CGPath;
    borderLayer.path = bezierPath.CGPath;
    [self.layer insertSublayer:borderLayer atIndex:0];
    [self.layer setMask:maskLayer];
}
- (void)setViewSize:(CGSize)size borderRadius:(CGFloat)borderRadius corners:(UIRectCorner)corners
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(borderRadius, borderRadius)];
    maskLayer.path = bezierPath.CGPath;
    [self.layer setMask:maskLayer];
}

- (void)drawDashLine
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:self.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:COLOR(@"D4D4D4").CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(self.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:2], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(self.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [self.layer addSublayer:shapeLayer];
}
// UIView Set borders separately
+ (void)setViewBorder:(UIView *)view color:(UIColor *)color border:(float)border type:(UIViewBorderLineType)borderLineType
{
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = color.CGColor;
    switch (borderLineType) {
        case UIViewBorderLineTypeTop:{
            lineLayer.frame = CGRectMake(0, 0, view.frame.size.width, border);
            break;
        }
        case UIViewBorderLineTypeRight:{
            lineLayer.frame = CGRectMake(view.frame.size.width, 0, border, view.frame.size.height);
            break;
        }
        case UIViewBorderLineTypeBottom:{
            lineLayer.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width,border);
            break;
        }
        case UIViewBorderLineTypeLeft:{
            lineLayer.frame = CGRectMake(0, 0, border, view.frame.size.height);
            break;
        }
            
        default:{
            lineLayer.frame = CGRectMake(0, 0, view.frame.size.width-42, border);
            break;
        }
    }
    [view.layer addSublayer:lineLayer];
}

#pragma mark - 旋转动画
- (void)setTransformAnimation
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    //    CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z); 第一个参数是旋转角度，后面三个参数形成一个围绕其旋转的向量，起点位置由UIView的center属性标识。
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.28, 0, 0.5, 0)],
                           nil];
    theAnimation.cumulative = YES;
    //    每个帧的时间=总duration/(values.count - 1)
    // 间隔时间 频率
    theAnimation.duration = .4;
    // 重复次数
    theAnimation.repeatCount = CGFLOAT_MAX;
    // 取消反弹// 告诉在动画结束的时候不要移除
    theAnimation.removedOnCompletion = YES;
    // 始终保持最新的效果
    theAnimation.fillMode = kCAFillModeForwards;
    
//    theAnimation.delegate = self;
    self.layer.zPosition = 50;
    [self.layer addAnimation:theAnimation forKey:@"transform"];
}
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
#pragma mark - 抖动动画
- (void)setShakeAnimation
{
    // 创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    //    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
    keyAnimaion.values = @[@(Angle2Radian(-3)), @(Angle2Radian(3)), @(Angle2Radian(-3))];
    // removedOnCompletion和fillMode一般是配合起来用的
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = CGFLOAT_MAX;//动画次数
    [self.layer addAnimation:keyAnimaion forKey:Shake_Animation];
}
@end
