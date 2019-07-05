//
//  VoucherModel.h
//  bupocket
//
//  Created by huoss on 2019/7/5.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoucherModel : BaseModel

// 数字券id
@property (nonatomic, copy) NSString * voucherId;
// 合约地址
@property (nonatomic, copy) NSString * contractAddress;
// 数字券名称
@property (nonatomic, copy) NSString * voucherName;
// 数字券图标
@property (nonatomic, copy) NSString * voucherIcon;
// 面值
@property (nonatomic, copy) NSString * faceValue;
// 持有数量
@property (nonatomic, copy) NSString * balance;
// 数字券描述
@property (nonatomic, copy) NSString * desc;
// 数字券trancheid
@property (nonatomic, copy) NSString * trancheId;
// 数字券分类
@property (nonatomic, copy) NSString * spuId;
// 有效期开始时间 单位:毫秒 -1:没有有效期开始时间
@property (nonatomic, copy) NSString * startTime;
// 有效期结束时间 单位:毫秒 -1:没有有效期结束时间
@property (nonatomic, copy) NSString * endTime;
// 数字券属性 key value
@property (nonatomic, copy) NSArray * voucherProperties;
// 发行方账户地址 发行方名称 发行方icon
@property (nonatomic, copy) NSDictionary * voucherIssuer;
// 承兑方账户地址 承兑方名称 承兑方icon
@property (nonatomic, copy) NSDictionary * voucherAcceptance;

// 资产详情
// 规格
@property (nonatomic, copy) NSString * voucherSpec;
/*
{
    balance = 100;
    contractAddress = buQt7RA1wdN5U4g1SpxTFs2nTs8qaK6q8Rre;
    description = "<null>";
    endTime = "-1";
    faceValue = 200;
    spuId = 20190701055159000000;
    startTime = "-1";
    trancheId = 0;
    voucherAcceptance =                 {
        address = buQY78z9rKn1kZWjJZt6Y5Ak9CyVaqQjTxYy;
        icon = "";
        name = "\U9752\U4e91\U7f51\U7edc\U6280\U672f\U6709\U9650\U516c\U53f8";
    };
    voucherIcon = "";
    voucherId = 20190701055159000002;
    voucherIssuer =                 {
        address = buQrp3BCVdfbb5mJjNHZQwHvecqe7CCcounY;
        icon = "";
        name = "\U9752\U4e91\U7f51\U7edc\U6280\U672f\U6709\U9650\U516c\U53f8";
    };
    voucherName = "\U8010\U514b\U978b\U5b50";
    voucherProperties =                 (
                                         {
                                             key = "\U5c3a\U7801";
                                             value = 34;
                                         },
                                         {
                                             key = "\U989c\U8272";
                                             value = "\U767d\U8272";
                                         }
                                         );
},
*/
/*
 {
 data =     {
 contractAddress = buQt7RA1wdN5U4g1SpxTFs2nTs8qaK6q8Rre;
 description = "<null>";
 endTime = "-1";
 faceValue = 200;
 spuId = 20190701055159000000;
 startTime = "-1";
 trancheId = 0;
 voucherAcceptance =         {
 address = buQY78z9rKn1kZWjJZt6Y5Ak9CyVaqQjTxYy;
 icon = "";
 name = "\U9752\U4e91\U7f51\U7edc\U6280\U672f\U6709\U9650\U516c\U53f8";
 };
 voucherIcon = "";
 voucherId = 20190701055159000002;
 voucherIssuer =         {
 address = buQrp3BCVdfbb5mJjNHZQwHvecqe7CCcounY;
 icon = "";
 name = "\U9752\U4e91\U7f51\U7edc\U6280\U672f\U6709\U9650\U516c\U53f8";
 };
 voucherName = "\U8010\U514b\U978b\U5b50";
 voucherSpec = "34\U767d\U8272";
 };
 errCode = 0;
 msg = "\U6210\U529f";
 }
 */
@end

NS_ASSUME_NONNULL_END
