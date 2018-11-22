//
//  SocketIOHandler.h
//  bupocket
//
//  Created by huoss on 2018/11/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SocketIOHandler : NSObject

+ (SocketIOHandler *)shareInstance;

- (void)connect;
- (void)disconnect;
- (NSUUID * _Nonnull)on:(NSString * _Nonnull)event callback:(void (^ _Nonnull)(NSArray * _Nonnull data))callback;
- (void)emitWithAck:(NSString * _Nonnull)event with:(NSArray * _Nonnull)items callback:(void (^ _Nonnull)(NSArray * _Nonnull data))callback;
- (void)removeAllHandlers;

@property(nonatomic,assign)BOOL isNotConnected;
@property(nonatomic,assign)BOOL isDisConnected;

@end

NS_ASSUME_NONNULL_END
