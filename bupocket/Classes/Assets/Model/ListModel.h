//
//  ListModel.h
//  bupocket
//
//  Created by bupocket on 2018/11/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListModel : BaseModel

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * detail;

@end

NS_ASSUME_NONNULL_END
