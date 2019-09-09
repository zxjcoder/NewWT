//
//  DataOper140.m
//  PlaneCircle
//
//  Created by Daniel on 9/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataOper140.h"

@implementation DataOper140

/**
 *  获取话题语音
 *
 *  @param topicId      话题ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getTopicPracticeArrayWithTopicId:(NSString *)topicId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (topicId) {
            [dicParam setObject:topicId forKey:@"id"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/article/getArticleSpeech" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrR.count > 0) {
                        for (NSDictionary *dic in arrR) {
                            [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                        }
                    }
                    resultBlock(arrResult, result.body);
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
 *  话题详情
 *
 *  @param userId       用户ID
 *  @param aid          话题ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getTopicDetailWithTopicId:(NSString *)aid userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        if (aid) {
            [dicParam setObject:aid forKey:@"aid"];
        }
        [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/search/getArtDetails" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrList = [result.body objectForKey:kQuestionAllKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrList && [arrList isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in arrList) {
                            ModelQuestionTopic *model = [[ModelQuestionTopic alloc] initWithCustom:dic];
                            [arrResult addObject:model];
                        }
                    }
                    ModelTag *modelTag = nil;
                    NSDictionary *dicTopic = [result.body objectForKey:kTagKey];
                    if (dicTopic && [dicTopic isKindOfClass:[NSDictionary class]]) {
                        BOOL isAtt = [[result.body objectForKey:@"flag"] boolValue];
                        modelTag = [[ModelTag alloc] initWithCustom:dicTopic];
                        [modelTag setIsAtt:isAtt];
                    }
                    resultBlock(arrResult, modelTag, result.body);
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
 *  查询我的任务
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)getMyTaskArrayWithUserId:(NSString *)userId resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/task/queryTask" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:@"resultTask"];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrR.count > 0) {
                        for (NSDictionary *dic in arrR) {
                            [arrResult addObject:[[ModelTask alloc] initWithCustom:dic]];
                        }
                    }
                    resultBlock(arrResult, result.body);
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
 *  完成我的任务
 *
 *  @param userId       用户ID
 *  @param taskId       任务ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)updMyTaskWithUserId:(NSString *)userId taskId:(NSString *)taskId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (taskId) {
            [dicParam setObject:taskId forKey:@"taskId"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        
        [self postJsonWithAction:@"share/task/updUserTask" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
 *  删除我的任务
 *
 *  @param userId       用户ID
 *  @param taskId       任务ID
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)delMyTaskWithUserId:(NSString *)userId taskId:(NSString *)taskId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (taskId) {
            [dicParam setObject:taskId forKey:@"taskId"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        
        [self postJsonWithAction:@"share/task/delTask" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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
 *  接受任务
 *
 *  @param userId       用户ID
 *  @param speechId     实务iD
 *  @param pageNum      当前第几页
 *  @result resultBlock 成功回调
 *  @result errorBlock  错误回调
 */
+(void)acceptMyTaskWithUserId:(NSString *)userId speechId:(NSString *)speechId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (speechId) {
            [dicParam setObject:speechId forKey:@"speechId"];
        }
        if (userId) {
            [dicParam setObject:userId forKey:@"userId"];
        }
        
        [self postJsonWithAction:@"share/task/saveTask" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
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

@end
