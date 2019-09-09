//
//  DataOper130.h
//  PlaneCircle
//
//  Created by Daniel on 8/30/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataHelper.h"

///1.3.0版本接口
@interface DataOper130 : DataHelper

/*************************************1.3.0版本新增接口*****************************************/

/**
 *  获取实务[语音]详情
 *
 *  @param practiceId   实务ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getPracticeDetailWithPracticeId:(NSString *)practiceId userId:(NSString*)userId resultBlock:(void(^)(ModelPractice *resultModel))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  实务详情获取问题列表接口
 *
 *  @param practiceId   实务ID
 *  @param type         问题分类
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getPracticeQuestionArrayWithPracticeId:(NSString *)practiceId type:(ZPracticeQuestionType)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, int pageSizeHot, NSInteger questionCount))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的评论列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getMyCommentArrayWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  对评论进行回复
 *
 *  @param userId       用户ID
 *  @param content      回复内容
 *  @param replyUserId  回复的那个用户id
 *  @param commentId    评论id
 *  @param parent_id    一级为0下面的所有未一级的id
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)postCommentReplyWithUserId:(NSString *)userId content:(NSString*)content replyUserId:(NSString*)replyUserId commentId:(NSString*)commentId parent_id:(NSString*)parent_id resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除评论和回复
 *
 *  @param userId       用户ID
 *  @param ids          评论ID或回复id
 *  @param type         0：评论 1：回复
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)postCommentReplyWithUserId:(NSString *)userId ids:(NSString*)ids type:(int)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  实务-发布问题
 *
 *  @param userId       用户ID
 *  @param question     问题标题
 *  @param quizDetail   问题描述
 *  @param articles     话题列表
 *  @param speechId     实务ID
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)postCirclePublishQuestionWithUserId:(NSString *)userId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles speechId:(NSString*)speechId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  答案详情
 *
 *  @param userId       用户ID
 *  @param answerId     回答ID
 *  @param commentId    默认查询的评论ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId commentId:(NSString *)commentId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrComment, ModelAnswerBase *modelAnswer, ModelAnswerComment *modelDefaultComment, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

@end
