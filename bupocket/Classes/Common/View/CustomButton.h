//
//  CustomButton.h
//  bupocket
//
//  Created by bupocket on 2018/10/17.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Arrangement type
typedef NS_ENUM(NSInteger, LayoutMode) {
    HorizontalNormal, // Left picture and right text
    HorizontalInverted, // Left text right picture
    VerticalNormal, // Text in the picture above and below
    VerticalInverted, // Pictures below the text above
};

@interface CustomButton : UIButton

@property (assign, nonatomic) LayoutMode layoutMode;

@end

NS_ASSUME_NONNULL_END
