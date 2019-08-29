//
//  InfoModel.h
//  bupocket
//
//  Created by huoss on 2019/8/29.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InfoModel : BaseModel

@property (nonatomic, copy) NSString * info;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
