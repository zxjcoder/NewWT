//
//  SQLiteOper.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "SQLiteOper.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "DBInitSql.h"
#import "Utils.h"
#import "AppSetting.h"
#import "ModelEntity.h"
#import "AESCrypt.h"

@interface SQLiteOper()

@property (retain, nonatomic) FMDatabaseQueue *dbQueue;

@end

@implementation SQLiteOper


static SQLiteOper *_instance;

#define dbQueue _instance.dbQueue

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (SQLiteOper*)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    [_instance open];
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(void)dealloc
{
    [_instance close];
    OBJC_RELEASE(_dbQueue);
    OBJC_RELEASE(_instance);
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)open
{
    if ([_instance isOpened]) { return; }
    
    [_instance close];
    
    NSString *dbpath = [[AppSetting getDocumentPath] stringByAppendingPathComponent: @"SQLITE.DB"];
#ifdef DEBUG
    NSLog(@"SQliteDataBasePath: %@", dbpath);
#endif
#if ! __has_feature(objc_arc)
    dbQueue = [[FMDatabaseQueue databaseQueueWithPath:dbpath] retain];
#else
    dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
#endif
    [_instance checkDBVersion];
}
-(void)close
{
    if (_instance != nil)
    {
        [dbQueue close];
        OBJC_RELEASE(dbQueue);
    }
}
-(BOOL)isOpened
{
    return dbQueue != nil;
}
///检查本地数据库版本,进行数据库升级
-(void)checkDBVersion
{
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSNumber *dbversion = @0;
        if([db tableExists:@"dbversion"])
        {
            FMResultSet *rs = [db executeQuery:@"SELECT version FROM dbversion"];
            if (rs != nil && [rs next]) {
                dbversion = [NSNumber numberWithInt:[rs intForColumnIndex:0]];
            }
            [rs close];
        }
        NSNumber *lastversioin = @0;
        NSArray *initsql = [DBInitSql getInitSql];
        for (int i=0; i<[initsql count];)
        {
            lastversioin = initsql[i];
            if ([dbversion intValue] < [initsql[i] intValue])
            {
                i++;
                NSArray *sqls = initsql[i];
                for (int j=0; j<[sqls count]; j++)
                {
                    [db executeUpdate:sqls[j]];
                }
            } else {
                i++;
            }
            i++;
        }
        if ([dbversion intValue] < [lastversioin intValue])
        {
            [db executeUpdate:@"DELETE FROM dbversion"];
            [db executeUpdate:@"INSERT INTO dbversion(version, note) VALUES(?, ?)", lastversioin, kEmpty];
        }
    }];
}

///获取自定义公共参数
-(NSString*)getSysParamWithKey:(NSString*)key
{
    NSString __block *re = kEmpty;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT para_value FROM sys_paras WHERE para_name=?", key];
        if (rs != nil && [rs next]) {
            re = [rs stringForColumnIndex:0];
        }
        [rs close];
    }];
    
    return re;
}

///设置自定义公共参数
-(BOOL)setSysParam:(NSString*)key value:(NSString*)value
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        re = [db executeUpdate:@"REPLACE INTO sys_paras(para_name, para_value, para_desc) VALUES(?, ?, NULL)", key, value];
    }];
    
    return re;
}

///清除数据库缓存
-(BOOL)clearHisData
{
    BOOL __block re = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSArray * arrSql = @[@"DELETE FROM sys_paras",];
        for (NSString *sqlX in arrSql) {
            re = [db executeUpdate:sqlX];
        }
    }];
    
    return re;
}

/**
 *  存储数据集合到本地文件
 *
 *  @param array 数据集合
 *  @param pathKey 文件KEY
 *  @return 返回执行结果
 */
-(BOOL)setLocalCacheDataWithArray:(NSArray*)array pathKay:(NSString*)pathKey
{
    NSString *filePath=[[AppSetting getDataFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",pathKey]];
    NSMutableArray *writeArray = [NSMutableArray array];
    for (id item in array) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            [writeArray addObject:item];
        } else if ([item isKindOfClass:[ModelEntity class]]) {
            [writeArray addObject:[(ModelEntity*)item getDictionary]];
        }
    }
    BOOL isSuccess = [writeArray writeToFile:filePath atomically:YES];
    return isSuccess;
}

/**
 *  存储数据集合到本地文件
 *
 *  @param dic      数据对象
 *  @param pathKey  文件KEY
 *  @return 返回执行结果
 */
-(BOOL)setLocalCacheDataWithDictionary:(NSDictionary*)dic pathKay:(NSString*)pathKey
{
    if (dic) {
        NSString *filePath=[[AppSetting getDataFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@key",[Utils stringMD5:pathKey]]];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        if (jsonData) {
            NSData *desEncryptedData = [jsonData DESEncryptedDataUsingKey:kDESEncryptedDataUsingKey error:nil];
            if (desEncryptedData) {
                return [desEncryptedData writeToFile:filePath atomically:YES];
            }
        }
    }
    return NO;
}

/**
 *  获取本地文件数据集合
 *
 *  @param pathKey 文件KEY
 *  @return 返回数据集合
 */
-(NSArray*)getLocalCacheDataArrayWithPathKay:(NSString*)pathKey
{
    NSString *filePath=[[AppSetting getDataFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",pathKey]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSArray arrayWithContentsOfFile:filePath];
    }
    return nil;
}

/**
 *  获取本地文件数据对象
 *
 *  @param pathKey 文件KEY
 *  @return 返回数据对象
 */
-(NSDictionary*)getLocalCacheDataWithPathKay:(NSString*)pathKey
{
    NSString *filePath=[[AppSetting getDataFilePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@key",[Utils stringMD5:pathKey]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *dataReulst = [NSData dataWithContentsOfFile:filePath];
        if (dataReulst) {
            dataReulst = [dataReulst decryptedDESDataUsingKey:kDESEncryptedDataUsingKey error:nil];
            NSDictionary *dicResult = [NSJSONSerialization JSONObjectWithData:dataReulst options:NSJSONReadingAllowFragments error:nil];
            return dicResult;
        }
    }
    return nil;
}

/**
 *  获取本地文件数据对象
 *
 *  @return 返回数据对象
 */
-(NSArray*)getLocalPlayMoney
{
    NSArray *result = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"LocalPayMoney" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSArray arrayWithContentsOfFile:filePath];
    }
    return result;
}

///设置最后一次播放对象
-(BOOL)setLocalPlayPracticeWithModel:(ModelPractice *)model
{
    if (model == nil) return NO;
    
    NSString *ids = model.ids==nil?kEmpty:model.ids;
    NSString *title = model.title==nil?kEmpty:model.title;
    NSString *time = model.time==nil?kEmpty:model.time;
    NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
    NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
    NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
    NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
    NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
    NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
    NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
    NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
    NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
    NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
    NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
    NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
    NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
    NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
    NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
    NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
    NSNumber *showText = [NSNumber numberWithInt:model.showText];
    NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
    NSString *price = model.price==nil?kEmpty:model.price;
    NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"DELETE FROM play_practice"];
        result = [db executeUpdate:@"REPLACE INTO play_practice(ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
    }];
    
    return result;
}
///获取最后一次播放对象
-(ModelPractice *)getLocalPlayPracticeModel
{
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM play_practice ORDER BY sortby ASC LIMIT 0,1"];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [rs resultDictionary];
                break;
            }
        }
        [rs close];
    }];
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        return [[ModelPractice alloc] initWithAuto:result];
    }
    return nil;
}
///获取指定ID播放对象
-(ModelPractice *)getLocalPlayPracticeModelWithId:(NSString *)ids
{
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM play_practice WHERE ids = '%@' LIMIT 0,1",ids]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [rs resultDictionary];
                break;
            }
        }
        [rs close];
    }];
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        return [[ModelPractice alloc] initWithAuto:result];
    }
    return nil;
}


///保存语音对象
-(BOOL)setLocalPracticeWithModel:(ModelPractice *)model
{
    if (model == nil) return NO;
    
    NSString *ids = model.ids==nil?kEmpty:model.ids;
    NSString *title = model.title==nil?kEmpty:model.title;
    NSString *time = model.time==nil?kEmpty:model.time;
    NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
    NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
    NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
    NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
    NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
    NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
    NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
    NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
    NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
    NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
    NSNumber *showText = [NSNumber numberWithInt:model.showText];
    NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
    NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
    NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
    NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
    NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
    NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
    NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
    NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
    NSString *price = model.price==nil?kEmpty:model.price;
    NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///添加图片
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_image WHERE typeid = '%@' AND typename = 'practice'",ids]];
        if (!result) {
            *rollback = YES;
        }
        for (NSString *url in model.arrImage) {
            if (url) {
                result = [db executeUpdate:@"REPLACE INTO sns_image(typeid,typename,imgurl,sortby) VALUES(?,'practice',?,strftime('%s%f','now'))" withArgumentsInArray:@[ids,url]];
                if (!result) {
                    break;
                }
            }
        }
        if (!result) {
            *rollback = YES;
        }
        result = [db executeUpdate:@"REPLACE INTO sns_practice(ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_title,person_synopsis,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_title,person_synopsis,showText,joinCart,price,buyStatus]];
    }];
    
    return result;
}

///获取指定ID实务对象
-(ModelPractice *)getLocalPracticeModelWithId:(NSString *)ids
{
    __block ModelPractice *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_practice WHERE ids = '%@' LIMIT 0,1",ids]];
        if (rs != nil)
        {
            while ([rs next]) {
                
                result = [[ModelPractice alloc] initWithAuto:[rs resultDictionary]];
                FMResultSet *rsArr = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_image WHERE typeid = '%@' AND typename = 'practice' ORDER BY sortby ASC",result.ids]];
                
                if (rsArr != nil)
                {
                    NSMutableArray *arrImage = [NSMutableArray array];
                    while ([rsArr next]) {
                        NSDictionary *dic = [rsArr resultDictionary];
                        NSString *imgUrl = [dic objectForKey:@"imgurl"];
                        if (imgUrl) {
                            [arrImage addObject:@{@"url":imgUrl}];
                        }
                    }
                    [result setArrImage:arrImage];
                }
                [rsArr close];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///保存实务集合
-(BOOL)setLocalPracticeWithArray:(NSArray *)arr userId:(NSString *)userId
{
    if (arr == nil || arr.count == 0) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_practice_detail WHERE userId = '%@' AND dataType = 1",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in arr) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            ///添加图片
            result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_image WHERE typeid = '%@' AND typename = 'practice'",ids]];
            if (!result) {
                *rollback = YES;
                break;
            }
            for (NSString *url in model.arrImage) {
                if (url) {
                    result = [db executeUpdate:@"REPLACE INTO sns_image(typeid,typename,imgurl,sortby) VALUES(?,'practice',?,strftime('%s%f','now'))" withArgumentsInArray:@[ids,url]];
                    if (!result) {
                        break;
                    }
                }
            }
            if (!result) {
                *rollback = YES;
                break;
            }
            ///添加语音
            result = [db executeUpdate:@"REPLACE INTO sns_practice_detail(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,dataType,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}

///获取实务集合
-(NSMutableArray *)getLocalPracticeOnePageWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_practice_detail WHERE userId = '%@' AND dataType = 1 ORDER BY sortby ASC",userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                ModelPractice *model = [[ModelPractice alloc] initWithAuto:dic];
                if (model.ids) {
                    __block NSMutableArray *arrImage = nil;
                    FMResultSet *rsArr = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_image WHERE typeid = '%@' AND typename = 'practice' ORDER BY sortby ASC",model.ids]];
                    if (rsArr != nil)
                    {
                        arrImage = [NSMutableArray array];
                        while ([rsArr next]) {
                            NSDictionary *dic = [rsArr resultDictionary];
                            NSString *imgUrl = [dic objectForKey:@"imgurl"];
                            if (imgUrl) {
                                [arrImage addObject:@{@"url":imgUrl}];
                            }
                        }
                    }
                    [rsArr close];
                    [model setArrImage:arrImage];
                }
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}

///保存语音对象
-(BOOL)setLocalPracticeDetailWithModel:(ModelPractice *)model  userId:(NSString *)userId
{
    if (model == nil) return NO;
    
    NSString *ids = model.ids==nil?kEmpty:model.ids;
    NSString *title = model.title==nil?kEmpty:model.title;
    NSString *time = model.time==nil?kEmpty:model.time;
    NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
    NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
    NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
    NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
    NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
    NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
    NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
    NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
    NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
    NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
    NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
    NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
    NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
    NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
    NSNumber *showText = [NSNumber numberWithInt:model.showText];
    NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
    NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
    NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
    NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
    NSString *price = model.price==nil?kEmpty:model.price;
    NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ///添加语音
        result = [db executeUpdate:@"REPLACE INTO sns_practice_detail(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,dataType,showText,person_synopsis,person_title,unlock,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,0,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,showText,person_synopsis,person_title,unlock,joinCart,price,buyStatus]];
        if (!result) {
            *rollback = YES;
        }
        ///添加图片
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_image WHERE typeid = '%@' AND typename = 'practice'",ids]];
        if (!result) {
            *rollback = YES;
        }
        for (NSString *url in model.arrImage) {
            if (url) {
                result = [db executeUpdate:@"REPLACE INTO sns_image(typeid,typename,imgurl,sortby) VALUES(?,'practice',?,strftime('%s%f','now'))" withArgumentsInArray:@[ids,url]];
                if (!result) {
                    *rollback = YES;
                    break;
                }
            }
        }
    }];
    
    return result;
}

///获取指定ID实务对象
-(ModelPractice *)getLocalPracticeDetailModelWithId:(NSString *)ids userId:(NSString *)userId
{
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_practice_detail WHERE ids = '%@' AND userId = '%@' AND dataType = 0 LIMIT 0,1",ids,userId]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [rs resultDictionary];
                break;
            }
        }
        [rs close];
    }];
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        ModelPractice *model = [[ModelPractice alloc] initWithAuto:result];
        if (model.ids) {
            __block NSMutableArray *arrImage = [NSMutableArray array];
            [dbQueue inDatabase:^(FMDatabase *db) {
                FMResultSet *rsArr = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_image WHERE typeid = '%@' AND typename = 'practice' ORDER BY sortby ASC",model.ids]];
                
                if (rsArr != nil)
                {
                    while ([rsArr next]) {
                        NSDictionary *dic = [rsArr resultDictionary];
                        NSString *imgUrl = [dic objectForKey:@"imgurl"];
                        if (imgUrl) {
                            [arrImage addObject:@{@"url":imgUrl}];
                        }
                    }
                }
                [rsArr close];
            }];
            [model setArrImage:arrImage];
        }
        return model;
    }
    return nil;
}
///修改音频对象
-(BOOL)updLocalAudioWithIds:(NSString *)ids objId:(NSString *)objId audioPlayTime:(NSString *)audioPlayTime audioPlayType:(NSString *)audioPlayType
{
    if (ids == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:[NSString stringWithFormat:@"UPDATE sns_play_audio SET audioPlayTime='%@' WHERE ids='%@' AND objId='%@' AND audioPlayType='%@';", audioPlayTime, ids, objId, audioPlayType]];
    }];
    
    return result;
}
///保存音频对象
-(BOOL)setLocalAudioWithModel:(ModelAudio *)model
{
    if (model == nil) return NO;
    
    NSString *ids = model.ids==nil?kEmpty:model.ids;
    NSString *objId = model.objId==nil?kEmpty:model.objId;
    NSString *audioTitle = model.audioTitle==nil?kEmpty:model.audioTitle;
    NSString *audioImage = model.audioImage==nil?kEmpty:model.audioImage;
    NSString *audioPath = model.audioPath==nil?kEmpty:model.audioPath;
    NSString *audioLocalPath = model.audioLocalPath==nil?kEmpty:model.audioLocalPath;
    NSString *audioAuthor = model.audioAuthor==nil?kEmpty:model.audioAuthor;
    NSNumber *audioPlayTime = [NSNumber numberWithLong:model.audioPlayTime];
    NSString *totalDuration = model.totalDuration==nil?kEmpty:model.totalDuration;
    NSNumber *audioPlayType = [NSNumber numberWithInt:model.audioPlayType];
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"REPLACE INTO sns_play_audio(ids,objId,audioTitle,audioAuthor,audioPath,audioLocalPath,audioImage,audioPlayTime,totalDuration,audioPlayType,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,objId,audioTitle,audioAuthor,audioPath,audioLocalPath,audioImage,audioPlayTime,totalDuration,audioPlayType]];
    }];
    
    return result;
}
///获取指定ID音频对象
-(ModelAudio *)getLocalAudioModelWithId:(NSString *)ids
{
    __block ModelAudio *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_play_audio WHERE ids = '%@' LIMIT 0,1",ids]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [[ModelAudio alloc] initWithAuto:[rs resultDictionary]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}
///获取指定OBJID和audioPlayType音频对象
-(ModelAudio *)getLocalAudioModelWithObjId:(NSString *)objId audioPlayType:(int)audioPlayType
{
    __block ModelAudio *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_play_audio WHERE objId = '%@' AND audioPlayType = '%@' LIMIT 0,1", objId, [NSNumber numberWithInt:audioPlayType]]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [[ModelAudio alloc] initWithAuto:[rs resultDictionary]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}
///获取最新的一条
-(ModelAudio *)getLocalAudioModelWithNewTopOne
{
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_play_audio ORDER BY sortby DESC LIMIT 0,1"]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [rs resultDictionary];
                break;
            }
        }
        [rs close];
    }];
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        return [[ModelAudio alloc] initWithAuto:result];
    }
    return nil;
}

