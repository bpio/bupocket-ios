//
//  WXApiManager.h
//  bupocket
//
//  Created by huoss on 2019/8/22.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>
@required

@optional
-(void)wxPayResponse:(PayResp *)resp;
-(void)wxSendAuthResponse:(SendAuthResp *)resp;
@end

NS_ASSUME_NONNULL_BEGIN

@interface WXApiManager : NSObject<WXApiDelegate>

@property(nonatomic, assign) id <WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
