//
//  CustomButton.h
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 排布类型
typedef NS_ENUM(NSInteger, LayoutMode) {
    HorizontalNormal, // 左图片 右文字
    HorizontalInverted, // 左文字 右图片
    VerticalNormal, // 上图片 下文字
    VerticalInverted, // 上文字 下图片
};

@interface CustomButton : UIButton

@property (assign, nonatomic) LayoutMode layoutMode;

@end

NS_ASSUME_NONNULL_END
