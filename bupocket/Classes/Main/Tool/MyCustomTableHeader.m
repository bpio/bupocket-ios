//
//  MyCustomTableHeader.m
//  ArtBridge
//
//  Created by liushuzeng on 16/3/15.
//  Copyright © 2016年 xinghe.li. All rights reserved.
//

#import "MyCustomTableHeader.h"

@implementation MyCustomTableHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    NSArray *imageArr = @[@"pull_3",@"pull_3",@"pull_12",@"pull_12",@"pull_2",@"pull_2",@"pull_11",@"pull_11",@"pull_1",@"pull_1",@"pull_10",@"pull_10"];
    for (int i = 0; i< imageArr.count; i++) {
        UIImage *image = [UIImage imageNamed:imageArr[i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStatePulling];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pull_%ld", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
    
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;
   self.stateLabel.hidden = YES;
}


@end
