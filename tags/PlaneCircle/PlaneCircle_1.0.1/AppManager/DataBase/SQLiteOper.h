//
//  SQLiteOper.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "ModelAudio.h"

@interface SQLiteOper : NSObject

///单例模式
+ (SQLiteOper*)sharedSingleton;

///获取自定义公共参数
-(NSString*)getSysParamWithKey:(NSString*)key;

///设置自定义公共参数
-(BOOL)setSysParam:(NSString*)key value:(NSString*)value;

///清除数据库缓存
-(BOOL)clearHisData;

/**
 *  存储数据集合到本地文件
 *
 *  @param array 数据集合
 *  @param pathKey 文件KEY
 *  @result 返回执行结果
 */
-(BOOL)setLocalCacheDataWithArray:(NSArray*)array pathKay:(NSString*)pathKey;

/**
 *  存储数据集合到本地文件
 *
 *  @param dictionary 数据对象
 *  @param pathKey 文件KEY
 *  @result 返回执行结果
 */
-(BOOL)setLocalCacheDataWithDictionary:(NSDictionary*)dic pathKay:(NSString*)pathKey;

/**
 *  获取本地文件数据集合
 *
 *  @param pathKay 文件KEY
 *  @result 返回数据集合
 */
-(NSArray*)getLocalCacheDataArrayWithPathKay:(NSString*)pathKey;

///本地金额缓存
-(NSArray*)getLocalPlayMoney;

/**
 *  获取本地文件数据对象
 *
 *  @param pathKay 文件KEY
 *  @result 返回数据对象
 */
-(NSDictionary*)getLocalCacheDataWithPathKay:(NSString*)pathKey;

///设置最后一次播放对象
-(BOOL)setLocalPlayPracticeWithModel:(ModelPractice *)model;

///获取最后一次播放对象
-(ModelPractice *)getLocalPlayPracticeModel;

///获取指定ID播放对象
-(ModelPractice *)getLocalPlayPracticeModelWithId:(NSString *)ids;

///保存实务对象
-(BOOL)setLocalPracticeWithModel:(ModelPractice *)model;

///获取指定ID实务对象
-(ModelPractice *)getLocalPracticeModelWithId:(NSString *)ids;

///保存实务对象
-(BOOL)setLocalPracticeDetailWithModel:(ModelPractice *)model userId:(NSString *)userId;

///获取指定ID实务对象
-(ModelPractice *)getLocalPracticeDetailModelWithId:(NSString *)ids userId:(NSString *)userId;

///保存音频对象
-(BOOL)setLocalAudioWithModel:(ModelAudio *)model;

///获取指定ID音频对象
-(ModelAudio *)getLocalAudioModelWithId:(NSString *)ids;

///保存App配置对象
-(BOOL)setLocalAppConfigWithModel:(ModelAppConfig *)model;

///获取指定App配置对象
-(ModelAppConfig *)getLocalAppConfigModelWithId:(NSString *)appVersion;

@end

#define sqlite [SQLiteOper sharedSingleton]
