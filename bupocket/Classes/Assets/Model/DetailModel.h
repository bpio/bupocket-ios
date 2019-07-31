//
//  DetailModel.h
//  bupocket
//
//  Created by bupocket on 2019/7/30.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailModel : BaseModel

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * infoTitle;
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
