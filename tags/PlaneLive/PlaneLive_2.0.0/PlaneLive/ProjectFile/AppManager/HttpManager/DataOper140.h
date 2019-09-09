//
//  DataOper140.h
//  PlaneCircle
//
//  Created by Daniel on 9/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataHelper.h"

///1.4.0版本接口
@interface DataOper140 : DataHelper

/**
 *  获取话题语音
 *
 *  @param topicId      话题ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getTopicPracticeArrayWithTopicId:(NSString *)topicId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  话题详情
 *
 *  @param userId       用户ID
 *  @param aid          话题ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getTopicDetailWithTopicId:(NSString *)aid userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  查询我的任务
 *
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getMyTaskArrayWithUserId:(NSString *)userId resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  完成我的任务
 *
 *  @param userId       用户ID
 *  @param taskId       任务ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)updMyTaskWithUserId:(NSString *)userId taskId:(NSString *)taskId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除我的任务
 *
 *  @param userId       用户ID
 *  @param taskId       任务ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)delMyTaskWithUserId:(NSString *)userId taskId:(NSString *)taskId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  接受任务
 *
 *  @param userId       用户ID
 *  @param speechId     实务ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)acceptMyTaskWithUserId:(NSString *)userId speechId:(NSString *)speechId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

@end