///保存App配置对象
-(BOOL)setLocalAppConfigWithModel:(ModelAppConfig *)model
{
    if (model == nil) return NO;
    
    NSString *appVersion = APP_PROJECT_VERSION;
    NSNumber *platform = [NSNumber numberWithInt:model.platform];
    NSNumber *appStatus = [NSNumber numberWithInt:model.appStatus];
    NSNumber *rankStatus = [NSNumber numberWithInt:model.rankStatus];
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"REPLACE INTO sns_appconfig(appVersion,platform,appStatus,rankStatus,sortby) VALUES(?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[appVersion,platform,appStatus,rankStatus]];
    }];
    
    return result;
}

///获取指定App配置对象
-(ModelAppConfig *)getLocalAppConfigModelWithId:(NSString *)appVersion
{
    __block ModelAppConfig *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_appconfig WHERE appVersion = '%@' LIMIT 0,1",appVersion]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [[ModelAppConfig alloc] initWithAuto:[rs resultDictionary]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///保存第一页消息中心列表
-(BOOL)setLocalUserNoticeWithArray:(NSArray *)arr
{
    if (arr == nil || arr.count == 0) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_notice"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelNotice *model in arr) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            if (ids == nil || ids.length == 0) {
                NSString *ids = model.ids==nil?kEmpty:model.ids;
                NSString *noticeTitle = model.noticeTitle==nil?kEmpty:model.noticeTitle;
                NSString *noticeDesc = model.noticeDesc==nil?kEmpty:model.noticeDesc;
                NSNumber *noticeType = [NSNumber numberWithInt:model.noticeType];
                NSString *noticeLogo = model.noticeLogo==nil?kEmpty:model.noticeLogo;
                NSNumber *noticeCount = [NSNumber numberWithInt:model.noticeCount];
                NSString *noticeTime = model.noticeTime==nil?kEmpty:model.noticeTime;
                
                result = [db executeUpdate:@"REPLACE INTO sns_notice(ids,noticeTitle,noticeDesc,noticeType,noticeLogo,noticeCount,noticeTime,sortby) VALUES(?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,noticeTitle,noticeDesc,noticeType,noticeLogo,noticeCount,noticeTime]];
                if (!result) {
                    *rollback = YES;
                }
                break;
            }
        }
    }];
    
    return result;
}

///获取第一页消息中心列表
-(NSArray *)getLocalUserNotice
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_notice ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                [result addObject:[[ModelNotice alloc] initWithAuto:dic]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///保存第一页消息中心->详情列表
-(BOOL)setLocalUserNoticeDetailWithArray:(NSArray *)arr
{
    if (arr == nil || arr.count == 0) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_notice_detail"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelNoticeDetail *model in arr) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            if (ids == nil || ids.length == 0) {
                NSString *ids = model.ids==nil?kEmpty:model.ids;
                NSString *noticeContent = model.noticeContent==nil?kEmpty:model.noticeContent;
                NSString *noticeDesc = model.noticeDesc==nil?kEmpty:model.noticeDesc;
                NSString *noticeNickName = model.noticeNickName==nil?kEmpty:model.noticeNickName;
                NSString *noticeTime = model.noticeTime==nil?kEmpty:model.noticeTime;
                
                result = [db executeUpdate:@"REPLACE INTO sns_notice_detail(ids,noticeContent,noticeDesc,noticeNickName,noticeTime,isRead,sortby) VALUES(?,?,?,?,?,1,strftime('%s%f','now'));" withArgumentsInArray:@[ids,noticeContent,noticeDesc,noticeNickName,noticeTime]];
                if (!result) {
                    *rollback = YES;
                }
                break;
            }
        }
    }];
    
    return result;
}

///获取第一页消息中心->详情列表
-(NSArray *)getLocalUserNoticeDetail
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_notice_detail ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                [result addObject:[[ModelNoticeDetail alloc] initWithAuto:dic]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///保存话题分类列表
-(BOOL)setLocalTopicWithArray:(NSArray *)arr typeId:(NSString *)typeId userId:(NSString *)userId
{
    if (arr == nil || arr.count == 0) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_topic WHERE userId='%@' AND typeId='%@'",userId,typeId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelTag *model in arr) {
            NSString *tagId = model.tagId==nil?kEmpty:model.tagId;
            NSString *tagName = model.tagName==nil?kEmpty:model.tagName;
            NSString *tagLogo = model.tagLogo==nil?kEmpty:model.tagLogo;
            NSNumber *attCount = [NSNumber numberWithLong:model.attCount];
            NSNumber *isAtt = [NSNumber numberWithBool:model.isAtt];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *status = [NSNumber numberWithInt:model.status];
            
            result = [db executeUpdate:@"REPLACE INTO sns_topic(tagId,userId,typeId,tagName,tagLogo,status,isAtt,isCollection,attCount,sortby) VALUES(?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[tagId,userId,typeId,tagName,tagLogo,status,isAtt,isCollection,attCount]];
            if (!result) {
                *rollback = YES;
            }
            break;
        }
    }];
    
    return result;
}

///获取话题分类列表
-(NSArray *)getLocalTopicDetailWithTypeId:(NSString *)typeId userId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_topic WHERE userId='%@' AND typeId='%@' ORDER BY sortby ASC",userId,typeId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                [result addObject:[[ModelTag alloc] initWithAuto:dic]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///获取第一条的崩溃日志
-(NSString *)getLocalCatchCrashTop
{
    __block NSString *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_catchcrash ORDER BY pkid DESC LIMIT 0,1"];
        if (rs != nil)
        {
            while ([rs next]) {
                
                result = [rs stringForColumn:@"content"];
                break;
            }
        }
        [rs close];
    }];
    return result;
}
///添加未上传的崩溃日志
-(BOOL)setLocalCatchCrashWithContent:(NSString *)content
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"REPLACE INTO sns_catchcrash(content) VALUES('%@');", content]];
        
    }];
    
    return result;
}
///删除已上传的崩溃日志
-(BOOL)delLocalCatchCrash
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:@"DELETE FROM sns_catchcrash "];
        
    }];
    
    return result;
}

///删除全部的崩溃日志
-(BOOL)delLocalCatchCrashWithAll
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:@"DELETE FROM sns_catchcrash "];
        
    }];
    
    return result;
}

