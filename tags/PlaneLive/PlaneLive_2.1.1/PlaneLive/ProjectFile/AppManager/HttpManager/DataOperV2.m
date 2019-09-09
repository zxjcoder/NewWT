//
//  DataOperV2.m
//  PlaneLive
//
//  Created by Daniel on 16/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataOperV2.h"

@implementation DataOperV2

static DataOperV2 *_dataOperV2Instance;

+ (DataOperV2 *)sharedSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataOperV2Instance = [[DataOperV2 alloc] init];
    });
    return _dataOperV2Instance;
}

#pragma mark - V2.0.0

/**
 *  获取首页数据
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getHomeDataWithResultBlock:(void(^)(NSArray *arrBanner, NSArray *arrPractice, NSArray *arrQuestion, NSArray *arrSubscribe, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/v2/speech/queryHomeData" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if ([arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                    }
                }
                NSArray *arrB = [result.body objectForKey:@"resultBanaer"];
                NSMutableArray *arrBanner = [NSMutableArray array];
                if ([arrB isKindOfClass:[NSArray class]] && arrB.count > 0) {
                    for (NSDictionary *dic in arrB) {
                        [arrBanner addObject:[[ModelBanner alloc] initWithCustom:dic]];
                    }
                }
                NSArray *arrQ = [result.body objectForKey:@"resultQuestion"];
                NSMutableArray *arrQuestion = [NSMutableArray array];
                if ([arrQ isKindOfClass:[NSArray class]] && arrQ.count > 0) {
                    for (NSDictionary *dic in arrQ) {
                        [arrQuestion addObject:[[ModelQuestionBoutique alloc] initWithCustom:dic]];
                    }
                }
                NSArray *arrA = [result.body objectForKey:@"resultCurriculum"];
                NSMutableArray *arrSubscribe = [NSMutableArray array];
                if ([arrA isKindOfClass:[NSArray class]] && arrA.count > 0) {
                    for (NSDictionary *dic in arrA) {
                        [arrSubscribe addObject:[[ModelSubscribe alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrBanner, arrResult, arrQuestion, arrSubscribe, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  首页搜索实务
 *
 *  @oaram param        关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getHomeSearchPracticeWithParam:(NSString *)param pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (param) {
        [dicParam setObject:param forKey:@"param"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/v2/speech/querySpeechData" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR && [arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  首页搜索订阅
 *
 *  @oaram param        关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getHomeSearchSubscribeWithParam:(NSString *)param pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (param) {
        [dicParam setObject:param forKey:@"param"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/course/queryCourseData" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelSubscribe alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取精品问答列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getBoutiqueQuestionAndAnswerWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/topQuestion/queryTopQuestion" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelQuestionBoutique alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取实务分类
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPracticeTypeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/v2/speech/querySpeechType" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPracticeType alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取实务分类下的实务列表
 *
 *  @param typeId       分类ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPracticeArrayWithTypeId:(NSString *)typeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (typeId) {
        [dicParam setObject:typeId forKey:@"typeId"];
    }
    [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/v2/speech/queryTypeSpeechData" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取订阅推荐列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeRecommendArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/course/queryCourseList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR && arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelSubscribe alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取订阅已订阅列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeAlreadyWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/course/queryCourseProbation" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelCurriculum alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}
/**
 *  获取订阅试读列表
 *
 *  @param subscribeId  课程ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeProbationWithSubscribeId:(NSString *)subscribeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (subscribeId) {
        [dicParam setObject:subscribeId forKey:@"id"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/course/getFreeRead" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelCurriculum alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取订阅详情
 *
 *  @param ids          订阅课程ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeRecommendArrayWithSubscribeId:(NSString *)ids resultBlock:(void(^)(ModelSubscribeDetail *model, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (ids) {
        [dicParam setObject:ids forKey:@"id"];
    }
    [self postJsonWithAction:@"share/course/queryCourseInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                ModelSubscribeDetail *model = nil;
                NSDictionary *dicR = [result.body objectForKey:kResultKey];
                if (dicR && [dicR isKindOfClass:[NSDictionary class]]) {
                    model = [[ModelSubscribeDetail alloc] initWithCustom:dicR];
                }
                GCDMainBlock(^{
                    resultBlock(model, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  生成订单-立即购买
 *
 *  @param money        金额
 *  @param type         订单类型 0：充值 1：订阅 2：实务
 *  @param objid        支付对象Id type类型为0可不传
 *  @param title        消费标题 type类型为0可不传
 *  @param payType      支付类型 0：苹果 1：微信 2：支付宝 3：余额
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 *  @param balanceBlock 余额不足回调
 */
