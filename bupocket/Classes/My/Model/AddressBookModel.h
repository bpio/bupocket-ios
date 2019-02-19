//
//  AddressBookModel.h
//  bupocket
//
//  Created by bubi on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressBookModel : BaseModel

@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * linkmanAddress;
@property (nonatomic, copy) NSString * remark;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
