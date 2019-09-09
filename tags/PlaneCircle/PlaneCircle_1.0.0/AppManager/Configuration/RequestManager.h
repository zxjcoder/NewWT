//
//  RequestManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "HostManager.h"

//异常提交接口
#define kJson_PostErrorReport_CMD @"/PostErrorReport"

//微信第三方AccessToken接口
#define kJson_Wechat_AccessToken_CMD @"https:#pragma mark - api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
//微信第三方用户接口
#define kJson_Wechat_UserInfor_CMD @"https:#pragma mark - api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@"

//第三方登录
#define kJson_ThirdLogin_CMD @"share/user/threeLogin"
//登录
#define kJson_Login_CMD @"share/user/login"
//注册
#define kJson_Register_CMD @"share/user/register"
//获取验证码
#define kJson_GetCode_CMD @"share/user/beforeReg"
//修改密码
#define kJson_UpdatePassword_CMD @"share/user/modifyPass"
//找回密码
#define kJson_ForgotPassword_CMD @"share/user/findPass"
//修改个人信息
#define kJson_UpdateUser_CMD @"share/user/updateMyInfo"
//问题反馈
#define kJson_Feekback_CMD @"share/user/feedBack"
//获取用户基本信息
#define kJson_GetUserInfo_CMD @"share/user/refresh"//@"share/user/queryMyInfo"
//获取他人用户信息
#define kJson_GetOtherUserInfo_CMD @"share/search/getInfo"
//黑名单管理
#define kJson_GetBlackList_CMD @"share/user/getBlackList"
//移除黑名单
#define kJson_RemoveBlackList_CMD @"share/user/removeBlackList"
//添加黑名单
#define kJson_AddBlackList_CMD @"share/user/addBlackList"

//关注用户
#define kJson_SearchAttentOtherUser_CMD @"share/search/attentOther"
//用户点击邀请回答后显示的推荐用户
#define kJson_SearchRecommendUser_CMD @"share/search/recommendUser"
//用户点击邀请
#define kJson_SearchInviteAnswer_CMD @"share/search/inviteAnswer"

//问题详情接口
#define kJson_QuestionAnswerQuestion_CMD @"share/question/answerQuestion"
//回答详情问题
#define kJson_QuestionGetComment_CMD @"share/question/getComment"
//关注的问题
#define kJson_QuestionAttention_CMD @"share/question/attention"
//点赞
#define kJson_QuestionApplaud_CMD @"share/question/applaud"
//删除答案
#define kJson_QuestionDelComment_CMD @"share/question/delComment"
//回答问题
#define kJson_QuestionAddAnswer_CMD @"share/question/addAnswer"
//举报问题
#define kJson_QuestionAddReport_CMD @"share/question/addReport"
//获取要编辑的答案
#define kJson_QuestionGetAnswer_CMD @"share/question/getAnswer"
//保存修改后的答案
#define kJson_QuestionUpdAnswer_CMD @"share/question/updAnswer"

//我的收藏
#define kJson_MyGetCollection_CMD @"share/collect/getCollect"
//我的粉丝
#define kJson_MyGetFuns_CMD @"share/user/myFuns"
//我的回答
#define kJson_MyGetReply_CMD @"share/user/myReply"
//我的问题
#define kJson_MyGetQueryQuestion_CMD @"share/question/queryQuestion"
//我的问题的更新信息(新答案)
#define kJson_MyGetUpdQuestion_CMD @"share/question/getUpdQuestion"
//我的关注
#define kJson_MyGetAttention_CMD @"share/user/myAttention"
//等我的回答
//#define kJson_MyGetNeedAnswerQuestion_CMD @"share/question/needAnswerQuestion"
//等我回答的问题
#define kJson_MyGetQueryInviteAnswers_CMD @"share/question/queryInviteAnswers"
//删除被别人邀请但不想回答的问题
#define kJson_MyDelInviteAnswers_CMD @"share/question/delInviteAnswers"

//圈子模糊查询问题及话题
#define kJson_GetCircleQueryQuestionAnswer_CMD @"share/remd/queryQuestionAnswer"
//搜索内容
#define kJson_GetCircleSearchContent_CMD @"share/search/searchSubstance"
//搜索用户
#define kJson_GetCircleSearchUser_CMD @"share/search/searchUser"

//圈子推荐
#define kJson_GetCircleRemdList_CMD @"share/remd/getQuestionAnswer"
//圈子最新
#define kJson_GetCircleLatestList_CMD @"share/latest/latestList"
//圈子动态
#define kJson_GetCircleTrendList_CMD @"share/latest/trend"
//圈子关注
#define kJson_GetCircleAttentionList_CMD @"share/latest/myAttentionList"


