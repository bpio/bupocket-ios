//
//  OrderDetailsViewController.h
//  bupocket
//
//  Created by bupocket on 2018/10/23.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "BaseViewController.h"
#import "AssetsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailsViewController : BaseViewController

@property (nonatomic, strong) AssetsDetailModel * listModel;
@property (nonatomic, copy) NSString * assetCode;

@end

NS_ASSUME_NONNULL_END
