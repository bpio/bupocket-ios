//
//  AddressBookCache.h
//  bupocket
//
//  Created by bupocket on 2019/3/1.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressBookCache : BaseModel

+ (void)saveAddressBookWithArray:(NSArray *)array;
+ (NSArray *)cachedAddressBookData;
+ (void)deleteAddressBookCached;

@end

NS_ASSUME_NONNULL_END
