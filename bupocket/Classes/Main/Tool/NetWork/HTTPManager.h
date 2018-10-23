//
//  HTTPManager.h
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPManager : NSObject

+ (HTTPManager *)shareManager;
// Assets
+ (void)getDataWithSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure;
/*
#pragma mark 注册
+ (void)getAccountDataWithtype:(NSInteger)type
                  txt_realname:(NSString *)txt_realname
                   txt_usernum:(NSString *)txt_usernum
                    txt_verify:(NSString *)txt_verify
                  txt_password:(NSString *)txt_password
                    txt_paypwd:(NSString *)txt_paypwd
                   txt_country:(NSString *)txt_country
                  txt_province:(NSString *)txt_province
                      txt_city:(NSString *)txt_city
                  txt_district:(NSString *)txt_district
                   txt_address:(NSString *)txt_address
                     txt_refid:(NSString *)txt_refid
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;
#pragma mark 登录 获取验证码
//type => 1：普通登录    2：快速登录
//txt_password => 1登录密码， 2快速登录时验证码
+ (void)getAccountLoginDataWithURL:(NSString *)URL
                              type:(NSInteger)type
                       txt_usernum:(NSString *)txt_usernum
                      txt_password:(NSString *)txt_password
                          user_tel:(NSString *)user_tel
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure;
#pragma mark 忘记密码 获取验证码 修改绑定手机
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
              phoneNum:(NSString *)phoneNum
              txt_code:(NSString *)txt_code
              newValue:(NSString *)newValue
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure;
#pragma mark 修改绑定手机、昵称、推荐人、支付密码、确认登录密码、新密码、忘记密码、个人信息、返利明细、我的粉丝
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
             paramName:(NSString *)paramName
            paramValue:(NSString *)paramValue
              txt_code:(NSString *)txt_code
             pageindex:(NSInteger)pageindex
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure;
#pragma mark 收藏
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
              txt_type:(NSInteger)txt_type
                    ID:(NSString *)ID
             pageindex:(NSInteger)pageindex
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure;
#pragma mark 兑换
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
              txt_type:(NSInteger)txt_type
            txt_amount:(NSString *)txt_amount
           txt_payword:(NSString *)txt_payword
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure;
#pragma mark style => 1=充值 2=购物     type => 1=支付宝 2=微信 3=余额 4=银联
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
                 style:(NSInteger)style
               txt_pwd:(NSString *)txt_pwd
             txt_money:(NSString *)txt_money
        txt_merchantid:(NSString *)txt_merchantid
       txt_remainmoney:(NSString *)txt_remainmoney
        txt_totalmoney:(NSString *)txt_totalmoney
            txt_remark:(NSString *)txt_remark
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure;
#pragma mark 实名认证
+ (void)getDataWithtype:(NSInteger)type
           txt_realname:(NSString *)txt_realname
               txt_card:(NSString *)txt_card
            txt_address:(NSString *)txt_address
          txt_alipaynum:(NSString *)txt_alipaynum
          txt_wechatnum:(NSString *)txt_wechatnum
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError * error))failure;

#pragma mark 添加、编辑银行卡/微信/支付宝
+ (void)getDataWithtype:(NSInteger)type
               txt_type:(NSInteger)txt_type
             txt_verify:(NSString *)txt_verify
        txt_accountname:(NSString *)txt_accountname
            txt_banknum:(NSString *)txt_banknum
           txt_bankname:(NSString *)txt_bankname
           txt_province:(NSString *)txt_province
               txt_city:(NSString *)txt_city
           txt_district:(NSString *)txt_district
            txt_address:(NSString *)txt_address
           txt_bankopen:(NSString *)txt_bankopen
             txt_remark:(NSString *)txt_remark
            txt_default:(NSInteger)txt_default
             txt_bankid:(NSString *)txt_bankid
         txt_alipayname:(NSString *)txt_alipayname
          txt_alipaynum:(NSString *)txt_alipaynum
         txt_wechatname:(NSString *)txt_wechatname
          txt_wechatnum:(NSString *)txt_wechatnum
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError * error))failure;
#pragma mark 会员提现
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
            paramName0:(NSString *)paramName0
           paramValue0:(NSString *)paramValue0
            paramName1:(NSString *)paramName1
           paramValue1:(NSString *)paramValue1
            paramName2:(NSString *)paramName2
           paramValue2:(NSString *)paramValue2
            paramName3:(NSString *)paramName3
           paramValue3:(NSString *)paramValue3
            paramName4:(NSString *)paramName4
           paramValue4:(NSString *)paramValue4
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure;
 */


@end
