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
 *  @param dic      数据对象
 *  @param pathKey  文件KEY
 *  @return 返回执行结果
 */
-(BOOL)setLocalCacheDataWithDictionary:(NSDictionary*)dic pathKay:(NSString*)pathKey;

/**
 *  获取本地文件数据集合
 *
 *  @param pathKey  文件KEY
 *  @return 返回数据集合
 */
-(NSArray*)getLocalCacheDataArrayWithPathKay:(NSString*)pathKey;


/**
 *  获取本地文件数据对象
 *
 *  @param pathKey 文件KEY
 *  @result 返回数据对象
 */
-(NSDictionary*)getLocalCacheDataWithPathKay:(NSString*)pathKey;

/**
 *  获取本地文件数据对象
 *
 *  @return 返回数据对象
 */
-(NSArray*)getLocalPlayMoney;

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

///修改音频对象
-(BOOL)updLocalAudioWithIds:(NSString *)ids objId:(NSString *)objId audioPlayTime:(NSString *)audioPlayTime audioPlayType:(NSString *)audioPlayType;
///保存音频对象
-(BOOL)setLocalAudioWithModel:(ModelAudio *)model;

///获取指定ID音频对象
-(ModelAudio *)getLocalAudioModelWithId:(NSString *)ids;
///获取最新的一条
-(ModelAudio *)getLocalAudioModelWithNewTopOne;

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


/**************************************2.0缓存**********************************************/

/// 添加首页广告
-(BOOL)setLocalHomeBannerWithArray:(NSArray *)array;
/// 获取首页广告集合
-(NSArray *)getLocalHomeBannerArrayWithAll;

/// 添加首页实务
-(BOOL)setLocalHomePracticeWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取首页实务
-(NSArray *)getLocalHomePracticeArrayWithUserId:(NSString *)userId;

/// 添加首页问答
-(BOOL)setLocalHomeQuestionWithArray:(NSArray *)array;
/// 获取首页问答
-(NSArray *)getLocalHomeQuestionArrayWithAll;

/// 添加首页订阅
-(BOOL)setLocalHomeSubscribeWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取首页订阅
-(NSArray *)getLocalHomeSubscribeArrayWithUserId:(NSString *)userId;

/// 添加首页实务分类
-(BOOL)setLocalPracticeTypeWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取首页实务分类
-(NSArray *)getLocalPracticeTypeArrayWithUserId:(NSString *)userId;

/// 添加分类下的实务
-(BOOL)setLocalPracticeWithArray:(NSArray *)array typeId:(NSString *)typeId userId:(NSString *)userId;
/// 获取分类下的实务
-(NSArray *)getLocalPracticeArrayWithUserId:(NSString *)userId typeId:(NSString *)typeId;

/// 设置订阅推荐
-(BOOL)setLocalSubscribeRecommendWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取订阅推荐
-(NSArray *)getLocalSubscribeRecommendArrayWithUserId:(NSString *)userId;

/// 设置订阅已定
-(BOOL)setLocalSubscribeAlreadyWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取订阅已定
-(NSArray *)getLocalSubscribeAlreadyArrayWithUserId:(NSString *)userId;

/// 设置订阅试读
-(BOOL)setLocalCurriculumProbationWithArray:(NSArray *)array subscribeId:(NSString *)subscribeId userId:(NSString *)userId;
/// 获取订阅试读
-(NSArray *)getLocalCurriculumProbationArrayWithUserId:(NSString *)userId subscribeId:(NSString *)subscribeId;

/// 设置订阅详情
-(BOOL)setLocalSubscribeDetailWithModel:(ModelSubscribeDetail *)model userId:(NSString *)userId;
/// 获取订阅详情
-(ModelSubscribeDetail *)getLocalSubscribeDetailWithUserId:(NSString *)userId subscribeId:(NSString *)subscribeId;

/// 设置每期看列表
-(BOOL)setLocalCurriculumEachWatchWithArray:(NSArray *)array subscribeId:(NSString *)subscribeId userId:(NSString *)userId;
/// 获取每期看列表
-(NSArray *)getLocalCurriculumEachWatchArrayWithSubscribeId:(NSString *)subscribeId userId:(NSString *)userId;

/// 设置连续播列表
-(BOOL)setLocalCurriculumContinuousSowingWithArray:(NSArray *)array subscribeId:(NSString *)subscribeId userId:(NSString *)userId;
/// 设置连续播列表
-(BOOL)setLocalCurriculumContinuousSowingWithModel:(ModelCurriculum *)model userId:(NSString *)userId;
/// 获取连续播列表
-(NSArray *)getLocalCurriculumContinuousSowingArrayWithSubscribeId:(NSString *)subscribeId userId:(NSString *)userId;
/// 获取连续播列表
-(ModelCurriculum *)getLocalCurriculumContinuousSowingModelWithCurriculumId:(NSString *)curriculumId userId:(NSString *)userId;

/// 设置发现实务分类
-(BOOL)setLocalFoundPracticeTypeWithArray:(NSArray *)array;
/// 获取发现实务分类
-(NSArray *)getLocalFoundPracticeTypeArrayWithAll;

/// 设置购买记录
-(BOOL)setLocalSubscribePlayWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取购买记录
-(NSArray *)getLocalSubscribePlayArrayWithUserId:(NSString *)userId;

/// 设置充值记录
-(BOOL)setLocalRechargeRecordWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取充值记录
-(NSArray *)getLocalRechargeRecordArrayWithUserId:(NSString *)userId;

