//
//  RegisteredResultViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/29.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisteredResultViewController : BaseViewController

// 0 成功 1 失败 2 超时
@property (nonatomic, assign) NSInteger state;
//@property (nonatomic, strong) NSDictionary * scanDic;
@property (nonatomic, strong) RegisteredModel * registeredModel;
@property (nonatomic, strong) NSMutableArray * listArray;
//@property (nonatomic, strong) NSDictionary * assetsDic;

@end

NS_ASSUME_NONNULL_END