-(void)getGenerateOrderWithMoney:(NSString *)money type:(int)type objid:(NSString *)objid title:(NSString *)title payType:(WTPayWayType)payType resultBlock:(void(^)(ModelOrderWT *model, id resultThree, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock balanceBlock:(void(^)(NSString *msg))balanceBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (money) {
        [dicParam setObject:money forKey:@"money"];
    }
    [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    if (objid) {
        [dicParam setObject:objid forKey:@"objid"];
    }
    if (title) {
        [dicParam setObject:title forKey:@"title"];
    }
    [dicParam setObject:[NSNumber numberWithInteger:payType] forKey:@"payType"];
    
    [self postJsonWithAction:@"share/userPay/userPay" postParam:dicParam postFile:nil serverType:WTServerTypeEncrypt resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                ModelOrderWT *model = nil;
                NSDictionary *dicR = [result.body objectForKey:kResultKey];
                if (dicR && [dicR isKindOfClass:[NSDictionary class]]) {
                    model = [[ModelOrderWT alloc] initWithCustom:dicR];
                }
                id resultThree = [result.body objectForKey:@"resultThree"];
                GCDMainBlock(^{
                    resultBlock(model, resultThree, result.body);
                });
            }
        } else {
            if (result.code == kSNS_RETURN_NOTBALANCE) {
                if (balanceBlock) {
                    balanceBlock(kSNS_RETURN_NOTBALANCE_Text);
                }
            } else {
                if (errorBlock) {
                    GCDMainBlock(^{
                        errorBlock(result.msg);
                    });
                }
            }
        }
    }];
}