/// 设置订单对象
-(BOOL)setLocalOrderDetailWithModel:(ModelOrderWT *)model userId:(NSString *)userId;
/// 修改多个订单状态
-(BOOL)updLocalOrderDetailWithOrderIds:(NSArray *)arrOrderId;
/// 获取订单详情
-(ModelOrderWT *)getLocalOrderDetailWithUserId:(NSString *)userId orderId:(NSString *)orderId;
/// 获取指定状态的订单集合
-(NSArray *)getLocalOrderDetailWithUserId:(NSString *)userId status:(int)status;

/// 设置精品问答
-(BOOL)setLocalBoutiqueQuestionWithArray:(NSArray *)array;
/// 获取精品问答
-(NSArray *)getLocalBoutiqueQuestionArrayWithAll;

/// 设置圈子推荐
-(BOOL)setLocalCircleHotQuestionWithArray:(NSArray *)array;
/// 获取圈子推荐
-(NSArray *)getLocalCircleHotQuestionArrayWithAll;

/// 设置圈子动态
-(BOOL)setLocalCircleDynamicQuestionWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取圈子动态
/// 获取圈子动态
-(NSArray *)getLocalCircleDynamicQuestionArrayWithUserId:(NSString *)userId;

/// 设置圈子最新
-(BOOL)setLocalCircleNewQuestionWithArray:(NSArray *)array;
/// 获取圈子最新
-(NSArray *)getLocalCircleNewQuestionArrayWithAll;

/// 添加任何实务列表下面的实务播放列表
-(BOOL)setLocalPlayListPracticeListWithArray:(NSArray *)array userId:(NSString *)userId;
/// 添加任何实务列表下面的实务播放列表
-(BOOL)setLocalPlayListPracticeListWithModel:(ModelPractice *)model userId:(NSString *)userId;
/// 获取任何实务列表下面的实务播放列表
-(NSArray *)getLocalPlayListPracticeListWithUserId:(NSString *)userId;

/// 添加发现下面的实务播放列表
-(BOOL)setLocalPlayListPracticeFoundWithArray:(NSArray *)array userId:(NSString *)userId;
/// 修改发现下面的实务播放列表
-(BOOL)setLocalPlayListPracticeFoundWithModel:(ModelPractice *)model userId:(NSString *)userId;
/// 获取发现下面的实务播放列表
-(NSArray *)getLocalPlayListPracticeFoundWithUserId:(NSString *)userId;

/// 添加订阅内容列表播放列表
-(BOOL)setLocalPlayListSubscribeCurriculumListWithArray:(NSArray *)array userId:(NSString *)userId;
/// 修改订阅内容列表播放列表
-(BOOL)setLocalPlayListSubscribeCurriculumListWithModel:(ModelCurriculum *)model userId:(NSString *)userId;
/// 获取订阅内容列表播放列表
-(NSArray *)getLocalPlayListSubscribeCurriculumListWithUserId:(NSString *)userId;


/**************************************2.1缓存**********************************************/

/// 添加音频下载
-(BOOL)addLocalDownloadAudioWithModel:(ModelAudio *)model userId:(NSString *)userId;
/// 删除音频下载
-(BOOL)delLocalDownloadAudioWithModel:(ModelAudio *)model userId:(NSString *)userId;
/// 删除音频下载
-(BOOL)delLocalDownloadAudioWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取下载完成音频列表
-(NSArray *)getLocalDownloadAudioEndWithUserId:(NSString *)userId type:(int)type pageNum:(int)pageNum;
/// 获取待下载音频列表
-(NSArray *)getLocalDownloadAudioWaitWithUserId:(NSString *)userId pageNum:(int)pageNum;
/// 获取音频对象
-(ModelAudio *)getLocalDownloadAudioWithUserId:(NSString *)userId ids:(NSString*)ids type:(int)type;

///检测是否存在下载对象
-(ModelAudio *)checkToDetectWhetherThereALocalDownload;
///检测对象是否下载完成
-(BOOL)checkLocalDownloadEndWithIds:(NSString *)ids userId:(NSString *)userId;

/// 获取最新的一个需要下载的音频对象
-(ModelAudio *)getLocalDownloadAudioWithUserId:(NSString *)userId;

///保存购物车实务集合
-(BOOL)setLocalPayCartPracticeWithArray:(NSArray *)arr userId:(NSString *)userId;
///获取购物车实务集合
-(NSArray *)getLocalPayCartPracticeArrayWithUserId:(NSString *)userId;

///保存已购实务集合
-(BOOL)setLocalPurchasePracticeWithArray:(NSArray *)arr userId:(NSString *)userId;
///获取已购实务集合
-(NSArray *)getLocalPurchasePracticeArrayWithUserId:(NSString *)userId;

/// 设置已购订阅集合
-(BOOL)setLocalPurchaseSubscribeWithArray:(NSArray *)array userId:(NSString *)userId;
/// 获取已购订阅集合
-(NSArray *)getLocalPurchaseSubscribeArrayWithUserId:(NSString *)userId;

///保存播放记录实务集合
-(BOOL)setLocalPlayrecordPracticeWithArray:(NSArray *)array;
///保存播放记录实务对象
-(BOOL)setLocalPlayrecordPracticeWithModel:(ModelPractice *)model;
///获取播放记录
-(NSArray *)getLocalPlayrecordPracticeArrayWithIds:(NSString *)ids;
/// 设置订阅播放记录
-(BOOL)setLocalPlayrecordSubscribeCurriculumWithArray:(NSArray *)array;
/// 获取订阅播放记录
-(NSArray *)getLocalPlayrecordSubscribeCurriculumArrayWithIds:(NSString *)ids;

@end

#define sqlite [SQLiteOper sharedSingleton]
