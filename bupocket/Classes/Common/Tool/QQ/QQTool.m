//
//  QQTool.m
//  bupocket
//
//  Created by bupocket on 2019/5/8.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "QQTool.h"
#import  <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@implementation QQTool

+ (void)QQShareWithImage:(UIImage *)image
{
    NSData * imageData = UIImagePNGRepresentation(image);
    QQApiImageObject * imageObject = [QQApiImageObject objectWithData:imageData previewImageData:imageData title:@"" description:@""];
    SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent:imageObject];
    QQApiSendResultCode sendResult = [QQApiInterface sendReq:req];
    
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            // 发送参数错误（出错了，请稍后重试）
            [Encapsulation showAlertControllerWithMessage:Localized(@"SharingFailure") handler:nil];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            // 请下载QQ后使用
            [Encapsulation showAlertControllerWithMessage:Localized(@"QQAppUninstalled") handler:nil];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            // QQ api不支持
            [Encapsulation showAlertControllerWithMessage:Localized(@"Unsupported") handler:nil];
            break;
        }
        case EQQAPISENDFAILD:
        {
            // 发送失败（出错了，请稍后重试）
            [Encapsulation showAlertControllerWithMessage:Localized(@"SharingFailure") handler:nil];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            // 当前QQ版本太低，需要更新
            [Encapsulation showAlertControllerWithMessage:Localized(@"Unsupported") handler:nil];
            break;
        }
        default:
        {
            break;
        }
    }
    
}

@end
