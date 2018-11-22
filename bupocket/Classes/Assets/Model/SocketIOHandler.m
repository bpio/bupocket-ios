//
//  SocketIOHandler.m
//  bupocket
//
//  Created by huoss on 2018/11/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "SocketIOHandler.h"
@import SocketIO;

@interface SocketIOHandler()
{
    SocketIOClient * socket;
}
@end

@implementation SocketIOHandler

+ (SocketIOHandler *)shareInstance
{
    static SocketIOHandler * shareSocker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareSocker == nil) {
            NSURL* url = [[NSURL alloc] initWithString:[HTTPManager shareManager].pushMessageSocketUrl];
            shareSocker = [[SocketIOHandler alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
        }
    });
    return shareSocker;
}
- (nonnull instancetype)initWithSocketURL:(NSURL * _Nonnull)socketURL config:(NSDictionary * _Nullable)config
{
    self = [super init];
    if (self) {
        SocketManager * manager = [[SocketManager alloc] initWithSocketURL:socketURL config:config];
        socket = [manager defaultSocket];
    }
    return self;
}
- (void)connect
{
    [socket connect];
}
- (void)disconnect
{
    [socket disconnect];
}
- (NSUUID *)on:(NSString *)event callback:(void (^)(NSArray * _Nonnull))callback
{
    return [socket on:event callback:^(NSArray * data, SocketAckEmitter * ack) {
        callback(data);
    }];
}
- (void)emitWithAck:(NSString *)event with:(NSArray *)items callback:(void (^)(NSArray * _Nonnull))callback
{
    [[socket emitWithAck:event with:items] timingOutAfter:0 callback:callback];
}
- (BOOL)isDisConnected
{
    return socket.status == SocketIOStatusDisconnected;
}
- (BOOL)isNotConnected
{
    return socket.status == SocketIOStatusNotConnected;
}
- (void)removeAllHandlers
{
    [socket removeAllHandlers];
}
- (void)dealloc
{
    [socket removeAllHandlers];
    [socket disconnect];
    socket = nil;
}
@end
