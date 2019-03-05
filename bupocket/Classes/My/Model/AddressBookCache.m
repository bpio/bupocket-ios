//
//  AddressBookCache.m
//  bupocket
//
//  Created by bupocket on 2019/3/1.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "AddressBookCache.h"
#import <FMDB/FMDB.h>
#import "AddressBookModel.h"

@implementation AddressBookCache

static FMDatabase *_db;

+ (void)initialize
{
    NSString * dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * fileName = [dirPath stringByAppendingPathComponent:AddressBook_Cache_Name];
    _db = [FMDatabase databaseWithPath:fileName];
    if ([_db open]) {
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_addressBook(id integer PRIMARY KEY AUTOINCREMENT, addressBook blob NOT NULL);"];
        if (result) {
            DLog(@"创表成功");
        } else {
            DLog(@"创表失败");
        }
    }
}

+ (void)saveAddressBookWithArray:(NSArray *)array
{
    for (NSDictionary * dic in array) {
        NSData * dicData = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [_db executeUpdateWithFormat:@"INSERT INTO t_addressBook(addressBook) VALUES (%@);", dicData];
    }
}
+ (NSArray *)cachedAddressBookData
{
    NSMutableArray * cacheArray = [NSMutableArray array];
    // @"SELECT * FROM t_addressBook WHEWR ORDER BY idStr DESC limit;"
    FMResultSet * resultSet = [_db executeQuery:@"SELECT * FROM t_addressBook;"];
    while (resultSet.next) {
        NSData * addressBookData = [resultSet objectForColumn:@"addressBook"];
        NSDictionary * addressBookDic = [NSKeyedUnarchiver unarchiveObjectWithData:addressBookData];
        AddressBookModel * addressBookModel = [AddressBookModel mj_objectWithKeyValues:addressBookDic];
        [cacheArray addObject:addressBookModel];
    }
    return cacheArray;
}
+ (void)deleteAddressBookCached
{
    [_db executeUpdate:@"DELETE FROM t_addressBook;"];
//    [_db executeUpdate:@"DROP TABLE IF EXISTS t_addressBook;"];
}


@end
