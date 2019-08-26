//
//  DataBase.m
//  bupocket
//
//  Created by huoss on 2019/8/13.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"
#import "AssetsListModel.h"
#import "AssetsDetailModel.h"
#import "AddressBookModel.h"
#import "VoucherModel.h"
#import "AdsModel.h"
#import "NodePlanModel.h"
#import "CooperateModel.h"
#import "VersionModel.h"

#define DataBaseFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"dataBase.sqlite"]

@interface DataBase()<NSCopying,NSMutableCopying>

@end

static NSString * const Assets = @"assets";
static NSString * const TransactionRecord = @"transactionRecord";
static NSString * const TransactionDetails = @"transactionDetails";
static NSString * const AddressBook = @"addressBook";
static NSString * const Voucher = @"voucher";
static NSString * const VoucherDetail = @"voucherDetail";
static NSString * const Find_Banner = @"findBanner";
static NSString * const Node = @"node";
static NSString * const Cooperate = @"cooperate";
static NSString * const VersionLog = @"versionLog";

@implementation DataBase

static DataBase * _shareTool = nil;
static FMDatabase * _db;

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
    DLog(@"数据库路径 %@", DataBaseFilePath);
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:DataBaseFilePath];
    [_db open];
    // 初始化数据表
    NSArray * titleArray = @[Assets , TransactionRecord, TransactionDetails, AddressBook, Voucher, VoucherDetail, Find_Banner, Node, Cooperate, VersionLog];
    for (NSString * title in titleArray) {
        [self setTableSqlWithTitle:title];
    }
    [_db close];
}
- (void)setTableSqlWithTitle:(NSString *)title
{
    NSString * str = @"";
    if ([title isEqualToString:Assets]) {
        str = @", network text NOT NULL, currency text NOT NULL, walletAddress text NOT NULL";
    } else if ([title isEqualToString:TransactionRecord] || [title isEqualToString:Voucher]) {
        str = @", network text NOT NULL, walletAddress text NOT NULL";
    } else if ([title isEqualToString:TransactionDetails] || [title isEqualToString:VoucherDetail]) {
        str = @", network text NOT NULL, walletAddress text NOT NULL, detailId text NOT NULL";
    }
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_%@(id integer PRIMARY KEY AUTOINCREMENT%@, %@ blob NOT NULL);", title, str, title];
    [_db executeUpdate:sql];
}
- (NSString *)getDBNameWithCacheDataType:(CacheDataType)cacheType
{
    NSString * dbName;
    if (cacheType == CacheTypeAssets) {
        dbName = Assets;
    } else if (cacheType == CacheTypeTransactionRecord) {
        dbName = TransactionRecord;
    } else if (cacheType == CacheTypeTransactionDetails) {
        dbName = TransactionDetails;
    } else if (cacheType == CacheTypeAddressBook) {
        dbName = AddressBook;
    } else if (cacheType == CacheTypeVoucherList) {
        dbName = Voucher;
    } else if (cacheType == CacheTypeVoucherDetail) {
        dbName = VoucherDetail;
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
    if (cacheType == CacheTypeAssets) {
        dbModel = [AssetsListModel mj_objectWithKeyValues:dic];
    } else if (cacheType == CacheTypeTransactionRecord) {
        dbModel = [AssetsDetailModel mj_objectWithKeyValues:dic];
    } else if (cacheType == CacheTypeAddressBook) {
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
    NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO t_%@(%@) VALUES (?);", dbName, dbName];
    if (cacheType == CacheTypeAssets) {
        sql = [NSString stringWithFormat:@"INSERT INTO t_%@(network, currency, walletAddress, %@) VALUES (?, ?, ?, ?);", dbName, dbName];
    } else if (cacheType == CacheTypeTransactionRecord || cacheType == CacheTypeVoucherList) {
        sql = [NSString stringWithFormat:@"INSERT INTO t_%@(network, walletAddress, %@) VALUES (?, ?, ?);", dbName, dbName];
    }
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        //        [_db executeUpdateWithFormat:@"INSERT INTO t_%@(%@) VALUES (%@);", dbName, dbName, dicData];
        NSString * network = [[HTTPManager shareManager] getCurrentNetwork];
        if (cacheType == CacheTypeAssets) {
            [_db executeUpdate: sql, network, [self getCurrentCurrency], CurrentWalletAddress, dicData];
        } else if (cacheType == CacheTypeTransactionRecord || cacheType == CacheTypeVoucherList) {
            [_db executeUpdate:sql, network, CurrentWalletAddress, dicData];
        } else {
            [_db executeUpdate:sql, dicData];
        }
    }
    [_db close];
}

- (NSArray *)getCachedDataWithCacheType:(CacheDataType)cacheType
{
    [_db open];
    NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
    NSMutableArray * cacheArray = [NSMutableArray array];
    // @"SELECT * FROM t_addressBook WHEWR ORDER BY idStr DESC limit;"
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM t_%@;", dbName];
    FMResultSet * resultSet;
    NSString * network = [[HTTPManager shareManager] getCurrentNetwork];
    if (cacheType == CacheTypeAssets) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_%@ WHERE network = ? and currency = ? and walletAddress = ?;", dbName];
        resultSet = [_db executeQuery: sql , network, [self getCurrentCurrency], CurrentWalletAddress];
        DLog(@"当前钱包地址：%@", CurrentWalletAddress);
    } else if (cacheType == CacheTypeTransactionRecord || cacheType == CacheTypeVoucherList) {
        sql = [NSString stringWithFormat:@"SELECT * FROM t_%@ WHERE network = ? and walletAddress = ?;", dbName];
        resultSet = [_db executeQuery: sql, network, CurrentWalletAddress];
    } else {
        resultSet = [_db executeQuery: sql];
    }
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
    NSString * network = [[HTTPManager shareManager] getCurrentNetwork];
    if (cacheType == CacheTypeAssets) {
        sql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE network = ? and currency = ? and walletAddress = ?;", dbName];
        [_db executeUpdate: sql, network, [self getCurrentCurrency], CurrentWalletAddress];
    } else if (cacheType == CacheTypeTransactionRecord || cacheType == CacheTypeVoucherList) {
        sql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE network = ? and walletAddress = ?;", dbName];
        [_db executeUpdate:sql, network, CurrentWalletAddress];
    } else {
        [_db executeUpdate:sql];
    }
    [_db close];
    //    [_db executeUpdate:@"DROP TABLE IF EXISTS t_addressBook;"];
}

