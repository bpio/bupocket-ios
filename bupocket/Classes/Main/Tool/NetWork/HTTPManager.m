//
//  HTTPManager.m
//  TheImperialPalaceMuseum
//
//  Created by 霍双双 on 17/2/25.
//  Copyright © 2017年 hss. All rights reserved.
//

#import "HTTPManager.h"
#import "HttpTool.h"
#import "Util.h"

@implementation HTTPManager

+ (HTTPManager *)shareManager
{
    __strong static HTTPManager * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[HTTPManager alloc]init];
    });
    return shareManager;
}
#pragma mark -- 辅助函数 处理共同的特性等.
/**
 *  将HTTP的string类型参数转换成字典
 *
 *  @param body phone=1234567&password=321
 *
 *  @return @{@"phone":@"1234567",@"password":@"321"}
 */
- (NSDictionary *)parametersWithHTTPBody:(NSString *)body
{
    if (body.length == 0) {
        return nil;
    }
    NSArray *array = [body componentsSeparatedByString:@"&"];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    for (NSString * str in array) {
        NSString * key = [str componentsSeparatedByString:@"="][0];
        NSString * value = [str componentsSeparatedByString:@"="][1];
        [parameters setValue:value forKey:key];
    }
    return parameters;
}
// Assets
+ (void)getDataWithSuccess:(void (^)(id responseObject))success
                   failure:(void (^)(NSError *error))failure {
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Assets_List);
//    NSArray * tokenList = @[@{@"assetCode":@"CLB", @"issuer":@"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje"}];
    NSArray * tokenList = [NSArray array];
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"address=%@&currencyType=%@&tokenList=%@&assetCode=&issuer=", @"buQWESXjdgXSFFajEZfkwi5H4fuAyTGgzkje", @"UD", tokenList];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //创建请求request
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:30];
    //设置请求方式为POST
    request.HTTPMethod = @"POST";
    //设置请求内容格式
//    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = data;
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
    [manager.requestSerializer setTimeoutInterval:30.0];
    NSURLSessionDataTask *dataTask =[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        
    }];
//    [manager dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//
//    }];
    
    //7.执行任务
    [dataTask resume];