/**
 *  修改单个订单状态
 *
 *  @param orderId      订单ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)updOrderStateWithOrderId:(NSString *)orderId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (orderId) {
        [dicParam setObject:orderId forKey:@"orderNo"];
    }
    [self postJsonWithAction:@"share/userPay/modifyOrder" postParam:dicParam postFile:nil serverType:WTServerTypeEncrypt resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  修改多个订单状态
 *
 *  @param orderIds     订单ID集合
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)updOrderStateWithOrderIds:(NSArray *)orderIds resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        if (orderIds) {
            [dicParam setObject:orderIds forKey:@"orderNos"];
        }
        [self postJsonWithAction:@"share/userPay/modifyOrders" postParam:dicParam postFile:nil serverType:WTServerTypeEncrypt resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    GCDMainBlock(^{
                        resultBlock(result.body);
                    });
                }
            } else {
                if (errorBlock) {
                    GCDMainBlock(^{
                        errorBlock(result.msg);
                    });
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            GCDMainBlock(^{
                errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
            });
        }
    }
}

/**
 *  获取我的余额
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMyBalanceWithResultBlock:(void(^)(NSString *balance, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    [self postJsonWithAction:@"share/userPay/getMyBalance" postParam:nil postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock([result.body objectForKey:kResultKey], result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  发现--获取语音类型
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getFoundPracticeTypeWithResultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    [self postJsonWithAction:@"share/find/getSpeechType" postParam:nil postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPracticeType alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  发现--点击分类进入音频播放
 *
 *  @param practiceTypeId   分类ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getFoundPracticeArrayWithPracticeTypeId:(NSString *)practiceTypeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (practiceTypeId) {
        [dicParam setObject:practiceTypeId forKey:@"id"];
    }
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/find/getAudio" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  我的--已支付--已购买【用户订阅记录】
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMySubscribePlayArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/userPay/alreadyBoughtList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelSubscribePlay alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  我的--已支付--充值【用户充值记录】
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMyRechargeRecordArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/userPay/rechargeList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelRechargeRecord alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取订阅每期看和连续播的列表
 *
 *  @param subscribeId  课程ID
 *  @param type         0每期看 1连续播
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getCurriculumArrayWithSubscribeId:(NSString *)subscribeId type:(int)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (subscribeId) {
        [dicParam setObject:subscribeId forKey:@"id"];
    }
    [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/course/courseContentPage" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR && [arrR isKindOfClass:[NSArray class]] && arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelCurriculum alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}
/**
 *  获取试读和阅读WebUrl地址
 *
 *  @param curriculumId 每期内容的ID
 *  @param subscribeId  课程ID
 *  @param type         1试读 2阅读
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getCurriculumDetailWebUrlWithCurriculumId:(NSString *)curriculumId subscribeId:(NSString *)subscribeId type:(int)type resultBlock:(void(^)(NSString *webUrl, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (subscribeId) {
        [dicParam setObject:subscribeId forKey:@"id"];
    }
    if (curriculumId) {
        [dicParam setObject:curriculumId forKey:@"cid"];
    }
    [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    
    [self postJsonWithAction:@"share/course/getCourseUrl" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock([result.body objectForKey:kResultKey], result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  圈子推荐
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleRemdListWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/remd/getRecommend" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSArray *arrR = [result.body objectForKey:kResultKey];
                NSMutableArray *arrResult = [NSMutableArray array];
                if (arrR.count > 0) {
                    for (NSDictionary *dic in arrR) {
                        [arrResult addObject:[[ModelCircleHot alloc] initWithCustom:dic]];
                    }
                }
                GCDMainBlock(^{
                    resultBlock(arrResult, result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

#pragma mark - V2.1.0

/**
 *  修改个人资料接口
 *
 *  @param model       用户对象
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postUpdateUserInfoWithModel:(ModelUser *)model resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (model.account) {
        [dicParam setObject:model.account forKey:@"userId"];
    }
    if (model.nickname) {
        [dicParam setObject:model.nickname forKey:@"nickname"];
    }
    if (model.sign) {
        [dicParam setObject:model.sign forKey:@"signature"];
    }
    [dicParam setObject:[NSNumber numberWithInteger:model.sex] forKey:@"sex"];
    if (model.trade) {
        [dicParam setObject:model.trade forKey:@"trade"];
    }
    if (model.company) {
        [dicParam setObject:model.company forKey:@"company"];
    }
    if (model.birthday) {
        [dicParam setObject:model.birthday forKey:@"dateOfBirth"];
    }
    if (model.education) {
        [dicParam setObject:model.education forKey:@"education"];
    }
    if (model.joinTime) {
        [dicParam setObject:model.joinTime forKey:@"entryTime"];
    }
    if (model.address) {
        [dicParam setObject:model.address forKey:@"address"];
    }
    NSString *headImgPath = model.head_img.length == 0 ? kEmpty : model.head_img;
    
    [self postJsonWithAction:@"share/user/updateMyInfo" postParam:dicParam postFile:@[headImgPath] resultBlock:^(Response *result) {
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
}

/**
 *  加入购物车
 *
 *  @param ids          实务ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postJoinPracticeToCartWithPracticeIds:(NSString *)ids resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (ids) {
        [dicParam setObject:ids forKey:@"id"];
    }
    [self postJsonWithAction:@"share/v2/cart/add" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  删除购物车
 *
 *  @param ids          实务ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postRemovePracticeByCartWithPracticeIds:(NSString *)ids resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (ids) {
        [dicParam setObject:ids forKey:@"id"];
    }
    [self postJsonWithAction:@"share/v2/cart/del" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取购物车列表
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPayCartPracticeArrayResultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    @try {
        NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
        [dicParam setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
        [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
        
        [self postJsonWithAction:@"share/v2/cart/cartList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
            if (result.success) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in arrR) {
                            [arrResult addObject:[[ModelPayCart alloc] initWithCustom:dic]];
                        }
                    }
                    GCDMainBlock(^{
                        resultBlock(arrResult, result.body);
                    });
                }
            } else {
                if (errorBlock) {
                    GCDMainBlock(^{
                        errorBlock(result.msg);
                    });
                }
            }
        }];
    } @catch (NSException *exception) {
        if (errorBlock) {
            GCDMainBlock(^{
                errorBlock(kSNS_RETURN_SERVER_DATA_ERROR_Text);
            });
        }
    }
}

/**
 *  生成订单-结算购物车
 *
 *  @param money        金额
 *  @param type         订单类型 0：充值 1：订阅 2：实务
 *  @param objid        支付对象Id type类型为0可不传
 *  @param title        消费标题 type类型为0可不传
 *  @param payType      支付类型 0：苹果 1：微信 2：支付宝 3：余额
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 *  @param balanceBlock 余额不足回调
 */