- (NSString *)getCurrentCurrency
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * currentCurrency = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[defaults objectForKey:Current_Currency] integerValue]];
    return currentCurrency;
}
// Transaction Details
- (void)saveDetailDataWithCacheType:(CacheDataType)cacheType dic:(NSDictionary *)dic ID:(NSString *)ID
{
    [_db open];
    NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
    NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO t_%@(network, walletAddress, detailId, %@) VALUES (?, ?, ?, ?);", dbName, dbName];
    NSString * network = [[HTTPManager shareManager] getCurrentNetwork];
    [_db executeUpdate: sql, network, CurrentWalletAddress, ID, dicData];
    [_db close];
}
- (NSDictionary *)getDetailCachedDataWithCacheType:(CacheDataType)cacheType detailId:(NSString *)detailId
{
    [_db open];
    NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    // @"SELECT * FROM t_addressBook WHEWR ORDER BY idStr DESC limit;"
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM t_%@ WHERE detailId = ?;", dbName];
    FMResultSet * resultSet = [_db executeQuery: sql, detailId];
    while (resultSet.next) {
        NSData * data = [resultSet objectForColumn:dbName];
        dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    [_db close];
    return dic;
}
- (void)deleteTxDetailsCachedDataWithCacheType:(CacheDataType)cacheType detailId:(NSString *)detailId
{
    [_db open];
    NSString * dbName = [self getDBNameWithCacheDataType:cacheType];
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE detailId = ?;", dbName];
    [_db executeUpdate: sql, detailId];
    [_db close];
}
- (void)clearCache
{
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:DataBaseFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:DataBaseFilePath error:nil];
    }
}

