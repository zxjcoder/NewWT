//
//  EventKeyManager.h
//  PlaneCircle
//
//  Created by Daniel on 7/14/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCategory_Circle kCircle
#define kCategory_Question kQuestion
#define kCategory_Answer kAnswer
#define kCategory_SwitchTool kToolBar
#define kCategory_Rank kRank
#define kCategory_Practice kPractice
#define kCategory_User kMyInfo





//Circle_Search,圈子->搜索,0
#define kEvent_Circle_Search @"Circle_Search"
//Circle_Search_QA,圈子->搜索->问答,0
#define kEvent_Circle_Search_QA @"Circle_Search_QA"
//Circle_Search_User,圈子->搜索->用户,0
#define kEvent_Circle_Search_User @"Circle_Search_User"
//Circle_News,圈子->新闻,0
#define kEvent_Circle_News @"Circle_News"
//Circle_Question,圈子->提问,0
#define kEvent_Circle_Question @"Circle_Question"
//Circle_Recommend,圈子->推荐,0
#define kEvent_Circle_Recommend @"Circle_Recommend"
//Circle_Dynamic,圈子->动态,0
#define kEvent_Circle_Dynamic @"Circle_Dynamic"
//Circle_New,圈子->最新,0
#define kEvent_Circle_New @"Circle_New"
//Circle_Attention,圈子->关注,0
#define kEvent_Circle_Attention @"Circle_Attention"
//Circle_Topic,圈子->话题,0
#define kEvent_Circle_Topic @"Circle_Topic"



//Question_Topic,问题->话题,0
#define kEvent_Question_Topic @"Question_Topic"
//Question_Topic,问题->话题->ID,0
#define kEvent_Question_Topic_ID @"Topic_ID"
//Question_Topic,问题->话题->Name,0
#define kEvent_Question_Topic_Name @"Topic_Name"
//Question_InvitationAnswer,问题->邀请回答,0
#define kEvent_Question_InvitationAnswer @"Question_InvitationAnswer"
//Question_AddAnswer,问题->查看答案,0
#define kEvent_Question_SayAnswer @"Question_SayAnswer"
//Question_AddAnswer,问题->添加答案,0
#define kEvent_Question_AddAnswer @"Question_AddAnswer"
//Question_Attention,问题->关注,0
#define kEvent_Question_Attention @"Question_Attention"
//Question_Edit,问题->编辑问题,0
#define kEvent_Question_Edit @"Question_Edit"
//Question_Delete,问题->删除问题,0
#define kEvent_Question_Delete @"Question_Delete"
//Question_Report,问题->举报问题,0
#define kEvent_Question_Report @"Question_Report"
//Question_Share,问题->分享,0
#define kEvent_Question_Share @"Question_Share"
//Question_Share_WeChat,问题->分享->微信,0
#define kEvent_Question_Share_WeChat @"Question_Share_WeChat"
//Question_Share_WeChatCircle,问题->分享->朋友圈,0
#define kEvent_Question_Share_WeChatCircle @"Question_Share_WeChatCircle"
//Question_Share_QQ,问题->分享->QQ,0
#define kEvent_Question_Share_QQ @"Question_Share_QQ"
//Question_Share_QZone,问题->分享->QQ空间,0
#define kEvent_Question_Share_QZone @"Question_Share_QZone"



//Answer_Agree,答案->同意,0
#define kEvent_Answer_Agree @"Answer_Agree"
//Answer_Comment,答案->评论,0
#define kEvent_Answer_Comment @"Answer_Comment"
//Answer_Edit,答案->编辑答案,0
#define kEvent_Answer_Edit @"Answer_Edit"
//Answer_Delete,答案->删除答案,0
#define kEvent_Answer_Delete @"Answer_Delete"
//Answer_Report,答案->举报,0
#define kEvent_Answer_Report @"Answer_Report"
//Answer_Collection,答案->收藏,0
#define kEvent_Answer_Collection @"Answer_Collection"
//Answer_Share,答案->分享,0
#define kEvent_Answer_Share @"Answer_Share"
//Answer_Share_WeChat,答案->分享->微信,0
#define kEvent_Answer_Share_WeChat @"Answer_Share_WeChat"
//Answer_Share_WeChatCircle,答案->分享->朋友圈,0
#define kEvent_Answer_Share_WeChatCircle @"Answer_Share_WeChatCircle"
//Answer_Share_QQ,答案->分享->QQ,0
#define kEvent_Answer_Share_QQ @"Answer_Share_QQ"
//Answer_Share_QZone,答案->分享->QQ空间,0
#define kEvent_Answer_Share_QZone @"Answer_Share_QZone"




