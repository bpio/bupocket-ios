//
//  TermsOfUseViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/16.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "WKWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UserProtocolType) {
    UserProtocolDefault,
    UserProtocolCreateID,
    UserProtocolRestoreID
};
@interface TermsOfUseViewController : WKWebViewController

@property (nonatomic, assign) UserProtocolType userProtocolType;

@end

NS_ASSUME_NONNULL_END
