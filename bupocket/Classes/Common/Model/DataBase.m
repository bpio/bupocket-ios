//
//  DataBase.m
//  bupocket
//
//  Created by huoss on 2019/8/13.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"
#import "FileManager.h"
#import "AddressBookModel.h"
#import "VoucherModel.h"
#import "AdsModel.h"
#import "NodePlanModel.h"
#import "CooperateModel.h"
#import "VersionModel.h"

@interface DataBase()<NSCopying,NSMutableCopying>

@end

static NSString * const AddressBook = @"addressBook";
static NSString * const Voucher = @"voucher";
static NSString * const Find_Banner = @"findBanner";
static NSString * const Node = @"node";
static NSString * const Cooperate = @"cooperate";
static NSString * const VersionLog = @"versionLog";

//static NSString * const AddressBook_Cache_Name = @"addressBook.sqlite";
//static NSString * const Voucher_List_Cache_Name = @"voucherList.sqlite";
//static NSString * const Find_Banner_Cache_Name = @"findBanner.sqlite";
//static NSString * const Node_List_Cache_Name = @"nodeList.sqlite";
//static NSString * const Cooperate_List_Cache_Name = @"cooperateList.sqlite";
//static NSString * const VersionLog_List_Cache_Name = @"versionLogList.sqlite";


@implementation DataBase

static DataBase * _shareTool = nil;
static FMDatabase *_db;

+ (instancetype)shareDataBase {
    if (_shareTool == nil) {
        _shareTool = [[DataBase alloc] init];
        [_shareTool initDataBase];
    }
    return _shareTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_shareTool == nil) {
        _shareTool = [super allocWithZone:zone];
    }
    return _shareTool;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

- (void)initDataBase {
    // 获得Documents目录路径
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString * filePath = [documentsPath stringByAppendingPathComponent:@"dataBase.sqlite"];
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    // 初始化数据表
    NSString * addressBookSql = [self getTableSqlWithStr:AddressBook];
    NSString * voucherSql = [self getTableSqlWithStr:Voucher];
    NSString * findBannerSql = [self getTableSqlWithStr:Find_Banner];
    NSString * nodeSql = [self getTableSqlWithStr:Node];
    NSString * cooperateSql = [self getTableSqlWithStr:Cooperate];
    NSString * versionLogSql = [self getTableSqlWithStr:VersionLog];
    [_db executeUpdate:addressBookSql];
    [_db executeUpdate:voucherSql];
    [_db executeUpdate:findBannerSql];
    [_db executeUpdate:nodeSql];
    [_db executeUpdate:cooperateSql];
    [_db executeUpdate:versionLogSql];
    [_db close];
}
- (NSString *)getTableSqlWithStr:(NSString *)str
{
    return [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_%@(id integer PRIMARY KEY AUTOINCREMENT, %@ blob NOT NULL);", str, str];
}
- (NSString *)getDBNameWithCacheDataType:(CacheDataType)cacheType
{
    NSString * dbName;
    if (cacheType == CacheTypeAddressBook) {
        dbName = AddressBook;
    } else if (cacheType == CacheTypeVoucherList) {
        dbName = Voucher;
    } else if (cacheType == CacheTypeFindBanner) {
        dbName = Find_Banner;
    } else if (cacheType == CacheTypeNodeList) {
        dbName = Node;
    } else if (cacheType == CacheTypeCooperateList) {
        dbName = Cooperate;
    } else if (cacheType == CacheTypeVersionLogList) {
        dbName = VersionLog;
    }
    return dbName;
}
- (BaseModel *)getDBModelWithCacheDataType:(CacheDataType)cacheType dic:(NSDictionary *)dic
{
    BaseModel * dbModel;
    if (cacheType == CacheTypeAddressBook) {
        dbModel = [AddressBookModel mj_objectWithKeyValues:dic];
    } else if (cacheType == CacheTypeVoucherList) {
        dbModel = [VoucherModel mj_objectWithKeyValues:dic];
    } else if (cacheType == CacheTypeFindBanner) {
        dbModel = [AdsModel mj_objectWithKeyValues:dic];
    } else if (cacheType == CacheTypeNodeList) {
        dbModel = [NodePlanModel mj_objectWithKeyValues:dic];
    } else if (cacheType == CacheTypeCooperateList) {
        dbModel = [CooperateModel mj_objectWithKeyValues:dic];
    } else if (cacheType == CacheTypeVersionLogList) {
        dbModel = [VersionModel mj_objectWithKeyValues:dic];
    }
    return dbModel;
}
- (void)saveDataWithArray:(NSArray *)array cacheType:(CacheDataType)cacheType
{
    [_db open];
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
        NSString * sql = [NSString stringWithFormat:@"INSERT INTO t_%@(%@) VALUES (?);", dbName, dbName];
//        [_db executeUpdateWithFormat:@"INSERT INTO t_%@(%@) VALUES (%@);", dbName, dbName, dicData];
        [_db executeUpdate:sql, dicData];
    }
    [_db close];
}
- (NSArray *)getCachedDataWithCacheType:(CacheDataType)cacheType
{
    [_db open];
    NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
    NSMutableArray * cacheArray = [NSMutableArray array];
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM t_%@;", dbName];
    FMResultSet * resultSet = [_db executeQuery: sql];
    while (resultSet.next) {
        NSData * data = [resultSet objectForColumn:dbName];
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        BaseModel * model = [self getDBModelWithCacheDataType:cacheType dic:dic];
        [cacheArray addObject:model];
    }
    [_db close];
    return cacheArray;
}
- (void)deleteCachedDataWithCacheType:(CacheDataType)cacheType
{
    [_db open];
    NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM t_%@;", dbName];
    [_db executeUpdate:sql];
    [_db close];
    //    [_db executeUpdate:@"DROP TABLE IF EXISTS t_addressBook;"];
}

@end