///保存实务对应的问题
-(BOOL)setLocalPracticeQuestionWithArray:(NSArray *)array practiceId:(NSString *)practiceId type:(ZPracticeQuestionType)type
{
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_practice_question WHERE pid='%@' AND qtype='%@' ",practiceId,[NSNumber numberWithInteger:type]]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPracticeQuestion *model in array) {
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *aid = model.aid == nil?kEmpty:model.aid;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *userId = model.userId == nil?kEmpty:model.userId;
            NSString *nickname = model.nickname == nil?kEmpty:model.nickname;
            NSString *head_img = model.head_img == nil?kEmpty:model.head_img;
            NSString *sign = model.sign == nil?kEmpty:model.sign;
            NSString *content = model.content == nil?kEmpty:model.content;
            result = [db executeUpdate:@"REPLACE INTO sns_practice_question(ids,pid,qtype,aid,title,userId,nickname,head_img,sign,answerContent,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,practiceId,[NSNumber numberWithInteger:type],aid,title,userId,nickname,head_img,sign,content]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///获取实务关联的问题
-(NSArray *)getLocalPracticeQuestionWithPracticeId:(NSString *)practiceId type:(ZPracticeQuestionType)type
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_practice_question WHERE pid='%@' AND qtype='%@' ORDER BY sortby ASC",practiceId,[NSNumber numberWithInteger:type]]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                ModelPracticeQuestion *modelPQ = [[ModelPracticeQuestion alloc] initWithAuto:[rs resultDictionary]];
                [modelPQ setContent:[rs stringForColumn:@"answerContent"]];
                [result addObject:modelPQ];
                
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///修改问题详情
-(BOOL)updLocalAnswerDetailWithModel:(ModelAnswerBase *)modelAB userId:(NSString *)userId
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = modelAB.ids == nil?kEmpty:modelAB.ids;
        NSString *title = modelAB.title == nil?kEmpty:modelAB.title;
        NSString *userId = modelAB.userId == nil?kEmpty:modelAB.userId;
        NSString *nickname = modelAB.nickname == nil?kEmpty:modelAB.nickname;
        NSString *sign = modelAB.sign == nil?kEmpty:modelAB.sign;
        NSString *head_img = modelAB.head_img == nil?kEmpty:modelAB.head_img;
        NSString *discuss_time = modelAB.discuss_time == nil?kEmpty:modelAB.discuss_time;
        NSString *question_id = modelAB.question_id == nil?kEmpty:modelAB.question_id;
        NSString *question_title = modelAB.question_title == nil?kEmpty:modelAB.question_title;
        NSNumber *resultRpt = [NSNumber numberWithLong:modelAB.resultRpt];
        NSNumber *agree = [NSNumber numberWithLong:modelAB.agree];
        NSNumber *disagree = [NSNumber numberWithLong:modelAB.disagree];
        NSNumber *isRept = [NSNumber numberWithInt:modelAB.isRept];
        NSNumber *isAgree = [NSNumber numberWithInt:modelAB.isAgree];
        NSNumber *commentCount = [NSNumber numberWithLong:modelAB.commentCount];
        NSNumber *isCollection = [NSNumber numberWithLong:modelAB.isCollection];
        
        result = [db executeUpdate:@"REPLACE INTO sns_answer_detail(ids,title,userId,nickname,sign,head_img,discuss_time,question_id,question_title,resultRpt,agree,disagree,isRept,isAgree,commentCount,isCollection,loginUserId) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);" withArgumentsInArray:@[ids,title,userId,nickname,sign,head_img,discuss_time,question_id,question_title,resultRpt,agree,disagree,isRept,isAgree,commentCount,isCollection,userId]];
    }];
    
    return result;
}
///保存问题详情
-(BOOL)setLocalAnswerDetailWithModel:(ModelAnswerBase *)modelAB commentArray:(NSArray *)commentArray userId:(NSString *)userId
{
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *ids = modelAB.ids == nil?kEmpty:modelAB.ids;
        NSString *title = modelAB.title == nil?kEmpty:modelAB.title;
        NSString *userId = modelAB.userId == nil?kEmpty:modelAB.userId;
        NSString *nickname = modelAB.nickname == nil?kEmpty:modelAB.nickname;
        NSString *sign = modelAB.sign == nil?kEmpty:modelAB.sign;
        NSString *head_img = modelAB.head_img == nil?kEmpty:modelAB.head_img;
        NSString *discuss_time = modelAB.discuss_time == nil?kEmpty:modelAB.discuss_time;
        NSString *question_id = modelAB.question_id == nil?kEmpty:modelAB.question_id;
        NSString *question_title = modelAB.question_title == nil?kEmpty:modelAB.question_title;
        NSNumber *resultRpt = [NSNumber numberWithLong:modelAB.resultRpt];
        NSNumber *agree = [NSNumber numberWithLong:modelAB.agree];
        NSNumber *disagree = [NSNumber numberWithLong:modelAB.disagree];
        NSNumber *isRept = [NSNumber numberWithInt:modelAB.isRept];
        NSNumber *isAgree = [NSNumber numberWithInt:modelAB.isAgree];
        NSNumber *commentCount = [NSNumber numberWithLong:modelAB.commentCount];
        NSNumber *isCollection = [NSNumber numberWithLong:modelAB.isCollection];
        
        result = [db executeUpdate:@"REPLACE INTO sns_answer_detail(ids,title,userId,nickname,sign,head_img,discuss_time,question_id,question_title,resultRpt,agree,disagree,isRept,isAgree,commentCount,isCollection,loginUserId) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);" withArgumentsInArray:@[ids,title,userId,nickname,sign,head_img,discuss_time,question_id,question_title,resultRpt,agree,disagree,isRept,isAgree,commentCount,isCollection,userId]];
        if (!result) {
            *rollback = YES;
        }
        ///添加评论列表
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_answer_comment WHERE answerId='%@' ", modelAB.ids]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelAnswerComment *modelAC in commentArray) {
            
            NSString *ids = modelAC.ids == nil?kEmpty:modelAC.ids;
            NSString *answerId = modelAB.ids == nil?kEmpty:modelAB.ids;
            NSString *content = modelAC.content == nil?kEmpty:modelAC.content;
            NSString *userId = modelAC.userId == nil?kEmpty:modelAC.userId;
            NSString *nickname = modelAC.nickname == nil?kEmpty:modelAC.nickname;
            NSString *head_img = modelAC.head_img == nil?kEmpty:modelAC.head_img;
            NSString *createTime = modelAC.createTime == nil?kEmpty:modelAC.createTime;
            NSString *obj_id = modelAC.obj_id == nil?kEmpty:modelAC.obj_id;
            NSNumber *type = [NSNumber numberWithInt:modelAC.type];
            NSNumber *status = [NSNumber numberWithInt:modelAC.status];
            result = [db executeUpdate:@"REPLACE INTO sns_answer_comment(ids,answerId,content,userId,nickname,head_img,createTime,type,obj_id,status,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,answerId,content,userId,nickname,head_img,createTime,type,obj_id,status]];
            if (!result) {
                *rollback = YES;
                break;
            }
            result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_comment_reply WHERE commentId='%@' ", modelAC.ids]];
            if (!result) {
                *rollback = YES;
                break;
            }
            ///评论的回复列表
            for (ModelCommentReply *modelCR in modelAC.arrReply) {
                
                NSString *ids = modelCR.ids == nil?kEmpty:modelCR.ids;
                NSString *commentId = modelAC.ids == nil?kEmpty:modelAC.ids;
                NSString *content = modelCR.content == nil?kEmpty:modelCR.content;
                NSString *parent_id = modelCR.parent_id == nil?kEmpty:modelCR.parent_id;
                NSString *user_id = modelCR.user_id == nil?kEmpty:modelCR.user_id;
                NSString *hnickname = modelCR.hnickname == nil?kEmpty:modelCR.hnickname;
                NSString *reply_user_id = modelCR.reply_user_id == nil?kEmpty:modelCR.reply_user_id;
                NSString *nickname = modelCR.nickname == nil?kEmpty:modelCR.nickname;
                
                result = [db executeUpdate:@"REPLACE INTO sns_comment_reply(ids,commentId,parent_id,content,user_id,hnickname,reply_user_id,nickname,sortby) VALUES(?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,commentId,parent_id,content,user_id,hnickname,reply_user_id,nickname]];
                if (!result) {
                    break;
                }
            }
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///获取问题详情
-(ModelAnswerBase *)getLocalAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId
{
    __block ModelAnswerBase *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsAB = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_answer_detail WHERE ids = '%@' AND loginUserId='%@' ", answerId, userId]];
        if (rsAB != nil)
        {
            ///答案详情
            while ([rsAB next]) {
                
                result = [[ModelAnswerBase alloc] initWithAuto:[rsAB resultDictionary]];
                
                if (result && [result.ids integerValue] > 0) {
                    FMResultSet *rsAC = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_answer_comment WHERE answerId = '%@' ORDER BY sortby ASC", answerId]];
                    if (rsAC != nil)
                    {
                        ///评论列表
                        NSMutableArray *commentArray = [NSMutableArray array];
                        while ([rsAC next]) {
                            
                            ModelAnswerComment *modelAC = [[ModelAnswerComment alloc] initWithAuto:[rsAC resultDictionary]];
                            if (modelAC && [modelAC.ids integerValue] > 0) {
                                FMResultSet *rsAC = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_comment_reply WHERE commentId = '%@' ORDER BY sortby ASC", modelAC.ids]];
                                if (rsAC != nil)
                                {
                                    ///回复列表
                                    NSMutableArray *replyArray = [NSMutableArray array];
                                    while ([rsAC next]) {
                                        ModelCommentReply *modelCR = [[ModelCommentReply alloc] initWithAuto:[rsAC resultDictionary]];
                                        if (modelCR) {
                                            [replyArray addObject:modelCR];
                                        }
                                    }
                                    modelAC.arrReply = [NSArray arrayWithArray:replyArray];
                                }
                            }
                            [commentArray addObject:modelAC];
                        }
                        result.commentArray = [NSArray arrayWithArray:commentArray];
                    }
                }
                break;
            }
        }
        [rsAB close];
    }];
    return result;
}

///添加一条新评论
-(BOOL)addLocalAnswerCommentWithModel:(ModelAnswerComment *)modelAC answerId:(NSString *)answerId
{
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *ids = modelAC.ids == nil?kEmpty:modelAC.ids;
        NSString *content = modelAC.content == nil?kEmpty:modelAC.content;
        NSString *userId = modelAC.userId == nil?kEmpty:modelAC.userId;
        NSString *nickname = modelAC.nickname == nil?kEmpty:modelAC.nickname;
        NSString *head_img = modelAC.head_img == nil?kEmpty:modelAC.head_img;
        NSString *createTime = modelAC.createTime == nil?kEmpty:modelAC.createTime;
        NSString *obj_id = modelAC.obj_id == nil?kEmpty:modelAC.obj_id;
        NSNumber *type = [NSNumber numberWithInt:modelAC.type];
        NSNumber *status = [NSNumber numberWithInt:modelAC.status];
        result = [db executeUpdate:@"REPLACE INTO sns_answer_comment(ids,answerId,content,userId,nickname,head_img,createTime,type,obj_id,status,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,answerId,content,userId,nickname,head_img,createTime,type,obj_id,status]];
        if (!result) {
            *rollback = YES;
        }
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_comment_reply WHERE commentId='%@' ", modelAC.ids]];
        if (!result) {
            *rollback = YES;
        }
        ///评论的回复列表
        for (ModelCommentReply *modelCR in modelAC.arrReply) {
            
            NSString *ids = modelCR.ids == nil?kEmpty:modelCR.ids;
            NSString *commentId = modelAC.ids == nil?kEmpty:modelAC.ids;
            NSString *content = modelCR.content == nil?kEmpty:modelCR.content;
            NSString *parent_id = modelCR.parent_id == nil?kEmpty:modelCR.parent_id;
            NSString *user_id = modelCR.user_id == nil?kEmpty:modelCR.user_id;
            NSString *hnickname = modelCR.hnickname == nil?kEmpty:modelCR.hnickname;
            NSString *reply_user_id = modelCR.reply_user_id == nil?kEmpty:modelCR.reply_user_id;
            NSString *nickname = modelCR.nickname == nil?kEmpty:modelCR.nickname;
            
            result = [db executeUpdate:@"REPLACE INTO sns_comment_reply(ids,commentId,parent_id,content,user_id,hnickname,reply_user_id,nickname,sortby) VALUES(?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,commentId,parent_id,content,user_id,hnickname,reply_user_id,nickname]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///添加一条新回复
-(BOOL)addLocalAnswerCommentReplyWithModel:(ModelCommentReply *)modelCR commentId:(NSString *)commentId
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = modelCR.ids == nil?kEmpty:modelCR.ids;
        NSString *content = modelCR.content == nil?kEmpty:modelCR.content;
        NSString *parent_id = modelCR.parent_id == nil?kEmpty:modelCR.parent_id;
        NSString *user_id = modelCR.user_id == nil?kEmpty:modelCR.user_id;
        NSString *hnickname = modelCR.hnickname == nil?kEmpty:modelCR.hnickname;
        NSString *reply_user_id = modelCR.reply_user_id == nil?kEmpty:modelCR.reply_user_id;
        NSString *nickname = modelCR.nickname == nil?kEmpty:modelCR.nickname;
        
        result = [db executeUpdate:@"REPLACE INTO sns_comment_reply(ids,commentId,parent_id,content,user_id,hnickname,reply_user_id,nickname,sortby) VALUES(?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,commentId,parent_id,content,user_id,hnickname,reply_user_id,nickname]];
    }];
    
    return result;
}
///删除一条评论
-(BOOL)delLocalAnswerCommentWithCommentId:(NSString *)commentId answerId:(NSString *)answerId
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *resAnswerId = answerId==nil?kEmpty:answerId;
        NSString *resCommentId = commentId==nil?kEmpty:commentId;
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_answer_comment WHERE answerId='%@' AND ids='%@' ", resAnswerId, resCommentId]];
        
    }];
    
    return result;
}
///删除一条回复
-(BOOL)delLocalAnswerCommentReplyWithReplyId:(NSString *)replyId commentId:(NSString *)commentId
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *resReplyId = replyId==nil?kEmpty:replyId;
        NSString *resCommentId = commentId==nil?kEmpty:commentId;
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_comment_reply WHERE commentId='%@' AND ids='%@' ", resCommentId, resReplyId]];
        
    }];
    
    return result;
}


///添加任务集合
-(BOOL)setLocalTaskArrayWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil ||
        [array isKindOfClass:[NSNull class]] ||
        ![array isKindOfClass:[NSArray class]] ||
        array.count == 0 ||
        userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_user_task WHERE user_id='%@' ",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (id obj in array) {
            ModelTask *model = nil;
            if ([obj isKindOfClass:[ModelTask class]]) {
                model = (ModelTask *)obj;
            } else {
                model = [[ModelTask alloc] initWithCustom:obj];
            }
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *speech_id = model.speech_id == nil?kEmpty:model.speech_id;
            NSNumber *rule = [NSNumber numberWithInteger:model.rule];
            NSNumber *status = [NSNumber numberWithInt:model.status];
            NSString *user_id = userId == nil?kEmpty:userId;
            
            result = [db executeUpdate:@"REPLACE INTO sns_user_task(ids,user_id,content,speech_id,status,rule,sortby) VALUES(?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,user_id,content,speech_id,status,rule]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///修改或添加任务对象
-(BOOL)setLocalTaskModelWithModel:(ModelTask *)model userId:(NSString *)userId
{
    if (model == nil || userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *ids = model.ids == nil?kEmpty:model.ids;
        NSString *content = model.content == nil?kEmpty:model.content;
        NSString *speech_id = model.speech_id == nil?kEmpty:model.speech_id;
        NSNumber *rule = [NSNumber numberWithInteger:model.rule];
        NSNumber *status = [NSNumber numberWithInt:model.status];
        NSString *user_id = userId == nil?kEmpty:userId;
        
        result = [db executeUpdate:@"REPLACE INTO sns_user_task(ids,user_id,content,speech_id,status,rule,sortby) VALUES(?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,user_id,content,speech_id,status,rule]];
    }];
    
    return result;
}
///删除任务集合
-(BOOL)delLocalTaskArrayWithUserId:(NSString *)userId
{
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *resuserId = userId==nil?kEmpty:userId;
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_user_task WHERE user_id='%@' ", resuserId]];
        
    }];
    
    return result;
}
///获取任务集合
-(NSArray *)getLocalTaskArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_user_task WHERE user_id='%@' ORDER BY sortby ASC",userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelTask alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
///获取任务对象
-(ModelTask *)getLocalTaskModelWithUserId:(NSString *)userId rule:(NSInteger)rule
{
    __block ModelTask *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_user_task WHERE user_id='%@' AND rule='%@' ORDER BY sortby ASC",userId, [NSString stringWithFormat:@"%d", (int)rule]]];
        if (rs != nil)
        {
            while ([rs next]) {
                
                result = [[ModelTask alloc] initWithAuto:[rs resultDictionary]];
                
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///获取任务集合
-(NSArray *)getLocalTaskArrayWithUserId:(NSString *)userId speechId:(NSString *)speechId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_user_task WHERE user_id='%@' AND speech_id='%@' ORDER BY sortby ASC",userId, speechId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelTask alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

///添加话题对象
-(BOOL)setLocalTopicModelWithModel:(ModelTag *)model userId:(NSString *)userId
{
    if (model == nil ) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_topic_detail WHERE userId='%@' ",userId]];
        if (!result) {
            *rollback = YES;
        }
        NSString *tagId = model.tagId == nil?kEmpty:model.tagId;
        NSString *tagName = model.tagName == nil?kEmpty:model.tagName;
        NSString *tagLogo = model.tagLogo == nil?kEmpty:model.tagLogo;
        NSString *question_id = model.question_id == nil?kEmpty:model.question_id;
        NSString *user_id = userId == nil?kEmpty:userId;
        NSNumber *attCount = [NSNumber numberWithInt:model.attCount];
        NSNumber *status = [NSNumber numberWithInt:model.status];
        NSNumber *isCheck = [NSNumber numberWithBool:model.isCheck];
        NSNumber *isAtt = [NSNumber numberWithBool:model.isAtt];
        NSNumber *isCollection = [NSNumber numberWithInt:model.isCollection];
        
        result = [db executeUpdate:@"REPLACE INTO sns_topic_detail(tagId,tagName,userId,tagLogo,question_id,attCount,status,isCheck,isAtt,isCollection,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[tagId,tagName,user_id,tagLogo,question_id,attCount,status,isCheck,isAtt,isCollection]];
        if (!result) {
            *rollback = YES;
        }
        
    }];
    
    return result;
}
///获取话题对象
-(ModelTag *)getLocalTopicModelWithUserId:(NSString *)userId topicId:(NSString *)topicId
{
    __block ModelTag *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_topic_detail WHERE userId='%@' AND tagId='%@' ORDER BY sortby ASC",userId, topicId]];
        if (rs != nil)
        {
            while ([rs next]) {
                
                result = [[ModelTag alloc] initWithAuto:[rs resultDictionary]];
                
                break;
            }
        }
        [rs close];
    }];
    return result;
}

