//
//  WechatTool.m
//  bupocket
//
//  Created by bupocket on 2019/5/8.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "WechatTool.h"
#import <WXApi.h>

@implementation WechatTool

+ (BOOL)WXAppCheck
{
    if (!WXApi.isWXAppInstalled) {
        [Encapsulation showAlertControllerWithMessage:Localized(@"WXAppUninstalled") handler:nil];
        return NO;
    } else if (!WXApi.isWXAppSupportApi) {
        // 判断当前微信的版本不支持OpenApi
        [Encapsulation showAlertControllerWithMessage:Localized(@"Unsupported") handler:nil];
        return NO;
    } else {
        return YES;
    }
}

+ (void)enterWechatMiniProgram
{
    if ([WechatTool WXAppCheck] == NO) return;
    WXLaunchMiniProgramReq * launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = XCX_YouPin_Original_ID;
    //        launchMiniProgramReq.path = @"";//拉起小程序页面的可带参路径，不填默认拉起小程序首页
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease;
    [WXApi sendReq:launchMiniProgramReq];
}

+ (void)wechatShareWithImage:(UIImage *)image
{
    if ([WechatTool WXAppCheck] == NO) return;
    WXMediaMessage *message = [WXMediaMessage message];
    // 设置消息缩略图的方法
    [message setThumbImage:[UIImage imageNamed:@"logo"]];
    // 多媒体消息中包含的图片数据对象
    WXImageObject *imageObject = [WXImageObject object];
    
    // 图片真实数据内容
    NSData *data = UIImagePNGRepresentation(image);
    imageObject.imageData = data;
    // 多媒体数据对象，可以为WXImageObject，WXMusicObject，WXVideoObject，WXWebpageObject等。
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;// 分享到朋友圈
    [WXApi sendReq:req];
}

@end
