//
//  CustomRefreshFooter.m
//  bupocket
//
//  Created by huoss on 2018/11/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "CustomRefreshFooter.h"

@implementation CustomRefreshFooter

- (void)prepare
{
    [super prepare];
    [self setTitle:Localized_Refresh(@"MJRefreshBackFooterIdleText") forState:MJRefreshStateIdle];
    [self setTitle:Localized_Refresh(@"MJRefreshBackFooterPullingText") forState:MJRefreshStatePulling];
    [self setTitle:Localized_Refresh(@"MJRefreshBackFooterRefreshingText") forState:MJRefreshStateRefreshing];
    [self setTitle:Localized_Refresh(@"MJRefreshBackFooterNoMoreDataText") forState:MJRefreshStateNoMoreData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