//Practice_List_Item,实务->每期点击量,0
#define kEvent_Practice_List_Item @"Practice_List_Item"
//Practice_List_Item,实务->每期点击量,1
#define kEvent_Practice_List_Item_PlayTime @"Practice_List_Item_PlayTime"
//Practice_List_Item,实务->每期点击量->ID,0
#define kEvent_Practice_List_Item_ID @"Practice_ID"
//Practice_List_Item,实务->每期点击量->Name,0
#define kEvent_Practice_List_Item_Name @"Practice_Name"
//Practice_Play,实务->旋转图标,0
#define kEvent_Practice_Play @"Practice_Play"
//Practice_Detail,实务->实务详情,0
#define kEvent_Practice_Detail @"Practice_Detail"
//Practice_Detail_Text,实务->实务详情->文本,0
#define kEvent_Practice_Detail_Text @"Practice_Detail_Text"
//Practice_Detail_Collection,实务->实务详情->收藏,0
#define kEvent_Practice_Detail_Collection @"Practice_Detail_Collection"
//Practice_Detail_Praise,实务->实务详情->点赞,0
#define kEvent_Practice_Detail_Praise @"Practice_Detail_Praise"
//Practice_Detail_Comment,实务->实务详情->评论,0
#define kEvent_Practice_Detail_Comment @"Practice_Detail_Comment"
//Practice_Detail_Share,实务->实务详情->分享,0
#define kEvent_Practice_Detail_Share @"Practice_Detail_Share"
//Practice_Detail_Share_WeChat,实务->实务详情->分享->微信,0
#define kEvent_Practice_Detail_Share_WeChat @"Practice_Detail_Share_WeChat"
//Practice_Detail_Share_WeChatCircle,实务->实务详情->分享->朋友圈,0
#define kEvent_Practice_Detail_Share_WeChatCircle @"Practice_Detail_Share_WeChatCircle"
//Practice_Detail_Share_QQ,实务->实务详情->分享->QQ,0
#define kEvent_Practice_Detail_Share_QQ @"Practice_Detail_Share_QQ"
//Practice_Detail_Share_QZone,实务->实务详情->分享->QQ空间,0
#define kEvent_Practice_Detail_Share_QZone @"Practice_Detail_Share_QZone"
//Practice_Detail_Share_QZone,实务->实务详情->分享->印象笔记,0
#define kEvent_Practice_Detail_Share_YingXiang @"Practice_Detail_Share_YingXiang"
//Practice_Detail_Share_QZone,实务->实务详情->分享->有道云笔记,0
#define kEvent_Practice_Detail_Share_YouDao @"Practice_Detail_Share_YouDao"