//    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
//        if(success != nil)
//        {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if(failure != nil)
//        {
//            failure(error);
//        }
//    }];
}
/*
//参数名    类型    必填    长度    参数    备注
//txt_usernum    int    Y    11    用户手机    必须为11位数字
//txt_verify    int    Y    6    短信验证码    必须为6位数字
//txt_password    string    Y    32    密码    注册密码
//txt_country    int    Y    11    国家    必须是数字值为1
//txt_province    int    Y    11    省份    必须是数字
//txt_city    int    Y    11    城市    必须是数字
//txt_district    int    Y    11    县区    必须是数字
//txt_address    string    Y    255    详细地址    长度不能超过50个字符
//txt_refid    int    Y    11    推荐人编号
//type    int    Y        标识    3：注册
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
                       failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Interface_Acount);
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"type=%zd&txt_realname=%@&txt_usernum=%@&txt_verify=%@&txt_password=%@&txt_paypwd=%@&txt_country=%@&txt_province=%@&txt_city=%@&txt_district=%@&txt_address=%@&txt_refid=%@", type, txt_realname, txt_usernum, txt_verify, txt_password, txt_paypwd, txt_country, txt_province, txt_city, txt_district, txt_address, txt_refid];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
//txt_code：0=成功  1=失败  2=token失效 4=无数据
#pragma mark 登录 获取验证码
//type => 1：普通登录    2：快速登录
//txt_password => 1登录密码， 2快速登录时验证码
+ (void)getAccountLoginDataWithURL:(NSString *)URL
                              type:(NSInteger)type
                       txt_usernum:(NSString *)txt_usernum
                      txt_password:(NSString *)txt_password
                          user_tel:(NSString *)user_tel
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(NSError *error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"type=%zd&txt_usernum=%@&txt_password=%@&user_tel=%@", type, txt_usernum, txt_password, user_tel];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
#pragma mark 忘记密码 获取验证码 修改绑定手机 确认登录密码
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
              phoneNum:(NSString *)phoneNum
              txt_code:(NSString *)txt_code
              newValue:(NSString *)newValue
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
    NSString * tel = nil;
    NSString * code = nil;
    if ([URL isEqualToString:Interface_VerificationCode]) {
        tel = @"user_tel";
        code = @"txt_code";
    } else if ([URL isEqualToString:Interface_EditProfile]) {
        if (type == 5) {//确认登录密码
            tel = @"txt_userpwd";
            code = @"txt_verify";
        } else {
            // type = 1修改绑定手机  type = 7忘记密码
            tel = @"txt_usertel";
            code = @"txt_code";
            // type = 6 新密码  7 txt_newpwd=%@&txt_tnewpwd
//            if (type == 1) {
//                newName = @"";
//            } else {
//                newName = @"";
//            }
        }
    }
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&%@=%@&%@=%@&txt_newpwd=%@&txt_tnewpwd=%@", CurrentUserToken, CurrentUserID,type, tel, phoneNum, code, txt_code, newValue, newValue];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
//#pragma mark 商家注册
//+ (void)getBusinessAccountDataWithtype:(NSInteger)type
//                           txt_usernum:(NSString *)txt_usernum
//                            txt_verify:(NSString *)txt_verify
//                          txt_password:(NSString *)txt_password
//                           txt_country:(NSString *)txt_country
//                          txt_province:(NSString *)txt_province
//                              txt_city:(NSString *)txt_city
//                          txt_district:(NSString *)txt_district
//                           txt_address:(NSString *)txt_address
//                             txt_refid:(NSString *)txt_refid
//                               success:(void (^)(id responseObject))success
//                               failure:(void (^)(NSError *error))failure
//{
//
//}
#pragma mark 修改绑定手机、昵称、推荐人、支付密码、确认登录密码、新密码、忘记密码、个人信息、返利明细、我的粉丝
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
             paramName:(NSString *)paramName
            paramValue:(NSString *)paramValue
              txt_code:(NSString *)txt_code
             pageindex:(NSInteger)pageindex
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
    NSString * code = @"txt_code";
    if ([URL isEqualToString:Interface_EditProfile]) {
        // 支付密码
        code = @"txt_verify";
    }
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&txt_lng=%@&txt_lat=%@&type=%zd&%@=%@&%@=%@&pagerindex=10&pagernum=%zd", CurrentUserToken, CurrentUserID, CurrentLongitude, CurrentLatitude, type, paramName, paramValue, code, txt_code, pageindex];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@-----%@", url, parameters);
        if(failure != nil)
        {
            failure(error);
        }
    }];
}

#pragma mark 收藏
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
              txt_type:(NSInteger)txt_type
                    ID:(NSString *)ID
             pageindex:(NSInteger)pageindex
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
    NSString * IDName;
    if ([URL isEqualToString:Interface_Collect]) {
        IDName = @"txt_supplierid";
    } else if ([URL isEqualToString:Interface_Deposit]) {
        IDName = @"txt_bankid";
    } else if ([URL isEqualToString:Interface_Turnover]) {
        IDName = @"txt_sppid";
    } else if ([URL isEqualToString:Interface_BusinessList]) {
        IDName = @"txt_goodsid";
    }
//    txt_supplierid
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&txt_type=%zd&%@=%@&pagerindex=10&pagernum=%zd", CurrentUserToken, CurrentUserID, type, txt_type, IDName, ID, pageindex];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
#pragma mark 兑换
+ (void)getDataWithURL:(NSString *)URL
                  type:(NSInteger)type
              txt_type:(NSInteger)txt_type
            txt_amount:(NSString *)txt_amount
           txt_payword:(NSString *)txt_payword
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&txt_type=%zd&txt_amount=%@&txt_payword=%@", CurrentUserToken, CurrentUserID, type, txt_type, txt_amount, txt_payword];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
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
               failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&style=%zd&txt_pwd=%@&txt_money=%@&txt_merchantid=%@&txt_remainmoney=%@&txt_totalmoney=%@&txt_remark=%@", CurrentUserToken, CurrentUserID, type, style, txt_pwd, txt_money, txt_merchantid, txt_remainmoney, txt_totalmoney, txt_remark];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}

////#pragma mark 我的积分 我的答疑 txt_type => 0=已回复 1=未审核 2=未回复   默认0
//////txt_code=0成功，1失败，2 token失效，3 其他
//+ (void)getDataWithURL:(NSString *)URL
//                  type:(NSInteger)type
//              pagernum:(NSInteger)pagernum
//               success:(void (^)(id responseObject))success
//               failure:(void (^)(NSError * error))failure
//{
//    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
//    //HTTP请求体
//    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&pagerindex=10&pagernum=%zd", CurrentUserToken, CurrentUserID, type, pagernum];
//    //请求体转换成字典
//    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
//    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
//        if(success != nil)
//        {
//            success(responseObject);
//        }
//    } failure:^(NSError *error) {
//        if(failure != nil)
//        {
//            failure(error);
//        }
//    }];
//}
#pragma mark 实名认证
+ (void)getDataWithtype:(NSInteger)type
           txt_realname:(NSString *)txt_realname
               txt_card:(NSString *)txt_card
            txt_address:(NSString *)txt_address
          txt_alipaynum:(NSString *)txt_alipaynum
          txt_wechatnum:(NSString *)txt_wechatnum
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Interface_EditProfile);
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&txt_realname=%@&txt_card=%@&txt_address=%@&txt_alipaynum=%@&txt_wechatnum=%@", CurrentUserToken, CurrentUserID, type, txt_realname, txt_card, txt_address, txt_alipaynum, txt_wechatnum];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
#pragma mark 添加、编辑银行卡
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
                failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, Interface_Deposit);
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&txt_type=%zd&txt_verify=%@&txt_accountname=%@&txt_banknum=%@&txt_bankname=%@&txt_province=%@&txt_city=%@&txt_district=%@&txt_address=%@&txt_bankopen=%@&txt_remark=%@&txt_default=%zd&txt_bankid=%@&txt_alipayname=%@&txt_alipaynum=%@&txt_wechatname=%@&txt_wechatnum=%@", CurrentUserToken, CurrentUserID, type, txt_type, txt_verify, txt_accountname, txt_banknum, txt_bankname, txt_province, txt_city, txt_district, txt_address, txt_bankopen, txt_remark, txt_default, txt_bankid, txt_alipayname, txt_alipaynum, txt_wechatname, txt_wechatnum];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
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
               failure:(void (^)(NSError * error))failure
{
    NSString * url = SERVER_COMBINE_API(URLPREFIX, URL);
    //HTTP请求体
    NSString * body = [NSString stringWithFormat:@"txt_usertoken=%@&txt_userid=%@&type=%zd&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@", CurrentUserToken, CurrentUserID, type, paramName0, paramValue0, paramName1, paramValue1, paramName2, paramValue2, paramName3, paramValue3, paramName4, paramValue4];
    //请求体转换成字典
    NSDictionary * parameters = [[HTTPManager shareManager] parametersWithHTTPBody:body];
    [HttpTool POST:url parameters:parameters success:^(id responseObject) {
        if(success != nil)
        {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if(failure != nil)
        {
            failure(error);
        }
    }];
}
 */

@end