///添加话题关联问题对象
-(BOOL)setLocalTopicQuestionArrayWithArray:(NSArray *)array topicId:(NSString *)topicId
{
    if (array == nil || topicId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_topic_question WHERE topicId='%@' ", topicId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelQuestionTopic *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *aid = model.aid == nil?kEmpty:model.aid;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *userIdA = model.userIdA == nil?kEmpty:model.userIdA;
            NSString *nicknameA = model.nicknameA == nil?kEmpty:model.nicknameA;
            NSString *head_imgA = model.head_imgA == nil?kEmpty:model.head_imgA;
            NSString *signA = model.signA == nil?kEmpty:model.signA;
            NSString *userIdQ = model.userIdQ == nil?kEmpty:model.userIdQ;
            NSString *nicknameQ = model.nicknameQ == nil?kEmpty:model.nicknameQ;
            NSString *head_imgQ = model.head_imgQ == nil?kEmpty:model.head_imgQ;
            NSString *signQ = model.signQ == nil?kEmpty:model.signQ;
            NSString *content = model.content == nil?kEmpty:model.content;
            
            result = [db executeUpdate:@"REPLACE INTO sns_topic_question(ids,topicId,aid,title,userIdA,nicknameA,head_imgA,signA,userIdQ,nicknameQ,head_imgQ,signQ,content,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,topicId,aid,title,userIdA,nicknameA,head_imgA,signA,userIdQ,nicknameQ,head_imgQ,signQ,content]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///获取话题关联问题对象
-(NSArray *)getLocalTopicQuestionArrayWithTopicId:(NSString *)topicId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_topic_question WHERE topicId='%@' ORDER BY sortby ASC",topicId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelQuestionTopic alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

///添加话题关联实务对象
-(BOOL)setLocalTopicPracticeArrayWithArray:(NSArray *)array topicId:(NSString *)topicId
{
    if (array == nil || topicId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_topic_practice WHERE topicId='%@' ", topicId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            
            result = [db executeUpdate:@"REPLACE INTO sns_topic_practice(ids,topicId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,topicId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///获取话题关联实务对象
-(NSArray *)getLocalTopicPracticeArrayWithTopicId:(NSString *)topicId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_topic_practice WHERE topicId='%@' ORDER BY sortby ASC",topicId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelPractice alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}


/**************************************2.0缓存**********************************************/

/// 添加首页广告
-(BOOL)setLocalHomeBannerWithArray:(NSArray *)array
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_home_banner"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelBanner *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *share_title = model.share_title==nil?kEmpty:model.share_title;
            NSString *share_desc = model.share_desc==nil?kEmpty:model.share_desc;
            NSString *url = model.url==nil?kEmpty:model.url;
            NSString *imageUrl = model.imageUrl==nil?kEmpty:model.imageUrl;
            NSNumber *type = [NSNumber numberWithInt:model.type];
            
            result = [db executeUpdate:@"REPLACE INTO sns_home_banner(ids,title,share_title,share_desc,url,imageUrl,type,sortby) VALUES(?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,share_title,share_desc,url,imageUrl,type]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取首页广告集合
-(NSArray *)getLocalHomeBannerArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_home_banner ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelBanner alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 添加首页实务
-(BOOL)setLocalHomePracticeWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil || userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *user_id = userId == nil?kEmpty:userId;
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_home_practice WHERE userId='%@' ", user_id]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            result = [db executeUpdate:@"REPLACE INTO sns_home_practice(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取首页实务
-(NSArray *)getLocalHomePracticeArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_home_practice WHERE userId='%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                ModelPractice *modelP = [[ModelPractice alloc] initWithAuto:[rs resultDictionary]];
                
                [result addObject:modelP];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 添加首页问答
-(BOOL)setLocalHomeQuestionWithArray:(NSArray *)array
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_home_question"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelQuestionBoutique *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *aid = model.aid == nil?kEmpty:model.aid;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *nickname = model.nickname == nil?kEmpty:model.nickname;
            NSString *head_img = model.head_img == nil?kEmpty:model.head_img;
            NSString *userId = model.userId == nil?kEmpty:model.userId;
            NSString *sign = model.sign == nil?kEmpty:model.sign;
            
            result = [db executeUpdate:@"REPLACE INTO sns_home_question(ids,title,aid,content,nickname,head_img,userId,sign,sortby) VALUES(?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,aid,content,nickname,head_img,userId,sign]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取首页问答
-(NSArray *)getLocalHomeQuestionArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_home_question ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelQuestionBoutique alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 添加首页订阅
-(BOOL)setLocalHomeSubscribeWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_home_subscribe"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelSubscribe *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *user_Id = userId == nil?kEmpty:userId;
            NSString *team_intro = model.team_info == nil?kEmpty:model.team_info;
            NSString *theme_intro = model.theme_intro == nil?kEmpty:model.theme_intro;
            NSString *create_time = model.time == nil?kEmpty:model.time;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            NSNumber *status = [NSNumber numberWithInt:model.status];
            NSNumber *hits = [NSNumber numberWithLong:model.hits];
            NSNumber *is_series_course = [NSNumber numberWithLong:model.is_series_course];
            
            result = [db executeUpdate:@"REPLACE INTO sns_home_subscribe(ids,userId,title,team_name,team_intro,theme_intro,create_time,price,units,illustration,status,hits,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,user_Id,title,team_name,team_intro,theme_intro,create_time,price,units,illustration,status,hits,is_series_course]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取首页订阅
-(NSArray *)getLocalHomeSubscribeArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_home_subscribe ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelSubscribe alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 添加首页系列课程
-(BOOL)setLocalHomeCurriculumWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_home_curriculum"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelSubscribe *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *user_Id = userId == nil?kEmpty:userId;
            NSString *team_intro = model.team_info == nil?kEmpty:model.team_info;
            NSString *theme_intro = model.theme_intro == nil?kEmpty:model.theme_intro;
            NSString *create_time = model.time == nil?kEmpty:model.time;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            NSNumber *status = [NSNumber numberWithInt:model.status];
            NSNumber *hits = [NSNumber numberWithLong:model.hits];
            NSNumber *is_series_course = [NSNumber numberWithLong:model.is_series_course];
            
            result = [db executeUpdate:@"REPLACE INTO sns_home_curriculum(ids,userId,title,team_name,team_intro,theme_intro,create_time,price,units,illustration,status,hits,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,user_Id,title,team_name,team_intro,theme_intro,create_time,price,units,illustration,status,hits,is_series_course]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取首页系列课程
-(NSArray *)getLocalHomeCurriculumArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_home_curriculum ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelSubscribe alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 添加首页实务分类数据集合
-(BOOL)setLocalPracticeTypePracticeListWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil || userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *user_id = userId == nil?kEmpty:userId;
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_type_practice WHERE typeId='%@' AND userId='%@' AND address = 2", kZero, user_id]];
        if (!result) {
            *rollback = YES;
            return;
        }
        for (ModelPractice *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            result = [db executeUpdate:@"REPLACE INTO sns_type_practice(ids,typeId,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,address,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,2,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,kZero,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 添加首页实务分类
-(BOOL)setLocalPracticeTypeWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil || userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_practice_type"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPracticeType *modelPT in array) {
            NSString *ptids = modelPT.ids==nil?kEmpty:modelPT.ids;
            NSString *type = modelPT.type==nil?kEmpty:modelPT.type;
            NSString *spe_img = modelPT.spe_img==nil?kEmpty:modelPT.spe_img;
            
            result = [db executeUpdate:@"REPLACE INTO sns_practice_type(ids,type,spe_img,sortby) VALUES(?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ptids,type,spe_img]];
        }
    }];
    
    return result;
}
/// 获取首页实务分类
-(NSArray *)getLocalPracticeTypePracticeListArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_type_practice WHERE userId = '%@' AND typeId = '%@' AND address = 2 ORDER BY sortby ASC", userId, kZero]];
        if (rsPractice != nil)
        {
            result = [NSMutableArray array];
            
            while ([rsPractice next]) {
                
                ModelPractice *modelP = [[ModelPractice alloc] initWithAuto:[rsPractice resultDictionary]];
                
                [result addObject:modelP];
            }
        }
        [rsPractice close];
    }];
    return result;
}
/// 获取首页实务分类
-(NSArray *)getLocalPracticeTypeArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_practice_type ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                ModelPracticeType *modelPT = [[ModelPracticeType alloc] initWithAuto:[rs resultDictionary]];
                [result addObject:modelPT];
            }
        }
        [rs close];
    }];
    return result;
}

/// 添加分类下的实务
-(BOOL)setLocalPracticeWithArray:(NSArray *)array typeId:(NSString *)typeId userId:(NSString *)userId
{
    if (array == nil || userId == nil || typeId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_type_practice WHERE address = 1"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            result = [db executeUpdate:@"REPLACE INTO sns_type_practice(ids,typeId,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,address,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,typeId,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取分类下的实务
-(NSArray *)getLocalPracticeArrayWithUserId:(NSString *)userId typeId:(NSString *)typeId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_type_practice WHERE userId = '%@' AND typeId = '%@' AND address = 1 ORDER BY sortby ASC", userId, typeId]];
        if (rsPractice != nil)
        {
            result = [NSMutableArray array];
            
            while ([rsPractice next]) {
                
                ModelPractice *modelP = [[ModelPractice alloc] initWithAuto:[rsPractice resultDictionary]];
                
                [result addObject:modelP];
                
            }
        }
        [rsPractice close];
    }];
    return result;
}

/// 设置订阅推荐
-(BOOL)setLocalSubscribeRecommendWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_subscribe WHERE userId='%@'",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelSubscribe *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *team_info = model.team_info == nil?kEmpty:model.team_info;
            NSString *theme_intro = model.theme_intro == nil?kEmpty:model.theme_intro;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSNumber *count = [NSNumber numberWithInt:model.count];
            NSString *units = model.units == nil?kEmpty:model.units;
            NSNumber *status = [NSNumber numberWithInt:model.status];
            NSNumber *hits = [NSNumber numberWithLong:model.hits];
            NSNumber *is_series_course = [NSNumber numberWithLong:model.is_series_course];
            
            result = [db executeUpdate:@"REPLACE INTO sns_subscribe(ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取订阅推荐
-(NSArray *)getLocalSubscribeRecommendArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_subscribe WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelSubscribe alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置系列课程
-(BOOL)setLocalSeriesCoursesWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_series_courses WHERE userId='%@'",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelSubscribe *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *team_info = model.team_info == nil?kEmpty:model.team_info;
            NSString *theme_intro = model.theme_intro == nil?kEmpty:model.theme_intro;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSNumber *count = [NSNumber numberWithInt:model.count];
            NSString *units = model.units == nil?kEmpty:model.units;
            NSNumber *status = [NSNumber numberWithInt:model.status];
            NSNumber *hits = [NSNumber numberWithLong:model.hits];
            NSNumber *is_series_course = [NSNumber numberWithLong:model.is_series_course];
            
            result = [db executeUpdate:@"REPLACE INTO sns_series_courses(ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取系列课程
-(NSArray *)getLocalSeriesCoursesArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_series_courses WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelSubscribe alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置订阅已定
-(BOOL)setLocalSubscribeAlreadyWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_curriculum WHERE userId='%@' AND address = 1",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCurriculum *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
            NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
            NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
            NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            
            result = [db executeUpdate:@"REPLACE INTO sns_curriculum(ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,address,team_intro,course_picture,price,units,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取订阅已定
-(NSArray *)getLocalSubscribeAlreadyArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_curriculum WHERE userId = '%@' AND address = 1 ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置订阅试读
-(BOOL)setLocalCurriculumProbationWithArray:(NSArray *)array subscribeId:(NSString *)subscribeId userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_curriculum WHERE userId='%@' AND subscribeId = '%@' AND address = 2",userId, subscribeId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCurriculum *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
            NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
            NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
            NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            
            result = [db executeUpdate:@"REPLACE INTO sns_curriculum(ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,address,team_intro,course_picture,price,units,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,2,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取订阅试读
-(NSArray *)getLocalCurriculumProbationArrayWithUserId:(NSString *)userId subscribeId:(NSString *)subscribeId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_curriculum WHERE userId = '%@' AND subscribeId = '%@' AND address = 2 ORDER BY sortby ASC", userId, subscribeId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置订阅详情
-(BOOL)setLocalSubscribeDetailWithModel:(ModelSubscribeDetail *)model userId:(NSString *)userId
{
    if (model == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = model.ids == nil?kEmpty:model.ids;
        NSString *title = model.title == nil?kEmpty:model.title;
        NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
        NSString *team_info = model.team_info == nil?kEmpty:model.team_info;
        NSString *theme_intro = model.theme_intro == nil?kEmpty:model.theme_intro;
        NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
        NSString *price = model.price == nil?kEmpty:model.price;
        NSString *fit_people = model.fit_people == nil?kEmpty:model.fit_people;
        NSString *must_know = model.must_know == nil?kEmpty:model.must_know;
        NSString *need_help = model.need_help == nil?kEmpty:model.need_help;
        NSString *latest_push = model.latest_push == nil?kEmpty:model.latest_push;
        NSNumber *count = [NSNumber numberWithInt:model.count];
        NSNumber *isSubscribe = [NSNumber numberWithBool:model.isSubscribe];
        NSString *units = model.units == nil?kEmpty:model.units;
        NSNumber *status = [NSNumber numberWithInt:model.status];
        NSNumber *hits = [NSNumber numberWithLong:model.hits];
        NSNumber *is_series_course = [NSNumber numberWithLong:model.is_series_course];
        NSNumber *isExistFreeRead = [NSNumber numberWithBool:model.isExistFreeRead];
        
        result = [db executeUpdate:@"REPLACE INTO sns_subscribe_detail(ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,fit_people,must_know,need_help,latest_push,units,status,isSubscribe,hits,is_series_course,isExistFreeRead,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,fit_people,must_know,need_help,latest_push,units,status,isSubscribe,hits,is_series_course,isExistFreeRead]];
    }];
    
    return result;
}
/// 获取订阅详情
-(ModelSubscribeDetail *)getLocalSubscribeDetailWithUserId:(NSString *)userId subscribeId:(NSString *)subscribeId
{
    __block ModelSubscribeDetail *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_subscribe_detail WHERE ids = '%@' AND userId = '%@' ORDER BY sortby ASC", subscribeId, userId]];
        if (rs != nil)
        {
            while ([rs next]) {
                
                result = [[ModelSubscribeDetail alloc] initWithAuto:[rs resultDictionary]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}
/// 获取订阅详情集合
-(NSMutableArray *)getLocalSubscribeDetailArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_subscribe_detail WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                ModelSubscribeDetail *model = [[ModelSubscribeDetail alloc] initWithAuto:[rs resultDictionary]];
                [result addObject:model];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置每期看列表
-(BOOL)setLocalCurriculumEachWatchWithArray:(NSArray *)array subscribeId:(NSString *)subscribeId userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_curriculum WHERE userId='%@' AND subscribeId = '%@' AND address = 3",userId, subscribeId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCurriculum *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
            NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
            NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
            NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            
            result = [db executeUpdate:@"REPLACE INTO sns_curriculum(ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,address,team_intro,course_picture,price,units,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,3,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取每期看列表
-(NSArray *)getLocalCurriculumEachWatchArrayWithSubscribeId:(NSString *)subscribeId userId:(NSString *)userId
{
    if (subscribeId == nil) {return nil;}
    
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_curriculum WHERE userId = '%@' AND subscribeId = '%@' AND address = 3 ORDER BY sortby ASC", userId, subscribeId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置连续播列表
-(BOOL)setLocalCurriculumContinuousSowingWithArray:(NSArray *)array subscribeId:(NSString *)subscribeId userId:(NSString *)userId
{
    if (array == nil || subscribeId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_curriculum WHERE userId='%@' AND subscribeId = '%@' AND address = 4",userId, subscribeId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCurriculum *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
            NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
            NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
            NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            
            result = [db executeUpdate:@"REPLACE INTO sns_curriculum(ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,address,team_intro,course_picture,price,units,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,4,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 设置连续播列表
-(BOOL)setLocalCurriculumContinuousSowingWithModel:(ModelCurriculum *)model userId:(NSString *)userId
{
    if (model == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = model.ids == nil?kEmpty:model.ids;
        NSString *title = model.title == nil?kEmpty:model.title;
        NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
        NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
        NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
        NSString *content = model.content == nil?kEmpty:model.content;
        NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
        NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
        NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
        NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
        NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
        NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
        NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
        NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
        NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
        NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
        NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
        NSString *price = model.price == nil?kEmpty:model.price;
        NSString *units = model.units == nil?kEmpty:model.units;
        
        result = [db executeUpdate:@"REPLACE INTO sns_curriculum(ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,address,team_intro,course_picture,price,units,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,4,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units]];
        
    }];
    
    return result;
}
/// 获取连续播列表
-(NSArray *)getLocalCurriculumContinuousSowingArrayWithSubscribeId:(NSString *)subscribeId userId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    if (subscribeId == nil) { return result; }
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_curriculum WHERE userId = '%@' AND subscribeId = '%@' AND address = 4 ORDER BY sortby ASC", userId, subscribeId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 获取连续播对象
-(ModelCurriculum *)getLocalCurriculumContinuousSowingModelWithCurriculumId:(NSString *)curriculumId userId:(NSString *)userId
{
    __block ModelCurriculum *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_curriculum WHERE userId = '%@' AND ids = '%@' AND address = 4 ORDER BY sortby ASC", userId, curriculumId]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置发现实务分类
-(BOOL)setLocalFoundPracticeTypeWithArray:(NSArray *)array
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_found_practice_type"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPracticeType *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *type = model.type == nil?kEmpty:model.type;
            
            result = [db executeUpdate:@"REPLACE INTO sns_found_practice_type(ids,type,sortby) VALUES(?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,type]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取发现实务分类
-(NSArray *)getLocalFoundPracticeTypeArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_found_practice_type ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelPracticeType alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置购买记录
-(BOOL)setLocalSubscribePlayWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_subscribe_play WHERE userId='%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelSubscribePlay *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *pay_time = model.pay_time == nil?kEmpty:model.pay_time;
            NSString *pay_type = model.pay_type == nil?kEmpty:model.pay_type;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            NSNumber *type = [NSNumber numberWithInt:model.type];
            
            result = [db executeUpdate:@"REPLACE INTO sns_subscribe_play(ids,userId,title,pay_time,pay_type,price,units,type,sortby) VALUES(?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,pay_time,pay_type,price,units,type]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取购买记录
-(NSArray *)getLocalSubscribePlayArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_subscribe_play WHERE userId='%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelSubscribePlay alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置充值记录
-(BOOL)setLocalRechargeRecordWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_recharge_record WHERE userId='%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelRechargeRecord *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *pay_time = model.pay_time == nil?kEmpty:model.pay_time;
            NSString *pay_type = model.pay_type == nil?kEmpty:model.pay_type;
            NSString *price = model.price == nil?kEmpty:model.price;
            
            result = [db executeUpdate:@"REPLACE INTO sns_recharge_record(ids,userId,title,pay_time,pay_type,price,sortby) VALUES(?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,pay_time,pay_type,price]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取充值记录
-(NSArray *)getLocalRechargeRecordArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_recharge_record WHERE userId='%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelRechargeRecord alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置打赏记录
-(BOOL)setLocalRewardRecordWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_reward_record WHERE userId='%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelRewardRecord *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *pay_time = model.pay_time == nil?kEmpty:model.pay_time;
            NSString *pay_type = model.pay_type == nil?kEmpty:model.pay_type;
            NSString *price = model.price == nil?kEmpty:model.price;
            
            result = [db executeUpdate:@"REPLACE INTO sns_reward_record(ids,userId,title,pay_time,pay_type,price,sortby) VALUES(?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,pay_time,pay_type,price]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取打赏记录
-(NSArray *)getLocalRewardRecordArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_reward_record WHERE userId='%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelRewardRecord alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置订单对象
-(BOOL)setLocalOrderDetailWithModel:(ModelOrderWT *)model userId:(NSString *)userId
{
    if (model == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = model.ids == nil?kEmpty:model.ids;
        NSString *title = model.title == nil?kEmpty:model.title;
        NSString *order_no = model.order_no == nil?kEmpty:model.order_no;
        NSString *price = model.price == nil?kEmpty:model.price;
        NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
        NSString *pay_time = model.pay_time == nil?kEmpty:model.pay_time;
        NSNumber *type = [NSNumber numberWithInt:model.type];
        NSNumber *pay_type = [NSNumber numberWithInteger:model.pay_type];
        NSNumber *status = [NSNumber numberWithInt:model.status];
        
        result = [db executeUpdate:@"REPLACE INTO sns_orderwt(ids,userId,title,type,order_no,price,pay_type,pay_time,create_time,status,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,type,order_no,price,pay_type,pay_time,create_time,status]];
    }];
    
    return result;
}
/// 修改多个订单状态
-(BOOL)updLocalOrderDetailWithOrderIds:(NSArray *)arrOrderId
{
    if (arrOrderId == nil && arrOrderId.count == 0) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"UPDATE sns_orderwt SET status = 1 WHERE order_no in (%@)", [arrOrderId toString]]];
    }];
    
    return result;
}
/// 获取订单详情
-(ModelOrderWT *)getLocalOrderDetailWithUserId:(NSString *)userId orderId:(NSString *)orderId
{
    __block ModelOrderWT *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_orderwt WHERE ids = '%@' AND userId = '%@' ORDER BY sortby ASC", orderId, userId]];
        if (rs != nil)
        {
            while ([rs next]) {
                
                result = [[ModelOrderWT alloc] initWithAuto:[rs resultDictionary]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

/// 获取指定状态的订单集合
-(NSArray *)getLocalOrderDetailWithUserId:(NSString *)userId status:(int)status
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_orderwt WHERE status = '%d' AND  userId = '%@' ORDER BY sortby DESC", status, userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelOrderWT alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置精品问答
-(BOOL)setLocalBoutiqueQuestionWithArray:(NSArray *)array
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_boutique_question"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelQuestionBoutique *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *aid = model.aid == nil?kEmpty:model.aid;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *userId = model.userId == nil?kEmpty:model.userId;
            NSString *nickname = model.nickname == nil?kEmpty:model.nickname;
            NSString *head_img = model.head_img == nil?kEmpty:model.head_img;
            NSString *sign = model.sign == nil?kEmpty:model.sign;
            
            result = [db executeUpdate:@"REPLACE INTO sns_boutique_question(ids,title,aid,content,userId,nickname,head_img,sign,sortby) VALUES(?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,aid,content,userId,nickname,head_img,sign]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取精品问答
-(NSArray *)getLocalBoutiqueQuestionArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_boutique_question ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelQuestionBoutique alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置圈子推荐
-(BOOL)setLocalCircleHotQuestionWithArray:(NSArray *)array
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_circle_hot_question"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCircleHot *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *aid = model.aid == nil?kEmpty:model.aid;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *contentNoImage = model.contentNoImage == nil?kEmpty:model.contentNoImage;
            NSString *userId = model.userId == nil?kEmpty:model.userId;
            NSString *nickname = model.nickname == nil?kEmpty:model.nickname;
            NSString *head_img = model.head_img == nil?kEmpty:model.head_img;
            NSString *sign = model.sign == nil?kEmpty:model.sign;
            
            result = [db executeUpdate:@"REPLACE INTO sns_circle_hot_question(ids,title,aid,content,contentNoImage,userId,nickname,head_img,sign,sortby) VALUES(?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,aid,content,contentNoImage,userId,nickname,head_img,sign]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取圈子推荐
-(NSArray *)getLocalCircleHotQuestionArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_circle_hot_question ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                ModelCircleHot *model = [[ModelCircleHot alloc] initWithAuto:[rs resultDictionary]];
                [result addObject:model];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置圈子动态
-(BOOL)setLocalCircleDynamicQuestionWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_circle_dynamic_question WHERE userIdL='%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCircleDynamic *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *aid = model.wid == nil?kEmpty:model.wid;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *contentNoImage = model.contentNoImage == nil?kEmpty:model.contentNoImage;
            NSString *userIdQ = model.userId == nil?kEmpty:model.userId;
            NSString *nicknameQ = model.nickname == nil?kEmpty:model.nickname;
            NSString *head_imgQ = model.head_img == nil?kEmpty:model.head_img;
            NSString *flag = model.flag == nil?kEmpty:model.flag;
            NSNumber *type = [NSNumber numberWithInt:model.type];
            
            result = [db executeUpdate:@"REPLACE INTO sns_circle_dynamic_question(ids,title,wid,content,contentNoImage,userId,nickname,head_img,flag,type,userIdL,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,aid,content,contentNoImage,userIdQ,nicknameQ,head_imgQ,flag,type,userId]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取圈子动态
-(NSArray *)getLocalCircleDynamicQuestionArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_circle_dynamic_question WHERE userIdL='%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                ModelCircleDynamic *model = [[ModelCircleDynamic alloc] initWithAuto:[rs resultDictionary]];
                [result addObject:model];
                
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置圈子最新
-(BOOL)setLocalCircleNewQuestionWithArray:(NSArray *)array
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_circle_new_question"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCircleNew *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *aid = model.aid == nil?kEmpty:model.aid;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *contentNoImage = model.contentNoImage == nil?kEmpty:model.contentNoImage;
            NSString *userIdQ = model.userIdQ == nil?kEmpty:model.userIdQ;
            NSString *nicknameQ = model.nicknameQ == nil?kEmpty:model.nicknameQ;
            NSString *head_imgQ = model.head_imgQ == nil?kEmpty:model.head_imgQ;
            NSString *userIdA = model.userIdA == nil?kEmpty:model.userIdA;
            NSString *nicknameA = model.nicknameA == nil?kEmpty:model.nicknameA;
            NSString *head_imgA = model.head_imgA == nil?kEmpty:model.head_imgA;
            NSString *signA = model.signA == nil?kEmpty:model.signA;
            NSString *time = model.time == nil?kEmpty:model.time;
            NSString *count = model.count == nil?kEmpty:model.count;
            
            result = [db executeUpdate:@"REPLACE INTO sns_circle_new_question(ids,title,aid,content,contentNoImage,userIdQ,nicknameQ,head_imgQ,userIdA,nicknameA,head_imgA,signA,time,count,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,aid,content,contentNoImage,userIdQ,nicknameQ,head_imgQ,userIdA,nicknameA,head_imgA,signA,time,count]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取圈子最新
-(NSArray *)getLocalCircleNewQuestionArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_circle_new_question ORDER BY sortby ASC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                ModelCircleNew *model = [[ModelCircleNew alloc] initWithAuto:[rs resultDictionary]];
                [result addObject:model];
                
            }
        }
        [rs close];
    }];
    return result;
}


/// 添加任何实务列表下面的实务播放列表
-(BOOL)setLocalPlayListPracticeListWithModel:(ModelPractice *)model userId:(NSString *)userId
{
    if (model == nil || userId == nil) { return NO; }
    userId = kOne;
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = model.ids==nil?kEmpty:model.ids;
        NSString *title = model.title==nil?kEmpty:model.title;
        NSString *time = model.time==nil?kEmpty:model.time;
        NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
        NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
        NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
        NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
        NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
        NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
        NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
        NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
        NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
        NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
        NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
        NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
        NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
        NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
        NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
        NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
        NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
        NSNumber *showText = [NSNumber numberWithInt:model.showText];
        NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
        NSString *price = model.price==nil?kEmpty:model.price;
        NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
        NSString *speech_images = model.arrImage.count==0?kEmpty:[model.arrImage componentsJoinedByString:@"@"];
        
        result = [db executeUpdate:@"REPLACE INTO sns_playlist_practice(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,islastplay,person_synopsis,person_title,showText,joinCart,price,buyStatus,speech_images,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,speech_images]];
    }];
    
    return result;
}
/// 添加发现下面的实务播放列表
-(BOOL)setLocalPlayListPracticeFoundWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil || userId == nil) { return NO; }
    userId = kOne;
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"UPDATE sns_playlist_found SET islastplay = 0"];
        if (!result) {
            *rollback = YES;
        }
        result = [db executeUpdate:@"UPDATE sns_playlist_practice SET islastplay = 0"];
        if (!result) {
            *rollback = YES;
        }
        result = [db executeUpdate:@"UPDATE sns_playlist_subscribe_curriculum SET islastplay = 0"];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            result = [db executeUpdate:@"REPLACE INTO sns_playlist_found(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,islastplay,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 修改发现下面的实务播放列表
-(BOOL)setLocalPlayListPracticeFoundWithModel:(ModelPractice *)model userId:(NSString *)userId
{
    if (model == nil || userId == nil) { return NO; }
    userId = kOne;
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = model.ids==nil?kEmpty:model.ids;
        NSString *title = model.title==nil?kEmpty:model.title;
        NSString *time = model.time==nil?kEmpty:model.time;
        NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
        NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
        NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
        NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
        NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
        NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
        NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
        NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
        NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
        NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
        NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
        NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
        NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
        NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
        NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
        NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
        NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
        NSNumber *showText = [NSNumber numberWithInt:model.showText];
        NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
        NSString *price = model.price==nil?kEmpty:model.price;
        NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
        
        result = [db executeUpdate:@"REPLACE INTO sns_playlist_found(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,islastplay,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
    }];
    
    return result;
}
/// 获取发现下面的实务播放列表
-(NSArray *)getLocalPlayListPracticeFoundWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    userId = kOne;
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_playlist_found WHERE islastplay = 1 AND userId = '%@' ORDER BY sortby DESC", userId]];
        if (rsPractice != nil)
        {
            result = [NSMutableArray array];
            
            while ([rsPractice next]) {
                
                ModelPractice *modelP = [[ModelPractice alloc] initWithAuto:[rsPractice resultDictionary]];
                
                [result addObject:modelP];
                
            }
        }
        [rsPractice close];
    }];
    return result;
}
/// 修改订阅内容列表播放列表
-(BOOL)setLocalPlayListSubscribeCurriculumListWithModel:(ModelCurriculum *)model userId:(NSString *)userId
{
    if (model == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = model.ids == nil?kEmpty:model.ids;
        NSString *title = model.title == nil?kEmpty:model.title;
        NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
        NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
        NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
        NSString *content = model.content == nil?kEmpty:model.content;
        NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
        NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
        NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
        NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
        NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
        NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
        NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
        NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
        NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
        NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
        NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
        NSString *price = model.price == nil?kEmpty:model.price;
        NSString *units = model.units == nil?kEmpty:model.units;
        NSString *speaker_name = model.speaker_name == nil?kEmpty:model.speaker_name;
        NSNumber *mcount = [NSNumber numberWithInteger:model.mcount];
        NSNumber *ccount = [NSNumber numberWithInteger:model.ccount];
        NSNumber *applauds = [NSNumber numberWithInteger:model.applauds];
        NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
        NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
        NSNumber *is_series_course = [NSNumber numberWithBool:model.is_series_course];
        result = [db executeUpdate:@"REPLACE INTO sns_playlist_subscribe_curriculum(ids,userId,subscribeId,speaker_name,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,islastplay,team_intro,course_picture,price,units,mcount,ccount,applauds,isPraise,isCollection,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,speaker_name,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units,mcount,ccount,applauds,isPraise,isCollection,is_series_course]];
    }];
    
    return result;
}
/// 获取订阅内容对象
-(ModelCurriculum *)getLocalPlayListSubscribeCurriculumListWithUserId:(NSString *)userId ids:(NSString *)ids
{
    __block ModelCurriculum *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_playlist_subscribe_curriculum WHERE userId = '%@' AND ids = '%@' ORDER BY sortby DESC", userId, ids]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]];
                NSString *strCourseImages = [rs stringForColumn:@"course_imges"];
                result.course_imges = [NSArray arrayWithArray:[strCourseImages componentsSeparatedByString:@"@"]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}

/**************************************2.1缓存**********************************************/

/// 添加音频下载
-(BOOL)addLocalDownloadAudioWithModel:(ModelAudio *)model userId:(NSString *)userId
{
    if (model == nil || userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *ids = model.ids==nil?kEmpty:model.ids;
        NSString *objId = model.objId==nil?kEmpty:model.objId;
        NSString *audioTitle = model.audioTitle==nil?kEmpty:model.audioTitle;
        NSString *audioImage = model.audioImage==nil?kEmpty:model.audioImage;
        NSString *audioPath = model.audioPath==nil?kEmpty:model.audioPath;
        NSString *audioLocalPath = model.audioLocalPath==nil?kEmpty:model.audioLocalPath;
        NSString *audioAuthor = model.audioAuthor==nil?kEmpty:model.audioAuthor;
        NSString *cachePath = model.cachePath==nil?kEmpty:model.cachePath;
        NSNumber *audioPlayTime = [NSNumber numberWithLong:model.audioPlayTime];
        NSString *totalDuration = model.totalDuration==nil?kEmpty:model.totalDuration;
        NSNumber *audioPlayType = [NSNumber numberWithInt:model.audioPlayType];
        NSNumber *address = [NSNumber numberWithInt:model.address];
        NSNumber *totalUnitCount = [NSNumber numberWithLongLong:model.totalUnitCount];
        NSNumber *completedUnitCount = [NSNumber numberWithLongLong:model.completedUnitCount];
        NSNumber *progress = [NSNumber numberWithLongLong:model.progress];
        
        result = [db executeUpdate:@"REPLACE INTO sns_download_audio(ids,userId,objId,audioTitle,audioAuthor,cachePath,audioPath,audioLocalPath,audioImage,audioPlayTime,totalDuration,audioPlayType,address,totalUnitCount,completedUnitCount,progress,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,objId,audioTitle,audioAuthor,cachePath,audioPath,audioLocalPath,audioImage,audioPlayTime,totalDuration,audioPlayType,address,totalUnitCount,completedUnitCount,progress]];
    }];
    
    return result;
}
/// 删除音频下载
-(BOOL)delLocalDownloadAudioWithModel:(ModelAudio *)model userId:(NSString *)userId
{
    if (model == nil || userId == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_download_audio WHERE ids ='%@' AND userId='%@' AND audioPlayType='%d'", model.ids, userId, model.audioPlayType]];
        
    }];
    
    return result;
}
/// 删除音频下载
-(BOOL)delLocalDownloadAudioWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil || array.count == 0 || userId == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (ModelAudio *model in array) {
            result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_download_audio WHERE ids = '%@' AND userId='%@' AND audioPlayType='%d'", model.ids, userId, model.audioPlayType]];
            if (!result) {
                 *rollback = YES;
                break;
            }
        }
        
    }];
    
    return result;
}
/// 获取下载完成音频列表
-(NSArray *)getLocalDownloadAudioEndWithUserId:(NSString *)userId type:(int)type pageNum:(int)pageNum
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_download_audio WHERE userId='%@' AND audioPlayType='%d' AND address=%d ORDER BY sortby DESC", userId, type, (int)ZDownloadStatusEnd]];
        if (rsPractice != nil)
        {
            result = [NSMutableArray array];
            
            while ([rsPractice next]) {
                
                ModelAudio *modelP = [[ModelAudio alloc] initWithAuto:[rsPractice resultDictionary]];
                
                [result addObject:modelP];
                
            }
        }
        [rsPractice close];
    }];
    return result;
}
/// 获取待下载音频列表
-(NSArray *)getLocalDownloadAudioWaitWithUserId:(NSString *)userId pageNum:(int)pageNum
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_download_audio WHERE userId='%@' AND address!=%d ORDER BY ids,audioPlayType ASC LIMIT %d,100", userId, (int)ZDownloadStatusEnd, pageNum*kPAGE_MAXCOUNT]];
        if (rsPractice != nil)
        {
            result = [NSMutableArray array];
            
            while ([rsPractice next]) {
                
                ModelAudio *modelP = [[ModelAudio alloc] initWithAuto:[rsPractice resultDictionary]];
                
                [result addObject:modelP];
                
            }
        }
        [rsPractice close];
    }];
    return result;
}
/// 获取音频对象
-(ModelAudio *)getLocalDownloadAudioWithUserId:(NSString *)userId ids:(NSString*)ids type:(int)type
{
    if (ids == nil) {
        return nil;
    }
    __block ModelAudio *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_download_audio WHERE userId='%@' AND ids='%@' AND audioPlayType='%d' ORDER BY sortby DESC LIMIT 0,1", userId, ids, type]];
        if (rsPractice != nil)
        {
            while ([rsPractice next]) {
                
                result = [[ModelAudio alloc] initWithAuto:[rsPractice resultDictionary]];
                break;
            }
        }
        [rsPractice close];
    }];
    return result;
}
///检测是否存在下载对象
-(ModelAudio *)checkToDetectWhetherThereALocalDownload
{
    __block ModelAudio *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_download_audio WHERE address = %d ORDER BY sortby DESC", (int)ZDownloadStatusDowloading]];
        if (rs != nil)
        {
            while ([rs next]) {
                
                result = [[ModelAudio alloc] initWithAuto:[rs resultDictionary]];
                break;
            }
        }
        [rs close];
    }];
    return result;
}
///检测对象是否下载完成
-(BOOL)checkLocalDownloadEndWithIds:(NSString *)ids userId:(NSString *)userId
{
    if (ids == nil || userId == nil) {
        return NO;
    }
    __block BOOL result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT count(*) FROM sns_download_audio WHERE ids = '%@' AND userId='%@' AND address = %d ORDER BY sortby DESC", ids, userId, (int)ZDownloadStatusEnd]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [rs intForColumnIndex:0] > 0;
                break;
            }
        }
        [rs close];
    }];
    return result;
}
/// 获取最新的一个需要下载的音频对象
-(ModelAudio *)getLocalDownloadAudioWithUserId:(NSString *)userId
{
    if (userId == nil) {
        return nil;
    }
    __block ModelAudio *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_download_audio WHERE userId='%@' AND address!='%d' AND address!='%d' ORDER BY sortby DESC LIMIT 0,1", userId, (int)ZDownloadStatusDowloading, (int)ZDownloadStatusEnd]];
        if (rsPractice != nil)
        {
            while ([rsPractice next]) {
                
                result = [[ModelAudio alloc] initWithAuto:[rsPractice resultDictionary]];
                break;
            }
        }
        [rsPractice close];
    }];
    return result;
}