//Rank_Search,榜单->搜索,0
#define kEvent_Rank_Search @"Rank_Search"
//Rank_Search_Organization,榜单->搜索->机构,0
#define kEvent_Rank_Search_Organization @"Rank_Search_Organization"
//Rank_Search_User,榜单->搜索->人员,0
#define kEvent_Rank_Search_User @"Rank_Search_User"
//Rank_HotSearchTag,榜单->热门搜索标签,0
#define kEvent_Rank_HotSearchTag @"Rank_HotSearchTag"
//Rank_HotSearchTag,榜单->热门搜索标签->机构ID,0
#define kEvent_Rank_HotSearchTag_OID @"Rank_OID"
//Rank_HotSearchTag,榜单->热门搜索标签->机构名称,0
#define kEvent_Rank_HotSearchTag_OName @"Rank_OName"
//Rank_HotSearchTag,榜单->热门搜索标签->姓名ID,0
#define kEvent_Rank_HotSearchTag_UID @"Rank_UID"
//Rank_HotSearchTag,榜单->热门搜索标签->姓名名称,0
#define kEvent_Rank_HotSearchTag_UName @"Rank_UName"
//Rank_PerformanceList,榜单->业绩清单,0
#define kEvent_Rank_PerformanceList @"Rank_PerformanceList"
//Rank_PerformanceList_Lawyer,榜单->业绩清单->律师事务所,0
#define kEvent_Rank_PerformanceList_Lawyer @"Rank_PerformanceList_Lawyer"
//Rank_PerformanceList_Lawyer_Share,榜单->业绩清单->律师事务所->分享,0
#define kEvent_Rank_PerformanceList_Lawyer_Share @"Rank_PerformanceList_Lawyer_Share"
//Rank_PerformanceList_Lawyer_Share_WeChat,榜单->业绩清单->律师事务所->分享->微信,0
#define kEvent_Rank_PerformanceList_Lawyer_Share_WeChat @"Rank_PerformanceList_Lawyer_Share_WeChat"
//Rank_PerformanceList_Lawyer_Share_WeChatCircle,榜单->业绩清单->律师事务所->分享->朋友圈,0
#define kEvent_Rank_PerformanceList_Lawyer_Share_WeChatCircle @"Rank_PerformanceList_Lawyer_Share_WeChatCircle"
//Rank_PerformanceList_Lawyer_Share_QQ,榜单->业绩清单->律师事务所->分享->QQ,0
#define kEvent_Rank_PerformanceList_Lawyer_Share_QQ @"Rank_PerformanceList_Lawyer_Share_QQ"
//Rank_PerformanceList_Lawyer_Share_QZone,榜单->业绩清单->律师事务所->分享->QQ空间,0
#define kEvent_Rank_PerformanceList_Lawyer_Share_QZone @"Rank_PerformanceList_Lawyer_Share_QZone"
//Rank_PerformanceList_Lawyer_Share_Collection,榜单->业绩清单->律师事务所->分享->收藏,0
#define kEvent_Rank_PerformanceList_Lawyer_Share_Collection @"Rank_PerformanceList_Lawyer_Share_Collection"
//Rank_PerformanceList_Lawyer_Share_Download,榜单->业绩清单->律师事务所->分享->下载,0
#define kEvent_Rank_PerformanceList_Lawyer_Share_Download @"Rank_PerformanceList_Lawyer_Share_Download"

//Rank_PerformanceList_SecuritiesCompany,榜单->业绩清单->证券公司,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany @"Rank_PerformanceList_SecuritiesCompany"
//Rank_PerformanceList_SecuritiesCompany_Share,榜单->业绩清单->证券公司->分享,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany_Share @"Rank_PerformanceList_SecuritiesCompany_Share"
//Rank_PerformanceList_SecuritiesCompany_Share_WeChat,榜单->业绩清单->证券公司->分享->微信,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChat @"Rank_PerformanceList_SecuritiesCompany_Share_WeChat"
//Rank_PerformanceList_SecuritiesCompany_Share_WeChatCircle,榜单->业绩清单->证券公司->分享->朋友圈,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany_Share_WeChatCircle @"Rank_PerformanceList_SecuritiesCompany_Share_WeChatCircle"
//Rank_PerformanceList_SecuritiesCompany_Share_QQ,榜单->业绩清单->证券公司->分享->QQ,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QQ @"Rank_PerformanceList_SecuritiesCompany_Share_QQ"
//Rank_PerformanceList_SecuritiesCompany_Share_QZone,榜单->业绩清单->证券公司->分享->QQ空间,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany_Share_QZone @"Rank_PerformanceList_SecuritiesCompany_Share_QZone"
//Rank_PerformanceList_SecuritiesCompany_Share_Collection,榜单->业绩清单->证券公司->分享->收藏,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Collection @"Rank_PerformanceList_SecuritiesCompany_Share_Collection"
//Rank_PerformanceList_SecuritiesCompany_Share_Download,榜单->业绩清单->证券公司->分享->下载,0
#define kEvent_Rank_PerformanceList_SecuritiesCompany_Share_Download @"Rank_PerformanceList_SecuritiesCompany_Share_Download"

