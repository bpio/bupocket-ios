//
//  ReceiveViewController.h
//  bupocket
//
//  Created by bupocket on 2019/6/21.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ReceiveType) {
    ReceiveTypeDefault,
    ReceiveTypeVoucher
};

@interface ReceiveViewController : BaseViewController

@property (nonatomic, assign) ReceiveType receiveType;

@end

NS_ASSUME_NONNULL_END
