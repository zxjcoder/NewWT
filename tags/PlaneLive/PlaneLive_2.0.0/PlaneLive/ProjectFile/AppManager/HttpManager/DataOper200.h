//
//  DataOper200.h
//  PlaneLive
//
//  Created by Daniel on 9/27/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataHelper.h"

@interface DataOper200 : DataHelper

/**
 *  获取首页数据
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getHomeDataWithResultBlock:(void(^)(NSArray *arrBanner, NSArray *arrPractice, NSArray *arrQuestion, NSArray *arrSubscribe, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  首页搜索实务
 *
 *  @oaram param        关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getHomeSearchPracticeWithParam:(NSString *)param pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  首页搜索订阅
 *
 *  @oaram param        关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getHomeSearchSubscribeWithParam:(NSString *)param pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取精品问答列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getBoutiqueQuestionAndAnswerWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取实务分类
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getPracticeTypeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取实务分类下的实务列表
 *
 *  @param typeId       分类ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getPracticeArrayWithTypeId:(NSString *)typeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅推荐列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getSubscribeRecommendArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅已订阅列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getSubscribeAlreadyWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅试读列表
 *
 *  @param subscribeId  课程ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getSubscribeProbationWithSubscribeId:(NSString *)subscribeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅详情
 *
 *  @param ids          订阅课程ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getSubscribeRecommendArrayWithSubscribeId:(NSString *)ids resultBlock:(void(^)(ModelSubscribeDetail *model, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  生成订单
 *
 *  @param money        金额
 *  @param type         订单类型 0：充值 1：订阅 1：实务
 *  @param objid        支付对象Id type类型为0可不传
 *  @param title        消费标题 type类型为0可不传
 *  @param payType      支付类型 0：苹果 1：微信 2：支付宝 3：余额
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 *  @param balanceBlock 余额不足回调
 */
+(void)getGenerateOrderWithMoney:(NSString *)money type:(int)type objid:(NSString *)objid title:(NSString *)title payType:(WTPayWayType)payType resultBlock:(void(^)(ModelOrderWT *model, id resultThree, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock balanceBlock:(void(^)(NSString *msg))balanceBlock;

/**
 *  修改订单状态
 *
 *  @param orderId      订单ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)updOrderStateWithOrderId:(NSString *)orderId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  修改多个订单状态
 *
 *  @param orderIds     订单ID集合
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)updOrderStateWithOrderIds:(NSArray *)orderIds resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的余额
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getMyBalanceWithResultBlock:(void(^)(NSString *balance, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  发现--获取语音类型
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getFoundPracticeTypeWithResultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  发现--点击分类进入音频播放
 *
 *  @param practiceTypeId   分类ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getFoundPracticeArrayWithPracticeTypeId:(NSString *)practiceTypeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的--已支付--已购买【用户订阅记录】
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getMySubscribePlayArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的--已支付--充值【用户充值记录】
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getMyRechargeRecordArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅每期看和连续播的列表
 *
 *  @param subscribeId  课程ID
 *  @param curriculumId 每期内容的ID
 *  @param type         0每期看 1连续播
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getCurriculumArrayWithSubscribeId:(NSString *)subscribeId curriculumId:(NSString *)curriculumId type:(int)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取试读和阅读WebUrl地址
 *
 *  @param curriculumId 每期内容的ID
 *  @param subscribeId  课程ID
 *  @param type         1试读 2阅读
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
+(void)getCurriculumDetailWebUrlWithCurriculumId:(NSString *)curriculumId subscribeId:(NSString *)subscribeId type:(int)type resultBlock:(void(^)(NSString *webUrl, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  圈子推荐
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
+(void)getCircleRemdListWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

@end
