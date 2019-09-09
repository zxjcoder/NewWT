//
//  DataOperV2.h
//  PlaneLive
//
//  Created by Daniel on 16/11/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataHelper.h"

@interface DataOperV2 : DataHelper

///单例模式
+ (DataOperV2 *)sharedSingleton;

#pragma mark - V2.0.0

/**
 *  获取首页数据
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getHomeDataWithResultBlock:(void(^)(NSArray *arrBanner, NSArray *arrPractice, NSArray *arrLawFirm, NSArray *arrQuestion, NSArray *arrSubscribe, NSArray *arrCurriculum, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  首页搜索微课
 *
 *  @oaram param        关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getHomeSearchPracticeWithParam:(NSString *)param pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  首页搜索订阅
 *
 *  @oaram param        关键字
 *  @param pageNum      当前第几页
 *  @param isSeries     是否是系列课
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getHomeSearchSubscribeWithParam:(NSString *)param pageNum:(int)pageNum isSeries:(BOOL)isSeries resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取精品问答列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getBoutiqueQuestionAndAnswerWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取微课分类
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPracticeTypeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取微课分类下搜索微课列表
 *
 *  @param param        搜索关键字
 *  @param pageNum      当前第几页
 *  @param sort         排序字段
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPracticeTypePracticeArrayWithParam:(NSString *)param pageNum:(int)pageNum sort:(ZPracticeTypeSort)sort resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取微课分类下的微课列表
 *
 *  @param typeId       分类ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPracticeArrayWithTypeId:(NSString *)typeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅推荐列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeRecommendArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅已订阅列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeAlreadyWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅试读列表
 *
 *  @param subscribeId  课程ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeProbationWithSubscribeId:(NSString *)subscribeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅详情
 *
 *  @param ids          订阅课程ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeRecommendArrayWithSubscribeId:(NSString *)ids resultBlock:(void(^)(ModelSubscribeDetail *model, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  生成订单-立即购买
 *
 *  @param money        金额
 *  @param type         订单类型 0：充值 1：订阅 2：微课 3:打赏微课 4:打赏订阅
 *  @param objid        支付对象Id type类型为0可不传
 *  @param title        消费标题 type类型为0可不传
 *  @param payType      支付类型 0：苹果 1：微信 2：支付宝 3：余额
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 *  @param balanceBlock 余额不足回调
 */