/*
 - (void)executeUpdateWithAssetsSql:(NSString *)sql dicData:(NSData *)dicData
 {
 
 NSString * network = [[HTTPManager shareManager] getCurrentNetwork];
 if (dicData) {
 [_db executeUpdate: sql, network, currentCurrency, CurrentWalletAddress, dicData];
 } else {
 [_db executeUpdate: sql, network, currentCurrency, CurrentWalletAddress];
 }
 }
#pragma mark - AddressBook
- (void)saveAddressBookWithArray:(NSArray *)array
{
    [_db open];
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [_db executeUpdateWithFormat:@"INSERT INTO t_addressBook(addressBook) VALUES (%@);", dicData];
    }
    [_db close];
}
- (NSArray *)cachedAddressBookData
{
    [_db open];
    NSMutableArray * cacheArray = [NSMutableArray array];
    // @"SELECT * FROM t_addressBook WHEWR ORDER BY idStr DESC limit;"
    FMResultSet * resultSet = [_db executeQuery:@"SELECT * FROM t_addressBook;"];
    while (resultSet.next) {
        NSData * data = [resultSet objectForColumn:@"addressBook"];
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        AddressBookModel * model = [AddressBookModel mj_objectWithKeyValues:dic];
        [cacheArray addObject:model];
    }
    [_db close];
    return cacheArray;
}
- (void)deleteAddressBookCached
{
    [_db open];
    [_db executeUpdate:@"DELETE FROM t_addressBook;"];
    [_db close];
    //    [_db executeUpdate:@"DROP TABLE IF EXISTS t_addressBook;"];
}

#pragma mark - VoucherList
- (void)saveVoucherWithArray:(NSArray *)array
{
    [_db open];
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [_db executeUpdateWithFormat:@"INSERT INTO t_voucher(voucher) VALUES (%@);", dicData];
    }
    [_db close];
}
- (NSArray *)cachedVoucherData
{
    [_db open];
    NSMutableArray * cacheArray = [NSMutableArray array];
    FMResultSet * resultSet = [_db executeQuery:@"SELECT * FROM t_voucher;"];
    while (resultSet.next) {
        NSData * data = [resultSet objectForColumn:@"voucher"];
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        VoucherModel * model = [VoucherModel mj_objectWithKeyValues:dic];
        [cacheArray addObject:model];
    }
    [_db close];
    return cacheArray;
}
- (void)deleteVoucherCached
{
    [_db open];
    [_db executeUpdate:@"DELETE FROM t_voucher;"];
    [_db close];
}

#pragma mark - NodeList
- (void)saveNodeWithArray:(NSArray *)array
{
    [_db open];
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [_db executeUpdateWithFormat:@"INSERT INTO t_node(node) VALUES (%@);", dicData];
    }
    [_db close];
}
- (NSArray *)cachedNodeData
{
    [_db open];
    NSMutableArray * cacheArray = [NSMutableArray array];
    FMResultSet * resultSet = [_db executeQuery:@"SELECT * FROM t_node;"];
    while (resultSet.next) {
        NSData * data = [resultSet objectForColumn:@"node"];
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NodePlanModel * model = [NodePlanModel mj_objectWithKeyValues:dic];
        [cacheArray addObject:model];
    }
    [_db close];
    return cacheArray;
}
- (void)deleteNodeCached
{
    [_db open];
    [_db executeUpdate:@"DELETE FROM t_node;"];
    [_db close];
}

#pragma mark - CooperateList
- (void)saveCooperateWithArray:(NSArray *)array
{
    [_db open];
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [_db executeUpdateWithFormat:@"INSERT INTO t_cooperate(cooperate) VALUES (%@);", dicData];
    }
    [_db close];
}
- (NSArray *)cachedCooperateData
{
    [_db open];
    NSMutableArray * cacheArray = [NSMutableArray array];
    FMResultSet * resultSet = [_db executeQuery:@"SELECT * FROM t_cooperate;"];
    while (resultSet.next) {
        NSData * data = [resultSet objectForColumn:@"cooperate"];
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CooperateModel * model = [CooperateModel mj_objectWithKeyValues:dic];
        [cacheArray addObject:model];
    }
    [_db close];
    return cacheArray;
}
- (void)deleteCooperateCached
{
    [_db open];
    [_db executeUpdate:@"DELETE FROM t_cooperate;"];
    [_db close];
}

#pragma mark - VersionLogList
- (void)saveVersionLogWithArray:(NSArray *)array
{
    [_db open];
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [_db executeUpdateWithFormat:@"INSERT INTO t_versionLog(versionLog) VALUES (%@);", dicData];
    }
    [_db close];
}
- (NSArray *)cachedVersionLogData
{
    [_db open];
    NSMutableArray * cacheArray = [NSMutableArray array];
    FMResultSet * resultSet = [_db executeQuery:@"SELECT * FROM t_versionLog;"];
    while (resultSet.next) {
        NSData * data = [resultSet objectForColumn:@"versionLog"];
        NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        VoucherModel * model = [VoucherModel mj_objectWithKeyValues:dic];
        [cacheArray addObject:model];
    }
    [_db close];
    return cacheArray;
}
- (void)deleteVersionLogCached
{
    [_db open];
    [_db executeUpdate:@"DELETE FROM t_versionLog;"];
    [_db close];
}
*/

@end
