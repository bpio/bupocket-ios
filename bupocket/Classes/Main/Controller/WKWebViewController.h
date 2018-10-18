//
//  WKWebViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/18.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewController : BaseViewController

typedef enum {
    WebLoadURLString = 0,
    WebLoadHTMLString,
    WebLoadJSPOST,
    webloadLocalPath,
} wkWebLoadType;


@property (nonatomic, strong) WKWebView * wkWebView;

//网页加载的类型
@property(nonatomic,assign) wkWebLoadType loadType;

/** 是否显示Nav */
@property (nonatomic,assign) BOOL isNavHidden;

/**
 加载纯外部链接网页
 
 @param string URL地址
 */
- (void)loadWebURLSring:(NSString *)string;

/**
 加载本地网页
 
 @param string 本地HTML文件名
 */
- (void)loadWebHTMLSring:(NSString *)string;
- (void)loadURLPathSring:(NSString *)string;

/**
 加载外部链接POST请求(注意检查 XFWKJSPOST.html 文件是否存在 )
 postData请求块 注意格式：@"\"username\":\"xxxx\",\"password\":\"xxxx\""
 
 @param string 需要POST的URL地址
 @param postData post请求块
 */
- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData;

//是否是encode的url如果是的话，则需要特殊处理
@property (nonatomic,assign) BOOL isEncodeUrl;

- (void)loadEncodeWebURLSring:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
