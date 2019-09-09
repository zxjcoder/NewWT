//
//  EnumManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

///View切换场景
typedef NS_OPTIONS(NSUInteger, ZTransitionAnimationType)
{
    ZTransitionAnimationTypePush = 0,
    ZTransitionAnimationTypePop = 1 << 0,
    ZTransitionAnimationTypePresent = 1 << 1,
    ZTransitionAnimationTypeDissmiss = 1 << 2
};
///分享回调枚举
typedef NS_ENUM(NSInteger, WTOpenURLType)
{
    ///腾讯OpenURL
    WTOpenURLTypeTencent = 1,
    ///微信OpenURL
    WTOpenURLTypeWechat = 2,
    ///支付宝OpenURL
    WTOpenURLTypeAli = 3,
    ///OpenURL
    WTOpenURLTypeNone
};

///分享平台枚举
typedef NS_ENUM(NSInteger, WTPlatformType)
{
    ///微信好友
    WTPlatformTypeWeChatSession = 1,
    ///微信朋友圈
    WTPlatformTypeWeChatTimeline = 2,
    ///QQ好友
    WTPlatformTypeQQFriend = 3,
    ///QQ空间
    WTPlatformTypeQzone = 4,
    ///印象笔记
    WTPlatformTypeYinXiang = 5,
    ///有道云笔记
    WTPlatformTypeYouDao = 6,
    ///默认值
    WTPlatformTypeNone
};

///支付平台枚举
typedef NS_ENUM(NSInteger, WTPayWayType)
{
    ///苹果支付
    WTPayWayTypeApplePay = 0,
    ///微信支付
    WTPayWayTypeWechat = 1,
    ///支付宝
    WTPayWayTypeAli = 2,
    ///余额支付
    WTPayWayTypeBalance = 3,
};

///购买类型
typedef NS_ENUM(NSInteger, WTPayType)
{
    ///余额充值
    WTPayTypeRecharge = 0,
    ///订阅
    WTPayTypeSubscribe = 1,
    ///微课
    WTPayTypePractice = 2,
    ///打赏微课
    WTPayTypeRewardPractice = 3,
    ///打赏订阅
    WTPayTypeRewardSubscribe = 4,
};

///服务器地址枚举
typedef NS_ENUM(NSInteger, WTServerType)
{
    ///默认值
    WTServerTypeNone = 0,
    ///需要加密
    WTServerTypeEncrypt = 2,
};

///性别枚举
typedef NS_ENUM(NSInteger, WTSexType)
{
    ///保密
    WTSexTypeNone = 0,
    ///男
    WTSexTypeMale = 1,
    ///女
    WTSexTypeFeMale = 2,
};

///登录帐号类型
typedef NS_ENUM(NSInteger, WTAccountType)
{
    ///手机号登录
    WTAccountTypePhone = 1,
    ///邮箱登录
    WTAccountTypeEmail = 2,
    ///qq帐号
    WTAccountTypeQQ = 3,
    ///微信帐号
    WTAccountTypeWeChat = 4,
    ///新浪
    WTAccountTypeSina = 5,
};

///背景状态枚举
typedef NS_ENUM(NSInteger, ZBackgroundState)
{
    ///默认无背景
    ZBackgroundStateNone = 0,
    ///加载中
    ZBackgroundStateLoading = 1,
    ///通用加载错误
    ZBackgroundStateFail = 2,
    ///无数据
    ZBackgroundStateNull = 3,
    ///未登录
    ZBackgroundStateLoginNull = 4,
    ///已购订阅无数据
    ZBackgroundStateSubscribeNoData = 5,
    ///已购系列课程无数据
    ZBackgroundStateCurriculumNoData = 6,
    ///已购微课无数据
    ZBackgroundStatePracticeNoData = 7,
    ///已购全部无数据
    ZBackgroundStateAllNoData = 8,
    ///无下拉错误
    ZBackgroundStateError = 9,
};