-(void)getGenerateOrderWithMoney:(NSString *)money type:(WTPayType)type objid:(NSString *)objid title:(NSString *)title payType:(WTPayWayType)payType resultBlock:(void(^)(ModelOrderWT *model, id resultThree, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock balanceBlock:(void(^)(NSString *msg))balanceBlock;

/**
 *  修改订单状态
 *
 *  @param orderId      订单ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)updOrderStateWithOrderId:(NSString *)orderId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  修改多个订单状态
 *
 *  @param orderIds     订单ID集合
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)updOrderStateWithOrderIds:(NSArray *)orderIds resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的余额
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMyBalanceWithResultBlock:(void(^)(NSString *balance, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  发现顶部标题
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getFoundConfigureContentWithResultBlock:(void(^)(NSString *title, NSString *desc))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  发现--获取微课分类
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getFoundPracticeTypeWithResultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  发现--获取微课列表
 *
 *  @param typeId       分类ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getFoundPracticeArrayWithTypeId:(NSString *)typeId resultBlock:(void(^)(NSArray *arrResult, NSInteger totalCount, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的--已支付--已购买【用户订阅记录】
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMySubscribePlayArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的--已支付--充值【用户充值记录】
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMyRechargeRecordArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅每期看和连续播的列表
 *
 *  @param subscribeId  课程ID
 *  @param type         0每期看 1连续播
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getCurriculumArrayWithSubscribeId:(NSString *)subscribeId type:(int)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取试读和阅读WebUrl地址
 *
 *  @param curriculumId 每期内容的ID
 *  @param subscribeId  课程ID
 *  @param type         0试读 1阅读 2课件
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getCurriculumDetailWebUrlWithCurriculumId:(NSString *)curriculumId subscribeId:(NSString *)subscribeId type:(int)type resultBlock:(void(^)(NSString *webUrl, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  圈子推荐
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleRemdListWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

#pragma mark - V2.1.0

/**
 *  修改个人资料接口
 *
 *  @param model       用户对象
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postUpdateUserInfoWithModel:(ModelUser *)model resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  加入购物车
 *
 *  @param ids          微课ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postJoinPracticeToCartWithPracticeIds:(NSString *)ids resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除购物车
 *
 *  @param ids          微课ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postRemovePracticeByCartWithPracticeIds:(NSString *)ids resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取购物车列表
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPayCartPracticeArrayResultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  生成订单-结算购物车
 *
 *  @param money        金额
 *  @param type         订单类型 0：充值 1：订阅 2：微课
 *  @param objid        支付对象Id type类型为0可不传
 *  @param title        消费标题 type类型为0可不传
 *  @param payType      支付类型 0：苹果 1：微信 2：支付宝 3：余额
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 *  @param balanceBlock 余额不足回调
 */
-(void)getGenerateOrderClearingWithMoney:(NSString *)money type:(int)type objid:(NSString *)objid title:(NSString *)title payType:(WTPayWayType)payType resultBlock:(void(^)(ModelOrderWT *model, id resultThree, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock balanceBlock:(void(^)(NSString *msg))balanceBlock;


/**
 *  添加留言
 *
 *  @param content      留言内容
 *  @param cid          课程内容ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postAddMessageContentWithSubscribe:(NSString *)content cId:(NSString *)cid resultBlock:(void(^)(NSString *messageId, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除留言
 *
 *  @param messageId    留言ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postDelMessageContentWithMessageId:(NSString *)messageId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  留言点赞
 *
 *  @param messageId    留言ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postMessagePraiseWithMessageId:(NSString *)messageId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  留言取消点赞
 *
 *  @param messageId    留言ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postMessageUnPraiseWithMessageId:(NSString *)messageId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取微课[语音]详情
 *
 *  @param practiceId   微课ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getPracticeDetailWithPracticeId:(NSString *)practiceId resultBlock:(void(^)(ModelPractice *resultModel))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的已购-购买微课列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPurchasePracticeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的已购-购买订阅列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPurchaseSubscribeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, int unReadTotalCount, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的已购-购买系列课程列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getPurchaseCurriculumArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, int unReadTotalCount, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  意见反馈
 *
 *  @param content      反馈的内容
 *  @param imageArray   图片集合
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postFeekbackWithContent:(NSString *)content imageArray:(NSArray *)imageArray resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  绑定手机号
 *
 *  @param phone        手机号
 *  @param password     设置密码
 *  @param valiCode     验证码
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postBindMobileNumberWithMobile:(NSString *)phone password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  更换手机号码
 *
 *  @param phone        手机号
 *  @param password     设置密码
 *  @param valiCode     验证码
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postChangeMobileNumberWithMobile:(NSString *)phone password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  验证手机号码
 *
 *  @param phone        手机号
 *  @param valiCode     验证码
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postCheckMobileNumberWithMobile:(NSString *)phone valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  绑定微信
 *
 *  @param uniqueCode   微信唯一标示
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postBindWeChatWithUniqueCode:(NSString *)uniqueCode wechatNickname:(NSString *)wechatname resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  解除微信绑定
 *
 *  @param uniqueCode   微信唯一标示
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postUnBindWeChatWithUniqueCode:(NSString *)uniqueCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  解除手机号绑定
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)postUnBindMobileWithMobile:(NSString *)phone valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取订阅列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getSubscribeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取课程列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getCurriculumArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的留言列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMyMessageArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的收藏->每期看
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyCollectionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取课程内容详情
 *
 *  @param curriculumId 课程内容ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getCurriculumDetailWithCurriculumId:(NSString *)curriculumId resultBlock:(void(^)(ModelCurriculum *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的--已支付--打赏【打赏记录】
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getMyRewardRecordArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取微课[语音]详情
 *
 *  @param practiceId   微课ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
//-(void)getPracticeDetailWithPracticeId:(NSString *)practiceId userId:(NSString*)userId resultBlock:(void(^)(ModelPractice *resultModel))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  统计收听数据
 *
 *  @param objectId     微课id或者课程内容id
 *  @param type         类型1微课,2订阅,3系列课程
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)addPlayStaticalWithObjectId:(NSString *)objectId type:(int)type resultBlock:(void(^)(void))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/*********************************************2.2.1*********************************************/

/**
 *  获取律所列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getLawFirmListWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取律所详情
 *
 *  @param ids          律所ID
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getLawFirmDetailWithLawFirmId:(NSString *)ids resultBlock:(void(^)(NSArray *resultPractice, NSArray *resultSubscribe, NSArray *resultSeriesCourse, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取律所微课列表
 *
 *  @param ids          律所ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getLawFirmPracticeListWithLawFirmId:(NSString *)ids pageNum:(int)pageNum resultBlock:(void(^)(NSArray *result, NSDictionary *dic))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取律所订阅列表
 *
 *  @param ids          律所ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getLawFirmSubscribeListWithLawFirmId:(NSString *)ids pageNum:(int)pageNum resultBlock:(void(^)(NSArray *result, NSDictionary *dic))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取律所系列课列表
 *
 *  @param ids          律所ID
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getLawFirmSeriesCourseListWithLawFirmId:(NSString *)ids pageNum:(int)pageNum resultBlock:(void(^)(NSArray *result, NSDictionary *dic))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;


/*********************************************2.2.5*********************************************/

/**
 *  首页数据对象
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6HomeDataResultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的已购-全部列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6PurchaseAllArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  热门搜索关键字
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6HotSearchWithResultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  提交意见反馈
 *
 *  @param files        ModelImage集合
 *  @param content      反馈内容
 *  @param contact      联系手机号
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6AddFeekBackWithFiles:(NSArray *)files content:(NSString *)content contact:(NSString *)contact resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  反馈记录
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6FeedBackArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取意见反馈常用手机号
 *
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6FeedBackPhoneWithResultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  我的收藏 - 微课
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6CollectPracticeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *array, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取免费专区微课列表
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock  成功回调
 *  @param errorBlock   错误回调
 */
-(void)getV6FreePracticeArrayWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

@end

#define snsV2 [DataOperV2 sharedSingleton]
