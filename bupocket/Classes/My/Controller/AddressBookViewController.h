//
//  AddressBookViewController.h
//  bupocket
//
//  Created by bupocket on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressBookViewController : BaseViewController

@property (nonatomic, copy) void (^walletAddress)(NSString *);

@end

NS_ASSUME_NONNULL_END
