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

///保存实务集合->用户实务列表本地缓存数据的dataType = 1为本地缓存
-(BOOL)setLocalPracticeWithArray:(NSArray *)arr  userId:(NSString *)userId;

///获取实务集合->用户实务列表本地缓存数据的dataType = 1为本地缓存
-(NSArray *)getLocalPracticeOnePageWithUserId:(NSString *)userId;

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


///保存第一页消息中心列表
-(BOOL)setLocalUserNoticeWithArray:(NSArray *)arr;

///获取第一页消息中心列表
-(NSArray *)getLocalUserNotice;

///保存第一页消息中心->详情列表
-(BOOL)setLocalUserNoticeDetailWithArray:(NSArray *)arr;

///获取第一页消息中心->详情列表
-(NSArray *)getLocalUserNoticeDetail;

///保存话题分类列表
-(BOOL)setLocalTopicWithArray:(NSArray *)arr typeId:(NSString *)typeId userId:(NSString *)userId;

///获取话题分类列表
-(NSArray *)getLocalTopicDetailWithTypeId:(NSString *)typeId userId:(NSString *)userId;

///获取第一条的崩溃日志
-(NSString *)getLocalCatchCrashTop;
///添加未上传的崩溃日志
-(BOOL)setLocalCatchCrashWithContent:(NSString *)content;
///删除已上传的崩溃日志
-(BOOL)delLocalCatchCrash;

///保存实务对应的问题
-(BOOL)setLocalPracticeQuestionWithArray:(NSArray *)array practiceId:(NSString *)practiceId type:(ZPracticeQuestionType)type;
///获取实务关联的问题
-(NSArray *)getLocalPracticeQuestionWithPracticeId:(NSString *)practiceId type:(ZPracticeQuestionType)type;

///修改问题详情
-(BOOL)updLocalAnswerDetailWithModel:(ModelAnswerBase *)modelAB userId:(NSString *)userId;
///保存问题详情
-(BOOL)setLocalAnswerDetailWithModel:(ModelAnswerBase *)modelAB commentArray:(NSArray *)commentArray userId:(NSString *)userId;
///获取问题详情
-(ModelAnswerBase *)getLocalAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId;
///添加一条新评论
-(BOOL)addLocalAnswerCommentWithModel:(ModelAnswerComment *)modelAC answerId:(NSString *)answerId;
///添加一条新回复
-(BOOL)addLocalAnswerCommentReplyWithModel:(ModelCommentReply *)modelCR commentId:(NSString *)commentId;
///删除一条评论
-(BOOL)delLocalAnswerCommentWithCommentId:(NSString *)commentId answerId:(NSString *)answerId;
///删除一条回复
-(BOOL)delLocalAnswerCommentReplyWithReplyId:(NSString *)replyId commentId:(NSString *)commentId;

///添加任务集合
-(BOOL)setLocalTaskArrayWithArray:(NSArray *)array userId:(NSString *)userId;
///修改或添加任务对象
-(BOOL)setLocalTaskModelWithModel:(ModelTask *)model userId:(NSString *)userId;
///删除任务集合
-(BOOL)delLocalTaskArrayWithUserId:(NSString *)userId;
///获取任务集合
-(NSArray *)getLocalTaskArrayWithUserId:(NSString *)userId;
///获取任务集合
-(NSArray *)getLocalTaskArrayWithUserId:(NSString *)userId speechId:(NSString *)speechId;
///获取任务对象
-(ModelTask *)getLocalTaskModelWithUserId:(NSString *)userId rule:(NSInteger)rule;

///添加话题对象
-(BOOL)setLocalTopicModelWithModel:(ModelTag *)model userId:(NSString *)userId;
///获取话题对象
-(ModelTag *)getLocalTopicModelWithUserId:(NSString *)userId topicId:(NSString *)topicId;

///添加话题关联问题对象
-(BOOL)setLocalTopicQuestionArrayWithArray:(NSArray *)array topicId:(NSString *)topicId;
///获取话题关联问题对象
-(NSArray *)getLocalTopicQuestionArrayWithTopicId:(NSString *)topicId;

///添加话题关联实务对象
-(BOOL)setLocalTopicPracticeArrayWithArray:(NSArray *)array topicId:(NSString *)topicId;
///获取话题关联实务对象
-(NSArray *)getLocalTopicPracticeArrayWithTopicId:(NSString *)topicId;

@end

#define sqlite [SQLiteOper sharedSingleton]