///分享枚举
typedef NS_ENUM(NSInteger, ZShareType)
{
    ///微信好友
    ZShareTypeWeChat = 0,
    ///微信朋友圈
    ZShareTypeWeChatCircle = 1,
    ///QQ
    ZShareTypeQQ = 2,
    ///QQ空间
    ZShareTypeQZone = 3,
    ///举报
    ZShareTypeReport = 4,
    ///黑名单
    ZShareTypeBlackList = 5,
    ///编辑
    ZShareTypeEdit = 6,
    ///删除
    ZShareTypeDelete = 7,
    ///编辑回答
    ZShareTypeEditAnswer = 8,
    ///删除回答
    ZShareTypeDeleteAnswer = 9,
    ///编辑问题
    ZShareTypeEditQuestion = 10,
    ///删除问题
    ZShareTypeDeleteQuestion = 11,
    ///下载
    ZShareTypeDownload = 12,
    ///收藏
    ZShareTypeCollection = 13,
    ///有道云笔记
    ZShareTypeYouDao = 14,
    ///印象笔记
    ZShareTypeYinXiang = 15,
};

///榜单分类
typedef NS_ENUM(NSInteger, WTRankType)
{
    ///律师事务所
    WTRankTypeL = 0,
    ///会计事务所
    WTRankTypeK = 1,
    ///证券公司
    WTRankTypeZ = 2,
    ///语音
    WTRankTypeA = 3,
    ///人
    WTRankTypeU = 4,
    ///机构
    WTRankTypeO = 5,
    
};

///圈子首页工具栏切换栏
typedef NS_ENUM(NSInteger, ZCircleToolViewItem)
{
    ///推荐
    ZCircleToolViewItemHot = 1,
    ///最新
    ZCircleToolViewItemNew = 3,
    ///话题
    ZCircleToolViewItemTopic = 2,
    ///动态
    ZCircleToolViewItemDynamic = 4,
};

///工具栏切换栏
typedef NS_ENUM(NSInteger, ZSwitchToolViewItem)
{
    ///圈子
    ZSwitchToolViewItemCircle = 1,
    ///我的问题
    ZSwitchToolViewItemMyQuestion = 2,
    ///我的收藏
    ZSwitchToolViewItemMyCollection = 3,
    ///我的关注
    ZSwitchToolViewItemMyAttention = 4,
    ///我的回答
    ZSwitchToolViewItemMyAnswer = 5,
    ///圈子搜索
    ZSwitchToolViewItemCircleSearch = 6,
    ///榜单详情
    ZSwitchToolViewItemRankDetail = 7,
    ///话题列表
    ZSwitchToolViewItemTopicList = 8,
    ///首页搜索
    ZSwitchToolViewItemHomeSearch = 9,
    ///首页搜索-无订阅
    ZSwitchToolViewItemHomeSearchNoSubscribe = 99,
    ///我的消费记录
    ZSwitchToolViewItemMyConsumption = 10,
    ///已订阅详情
    ZSwitchToolViewItemSubscribeAlready = 11,
    ///下载
    ZSwitchToolViewItemDownloadManager = 12,
    ///下载-无订阅
    ZSwitchToolViewItemDownloadManagerNoSubscribe = 122,
    ///已购
    ZSwitchToolViewItemPurchase = 13,
};

///呼唤APP参数Type类型
typedef NS_ENUM(NSInteger, WTOpenParamType)
{
    ///问题
    WTOpenParamTypeQuestion = 0,
    ///回答
    WTOpenParamTypeAnswer = 1,
    ///微课
    WTOpenParamTypePractice = 2,
    ///用户
    WTOpenParamTypeUserInfo = 3,
    ///榜单人员
    WTOpenParamTypeRankUser = 4,
    ///榜单机构
    WTOpenParamTypeRankOrganization = 5,
    ///会计
    WTOpenParamTypeRankAccounting = 6,
    ///券商
    WTOpenParamTypeRankBroker = 7,
    ///律师
    WTOpenParamTypeRankLawyer = 8,
    ///分享预告
    WTOpenParamTypeShareTrailer = 9,
    ///举报信息
    WTOpenParamTypeReportInfo = 10,
    ///更新提示消息视图
    WTOpenParamTypeAppUpdate = 11,
    ///订阅详情-未购买
    WTOpenParamTypeSubscribeDetail = 12,
    ///订阅详情-已经购买
    WTOpenParamTypeSubscribeDetailBuy = 13,
    ///梧桐管理员消息视图
    WTOpenParamTypeManagerInfoView = 14,
    ///订阅试读列表视图
    WTOpenParamTypeSubscribeProbationListView = 15,
    ///意见反馈详情视图
    WTOpenParamTypeFeedbackListView = 16,
    ///课程更新推送消息
    WTOpenParamTypeCourseUpdate = 17,
    ///最大值
    WTOpenParamTypeMax = 100,
};