-(void)getGenerateOrderClearingWithMoney:(NSString *)money type:(int)type objid:(NSString *)objid title:(NSString *)title payType:(WTPayWayType)payType resultBlock:(void(^)(ModelOrderWT *model, id resultThree, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock balanceBlock:(void(^)(NSString *msg))balanceBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (money) {
        [dicParam setObject:money forKey:@"money"];
    }
    [dicParam setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    if (objid) {
        [dicParam setObject:objid forKey:@"objid"];
    }
    if (title) {
        [dicParam setObject:title forKey:@"title"];
    }
    [dicParam setObject:[NSNumber numberWithInteger:payType] forKey:@"payType"];
    
    [self postJsonWithAction:@"share/v2/cart/checkOut" postParam:dicParam postFile:nil serverType:WTServerTypeEncrypt resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                ModelOrderWT *model = nil;
                NSDictionary *dicR = [result.body objectForKey:kResultKey];
                if (dicR && [dicR isKindOfClass:[NSDictionary class]]) {
                    model = [[ModelOrderWT alloc] initWithCustom:dicR];
                }
                id resultThree = [result.body objectForKey:@"resultThree"];
                GCDMainBlock(^{
                    resultBlock(model, resultThree, result.body);
                });
            }
        } else {
            if (result.code == kSNS_RETURN_NOTBALANCE) {
                if (balanceBlock) {
                    GCDMainBlock(^{
                        balanceBlock(kSNS_RETURN_NOTBALANCE_Text);
                    });
                }
            } else {
                if (errorBlock) {
                    GCDMainBlock(^{
                        errorBlock(result.msg);
                    });
                }
            }
        }
    }];
}

