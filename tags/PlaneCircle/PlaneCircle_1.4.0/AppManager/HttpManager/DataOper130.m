//
//  DataOper130.m
//  PlaneCircle
//
//  Created by Daniel on 8/30/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataOper130.h"

@implementation DataOper130

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
+(void)getPracticeDetailWithPracticeId:(NSString *)practiceId userId:(NSString*)userId resultBlock:(void(^)(ModelPractice *resultModel))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (practiceId) {
            [dicParam setObject:practiceId forKey:@"id"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/speech/querySpeechInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSDictionary *dic = [result.body objectForKey:kResultKey];
                    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dicResult = [NSMutableDictionary dictionaryWithDictionary:dic];
                        
                        NSString *resultCollect = [result.body objectForKey:@"resultCollect"];
                        if (resultCollect && ![resultCollect isKindOfClass:[NSNull class]]) {
                            [dicResult setObject:resultCollect forKey:@"resultCollect"];
                        }
                        NSString *resultApplaud = [result.body objectForKey:@"resultApplaud"];
                        if (resultApplaud && ![resultApplaud isKindOfClass:[NSNull class]]) {
                            [dicResult setObject:resultApplaud forKey:@"resultApplaud"];
                        }
                        ModelPractice *model = [[ModelPractice alloc] initWithCustom:dicResult];
                        resultBlock(model);
                    } else {
                        resultBlock(nil);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  实务详情获取问题列表接口
 *
 *  @param practiceId   实务ID
 *  @param type         问题分类
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getPracticeQuestionArrayWithPracticeId:(NSString *)practiceId type:(ZPracticeQuestionType)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, int pageSizeHot, NSInteger questionCount))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (practiceId) {
            [dicParam setObject:practiceId forKey:@"speechId"];
        }
        [dicParam setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
        switch (type) {
            case ZPracticeQuestionTypeHot: [dicParam setObject:[NSNumber numberWithInt:0] forKey:@"pageSize"]; break;
            default: [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"]; break;
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        
        [self postJsonWithAction:@"share/speech/querySpeechQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrR.count > 0) {
                        for (NSDictionary *dic in arrR) {
                            [arrResult addObject:[[ModelPracticeQuestion alloc] initWithCustom:dic]];
                        }
                    }
                    NSString *resultSize = [result.body objectForKey:@"resultSize"];
                    NSString *resultQuestionCount = [result.body objectForKey:@"resultQuestionCount"];
                    resultBlock(arrResult, [resultSize intValue], [resultQuestionCount integerValue]);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  获取我的评论列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getMyCommentArrayWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/user/myAnswerComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    if (arrR.count > 0) {
                        NSMutableArray *arr = [NSMutableArray array];
                        for (NSDictionary *dic in arrR) {
                            [arr addObject:[[ModelQuestionMyAnswerComment alloc] initWithCustom:dic]];
                        }
                        resultBlock(arr, result.body);
                    } else {
                        resultBlock(nil, result.body);
                    }
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

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
+(void)postCommentReplyWithUserId:(NSString *)userId content:(NSString*)content replyUserId:(NSString*)replyUserId commentId:(NSString*)commentId parent_id:(NSString*)parent_id resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (content) {
            [dicParam setObject:content forKey:@"content"];
        }
        if (replyUserId) {
            [dicParam setObject:replyUserId forKey:@"replyUserId"];
        }
        if (commentId) {
            [dicParam setObject:commentId forKey:@"commentId"];
        }
        if (parent_id) {
            [dicParam setObject:parent_id forKey:@"parent_id"];
        }
        
        [self postJsonWithAction:@"share/commentReply/saveCommentReply" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

/**
 *  删除评论和回复
 *
 *  @param userId       用户ID
 *  @param ids          评论ID或回复id
 *  @param type         0：评论 1：回复
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)postCommentReplyWithUserId:(NSString *)userId ids:(NSString*)ids type:(int)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (ids) {
            [dicParam setObject:ids forKey:@"id"];
        }
        [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
        
        [self postJsonWithAction:@"share/commentReply/delComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

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
+(void)postCirclePublishQuestionWithUserId:(NSString *)userId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles speechId:(NSString*)speechId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (question) {
            [dicParam setObject:question forKey:@"question"];
        }
        if (quizDetail) {
            [dicParam setObject:quizDetail forKey:@"quizDetail"];
        }
        if (articles) {
            [dicParam setObject:articles forKey:@"articles"];
        }
        if (speechId) {
            [dicParam setObject:speechId forKey:@"speechId"];
        }
        
        [self postJsonWithAction:@"share/speech/saveQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    resultBlock(result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

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
+(void)getAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId commentId:(NSString *)commentId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrComment, ModelAnswerBase *modelAnswer, ModelAnswerComment *modelDefaultComment, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (answerId) {
            [dicParam setObject:answerId forKey:@"answerId"];
        }
        if (commentId) {
            [dicParam setObject:commentId forKey:@"commentId"];
        } else {
            [dicParam setObject:@"0" forKey:@"commentId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/question/getComment" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    //问题对象
                    ModelAnswerBase *resultAnswer = nil;
                    NSDictionary *dicAnswer = [result.body objectForKey:@"resultAnswer"];
                    if (dicAnswer && [dicAnswer isKindOfClass:[NSDictionary class]]) {
                        resultAnswer = [[ModelAnswerBase alloc] initWithCustom:dicAnswer];
                        //评论数
                        NSString *resultComCount = [result.body objectForKey:@"resultComCount"];
                        //是否被点赞 1:是 0：否
                        NSString *resultAld = [result.body objectForKey:@"resultAld"];
                        //是否被举报 1:是0否
                        NSString *resultRpt = [result.body objectForKey:@"resultRpt"];
                        //是否已经收藏 1收藏0未收藏
//                        NSString *resultAns = [result.body objectForKey:@"resultAns"];
//                        [resultAnswer setIsCollection:[resultAns intValue]];
                        [resultAnswer setCommentCount:[resultComCount integerValue]];
                        [resultAnswer setIsAgree:[resultAld intValue]];
                        [resultAnswer setIsRept:[resultRpt intValue]];
                    }
                    //评论列表
                    NSArray *arrResult = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResultComment = [NSMutableArray array];
                    if (arrResult && [arrResult isKindOfClass:[NSArray class]] && arrResult.count > 0) {
                        if (arrResult) {
                            for (NSDictionary *dic in arrResult) {
                                [arrResultComment addObject:[[ModelAnswerComment alloc] initWithCustom:dic]];
                            }
                        }
                    }
                    //默认选中评论对象
                    ModelAnswerComment *resultDefaultComment = nil;
                    NSDictionary *dicDefaultComment = [result.body objectForKey:@"resultComment"];
                    if (dicDefaultComment && [dicDefaultComment isKindOfClass:[NSDictionary class]]) {
                        resultDefaultComment = [[ModelAnswerComment alloc] initWithCustom:dicDefaultComment];
                    }
                    ///组装答案详情数据
                    if (resultAnswer) {
                        if (arrResultComment) {
                            resultAnswer.commentArray = [NSArray arrayWithArray:arrResultComment];
                        }
                        resultAnswer.modelDefaultComment = resultDefaultComment;
                    }
                    resultBlock(arrResultComment, resultAnswer, resultDefaultComment, result.body);
                }
            } else {
                if (errorBlock) {
                    errorBlock(result.msg);
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
        }
    }
}

@end
