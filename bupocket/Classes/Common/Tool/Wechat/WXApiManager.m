//
//  WXApiManager.m
//  bupocket
//
//  Created by huoss on 2019/8/22.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - 单例

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        PayResp *payResp = (PayResp *)resp;
        [self.delegate wxPayResponse:payResp];
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *sendAuthResp = (SendAuthResp *)resp;
        if ([_delegate respondsToSelector:@selector(wxSendAuthResponse:)]) {
            [self.delegate wxSendAuthResponse:sendAuthResp];
            switch (resp.errCode) {
                case WXSuccess:
                    DLog(@"授权成功，retcode = %d", resp.errCode);
                    break;
                default:
                    DLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                    break;
            }            
        }
    }
}

@end
