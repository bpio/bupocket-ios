//
//  LoginConfirmModel.h
//  bupocket
//
//  Created by huoss on 2019/3/26.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginConfirmModel : BaseModel

@property (nonatomic, copy) NSString * uuid;
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * appName;
@property (nonatomic, copy) NSString * appPic;

@end

NS_ASSUME_NONNULL_END
