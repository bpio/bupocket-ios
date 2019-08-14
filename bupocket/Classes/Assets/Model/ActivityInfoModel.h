//
//  ActivityInfoModel.h
//  bupocket
//
//  Created by bupocket on 2019/8/4.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityInfoModel : BaseModel

@property (nonatomic, copy) NSString * topImage;
@property (nonatomic, copy) NSString * bottomImage;
@property (nonatomic, copy) NSString * issuerPhoto;
@property (nonatomic, copy) NSString * issuerNick;
// 最佳标识：0 否 1是
@property (nonatomic, copy) NSString * mvpFlag;
@property (nonatomic, copy) NSString * tokenSymbol;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * receiver;

@end

NS_ASSUME_NONNULL_END
