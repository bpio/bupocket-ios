//
//  TermsOfUseViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "WKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IDType) {
    IDTypeCreate,
    IDTypeRestore
};
@interface TermsOfUseViewController : WKWebViewController

@property (nonatomic, assign) IDType IDType;

@end

NS_ASSUME_NONNULL_END