/**
 *  添加留言
 *
 *  @param content      留言内容
 *  @param cid          课程内容ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postAddMessageContentWithSubscribe:(NSString *)content cId:(NSString *)cid resultBlock:(void(^)(NSString *messageId, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (content) {
        [dicParam setObject:content forKey:@"message"];
    }
    if (cid) {
        [dicParam setObject:cid forKey:@"cId"];
    }
    [self postJsonWithAction:@"share/v2/message/addMessage" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock([result.body objectForKey:kResultKey], result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  删除留言
 *
 *  @param messageId    留言ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postDelMessageContentWithMessageId:(NSString *)messageId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (messageId) {
        [dicParam setObject:messageId forKey:@"mId"];
    }
    [self postJsonWithAction:@"share/v2/message/delMessage" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  留言点赞
 *
 *  @param messageId    留言ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postMessagePraiseWithMessageId:(NSString *)messageId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (messageId) {
        [dicParam setObject:messageId forKey:@"id"];
    }
    [self postJsonWithAction:@"share/v2/message/addApplaud" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  留言取消点赞
 *
 *  @param messageId    留言ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postMessageUnPraiseWithMessageId:(NSString *)messageId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (messageId) {
        [dicParam setObject:messageId forKey:@"id"];
    }
    [self postJsonWithAction:@"share/v2/message/cancelMessage" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  获取实务[语音]详情
 *
 *  @param practiceId   实务ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getPracticeDetailWithPracticeId:(NSString *)practiceId resultBlock:(void(^)(ModelPractice *resultModel))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (practiceId) {
        [dicParam setObject:practiceId forKey:@"id"];
    }
    [self postJsonWithAction:@"share/v2/speech/querySpeechInfo" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                NSDictionary *dic = [result.body objectForKey:kResultKey];
                if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                    ModelPractice *model = [[ModelPractice alloc] initWithCustom:dic];
                    if (resultBlock) {
                        GCDMainBlock(^{
                            resultBlock(model);
                        });
                    }
                } else {
                    if (resultBlock) {
                        GCDMainBlock(^{
                            resultBlock(nil);
                        });
                    }
                }
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  我的已购-购买实务列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPurchasePracticeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/userPay/purchaseSpeechList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in arrR) {
                            [arrResult addObject:[[ModelPractice alloc] initWithCustom:dic]];
                        }
                    }
                    GCDMainBlock(^{
                        resultBlock(arrResult, result.body);
                    });
                }
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  我的已购-购买订阅列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPurchaseSubscribeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    [dicParam setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [dicParam setObject:[NSNumber numberWithInt:kPAGE_MAXCOUNT] forKey:@"pageSize"];
    
    [self postJsonWithAction:@"share/userPay/purchaseCourseList" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                if (resultBlock) {
                    NSArray *arrR = [result.body objectForKey:kResultKey];
                    NSMutableArray *arrResult = [NSMutableArray array];
                    if (arrR && [arrR isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in arrR) {
                            [arrResult addObject:[[ModelSubscribe alloc] initWithCustom:dic]];
                        }
                    }
                    GCDMainBlock(^{
                        resultBlock(arrResult, result.body);
                    });
                }
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  意见反馈
 *
 *  @param content      反馈的内容
 *  @param imageArray   图片集合
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postFeekbackWithContent:(NSString *)content imageArray:(NSArray *)imageArray resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (content) {
        [dicParam setObject:content forKey:@"content"];
    }
    NSArray *arrImage = [NSArray array];
    if (imageArray && [imageArray isKindOfClass:[NSArray class]]) {
        arrImage = [NSArray arrayWithArray:imageArray];
    }
    [dicParam setObject:[NSNumber numberWithInteger:arrImage.count] forKey:@"imgCount"];
    if (arrImage.count == 0) {
        arrImage = @[kEmpty];
    }
    [self postJsonWithAction:@"share/v2/account/uploadFeedbackImg" postParam:dicParam postFile:arrImage resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  绑定手机号
 *
 *  @param phone        手机号
 *  @param password     设置密码
 *  @param valiCode     验证码
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postBindMobileNumberWithMobile:(NSString *)phone password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (phone) {
        [dicParam setObject:phone forKey:@"mobile"];
    }
    if (password) {
        [dicParam setObject:[Utils stringMD5:password] forKey:@"password"];
    }
    if (valiCode) {
        [dicParam setObject:valiCode forKey:@"valiCode"];
    }
    [self postJsonWithAction:@"share/v2/account/bindingMobile" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  更换手机号码
 *
 *  @param phone        手机号
 *  @param password     设置密码
 *  @param valiCode     验证码
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postChangeMobileNumberWithMobile:(NSString *)phone password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (phone) {
        [dicParam setObject:phone forKey:@"mobile"];
    }
    if (password) {
        [dicParam setObject:[Utils stringMD5:password] forKey:@"password"];
    }
    if (valiCode) {
        [dicParam setObject:valiCode forKey:@"valiCode"];
    }
    [self postJsonWithAction:@"share/v2/account/changeMobile" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  验证手机号码
 *
 *  @param phone        手机号
 *  @param valiCode     验证码
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postCheckMobileNumberWithMobile:(NSString *)phone valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (phone) {
        [dicParam setObject:phone forKey:@"mobile"];
    }
    if (valiCode) {
        [dicParam setObject:valiCode forKey:@"valiCode"];
    }
    [self postJsonWithAction:@"share/v2/account/checkMobile" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  绑定微信
 *
 *  @param uniqueCode   微信唯一标示
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postBindWeChatWithUniqueCode:(NSString *)uniqueCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (uniqueCode) {
        [dicParam setObject:uniqueCode forKey:@"uniqueCode"];
    }
    [self postJsonWithAction:@"share/v2/account/bindingWechat" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  解除微信绑定
 *
 *  @param uniqueCode   微信唯一标示
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postUnBindWeChatWithUniqueCode:(NSString *)uniqueCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (uniqueCode) {
        [dicParam setObject:uniqueCode forKey:@"uniqueCode"];
    }
    [self postJsonWithAction:@"share/v2/account/unbindingWechat" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

/**
 *  解除手机号绑定
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postUnBindMobileWithMobile:(NSString *)phone valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock
{
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    if (phone) {
        [dicParam setObject:phone forKey:@"mobile"];
    }
    if (valiCode) {
        [dicParam setObject:valiCode forKey:@"valiCode"];
    }
    [self postJsonWithAction:@"share/v2/account/unbindingMobile" postParam:dicParam postFile:nil resultBlock:^(Response *result) {
        if (result.success) {
            if (resultBlock) {
                GCDMainBlock(^{
                    resultBlock(result.body);
                });
            }
        } else {
            if (errorBlock) {
                GCDMainBlock(^{
                    errorBlock(result.msg);
                });
            }
        }
    }];
}

@end