/// 显示分享样式
typedef NS_ENUM(NSInteger, ZShowShareType)
{
    /// 0 分享 微信,朋友圈,qq,qzone
    ZShowShareTypeNone = 0,
    /// 1 分享 微信,朋友圈,qq,qzone,举报
    ZShowShareTypeReport = 1,
    /// 2 分享 微信,朋友圈,qq,qzone,举报,收藏
    ZShowShareTypeReportCollection = 2,
    /// 3 分享 微信,朋友圈,qq,qzone,加入黑名单
    ZShowShareTypeBlacklist = 3,
    /// 4 分享 微信,朋友圈,qq,qzone,举报,加入黑名单
    ZShowShareTypeReportBlacklist = 4,
    /// 5 分享 微信,朋友圈,qq,qzone,编辑问题,删除问题
    ZShowShareTypeEditQ = 5,
    /// 6 分享 微信,朋友圈,qq,qzone,编辑回答,删除回答
    ZShowShareTypeEditA = 6,
    /// 7 分享 微信,朋友圈,qq,qzone,下载
    ZShowShareTypeDownload = 7,
    /// 8 分享 微信,朋友圈,qq,qzone,收藏
    ZShowShareTypeCollection = 8,
    /// 9 分享 微信,朋友圈,qq,qzone,下载,收藏
    ZShowShareTypeDownloadCollection = 9,
    /// 10 分享 微信,朋友圈,qq,qzone,印象笔记,有道云笔记
    ZShowShareTypePractice = 10,
    /// 11 分享 微信,朋友圈,qq,qzone,印象笔记,有道云笔记,收藏
    ZShowShareTypePracticeCollection = 11,
    /// 12 举报,加入黑名单
    ZShowShareTypeOnlyReportBlacklist = 12,
    /// 13 举报
    ZShowShareTypeOnlyReport = 13,
};

///举报位置枚举
typedef NS_ENUM(NSInteger, ZReportType)
{
    /// 举报问题
    ZReportTypeQuestion = 0,
    /// 举报答案
    ZReportTypeAnswer = 1,
    /// 举报人
    ZReportTypePersion = 2,
    /// 举报评论
    ZReportTypeComment = 3
};

///举报页面分类枚举
typedef NS_ENUM(NSInteger, ZReportViewType)
{
    ///垃圾广告
    ZReportViewTypeLJGG = 0,
    ///不友善内容
    ZReportViewTypeBYSNR = 1,
    ///违法信息
    ZReportViewTypeWFXX = 2,
    ///政治敏感
    ZReportViewTypeZZMG = 3,
    ///其他
    ZReportViewTypeOther = 4,
};

///圈子广告分类枚举
typedef NS_ENUM(NSInteger, ZBannerType)
{
    ///微课
    ZBannerTypePractice = 1,
    ///新闻
    ZBannerTypeNews = 2,
    ///问题详情
    ZBannerTypeQuestion = 3,
    ///订阅
    ZBannerTypeSubscribe = 4,
    ///系列课
    ZBannerTypeSerialCourse  = 5,
    ///培训课
    ZBannerTypeTrainingCourse = 6,
};

///微课详情获取问题列表接口类型枚举
typedef NS_ENUM(NSInteger, ZPracticeQuestionType)
{
    ///热门
    ZPracticeQuestionTypeHot = 1,
    ///最新
    ZPracticeQuestionTypeNew = 2,
};

