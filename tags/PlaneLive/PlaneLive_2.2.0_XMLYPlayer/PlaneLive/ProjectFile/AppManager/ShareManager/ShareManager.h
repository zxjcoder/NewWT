//
//  ShareManager.h
//  Project
//
//  Created by Daniel on 15/12/9.
//  Copyright © 2015年 Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/SSDKAuthViewStyle.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

/// 分享用户地址
#define kShare_UserInfoUrl(ids) [NSString stringWithFormat:@"%@users/%@",kWebServerUrl,ids];
/// 分享问题地址
#define kShare_QuestionInfoUrl(ids) ([NSString stringWithFormat:@"%@questions/%@?pageNum=1&pagesize=10",kWebServerUrl,ids])
/// 分享回答地址
#define kShare_AnswerInfoUrl(qid, aid) ([NSString stringWithFormat:@"%@questions/%@/answers/%@?pageNum=1&pagesize=10",kWebServerUrl,qid,aid])
/// 分享实务地址
#define kShare_VoiceUrl(ids) ([NSString stringWithFormat:@"%@speech/%@",kWebServerUrl,ids])
/// 分享实务详情地址
#define kApp_PracticeContentUrl(ids) ([NSString stringWithFormat:@"%@speech/%@/text?v=iOS",kWebServerUrl,ids])
/// 分享实务课件地址
#define kApp_PracticeCourseUrl(ids) ([NSString stringWithFormat:@"%@speech/%@/kejian?v=iOS",kWebServerUrl,ids])
/// 分享订阅或系列课试读地址
#define kApp_CurriculumContentUrl(ids,cid) ([NSString stringWithFormat:@"%@course/%@/content/%@?v=iOS",kWebServerUrl,ids,cid])
/// 分享订阅或系列课详情地址
#define kApp_SubscribeContentUrl(ids) ([NSString stringWithFormat:@"%@course/%@?v=iOS",kWebServerUrl,ids])
/// 延迟提醒
#define kShareManagerGCDAfterTime 0.9f

/// 分享管理类
@interface ShareManager : NSObject

/**
 *  调用图文分享
 *
 *  @param title 标题
 *  @param content 内容
 *  @param imageUrl 图片地址
 *  @param webUrl   链接地址
 *  @param platformType 分享平台
 *  @param resultBlock 回调函数
 */
+(void)shareWithTitle:(NSString*)title content:(NSString*)content imageUrl:(NSString*)imageUrl webUrl:(NSString*)webUrl platformType:(WTPlatformType)platformType resultBlock:(void(^)(bool isSuccess, NSString *msg))resultBlock;

/**
 *  调用图文分享
 *
 *  @param title 标题
 *  @param content 内容
 *  @param imgObj 图片
 *  @param webUrl   链接地址
 *  @param platformType 分享平台
 *  @param resultBlock 回调函数
 */
+(void)shareWithTitle:(NSString*)title content:(NSString*)content imgObj:(UIImage*)imgObj webUrl:(NSString*)webUrl platformType:(WTPlatformType)platformType resultBlock:(void(^)(bool isSuccess, NSString *msg))resultBlock;

@end
