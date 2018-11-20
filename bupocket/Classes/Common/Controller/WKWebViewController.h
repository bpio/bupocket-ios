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

@property(nonatomic,assign) wkWebLoadType loadType;

@property (nonatomic,assign) BOOL isNavHidden;

- (void)loadWebURLSring:(NSString *)string;

- (void)loadWebHTMLSring:(NSString *)string;
- (void)loadURLPathSring:(NSString *)string;

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData;

@property (nonatomic,assign) BOOL isEncodeUrl;

- (void)loadEncodeWebURLSring:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
