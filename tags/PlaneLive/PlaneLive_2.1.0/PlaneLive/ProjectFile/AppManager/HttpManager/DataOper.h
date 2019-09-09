//
//  DataOper.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataHelper.h"
#import "DataOperV2.h"

@interface DataOper : DataHelper

///单例模式
+ (DataOper *)sharedSingleton;

#pragma mark - V1.0.0

/**
 *  提交BUG或ERROR或用户建议
 *
 *  @param crashContent 崩溃内容
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postErrorReportWithContent:(NSString *)crashContent resultBlock:(void(^)(void))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取设备数量
 *
 *  @param userId       用户ID
 *  @param deviceToken  设备Token
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getDeviceNumberWithUserId:(NSString *)userId deviceToken:(NSString *)deviceToken resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取App配置信息
 *
 *  @param  appVersion  App版本号
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAppConfigWithAppVersion:(NSString *)appVersion resultBlock:(void(^)(ModelAppConfig *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;;

/**
 *  第三方登录
 *
 *  @param openid       openid
 *  @param unionid      unionid
 *  @param flag         1:微信  2:新浪  3:QQ
 *  @param nickname     昵称
 *  @param headImg      头像
 *  @param sex          性别 2男 1女 0默认
 *  @param address      地址
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postLoginWithOpenid:(NSString *)openid unionid:(NSString *)unionid flag:(WTAccountType)flag nickname:(NSString *)nickname headImg:(NSString *)headImg sex:(WTSexType)sex address:(NSString *)address resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  帐号登录
 *
 *  @param account      登录账户
 *  @param password     登录密码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postLoginWithAccount:(NSString *)account password:(NSString *)password resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取验证码
 *
 *  @param account      登录账户
 *  @param flag         1:注册时获取验证码 2:找回密码获取验证码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetCodeWithAccount:(NSString *)account flag:(int)flag resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  注册
 *
 *  @param account      登录账户
 *  @param password     登录密码
 *  @param valiCode     验证码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postRegisterWithAccount:(NSString *)account password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  找回密码
 *
 *  @param account      登录账户
 *  @param password     新密码
 *  @param valiCode     验证码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postForgotPasswordWithAccount:(NSString *)account password:(NSString *)password valiCode:(NSString *)valiCode resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  修改密码
 *
 *  @param account      登录账户
 *  @param oldPwd       旧密码
 *  @param newPwd       新密码
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postUpdatePasswordWithAccount:(NSString *)account oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  修改个人资料接口
 *
 *  @param account      登录账户
 *  @param headImg      图片
 *  @param nickname     昵称
 *  @param signature    个性签名
 *  @param sex          性别
 *  @param trade        行业
 *  @param company      公司
 *  @param address      地址
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postUpdateUserInfoWithAccount:(NSString *)account headImg:(NSString *)headImg nickname:(NSString *)nickname signature:(NSString *)signature sex:(WTSexType)sex trade:(NSString *)trade company:(NSString *)company address:(NSString *)address resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  意见反馈
 *
 *  @param userId       用户ID
 *  @param question     反馈的问题
 *  @param type         question:我的里面的问题反馈
 *                      lawyer:律师
 *                      organization:机构
 *  @param objId        反馈的对象ID type为question可不传
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postFeekbackWithUserId:(NSString *)userId question:(NSString *)question type:(NSString *)type objId:(NSString *)objId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取用户基本信息
 *
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetUserInfoWithUserId:(NSString *)userId resultBlock:(void(^)(ModelUser *resultModel, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取他人用户基本信息
 *
 *  @param userId       用户ID
 *  @param hisId        他人用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetUserInfoWithUserId:(NSString *)userId hisId:(NSString *)hisId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取黑名单列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postGetBlackListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除黑名单
 *
 *  @param userId       用户ID
 *  @param removeUserId 被移除的用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postRemoveBlackListWithUserId:(NSString *)userId removeUserId:(NSString *)removeUserId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  添加黑名单
 *
 *  @param userId       用户ID
 *  @param addUserId    添加用户
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAddBlackListWithUserId:(NSString *)userId addUserId:(NSString *)addUserId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;


/**
 *  获取我的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetQueryQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的问题的更新信息(新答案)
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetUpdQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的粉丝
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetFunsWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的回答
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetReplyWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的关注
 *
 *  @param userId       用户ID
 *  @param flag         1.用户    2.话题
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetAttentionWithUserId:(NSString *)userId flag:(int)flag pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取等我回答的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyGetQueryInviteAnswersWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除被别人邀请但不想回答的问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postMyDelInviteAnswersWithUserId:(NSString *)userId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  举报
 *
 *  @param userId       用户ID
 *  @param objId        举报对象ID
 *  @param type         举报类型
 *  @param content      举报内容
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAddReportWithUserId:(NSString *)userId objId:(NSString *)objId type:(ZReportType)type content:(NSString *)content resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  取消话题、问题、用户的关注
 *
 *  @param aid          关注对象的ID
 *  @param userId       用户ID
 *  @param type         类型 0问题1人2答案3话题4语音
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteAttentionWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  添加话题、问题、用户的关注
 *
 *  @param userId       用户ID
 *  @param hisId        关注对象的ID
 *  @param type         类型 0问题1人2答案3话题4语音
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAddAttentionWithuserId:(NSString *)userId hisId:(NSString *)hisId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteQuestionWithUserId:(NSString *)userId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除新回答提示信息
 *
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteQuestionWithQuestionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除我的粉丝
 *
 *  @param userId       用户ID
 *  @param hisId        被删除的用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteMyFunsWithUserId:(NSString *)userId hisId:(NSString *)hisId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除我的收藏
 *
 *  @param cid          收藏的ID,行业时可不传
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteMyFunsWithCId:(NSString *)cid resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  搜索用户
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param flag         搜索用户位置 0表示只是单纯的搜用户  1表示搜用户进行邀请回答
 *  @param content      搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getSearchUserWithUserId:(NSString *)userId questionId:(NSString *)questionId flag:(NSString *)flag content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;


#pragma mark - V1.0.0 - 圈子

/**
 *  圈子模糊查询问题及话题
 *
 *  @param question     搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleQueryQuestionAnswerWithQuestion:(NSString *)question pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  搜索内容
 *
 *  @param userId       用户ID
 *  @param content      搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleQueryQuestionAnswerWithUserId:(NSString *)userId content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  搜索用户
 *
 *  @param userId       用户ID
 *  @param content      搜索内容
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleSearchUserWithUserId:(NSString *)userId content:(NSString *)content pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  搜索话题
 *
 *  @param artName      关键字
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleQueryArticleWithArtName:(NSString *)artName pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  添加话题
 *
 *  @param userId       用户ID
 *  @param artName      关键字
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleSaveArticleWithUserId:(NSString *)userId artName:(NSString *)artName resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  圈子推荐
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleRemdListWithPageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  圈子最新
 *
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleLatestListWithPageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  圈子动态
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleTrendListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  圈子关注
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleAttentionListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  发布问题
 *
 *  @param userId       用户ID
 *  @param question     问题标题
 *  @param quizDetail   问题描述
 *  @param articles     话题列表
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCirclePublishQuestionWithUserId:(NSString *)userId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  修改问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param question     问题标题
 *  @param quizDetail   问题描述
 *  @param articles     话题列表
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCircleUpdateQuestionWithUserId:(NSString *)userId questionId:(NSString *)questionId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  问题详情接口
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getQuestionDetailWithQuestionId:(NSString *)questionId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  回答问题的详情接口
 *
 *  @param userId       用户ID
 *  @param answerId     回答ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  关注问题
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAttentionQuestionWithQuestionId:(NSString *)questionId userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  点赞
 *
 *  @param userId       用户ID
 *  @param aid          点赞对象ID
 *  @param type         类型
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postClickLikeWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  取消点赞
 *
 *  @param userId       用户ID
 *  @param aid          点赞对象ID
 *  @param type         类型
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postClickUnLikeWithAId:(NSString *)aid userId:(NSString *)userId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除答案
 *
 *  @param userId       用户ID
 *  @param answerId     答案ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteAnswerWithAnswerId:(NSString *)answerId userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  用户点击邀请回答问题
 *
 *  @param userId       用户ID
 *  @param hisId        被邀请用户ID
 *  @param questionId   问题ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postInviteUserWithUserId:(NSString *)userId hisId:(NSString *)hisId questionId:(NSString *)questionId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  用户点击邀请回答后显示的推荐用户
 *
 *  @param userId       用户ID
 *  @param questionId   问题ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getRecommendUserWithUserId:(NSString *)userId questionId:(NSString *)questionId pageNum:(int)pageNum resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  添加回答问题
 *
 *  @param content      回答内容
 *  @param questionId   问题ID
 *  @param userId       用户ID
 *  @param answerImg    图片集合
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAddAnswerWithQuestionId:(NSString *)questionId content:(NSString *)content userId:(NSString *)userId answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  修改回答问题
 *
 *  @param content      回答内容
 *  @param questionId   问题ID
 *  @param answerId     回答ID
 *  @param userId       用户ID
 *  @param answerImg    图片集合
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postUpdAnswerWithQuestionId:(NSString *)questionId answerId:(NSString *)answerId content:(NSString *)content userId:(NSString *)userId answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取要编辑的答案
 *
 *  @param answerId     回答ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAnswerDetailWithAnswerId:(NSString *)answerId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  保存修改后的答案
 *
 *  @param answerId     回答ID
 *  @param content      回答内容
 *  @param answerImg    图片集合
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postUpdAnswerDetailWithAnswerId:(NSString *)answerId content:(NSString *)content answerImg:(NSArray *)answerImg resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  评论
 *
 *  @param userId       用户ID
 *  @param content      评论内容
 *  @param objId        评论对象ID
 *  @param type         类型(问题：0,实务：1)
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postSaveCommentWithUserId:(NSString *)userId content:(NSString *)content objId:(NSString *)objId type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  收藏
 *
 *  @param userId       用户iD
 *  @param cid          收藏的ID,行业时可不传
 *  @param flag         1：实务 2：机构或人员 3:行业 4:答案
 *  @param type         0律所 1 会计 2证券 3语音 4人 5机构 6答案
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAddCollectionWithUserId:(NSString *)userId cid:(NSString *)cid flag:(int)flag type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  取消收藏
 *
 *  @param userId       用户iD
 *  @param cid          收藏的ID,行业时可不传
 *  @param type         0律所 1 会计 2证券 3语音 4人 5机构 6答案
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getDelCollectionWithUserId:(NSString *)userId cid:(NSString *)cid type:(NSString *)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

#pragma mark - V1.0.0 - 实务


/**
 *  获取实务[语音]列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getSpeechArrayWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取实务[语音]详情
 *
 *  @param speechId     实务ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getQuerySpeechDetailWithSpeechId:(NSString *)speechId userId:(NSString*)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;


#pragma mark - V1.1.0

/**
 *  获取我的收藏->回答
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyCollectionAnswerWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的收藏->榜单||实务
 *
 *  @param userId       用户ID
 *  @param type         类型 1榜单 2实务
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyCollectionWithUserId:(NSString *)userId type:(int)type pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的问题
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyQuestionWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  圈子话题分类集合
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getCircleTopicListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  根据话题类型查询话题集合
 *
 *  @param userId       用户ID
 *  @param typeId       话题分类ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getTopicListWithUserId:(NSString *)userId typeId:(NSString *)typeId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrReulst,NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除我的答案->收到的评论
 *
 *  @param comment      评论ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postDeleteAnswerCommentWithCommentId:(NSString *)comment resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  消息中心->列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getUserNoticeListWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  消息中心->列表->详情列表
 *
 *  @param noticeId     消息ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getUserNoticeListWithNoticeId:(NSString *)noticeId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;


#pragma mark - V1.2.0

/**
 *  分享答案时调用
 *
 *  @param share_id     答案ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postAddShareInfoWithShareId:(NSString *)share_id userId:(NSString *)userId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;


#pragma mark - V1.3.0

/**
 *  获取实务[语音]详情
 *
 *  @param practiceId   实务ID
 *  @param userId       用户ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getPracticeDetailWithPracticeId:(NSString *)practiceId userId:(NSString*)userId resultBlock:(void(^)(ModelPractice *resultModel))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  实务详情获取问题列表接口
 *
 *  @param practiceId   实务ID
 *  @param type         问题分类
 *  @param pageNum      当前第几页
 *  @param pageSize     每页多少条
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getPracticeQuestionArrayWithPracticeId:(NSString *)practiceId type:(ZPracticeQuestionType)type pageNum:(int)pageNum pageSize:(int)pageSize resultBlock:(void(^)(NSArray *arrResult, int pageSizeHot, NSInteger questionCount))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  获取我的评论列表
 *
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getMyCommentArrayWithUserId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  对评论进行回复
 *
 *  @param userId       用户ID
 *  @param content      回复内容
 *  @param replyUserId  回复的那个用户id
 *  @param commentId    评论id
 *  @param parent_id    一级为0下面的所有未一级的id
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCommentReplyWithUserId:(NSString *)userId content:(NSString*)content replyUserId:(NSString*)replyUserId commentId:(NSString*)commentId parent_id:(NSString*)parent_id resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  删除评论和回复
 *
 *  @param userId       用户ID
 *  @param ids          评论ID或回复id
 *  @param type         0：评论 1：回复
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCommentReplyWithUserId:(NSString *)userId ids:(NSString*)ids type:(int)type resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  实务-发布问题
 *
 *  @param userId       用户ID
 *  @param question     问题标题
 *  @param quizDetail   问题描述
 *  @param articles     话题列表
 *  @param speechId     实务ID
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)postCirclePublishQuestionWithUserId:(NSString *)userId question:(NSString *)question quizDetail:(NSString *)quizDetail articles:(NSString *)articles speechId:(NSString*)speechId resultBlock:(void(^)(NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  答案详情
 *
 *  @param userId       用户ID
 *  @param answerId     回答ID
 *  @param commentId    默认查询的评论ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getAnswerDetailWithAnswerId:(NSString *)answerId userId:(NSString *)userId commentId:(NSString *)commentId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrComment, ModelAnswerBase *modelAnswer, ModelAnswerComment *modelDefaultComment, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;


#pragma mark - V1.4.0

/**
 *  获取话题语音
 *
 *  @param topicId      话题ID
 *  @param userId       用户ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getTopicPracticeArrayWithTopicId:(NSString *)topicId userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, NSDictionary *result))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

/**
 *  话题详情
 *
 *  @param userId       用户ID
 *  @param aid          话题ID
 *  @param pageNum      当前第几页
 *  @param resultBlock 成功回调
 *  @param errorBlock  错误回调
 */
-(void)getTopicDetailWithTopicId:(NSString *)aid userId:(NSString *)userId pageNum:(int)pageNum resultBlock:(void(^)(NSArray *arrResult, ModelTag *modelTag, NSDictionary *dicResult))resultBlock errorBlock:(void(^)(NSString *msg))errorBlock;

@end

#define snsV1 [DataOper sharedSingleton]