///保存购物车实务集合
-(BOOL)setLocalPayCartPracticeWithArray:(NSArray *)arr userId:(NSString *)userId
{
    if (arr == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_cart_practice WHERE userId = '%@'",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in arr) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            ///添加图片
            result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_image WHERE typeid = '%@' AND typename = 'practice'",ids]];
            if (!result) {
                *rollback = YES;
                break;
            }
            for (NSString *url in model.arrImage) {
                if (url) {
                    result = [db executeUpdate:@"REPLACE INTO sns_image(typeid,typename,imgurl,sortby) VALUES(?,'practice',?,strftime('%s%f','now'))" withArgumentsInArray:@[ids,url]];
                    if (!result) {
                        break;
                    }
                }
            }
            if (!result) {
                *rollback = YES;
                break;
            }
            ///添加语音
            result = [db executeUpdate:@"REPLACE INTO sns_cart_practice(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///获取购物车实务集合
-(NSArray *)getLocalPayCartPracticeArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_cart_practice WHERE userId = '%@' ORDER BY sortby ASC",userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                ModelPractice *model = [[ModelPractice alloc] initWithAuto:dic];
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}

///保存已购实务集合
-(BOOL)setLocalPurchasePracticeWithArray:(NSArray *)arr userId:(NSString *)userId
{
    if (arr == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_purchase_practice WHERE userId = '%@'",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in arr) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            ///添加图片
            result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_image WHERE typeid = '%@' AND typename = 'practice'",ids]];
            if (!result) {
                *rollback = YES;
                break;
            }
            for (NSString *url in model.arrImage) {
                if (url) {
                    result = [db executeUpdate:@"REPLACE INTO sns_image(typeid,typename,imgurl,sortby) VALUES(?,'practice',?,strftime('%s%f','now'))" withArgumentsInArray:@[ids,url]];
                    if (!result) {
                        break;
                    }
                }
            }
            if (!result) {
                *rollback = YES;
                break;
            }
            ///添加实务
            result = [db executeUpdate:@"REPLACE INTO sns_purchase_practice(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///获取已购实务集合
-(NSArray *)getLocalPurchasePracticeArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_purchase_practice WHERE userId = '%@' ORDER BY sortby ASC",userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                ModelPractice *model = [[ModelPractice alloc] initWithAuto:dic];
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置已购订阅集合
-(BOOL)setLocalPurchaseSubscribeWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_purchase_subscribe WHERE userId='%@'",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelSubscribe *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *team_info = model.team_info == nil?kEmpty:model.team_info;
            NSString *theme_intro = model.theme_intro == nil?kEmpty:model.theme_intro;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSNumber *count = [NSNumber numberWithInt:model.count];
            NSString *units = model.units == nil?kEmpty:model.units;
            NSNumber *status = [NSNumber numberWithInt:model.status];
            NSNumber *hits = [NSNumber numberWithLong:model.hits];
            NSNumber *is_series_course = [NSNumber numberWithLong:model.is_series_course];
            
            result = [db executeUpdate:@"REPLACE INTO sns_purchase_subscribe(ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取已购订阅集合
-(NSArray *)getLocalPurchaseSubscribeArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_purchase_subscribe WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelSubscribe alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置已购系列课程集合
-(BOOL)setLocalPurchaseCurriculumWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_purchase_curriculum WHERE userId='%@'",userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelSubscribe *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *team_info = model.team_info == nil?kEmpty:model.team_info;
            NSString *theme_intro = model.theme_intro == nil?kEmpty:model.theme_intro;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSNumber *count = [NSNumber numberWithInt:model.count];
            NSString *units = model.units == nil?kEmpty:model.units;
            NSNumber *status = [NSNumber numberWithInt:model.status];
            NSNumber *hits = [NSNumber numberWithLong:model.hits];
            NSNumber *is_series_course = [NSNumber numberWithLong:model.is_series_course];
            
            result = [db executeUpdate:@"REPLACE INTO sns_purchase_curriculum(ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,is_series_course,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,team_name,team_info,theme_intro,illustration,price,count,units,status,hits,is_series_course]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取已购系列课程集合
-(NSArray *)getLocalPurchaseCurriculumArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_purchase_curriculum WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelSubscribe alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

///保存播放记录实务集合
-(BOOL)setLocalPlayrecordPracticeWithArray:(NSArray *)array
{
    if (array == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (ModelPractice *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            
            ///添加实务
            result = [db executeUpdate:@"REPLACE INTO sns_playrecord_practice(ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
            if (!result) {
                *rollback = YES;
                break;
            }
            ///添加图片
            result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_image WHERE typeid = '%@' AND typename = 'practice'",ids]];
            if (!result) {
                *rollback = YES;
                break;
            }
            for (NSString *url in model.arrImage) {
                if (url) {
                    result = [db executeUpdate:@"REPLACE INTO sns_image(typeid,typename,imgurl,sortby) VALUES(?,'practice',?,strftime('%s%f','now'))" withArgumentsInArray:@[ids,url]];
                    if (!result) {
                        break;
                    }
                }
            }
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
///保存播放记录实务对象
-(BOOL)setLocalPlayrecordPracticeWithModel:(ModelPractice *)model
{
    if (model == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *ids = model.ids==nil?kEmpty:model.ids;
        NSString *title = model.title==nil?kEmpty:model.title;
        NSString *time = model.time==nil?kEmpty:model.time;
        NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
        NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
        NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
        NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
        NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
        NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
        NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
        NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
        NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
        NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
        NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
        NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
        NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
        NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
        NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
        NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
        NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
        NSNumber *showText = [NSNumber numberWithInt:model.showText];
        NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
        NSString *price = model.price==nil?kEmpty:model.price;
        NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
        
        ///添加图片
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_image WHERE typeid = '%@' AND typename = 'practice'",ids]];
        if (!result) {
            *rollback = YES;
        }
        for (NSString *url in model.arrImage) {
            if (url) {
                result = [db executeUpdate:@"REPLACE INTO sns_image(typeid,typename,imgurl,sortby) VALUES(?,'practice',?,strftime('%s%f','now'))" withArgumentsInArray:@[ids,url]];
                if (!result) {
                    break;
                }
            }
        }
        if (!result) {
            *rollback = YES;
        }
        ///添加实务
        result = [db executeUpdate:@"REPLACE INTO sns_playrecord_practice(ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus]];
        if (!result) {
            *rollback = YES;
        }
    }];
    
    return result;
}
///获取播放记录
-(NSArray *)getLocalPlayrecordPracticeArrayWithIds:(NSString *)ids
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_playrecord_practice WHERE ids in (%@) ORDER BY sortby DESC", ids]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                ModelPractice *model = [[ModelPractice alloc] initWithAuto:dic];
                [model setUnlock:0];
                [model setBuyStatus:1];
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}
///获取播放记录
-(NSArray *)getLocalPlayrecordPracticeArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_playrecord_practice ORDER BY sortby DESC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                ModelPractice *model = [[ModelPractice alloc] initWithAuto:dic];
                [model setUnlock:0];
                [model setBuyStatus:1];
                FMResultSet *rsArr = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_image WHERE typeid = '%@' AND typename = 'practice' ORDER BY sortby ASC",model.ids]];
                
                if (rsArr != nil)
                {
                    NSMutableArray *arrImage = [NSMutableArray array];
                    while ([rsArr next]) {
                        NSDictionary *dic = [rsArr resultDictionary];
                        NSString *imgUrl = [dic objectForKey:@"imgurl"];
                        if (imgUrl) {
                            [arrImage addObject:@{@"url":imgUrl}];
                        }
                    }
                    [model setArrImage:arrImage];
                }
                [rsArr close];
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}
/// 设置订阅播放记录
-(BOOL)setLocalPlayrecordSubscribeCurriculumWithArray:(NSArray *)array
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (ModelCurriculum *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
            NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
            NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
            NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            NSString *speaker_name = model.speaker_name == nil?kEmpty:model.speaker_name;
            
            result = [db executeUpdate:@"REPLACE INTO sns_playrecord_curriculum(ids,subscribeId,speaker_name,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,subscribeId,speaker_name,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取订阅播放记录
-(NSArray *)getLocalPlayrecordSubscribeCurriculumArrayWithIds:(NSString *)ids
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_playrecord_curriculum WHERE ids in (%@) ORDER BY sortby DESC", ids]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                ModelCurriculum *modelC = [[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]];
                [modelC setCourse_imges:[[rs stringForColumn:@"course_imges"] toArray]];
                [result addObject:modelC];
                
            }
        }
        [rs close];
    }];
    return result;
}
/// 获取订阅播放记录
-(NSArray *)getLocalPlayrecordSubscribeCurriculumArrayWithAll
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM sns_playrecord_curriculum ORDER BY sortby DESC"];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                ModelCurriculum *modelC = [[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]];
                [modelC setCourse_imges:[[rs stringForColumn:@"course_imges"] toArray]];
                [result addObject:modelC];
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置我的留言集合
-(BOOL)setLocalMyMessageWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_mymessage WHERE userId = '%@'", userId]];
        if (!result) {
            *rollback = YES;
            return;
        }
        for (ModelMyMessage *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *course_id = model.course_id == nil?kEmpty:model.course_id;
            NSString *subscribe_id = model.subscribe_id == nil?kEmpty:model.subscribe_id;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *applaudCount = [NSNumber numberWithLong:model.applaudCount];
            NSString *reply = model.reply == nil?kEmpty:model.reply;
            NSString *reply_lecturer = model.reply_lecturer == nil?kEmpty:model.reply_lecturer;
            NSString *reply_time = model.reply_time == nil?kEmpty:model.reply_time;
            NSString *units = model.units == nil?kEmpty:model.units;
            NSString *price = model.price == nil?kEmpty:model.price;
            
            result = [db executeUpdate:@"REPLACE INTO sns_mymessage(ids,content,course_id,subscribe_id,create_time,title,free_read,applaudCount,reply,reply_lecturer,reply_time,userId,price,units,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,content,course_id,subscribe_id,create_time,title,free_read,applaudCount,reply,reply_lecturer,reply_time,userId,price,units]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取我的留言集合
-(NSArray *)getLocalMyMessageArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_mymessage WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelMyMessage alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

/**************************************2.2缓存**********************************************/

///保存喜马拉雅下载记录
-(BOOL)setLocalDownloadListWithModelTrack:(XMTrack *)model
{
    if (model == nil) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        NSNumber *trackId = [NSNumber numberWithInteger:model.trackId];
        NSNumber *announcerid = [NSNumber numberWithInteger:model.announcer.id];
        NSString *announcerkind = model.announcer.kind==nil?kEmpty:model.announcer.kind;
        NSString *announcernickname = model.announcer.nickname==nil?kEmpty:model.announcer.nickname;
        NSString *announceravatarUrl = model.announcer.avatarUrl==nil?kEmpty:model.announcer.avatarUrl;
        NSNumber *announcerisVerified = [NSNumber numberWithBool:model.announcer.isVerified];
        NSNumber *commentCount = [NSNumber numberWithInteger:model.commentCount];
        NSNumber *downloadCount = [NSNumber numberWithInteger:model.downloadCount];
        NSNumber *downloadSize = [NSNumber numberWithInteger:model.downloadSize];
        NSNumber *duration = [NSNumber numberWithInteger:model.duration];
        NSNumber *favoriteCount = [NSNumber numberWithInteger:model.favoriteCount];
        NSNumber *orderNum = [NSNumber numberWithInteger:model.orderNum];
        NSNumber *playCount = [NSNumber numberWithInteger:model.playCount];
        NSNumber *playSize24M4a = [NSNumber numberWithInteger:model.playSize24M4a];
        NSNumber *playSize32 = [NSNumber numberWithInteger:model.playSize32];
        NSNumber *playSize64 = [NSNumber numberWithInteger:model.playSize64];
        NSNumber *playSize64M4a = [NSNumber numberWithInteger:model.playSize64M4a];
        NSNumber *playSizeAmr = [NSNumber numberWithInteger:model.playSizeAmr];
        NSNumber *source = [NSNumber numberWithInteger:model.source];
        NSString *coverUrlLarge = model.coverUrlLarge==nil?kEmpty:model.coverUrlLarge;
        NSString *coverUrlMiddle = model.coverUrlMiddle==nil?kEmpty:model.coverUrlMiddle;
        NSString *coverUrlSmall = model.coverUrlSmall==nil?kEmpty:model.coverUrlSmall;
        NSString *downloadUrl = model.downloadUrl==nil?kEmpty:model.downloadUrl;
        NSString *kind = model.kind==nil?kEmpty:model.kind;
        NSString *playUrl24M4a = model.playUrl24M4a==nil?kEmpty:model.playUrl24M4a;
        NSString *playUrl32 = model.playUrl32==nil?kEmpty:model.playUrl32;
        NSString *playUrl64 = model.playUrl64==nil?kEmpty:model.playUrl64;
        NSString *playUrl64M4a = model.playUrl64M4a==nil?kEmpty:model.playUrl64M4a;
        NSString *playUrlAmr = model.playUrlAmr==nil?kEmpty:model.playUrlAmr;
        NSString *subordinatedAlbumalbumTitle = model.subordinatedAlbum.albumTitle==nil?kEmpty:model.subordinatedAlbum.albumTitle;
        NSString *subordinatedAlbumcoverUrlLarge = model.subordinatedAlbum.coverUrlLarge==nil?kEmpty:model.subordinatedAlbum.coverUrlLarge;
        NSString *subordinatedAlbumcoverUrlMiddle = model.subordinatedAlbum.coverUrlMiddle==nil?kEmpty:model.subordinatedAlbum.coverUrlMiddle;
        NSString *subordinatedAlbumcoverUrlSmall = model.subordinatedAlbum.coverUrlSmall==nil?kEmpty:model.subordinatedAlbum.coverUrlSmall;
        NSNumber *subordinatedAlbumalbumId = [NSNumber numberWithInteger:model.subordinatedAlbum.albumId];
        NSString *trackIntro = model.trackIntro==nil?kEmpty:model.trackIntro;
        NSString *trackTags = model.trackTags==nil?kEmpty:model.trackTags;
        NSString *trackTitle = model.trackTitle==nil?kEmpty:model.trackTitle;
        NSString *filePath = model.filePath==nil?kEmpty:model.filePath;
        NSString *startPlayTime = model.startPlayTime==nil?kEmpty:[model.startPlayTime toString];
        NSNumber *updatedAt = [NSNumber numberWithInteger:model.updatedAt];
        NSNumber *createdAt = [NSNumber numberWithInteger:model.createdAt];
        NSNumber *canDownload = [NSNumber numberWithInteger:model.canDownload];
        NSNumber *playing = [NSNumber numberWithInteger:model.playing];
        NSNumber *pause = [NSNumber numberWithInteger:model.pause];
        NSNumber *listenedTime = [NSNumber numberWithInteger:model.listenedTime];
        NSNumber *listenedPosition = [NSNumber numberWithInteger:model.listenedPosition];
        NSNumber *status = [NSNumber numberWithInteger:model.status];
        NSNumber *downloadedBytes = [NSNumber numberWithInteger:model.downloadedBytes];
        NSNumber *totalBytes = [NSNumber numberWithInteger:model.totalBytes];
        
        result = [db executeUpdate:@"REPLACE INTO sns_xmtrack(trackId,dataType,announcerid,announcerkind,announcernickname,announceravatarUrl,announcerisVerified,commentCount,downloadCount,downloadSize,duration,favoriteCount,orderNum,playCount,playSize24M4a,playSize32,playSize64,playSize64M4a,playSizeAmr,source,coverUrlLarge,coverUrlMiddle,coverUrlSmall,downloadUrl,kind,playUrl24M4a,playUrl32,playUrl64,playUrl64M4a,playUrlAmr,subordinatedAlbumalbumTitle,subordinatedAlbumcoverUrlLarge,subordinatedAlbumcoverUrlMiddle,subordinatedAlbumcoverUrlSmall,subordinatedAlbumalbumId,trackIntro,trackTags,trackTitle,filePath,startPlayTime,updatedAt,createdAt,canDownload,playing,pause,listenedTime,listenedPosition,status,downloadedBytes,totalBytes,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[trackId,source,announcerid,announcerkind ,announcernickname,announceravatarUrl,announcerisVerified,commentCount,downloadCount,downloadSize,duration,favoriteCount,orderNum,playCount,playSize24M4a,playSize32,playSize64,playSize64M4a,playSizeAmr,source,coverUrlLarge,coverUrlMiddle,coverUrlSmall,downloadUrl,kind,playUrl24M4a,playUrl32,playUrl64,playUrl64M4a,playUrlAmr,subordinatedAlbumalbumTitle,subordinatedAlbumcoverUrlLarge,subordinatedAlbumcoverUrlMiddle,subordinatedAlbumcoverUrlSmall,subordinatedAlbumalbumId,trackIntro,trackTags,trackTitle,filePath,startPlayTime,updatedAt,createdAt,canDownload,playing,pause,listenedTime,listenedPosition,status,downloadedBytes,totalBytes]];
    }];
    
    return result;
}
///删除喜马拉雅下载记录
-(BOOL)delLocalDownloadListWithTrackId:(NSInteger)trackId dataType:(NSInteger)dataType;
{
    BOOL __block result = NO;
    NSString *userId = [AppSetting getUserDetauleId];
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_xmtrack WHERE trackId = %ld AND source = %ld AND announcerid = '%@' ", (long)trackId, (long)dataType, userId]];
    }];
    return result;
}
///删除喜马拉雅下载记录
-(BOOL)delLocalDownloadListWithArray:(NSArray *)array
{
    BOOL __block result = NO;
    NSString *userId = [AppSetting getUserDetauleId];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (XMTrack *model in array) {
            result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_xmtrack WHERE trackId = %ld AND source = %ld AND announcerid = '%@' ", (long)model.trackId, (long)model.source, userId]];
        }
    }];
    return result;
}
///获取喜马拉雅下载记录
-(NSMutableArray *)getLocalDownloadListWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_xmtrack WHERE announcerid = '%@'  ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                XMCacheTrack *model = [[XMCacheTrack class] mj_objectWithKeyValues:[rs resultDictionary]];
                
                XMAnnouncer *announcer = [[XMAnnouncer alloc] init];
                announcer.id = [[rs stringForColumn:@"announcerid"] integerValue];
                announcer.kind = [rs stringForColumn:@"announcerkind"];
                announcer.nickname = [rs stringForColumn:@"announcernickname"];
                announcer.avatarUrl = [rs stringForColumn:@"announceravatarUrl"];
                announcer.isVerified = [rs boolForColumn:@"announcerisVerified"];
                model.announcer = announcer;
                
                XMSubordinatedAlbum *subordinatedAlbum = [[XMSubordinatedAlbum alloc] init];
                subordinatedAlbum.albumId = [[rs stringForColumn:@"subordinatedAlbumalbumId"] integerValue];
                subordinatedAlbum.albumTitle = [rs stringForColumn:@"subordinatedAlbumalbumTitle"];
                subordinatedAlbum.coverUrlLarge = [rs stringForColumn:@"subordinatedAlbumcoverUrlLarge"];
                subordinatedAlbum.coverUrlMiddle = [rs stringForColumn:@"subordinatedAlbumcoverUrlMiddle"];
                subordinatedAlbum.coverUrlSmall = [rs stringForColumn:@"subordinatedAlbumcoverUrlSmall"];
                model.subordinatedAlbum = subordinatedAlbum;
                
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}
///获取喜马拉雅下载记录
-(NSMutableArray *)getLocalDownloadListWithTrackId:(NSInteger)trackId dataType:(NSInteger)dataType
{
    __block NSMutableArray *result = nil;
    NSString *userId = [AppSetting getUserDetauleId];
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_xmtrack WHERE trackId = %ld AND source = %d AND announcerid = '%@'  ORDER BY sortby ASC", (long)trackId, (int)dataType, userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                XMCacheTrack *model = [[XMCacheTrack class] mj_objectWithKeyValues:[rs resultDictionary]];
                
                XMAnnouncer *announcer = [[XMAnnouncer alloc] init];
                announcer.id = [[rs stringForColumn:@"announcerid"] integerValue];
                announcer.kind = [rs stringForColumn:@"announcerkind"];
                announcer.nickname = [rs stringForColumn:@"announcernickname"];
                announcer.avatarUrl = [rs stringForColumn:@"announceravatarUrl"];
                announcer.isVerified = [rs boolForColumn:@"announcerisVerified"];
                model.announcer = announcer;
                
                XMSubordinatedAlbum *subordinatedAlbum = [[XMSubordinatedAlbum alloc] init];
                subordinatedAlbum.albumId = [[rs stringForColumn:@"subordinatedAlbumalbumId"] integerValue];
                subordinatedAlbum.albumTitle = [rs stringForColumn:@"subordinatedAlbumalbumTitle"];
                subordinatedAlbum.coverUrlLarge = [rs stringForColumn:@"subordinatedAlbumcoverUrlLarge"];
                subordinatedAlbum.coverUrlMiddle = [rs stringForColumn:@"subordinatedAlbumcoverUrlMiddle"];
                subordinatedAlbum.coverUrlSmall = [rs stringForColumn:@"subordinatedAlbumcoverUrlSmall"];
                model.subordinatedAlbum = subordinatedAlbum;
                
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}

/*********************************************播放历史记录*********************************************/

///保存播放实务详情对象
-(BOOL)setLocalPlayPracticeDetailWithModel:(ModelPractice *)model  userId:(NSString *)userId
{
    if (model == nil) return NO;
    
    NSString *ids = model.ids==nil?kEmpty:model.ids;
    NSString *title = model.title==nil?kEmpty:model.title;
    NSString *time = model.time==nil?kEmpty:model.time;
    NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
    NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
    NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
    NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
    NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
    NSString *arrImage = kEmpty;
    if (model.arrImage && model.arrImage.count > 0) {
        arrImage = [model.arrImage componentsJoinedByString:@"@"];
    }
    NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
    NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
    NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
    NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
    NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
    NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
    NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
    NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
    NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
    NSNumber *showText = [NSNumber numberWithInt:model.showText];
    NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
    NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
    NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
    NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
    NSString *price = model.price==nil?kEmpty:model.price;
    NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        ///添加实务详情
        result = [db executeUpdate:@"REPLACE INTO sns_play_practice_detail(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,showText,person_synopsis,person_title,unlock,joinCart,price,buyStatus,arrImage,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,showText,person_synopsis,person_title,unlock,joinCart,price,buyStatus,arrImage]];
    }];
    
    return result;
}
///获取播放指定ID实务对象
-(ModelPractice *)getLocalPlayPracticeDetailModelWithId:(NSString *)ids userId:(NSString *)userId
{
    __block ModelPractice *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_play_practice_detail WHERE ids = '%@' AND userId = '%@' LIMIT 0,1",ids,userId]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [[ModelPractice alloc] initWithAuto:[rs resultDictionary]];
                result.arrImage = [NSArray arrayWithArray:[[rs stringForColumn:@"arrImage"] componentsSeparatedByString:@"@"]];
                
                break;
            }
        }
        [rs close];
    }];
    return result;
}
///获取播放实务对象集合
-(NSMutableArray *)getLocalPlayPracticeDetailArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_play_practice_detail WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                ModelPractice *model = [[ModelPractice alloc] initWithAuto:[rs resultDictionary]];
                NSString *arrImage = [rs stringForColumn:@"arrImage"];
                if (arrImage && arrImage.length > 0) {
                    model.arrImage = [NSArray arrayWithArray:[[rs stringForColumn:@"arrImage"] componentsSeparatedByString:@"@"]];
                }
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}

