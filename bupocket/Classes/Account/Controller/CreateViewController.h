//
//  CreateViewController.h
//  bupocket
//
//  Created by huoss on 2019/6/18.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CreateType) {
    CreateIdentity,
    CreateWallet
};

@interface CreateViewController : BaseViewController

@property (assign, nonatomic) CreateType createType;

@end

NS_ASSUME_NONNULL_END
