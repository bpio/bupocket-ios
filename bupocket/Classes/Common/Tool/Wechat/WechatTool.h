//
//  WechatTool.h
//  bupocket
//
//  Created by bupocket on 2019/5/8.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WechatTool : NSObject

+ (void)enterWechatMiniProgram;

+ (void)wechatShareWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