/// 设置播放订阅或系列课
-(BOOL)setLocalPlayCurriculumDetailWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil || userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (ModelCurriculum *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
            NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
            NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
            NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            NSString *speaker_name = model.speaker_name == nil?kEmpty:model.speaker_name;
            NSNumber *is_series_course = [NSNumber numberWithInt:model.is_series_course];
            NSNumber *hits = [NSNumber numberWithLong:model.hits];
            NSNumber *unReadCount = [NSNumber numberWithInt:model.unReadCount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isPraise = [NSNumber numberWithInt:model.isPraise];
            NSNumber *isCollection = [NSNumber numberWithInt:model.isCollection];
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            
            result = [db executeUpdate:@"REPLACE INTO sns_play_curriculum_detail(ids,userId,subscribeId,title,speaker_name,team_name,team_intro,illustration,course_picture,course_imges,ctitle,content,create_time,audio_picture,audio_time,audio_url,is_series_course,hits,price,units,free_read,play_time,unReadCount,rowIndex,mcount,applauds,ccount,isPraise,isCollection,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,title,speaker_name,team_name,team_intro,illustration,course_picture,course_imges,ctitle,content,create_time,audio_picture,audio_time,audio_url,is_series_course,hits,price,units,free_read,play_time,unReadCount,rowIndex,mcount,applauds,ccount,isPraise,isCollection]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 设置播放订阅或系列课
-(BOOL)setLocalPlayCurriculumDetailWithModel:(ModelCurriculum *)model userId:(NSString *)userId
{
    if (model == nil || userId == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *ids = model.ids == nil?kEmpty:model.ids;
        NSString *title = model.title == nil?kEmpty:model.title;
        NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
        NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
        NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
        NSString *content = model.content == nil?kEmpty:model.content;
        NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
        NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
        NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
        NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
        NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
        NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
        NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
        NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
        NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
        NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
        NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
        NSString *price = model.price == nil?kEmpty:model.price;
        NSString *units = model.units == nil?kEmpty:model.units;
        NSString *speaker_name = model.speaker_name == nil?kEmpty:model.speaker_name;
        NSNumber *is_series_course = [NSNumber numberWithInt:model.is_series_course];
        NSNumber *hits = [NSNumber numberWithLong:model.hits];
        NSNumber *unReadCount = [NSNumber numberWithInt:model.unReadCount];
        NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
        NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
        NSNumber *isPraise = [NSNumber numberWithInt:model.isPraise];
        NSNumber *isCollection = [NSNumber numberWithInt:model.isCollection];
        NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
        
        result = [db executeUpdate:@"REPLACE INTO sns_play_curriculum_detail(ids,userId,subscribeId,title,speaker_name,team_name,team_intro,illustration,course_picture,course_imges,ctitle,content,create_time,audio_picture,audio_time,audio_url,is_series_course,hits,price,units,free_read,play_time,unReadCount,rowIndex,mcount,applauds,ccount,isPraise,isCollection,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,title,speaker_name,team_name,team_intro,illustration,course_picture,course_imges,ctitle,content,create_time,audio_picture,audio_time,audio_url,is_series_course,hits,price,units,free_read,play_time,unReadCount,rowIndex,mcount,applauds,ccount,isPraise,isCollection]];
    }];
    
    return result;
}
/// 获取播放订阅或系列课
-(ModelCurriculum *)getLocalPlayCurriculumDetailWithUserId:(NSString *)userId ids:(NSString *)ids
{
    __block ModelCurriculum *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_play_curriculum_detail WHERE userId = '%@' AND ids = '%@' ORDER BY sortby ASC", userId, ids]];
        if (rs != nil)
        {
            while ([rs next]) {
                result = [[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]];
                NSString *course_imges = [rs stringForColumn:@"course_imges"];
                if (course_imges && course_imges.length > 0) {
                    result.course_imges = [NSArray arrayWithArray:[course_imges componentsSeparatedByString:@"@"]];
                }
                break;
            }
        }
        [rs close];
    }];
    return result;
}
/// 获取播放订阅或系列课
-(NSMutableArray *)getLocalPlayCurriculumDetailArrayWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_play_curriculum_detail WHERE userId = '%@' ORDER BY sortby ASC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                ModelCurriculum *model = [[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]];
                NSString *course_imges = [rs stringForColumn:@"course_imges"];
                if (course_imges && course_imges.length > 0) {
                    model.course_imges = [NSArray arrayWithArray:[course_imges componentsSeparatedByString:@"@"]];
                }
                [result addObject:model];
            }
        }
        [rs close];
    }];
    return result;
}

