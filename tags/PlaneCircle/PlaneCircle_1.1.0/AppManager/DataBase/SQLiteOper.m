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
    GBLog(@"SQliteDataBasePath: %@",dbpath);
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
            }
            else
            {
                i++;
            }
            i++;
        }
        if ([dbversion intValue] < [lastversioin intValue])
        {
            [db executeUpdate:@"DELETE FROM dbversion"];
            [db executeUpdate:@"INSERT INTO dbversion(version, note) VALUES(?, ?)", lastversioin, @""];
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
        NSArray * arrSql = @[@"DELETE FROM sys_paras"];
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
 *  @result 返回执行结果
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
 *  @param dictionary 数据对象
 *  @param pathKey 文件KEY
 *  @result 返回执行结果
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
 *  @param pathKay 文件KEY
 *  @result 返回数据集合
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
 *  @param pathKay 文件KEY
 *  @result 返回数据对象
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
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"DELETE FROM play_practice"];
        result = [db executeUpdate:@"REPLACE INTO play_practice(ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex]];
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
    NSNumber *ccount = [NSNumber numberWithLong:model.ccount];
    NSNumber *mcount = [NSNumber numberWithLong:model.mcount];
    NSNumber *applauds = [NSNumber numberWithLong:model.applauds];
    NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
    NSNumber *isPraise = [NSNumber numberWithBool:model.isPraise];
    NSNumber *rowIndex = [NSNumber numberWithInteger:model.rowIndex];
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"REPLACE INTO sns_practice(ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex]];
    }];
    
    return result;
}

///获取指定ID实务对象
-(ModelPractice *)getLocalPracticeModelWithId:(NSString *)ids
{
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_practice WHERE ids = '%@' LIMIT 0,1",ids]];
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

///保存实务集合
-(BOOL)setLocalPracticeWithArray:(NSArray *)arr userId:(NSString *)userId
{
    if (arr == nil || arr.count == 0) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_practice_detail WHERE userId = '%@' AND dataType = 1",userId]];
        
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
            
            result = [db executeUpdate:@"REPLACE INTO sns_practice_detail(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,dataType,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex]];
        }
    }];
    
    return result;
}

///获取实务集合
-(NSArray *)getLocalPracticeOnePageWithUserId:(NSString *)userId
{
    __block NSMutableArray *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_practice_detail WHERE userId = '%@' AND dataType = 1 ORDER BY sortby ASC",userId]];
        if (rs != nil)
        {
            result = [NSMutableArray array];
            while ([rs next]) {
                NSDictionary *dic = [rs resultDictionary];
                [result addObject:[[ModelPractice alloc] initWithAuto:dic]];
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
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"REPLACE INTO sns_practice_detail(ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex,dataType,sortby) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,0,strftime('%s%f','now'));" withArgumentsInArray:@[ids,userId,title,time,play_time,speech_img,bkimg,speech_url,share_content,nickname,create_time,speech_content,ccount,mcount,applauds,isCollection,isPraise,rowIndex]];
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
        return [[ModelPractice alloc] initWithAuto:result];
    }
    return nil;
}

///保存音频对象
-(BOOL)setLocalAudioWithModel:(ModelAudio *)model
{
    if (model == nil) return NO;
    
    NSString *ids = model.ids==nil?kEmpty:model.ids;
    NSString *audioTitle = model.audioTitle==nil?kEmpty:model.audioTitle;
    NSString *audioImage = model.audioImage==nil?kEmpty:model.audioImage;
    NSString *audioPath = model.audioPath==nil?kEmpty:model.audioPath;
    NSString *audioLocalPath = model.audioLocalPath==nil?kEmpty:model.audioLocalPath;
    NSString *audioAuthor = model.audioAuthor==nil?kEmpty:model.audioAuthor;
    NSNumber *audioPlayTime = [NSNumber numberWithLong:model.audioPlayTime];
    
    BOOL __block result = NO;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"REPLACE INTO sns_audio(ids,audioTitle,audioAuthor,audioPath,audioLocalPath,audioImage,audioPlayTime,sortby) VALUES(?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[ids,audioTitle,audioAuthor,audioPath,audioLocalPath,audioImage,audioPlayTime]];
    }];
    
    return result;
}

///获取指定ID音频对象
-(ModelAudio *)getLocalAudioModelWithId:(NSString *)ids
{
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_audio WHERE ids = '%@' LIMIT 0,1",ids]];
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
    
    NSString *appVersion = model.appVersion==nil?kEmpty:model.appVersion;
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
    __block NSDictionary *result = nil;
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM sns_appconfig WHERE appVersion = '%@' LIMIT 0,1",appVersion]];
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
        return [[ModelAppConfig alloc] initWithAuto:result];
    }
    return nil;
}

///保存第一页消息中心列表
-(BOOL)setLocalUserNoticeWithArray:(NSArray *)arr
{
    if (arr == nil || arr.count == 0) return NO;
    
    BOOL __block result = NO;
    
    [dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_notice"];
        
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
    
    [dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:@"DELETE FROM sns_notice_detail"];
        
        for (ModelNoticeDetail *model in arr) {
            NSString *ids = model.ids==nil?kEmpty:model.ids;
            if (ids == nil || ids.length == 0) {
                NSString *ids = model.ids==nil?kEmpty:model.ids;
                NSString *noticeContent = model.noticeContent==nil?kEmpty:model.noticeContent;
                NSString *noticeDesc = model.noticeDesc==nil?kEmpty:model.noticeDesc;
                NSString *noticeNickName = model.noticeNickName==nil?kEmpty:model.noticeNickName;
                NSString *noticeTime = model.noticeTime==nil?kEmpty:model.noticeTime;
                
                result = [db executeUpdate:@"REPLACE INTO sns_notice_detail(ids,noticeContent,noticeDesc,noticeNickName,noticeTime,isRead,sortby) VALUES(?,?,?,?,?,1,strftime('%s%f','now'));" withArgumentsInArray:@[ids,noticeContent,noticeDesc,noticeNickName,noticeTime]];
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
    
    [dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        result = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM sns_topic WHERE userId='%@' AND typeId='%@'",userId,typeId]];
        
        for (ModelTag *model in arr) {
            NSString *tagId = model.tagId==nil?kEmpty:model.tagId;
            NSString *tagName = model.tagName==nil?kEmpty:model.tagName;
            NSString *tagLogo = model.tagLogo==nil?kEmpty:model.tagLogo;
            NSNumber *attCount = [NSNumber numberWithLong:model.attCount];
            NSNumber *isAtt = [NSNumber numberWithBool:model.isAtt];
            NSNumber *isCollection = [NSNumber numberWithBool:model.isCollection];
            NSNumber *status = [NSNumber numberWithInt:model.status];
            
            result = [db executeUpdate:@"REPLACE INTO sns_topic(tagId,userId,typeId,tagName,tagLogo,status,isAtt,isCollection,attCount,sortby) VALUES(?,?,?,?,?,?,?,?,?,strftime('%s%f','now'));" withArgumentsInArray:@[tagId,userId,typeId,tagName,tagLogo,status,isAtt,isCollection,attCount]];
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

@end