///文本输入地址
typedef NS_ENUM(NSInteger, ZTextFieldIndex)
{
    ///弹窗编辑
    ZTextFieldIndexAlertEdit = 1,
    ///添加提问话题搜索
    ZTextFieldIndexAddQuestionTag = 2,
    ///圈子首页搜索
    ZTextFieldIndexCircleSearch = 3,
    ///验证码
    ZTextFieldIndexCode = 4,
    ///邀请用户搜索
    ZTextFieldIndexInvitationUser = 5,
    ///登录账号
    ZTextFieldIndexLoginAccount = 6,
    ///登录密码
    ZTextFieldIndexLoginPwd = 7,
    ///编辑问题话题搜索
    ZTextFieldIndexEditQuestionTag = 8,
    ///榜单搜索
    ZTextFieldIndexRankSearch = 9,
    ///注册账号
    ZTextFieldIndexRegisterAccount = 10,
    ///注册验证吗
    ZTextFieldIndexRegisterCode = 11,
    ///注册密码
    ZTextFieldIndexRegisterPwd = 12,
    ///设置修改密码
    ZTextFieldIndexUpdatePwd = 13,
    ///修改昵称
    ZTextFieldIndexUserEditNickName = 14,
    ///修改行业
    ZTextFieldIndexUserEditTrade = 15,
    ///修改公司
    ZTextFieldIndexUserEditCompany = 16,
    ///修改地址
    ZTextFieldIndexUserEidtResidence = 17,
    ///绑定账号
    ZTextFieldIndexBindAccount = 18,
    ///绑定验证码
    ZTextFieldIndexBindCode = 19,
    ///绑定密码
    ZTextFieldIndexBindPassword = 20,
    ///修改个性签名
    ZTextFieldIndexUserEditSign = 21,
};

///多行文本输入地址
typedef NS_ENUM(NSInteger, ZTextViewIndex)
{
    ///评论或回复
    ZTextViewIndexCommment = 100,
};

///任务枚举
typedef NS_ENUM(NSInteger, ZTaskType)
{
    ///1: 邀请他人回答问题
    ZTaskTypeInvitationAnswerQuestion = 1,
    ///2：关注一个感兴趣的问题
    ZTaskTypeAttentionQuestion = 2,
    ///3：分享你喜欢的微课到朋友圈
    ZTaskTypeSharePracticeToCircle = 3,
    ///4: 回答其他用户提出的问题
    ZTaskTypeAnswerOtherUserQuestion = 4,
    ///5:修改个人资料
    ZTaskTypeEditUserInfo = 5,
};

///我的个人中心
typedef NS_ENUM(NSInteger, ZUserInfoCenterItemType)
{
    ///已支付
    ZUserInfoCenterItemTypePay = 1,
    ///余额查询
    ZUserInfoCenterItemTypeBalance = 2,
    ///我的收藏
    ZUserInfoCenterItemTypeCollection = 3,
    ///我的关注
    ZUserInfoCenterItemTypeAttention = 4,
    ///我的回答
    ZUserInfoCenterItemTypeAnswer = 5,
    ///评论
    ZUserInfoCenterItemTypeComment = 6,
    ///任务中心
    ZUserInfoCenterItemTypeTask = 7,
    ///消息中心
    ZUserInfoCenterItemTypeMessage = 8,
    ///意见反馈
    ZUserInfoCenterItemTypeFeedback = 9,
    ///设置
    ZUserInfoCenterItemTypeSetting = 10,
    ///下载
    ZUserInfoCenterItemTypeDownload = 11,
    ///账号
    ZUserInfoCenterItemTypeAccount = 12,
    ///购物车
    ZUserInfoCenterItemTypeShoppingCart = 13,
    ///购买记录
    ZUserInfoCenterItemTypePurchaseRecord = 14,
    ///已购
    ZUserInfoCenterItemTypePurchase = 15,
};
///我的个人中心
typedef NS_ENUM(NSInteger, ZUserInfoGridCVCType)
{
    ZUserInfoGridCVCTypeColl = 1,
    ZUserInfoGridCVCTypeAtt = 2,
    ZUserInfoGridCVCTypeDownload = 3,
    ZUserInfoGridCVCTypeMessage = 4,
    ZUserInfoGridCVCTypeWaitAnswer = 5,
    ZUserInfoGridCVCTypeMessageCenter = 6,
};
///我的个人中心
typedef NS_ENUM(NSInteger, ZUserInfoItemTVCType)
{
    ZUserInfoItemTVCTypeQuestion = 1,
    ZUserInfoItemTVCTypeAnswer = 2,
    ZUserInfoItemTVCTypeComment = 3,
    ZUserInfoItemTVCTypeFans = 4,
    ZUserInfoItemTVCTypeFeedback = 5,
    ZUserInfoItemTVCTypeServer = 6,
    ZUserInfoItemTVCTypeAccount = 7,
    ZUserInfoItemTVCTypeSetting = 8,
    ///我的留言
    ZUserInfoItemTVCTypeMessage = 9,
    ///我的消息
    ZUserInfoItemTVCTypeNews = 10,
    ///我的绑定
    ZUserInfoItemTVCTypeBind = 11,
    ZUserInfoItemTVCTypeCollection = 12
};
///网络状况
typedef NS_ENUM(NSInteger, ZNetworkReachabilityStatus) {
    ///未知错误
    ZNetworkReachabilityStatusUnknown          = -1,
    ///无网络
    ZNetworkReachabilityStatusNotReachable     = 0,
    ///流量
    ZNetworkReachabilityStatusReachableViaWWAN = 1,
    ///WIFI
    ZNetworkReachabilityStatusReachableViaWiFi = 2,
};

