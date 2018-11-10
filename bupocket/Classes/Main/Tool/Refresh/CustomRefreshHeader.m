//
//  CustomRefreshHeader.m
//  bupocket
//
//  Created by bubi on 2018/11/7.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "CustomRefreshHeader.h"

@implementation CustomRefreshHeader

- (void)prepare
{
    [super prepare];
    self.mj_h = StatusBarHeight + Margin_40;
    self.refreshImage = [[UIImageView alloc] init];
    self.refreshImage.contentMode = UIViewContentModeScaleAspectFit;
    self.refreshImage.image = [UIImage imageNamed:@"refresh"];
    [self addSubview:self.refreshImage];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.refreshImage.frame = CGRectMake(DEVICE_WIDTH * 0.5 - Margin_20, StatusBarHeight + Margin_5, Margin_40, Margin_30);
}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle: {
            self.refreshImage.transform = CGAffineTransformIdentity;
        }
            break;
        case MJRefreshStatePulling: {
            
        }
            break;
        case MJRefreshStateRefreshing: {
            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            animation.toValue = [NSNumber numberWithFloat:M_PI * 12.0];
//            animation.duration = 8.5f;
//            animation.repeatCount = 1;
            animation.duration = 1.0f;
            animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
            animation.repeatCount = CGFLOAT_MAX;
            animation.cumulative = YES;
            [_refreshImage.layer addAnimation:animation forKey:@"rotationAnimation"];
        }
            break;
            case MJRefreshStateNoMoreData:
        {
            self.refreshImage.transform = CGAffineTransformIdentity;
        }
            break;
            
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
