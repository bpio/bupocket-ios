//
//  StatusUpdateModel.h
//  bupocket
//
//  Created by huoss on 2019/8/27.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatusUpdateModel : BaseModel

@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * enContent;
@property (nonatomic, copy) NSString * enTitle;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * type;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
