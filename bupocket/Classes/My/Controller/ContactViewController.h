//
//  ContactViewController.h
//  bupocket
//
//  Created by bubi on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactViewController : BaseViewController

@property (nonatomic, strong) AddressBookModel * addressBookModel;

@end

NS_ASSUME_NONNULL_END
