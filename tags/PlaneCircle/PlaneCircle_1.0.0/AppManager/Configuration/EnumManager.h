//
//  EnumManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

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
    ///默认值
    WTPlatformTypeNone
};

///支付平台枚举
typedef NS_ENUM(NSInteger, WTPayWayType)
{
    ///支付宝
    WTPayWayTypeAli = 101,
    ///微信支付
    WTPayWayTypeWechat = 105,
    ///虎币支付
    WTPayWayTypeTigerCoin = 100,
};

///服务器地址枚举
typedef NS_ENUM(NSInteger, WTServerType)
{
    ///默认值
    WTServerTypeNone = 0,
    ///登录服务器
    WTServerTypeLogin = 1,
};

///性别枚举
typedef NS_ENUM(NSInteger, WTSexType)
{
    ///保密
    WTSexTypeNone = 0,
    ///女
    WTSexTypeFeMale = 1,
    ///男
    WTSexTypeMale = 2
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
    ///暂无等我回答
    ZBackgroundStateWAQNull = 4,
    ///暂无我的回答
    ZBackgroundStateAQNull = 5,
    ///暂无我的收藏
    ZBackgroundStateCollectionNull = 6,
    ///我的收藏错误
    ZBackgroundStateFailCollection = 7,
    ///暂无我的关注->问题
    ZBackgroundStateAttQNull = 8,
    ///暂无我的关注->用户
    ZBackgroundStateAttUNull = 9,
    ///暂无我的问题->发布的
    ZBackgroundStateMQNull = 10,
    ///暂无我的问题->新答案
    ZBackgroundStateMQNANull = 11,
    ///未登录
    ZBackgroundStateLoginNull = 12,
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
    ZShareTypeYingXiang = 15,
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
    ///动态
    ZCircleToolViewItemDynamic = 2,
    ///最新
    ZCircleToolViewItemNew = 3,
    ///关注
    ZCircleToolViewItemAtt = 4,
};

///呼唤APP参数Type类型 0问题，1答案，2实务，3用户，4榜单人员，5机构，6会计，7券商，8律所
typedef NS_ENUM(NSInteger, WTOpenParamType)
{
    ///问题
    WTOpenParamTypeQuestion = 0,
    ///回答
    WTOpenParamTypeAnswer = 1,
    ///实务
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
};

/**
 *  AudioPlayerMode 播放模式
 */
typedef NS_ENUM(NSInteger, AudioPlayerMode) {
    /**
     *  顺序播放
     */
    AudioPlayerModeOrderPlay,
    /**
     *  随机播放
     */
    AudioPlayerModeRandomPlay,
    /**
     *  单曲循环
     */
    AudioPlayerModeSinglePlay,
};

/// 显示分享样式
typedef NS_ENUM(NSInteger, ZShowShareType)
{
    /// 0 分享 微信,朋友圈,qq,qzone
    ZShowShareTypeNone = 0,
    /// 1 分享 微信,朋友圈,qq,qzone,举报
    ZShowShareTypeReport = 1,
    /// 2 分享 微信,朋友圈,qq,qzone,加入黑名单
    ZShowShareTypeBlacklist = 2,
    /// 3 分享 微信,朋友圈,qq,qzone,举报,加入黑名单
    ZShowShareTypeReportBlacklist = 3,
    /// 4 分享 微信,朋友圈,qq,qzone,编辑问题,删除问题
    ZShowShareTypeEditQ = 4,
    /// 5 分享 微信,朋友圈,qq,qzone,编辑回答,删除回答
    ZShowShareTypeEditA = 5,
    /// 6 分享 微信,朋友圈,qq,qzone,下载
    ZShowShareTypeDownload = 6,
    /// 7 分享 微信,朋友圈,qq,qzone,收藏
    ZShowShareTypeCollection = 7,
    /// 8 分享 微信,朋友圈,qq,qzone,下载,收藏
    ZShowShareTypeDownloadCollection = 8,
    /// 9 分享 微信,朋友圈,qq,qzone,印象笔记,有道云笔记
    ZShowShareTypePractice = 9,
    /// 9 分享 微信,朋友圈,qq,qzone,印象笔记,有道云笔记,收藏
    ZShowShareTypePracticeCollection = 10,
};