/*********************************************最后一次播放集合记录*********************************************/

/// 添加任何实务列表下面的实务播放列表
-(BOOL)setLocalPlayListPracticeWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil || userId == nil) { return NO; }
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_playlist_practice WHERE userId = '%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_playlist_subscribe_curriculum WHERE userId = '%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelPractice *model in array) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            NSString *title = model.title==nil?kEmpty:model.title;
            NSString *time = model.time==nil?kEmpty:model.time;
            NSString *play_time = [NSString stringWithFormat:@"%ld",model.play_time];
            NSString *speech_img = model.speech_img==nil?kEmpty:model.speech_img;
            NSString *bkimg = model.bkimg==nil?kEmpty:model.bkimg;
            NSString *speech_url = model.speech_url==nil?kEmpty:model.speech_url;
            NSString *share_content = model.share_content==nil?kEmpty:model.share_content;
            NSString *nickname = model.nickname==nil?kEmpty:model.nickname;
            NSString *create_time = model.create_time==nil?kEmpty:model.create_time;
            NSString *speech_content = model.speech_content==nil?kEmpty:model.speech_content;
            NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
            NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
            NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSNumber *unlock = [NSNumber numberWithInt:model.unlock];
            NSString *person_synopsis = model.person_synopsis==nil?kEmpty:model.person_synopsis;
            NSString *person_title = model.person_title==nil?kEmpty:model.person_title;
            NSNumber *showText = [NSNumber numberWithInt:model.showText];
            NSNumber *joinCart = [NSNumber numberWithInt:model.joinCart];
            NSString *price = model.price==nil?kEmpty:model.price;
            NSNumber *buyStatus = [NSNumber numberWithInt:model.buyStatus];
            NSString *speech_images = model.arrImage.count==0?kEmpty:[model.arrImage componentsJoinedByString:@"@"];
            
            result = [db executeUpdate:@"REPLACE INTO sns_playlist_practice(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,islastplay,person_synopsis,person_title,showText,joinCart,price,buyStatus,speech_images,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,unlock,person_synopsis,person_title,showText,joinCart,price,buyStatus,speech_images]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取任何实务列表下面的实务播放列表
-(NSMutableArray *)getLocalPlayListPracticeWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rsPractice = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_playlist_practice WHERE userId = '%@' ORDER BY sortby DESC", userId]];
        if (rsPractice != nil)
        {
            result = [NSMutableArray array];
            
            while ([rsPractice next]) {
                
                ModelPractice *modelP = [[ModelPractice alloc] initWithAuto:[rsPractice resultDictionary]];
                NSString *speechImages = [rsPractice stringForColumn:@"speech_images"];
                if (speechImages && speechImages.length > 0) {
                    modelP.arrImage = [speechImages componentsSeparatedByString:@"@"];
                }
                [result addObject:modelP];
                
            }
        }
        [rsPractice close];
    }];
    return result;
}
/// 添加订阅内容列表播放列表
-(BOOL)setLocalPlayListSubscribeCurriculumWithArray:(NSArray *)array userId:(NSString *)userId
{
    if (array == nil) { return NO; }
    
    BOOL __block result = NO;
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_playlist_practice WHERE userId = '%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_playlist_subscribe_curriculum WHERE userId = '%@'", userId]];
        if (!result) {
            *rollback = YES;
        }
        for (ModelCurriculum *model in array) {
            
            NSString *ids = model.ids == nil?kEmpty:model.ids;
            NSString *title = model.title == nil?kEmpty:model.title;
            NSString *subscribeId = model.subscribeId == nil?kEmpty:model.subscribeId;
            NSString *ctitle = model.ctitle == nil?kEmpty:model.ctitle;
            NSString *team_name = model.team_name == nil?kEmpty:model.team_name;
            NSString *content = model.content == nil?kEmpty:model.content;
            NSString *audio_picture = model.audio_picture == nil?kEmpty:model.audio_picture;
            NSString *illustration = model.illustration == nil?kEmpty:model.illustration;
            NSString *course_imges = model.course_imges.count==0?kEmpty:[model.course_imges componentsJoinedByString:@"@"];
            NSString *audio_time = model.audio_time == nil?kEmpty:model.audio_time;
            NSString *audio_url = model.audio_url == nil?kEmpty:model.audio_url;
            NSString *create_time = model.create_time == nil?kEmpty:model.create_time;
            NSNumber *free_read = [NSNumber numberWithInt:model.free_read];
            NSNumber *play_time = [NSNumber numberWithLong:model.play_time];
            NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
            NSString *team_intro = model.team_intro == nil?kEmpty:model.team_intro;
            NSString *course_picture = model.course_picture == nil?kEmpty:model.course_picture;
            NSString *price = model.price == nil?kEmpty:model.price;
            NSString *units = model.units == nil?kEmpty:model.units;
            NSString *speaker_name = model.speaker_name == nil?kEmpty:model.speaker_name;
            NSNumber *mcount = [NSNumber numberWithInteger:model.mcount];
            NSNumber *ccount = [NSNumber numberWithInteger:model.ccount];
            NSNumber *applauds = [NSNumber numberWithInteger:model.applauds];
            NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *is_series_course = [NSNumber numberWithBool:model.is_series_course];
            
            result = [db executeUpdate:@"REPLACE INTO sns_playlist_subscribe_curriculum(ids,userId,subscribeId,speaker_name,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,islastplay,team_intro,course_picture,price,units,mcount,ccount,applauds,isPraise,isCollection,is_series_course,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,subscribeId,speaker_name,title,ctitle,team_name,content,audio_picture,illustration,course_imges,audio_time,audio_url,create_time,free_read,play_time,rowIndex,team_intro,course_picture,price,units,mcount,ccount,applauds,isPraise,isCollection,is_series_course]];
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    
    return result;
}
/// 获取订阅内容列表播放列表
-(NSMutableArray *)getLocalPlayListSubscribeCurriculumWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_playlist_subscribe_curriculum WHERE userId = '%@' ORDER BY sortby DESC", userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            
            while ([rs next]) {
                
                [result addObject:[[ModelCurriculum alloc] initWithAuto:[rs resultDictionary]]];
                
            }
        }
        [rs close];
    }];
    return result;
}

@end