///播放页面功能按钮分类
typedef NS_ENUM(NSInteger, ZPlayTabBarViewType)
{
    ///微课
    ZPlayTabBarViewTypePractice = 1,
    ///订阅
    ZPlayTabBarViewTypeSubscribe = 2,
};

///下载状态 0:已加入下载队列；1:已下载完成；2:URL无效；4:正在下载；5:数据库错误；9:此音频不允许被下载；10:已注册但不立即下载；21:此音频正在下载中；22:此音频已下载
typedef NS_ENUM(NSInteger, ZDownloadStatus)
{
    ///已加入下载队列
    ZDownloadStatusJoin = 0,
    ///已下载完成
    ZDownloadStatusEnd = 1,
    ///URL无效
    ZDownloadStatusUrlError = 2,
    ///正在下载
    ZDownloadStatusDowloading = 4,
    ///数据库错误
    ZDownloadStatusSqlError = 5,
    ///此音频不允许被下载
    ZDownloadStatusNotDownload = 9,
    ///已注册但不立即下载
    ZDownloadStatusWaitDownload = 10,
    ///此音频正在下载中
    ZDownloadStatusAudioDowloading = 21,
    ///此音频已下载
    ZDownloadStatusAudioDowloadEnd = 22,
};
///下载类型 1微课,2订阅,3系列课程
typedef NS_ENUM(NSInteger, ZDownloadType)
{
    ///微课
    ZDownloadTypePractice = 1,
    ///订阅
    ZDownloadTypeSubscribe = 2,
    ///系列课
    ZDownloadTypeSeriesCourse = 3,
};
///微课分类排序枚举
typedef NS_ENUM(NSInteger, ZPracticeTypeSort)
{
    ///热度
    ZPracticeTypeSortHot = 0,
    ///最新
    ZPracticeTypeSortNew = 1,
    ///推荐
    ZPracticeTypeSortRecommend = 2,
};
///弹框类型
typedef NS_ENUM(NSInteger, ZAlertPickerViewType)
{
    /// 性别
    ZAlertPickerViewTypeSex = 0,
    /// 时间选择
    ZAlertPickerViewTypeTime = 1,
    /// 省市区
    ZAlertPickerViewTypeArea = 2,
    /// 学历
    ZAlertPickerViewTypeEducation = 3,
};
///消息类型: 1系统消息,2更新消息,3课程更新
typedef NS_ENUM(NSInteger, ZNoticeType) {
    /// 系统消息
    ZNoticeTypeSystem = 0,
    /// 课程更新
    ZNoticeTypeCourse = 1,
};
///消息数据类型: 0微课,1系列课,2培训课,3系列课子课程,4培训课子课程
typedef NS_ENUM(NSInteger, ZNoticeCourseType) {
    /// 微课
    ZNoticeCourseTypeMicro = 0,
    /// 系列课
    ZNoticeCourseTypeSeries = 1,
    /// 培训课
    ZNoticeCourseTypeTraining = 2,
    /// 系列课子课程
    ZNoticeCourseTypeSeriesItem = 3,
    /// 培训课子课程
    ZNoticeCourseTypeTrainingItem = 4,
};
