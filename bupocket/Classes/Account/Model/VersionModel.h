//
//  VersionModel.h
//  bupocket
//
//  Created by bupocket on 2018/11/13.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VersionModel : BaseModel

@property (nonatomic, copy) NSString * appSize;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * downloadLink;
@property (nonatomic, copy) NSString * englishVerContents;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * verContents;
@property (nonatomic, copy) NSString * verNumber;
@property (nonatomic, copy) NSString * verNumberCode;
@property (nonatomic, assign) NSInteger verType;

@end

NS_ASSUME_NONNULL_END