//Rank_PerformanceList_Accounting,榜单->业绩清单->会计事务所,0
#define kEvent_Rank_PerformanceList_Accounting @"Rank_PerformanceList_Accounting"
//Rank_PerformanceList_Accounting_Share,榜单->业绩清单->会计事务所->分享,0
#define kEvent_Rank_PerformanceList_Accounting_Share @"Rank_PerformanceList_Accounting_Share"
//Rank_PerformanceList_Accounting_Share_WeChat,榜单->业绩清单->会计事务所->分享->微信,0
#define kEvent_Rank_PerformanceList_Accounting_Share_WeChat @"Rank_PerformanceList_Accounting_Share_WeChat"
//Rank_PerformanceList_Accounting_Share_WeChatCircle,榜单->业绩清单->会计事务所->分享->朋友圈,0
#define kEvent_Rank_PerformanceList_Accounting_Share_WeChatCircle @"Rank_PerformanceList_Accounting_Share_WeChatCircle"
//Rank_PerformanceList_Accounting_Share_QQ,榜单->业绩清单->会计事务所->分享->QQ,0
#define kEvent_Rank_PerformanceList_Accounting_Share_QQ @"Rank_PerformanceList_Accounting_Share_QQ"
//Rank_PerformanceList_Accounting_Share_QZone,榜单->业绩清单->会计事务所->分享->QQ空间,0
#define kEvent_Rank_PerformanceList_Accounting_Share_QZone @"Rank_PerformanceList_Accounting_Share_QZone"
//Rank_PerformanceList_Accounting_Share_Collection,榜单->业绩清单->会计事务所->分享->收藏,0
#define kEvent_Rank_PerformanceList_Accounting_Share_Collection @"Rank_PerformanceList_Accounting_Share_Collection"
//Rank_PerformanceList_Accounting_Share_Download,榜单->业绩清单->会计事务所->分享->下载,0
#define kEvent_Rank_PerformanceList_Accounting_Share_Download @"Rank_PerformanceList_Accounting_Share_Download"




//User_Edit,我的->编辑资料,0
#define kEvent_User_Edit @"User_Edit"
//User_MYQuestion,我的->我的问题,0
#define kEvent_User_MYQuestion @"User_MYQuestion"
//User_MYQuestion_All,我的->我的问题->所有问题,0
#define kEvent_User_MYQuestion_All @"User_MYQuestion_All"
//User_MYQuestion_New,我的->我的问题->新答案,0
#define kEvent_User_MYQuestion_New @"User_MYQuestion_New"
//User_MYFans,我的->的粉丝,0
#define kEvent_User_MYFans @"User_MYFans"
//User_MYWaitAAnswer,我的->等我回答,0
#define kEvent_User_MYWaitAAnswer @"User_MYWaitAAnswer"
//User_MYCollection,我的->我的收藏,0
#define kEvent_User_MYCollection @"User_MYCollection"
//User_MYAnswer,我的->我的回答,0
#define kEvent_User_MYAnswer @"User_MYAnswer"
//User_MYAtt,我的->我的关注,0
#define kEvent_User_MYAtt @"User_MYAtt"
//User_MYAtt,我的->评论,0
#define kEvent_User_MYComment @"User_MYComment"
//User_FeebBack,我的->问题反馈,0
#define kEvent_User_FeebBack @"User_FeebBack"
//User_NoticeCenter,我的->通知中心,0
#define kEvent_User_NoticeCenter @"User_NoticeCenter"
//User_Setting,我的->设置,0
#define kEvent_User_Setting @"User_Setting"
//User_Setting_UpdatePWD,我的->设置->修改密码,0
#define kEvent_User_Setting_UpdatePWD @"User_Setting_UpdatePWD"
//User_Setting_Blacklist,我的->设置->黑名单管理,0
#define kEvent_User_Setting_Blacklist @"User_Setting_Blacklist"
//User_Setting_ClearCache,我的->设置->清除缓存,0
#define kEvent_User_Setting_ClearCache @"User_Setting_ClearCache"
//User_Setting_Exit,我的->设置->注销,0
#define kEvent_User_Setting_Exit @"User_Setting_Exit"
//User_Setting_Agreement,我的->设置->使用协议,0
#define kEvent_User_Setting_Agreement @"User_Setting_Agreement"
//User_Setting_FontSize,我的->设置->字体大小,0
#define kEvent_User_Setting_FontSize @"User_Setting_FontSize"
//User_Setting_About,我的->设置->关于,0
#define kEvent_User_Setting_About @"User_Setting_About"
//User_Setting_Score,我的->设置->评分,0
#define kEvent_User_Setting_Score @"User_Setting_Score"


