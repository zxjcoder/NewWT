//
//  ShareManager.m
//  Project
//
//  Created by Daniel on 15/12/9.
//  Copyright © 2015年 Z. All rights reserved.
//

#import "ShareManager.h"
#import "Utils.h"
#import "ZProgressHUD.h"

@implementation ShareManager

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
+(void)shareWithTitle:(NSString*)title content:(NSString*)content imageUrl:(NSString*)imageUrl webUrl:(NSString*)webUrl platformType:(WTPlatformType)platformType resultBlock:(void(^)(bool isSuccess, NSString *msg))resultBlock
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageUrl
                                        url:[NSURL URLWithString:webUrl]
                                      title:title
                                       type:SSDKContentTypeAuto];
    SSDKPlatformType type = SSDKPlatformTypeQQ;
    switch (platformType) {
        case WTPlatformTypeQzone: type = SSDKPlatformSubTypeQZone; break;
        case WTPlatformTypeQQFriend: type = SSDKPlatformSubTypeQQFriend; break;
        case WTPlatformTypeWeChatSession: type = SSDKPlatformSubTypeWechatSession; break;
        case WTPlatformTypeWeChatTimeline: type = SSDKPlatformSubTypeWechatTimeline; break;
        case WTPlatformTypeYinXiang: type = SSDKPlatformTypeYinXiang; break;
        case WTPlatformTypeYouDao: type = SSDKPlatformTypeYouDaoNote; break;
        default: type = SSDKPlatformTypeQQ; break;
    }
    BOOL isShare = YES;
    switch (type) {
        case SSDKPlatformSubTypeQQFriend:
        case SSDKPlatformSubTypeQZone:
        {
            if (![QQApiInterface isQQInstalled]) {
                isShare = NO;
                resultBlock(NO, kCQQNoInstalled);
                break;
            }
            if (![QQApiInterface isQQSupportApi]) {
                isShare = NO;
                resultBlock(NO, kCQQNoSupportApi);
                break;
            }
            break;
        }
        case SSDKPlatformSubTypeWechatSession:
        case SSDKPlatformSubTypeWechatTimeline:
        {
            if (![Utils isWXAppInstalled]) {
                isShare = NO;
                resultBlock(NO, kCWeChatNoInstalled);
                break;
            }
            if (![WXApi isWXAppSupportApi]) {
                isShare = NO;
                resultBlock(NO, kCWeChatNoSupportApi);
                break;
            }
            break;
        }
        default:break;
    }
    if (!isShare) {return;}
    
    //分享
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        GCDMainBlock(^(void){
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    GCDAfterBlock(kShareManagerGCDAfterTime, ^{
                        [ZProgressHUD showSuccess:kCShareTitleSuccess];
                    });
                    if (resultBlock) {
                        resultBlock(YES, nil);
                    }
                    break;
                }
                case SSDKResponseStateFail:
                {
                    if (resultBlock) {
                        if (error.code == 205) {
                            resultBlock(NO, kCShareTitleNoAuthorizeError);
                        } else {
                            resultBlock(NO, kCShareTitleError);
                        }
                    }
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    if (resultBlock) {
                        resultBlock(NO, nil);
                    }
                    break;
                }
                default:break;
            }
        });
    }];
}

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
+(void)shareWithTitle:(NSString*)title content:(NSString*)content imgObj:(UIImage*)imgObj webUrl:(NSString*)webUrl platformType:(WTPlatformType)platformType resultBlock:(void(^)(bool isSuccess, NSString *msg))resultBlock
{
    SSDKPlatformType type = SSDKPlatformTypeQQ;
    switch (platformType) {
        case WTPlatformTypeQzone: type = SSDKPlatformSubTypeQZone; break;
        case WTPlatformTypeQQFriend: type = SSDKPlatformSubTypeQQFriend; break;
        case WTPlatformTypeWeChatSession: type = SSDKPlatformSubTypeWechatSession; break;
        case WTPlatformTypeWeChatTimeline: type = SSDKPlatformSubTypeWechatTimeline; break;
        case WTPlatformTypeYinXiang: type = SSDKPlatformTypeYinXiang; break;
        case WTPlatformTypeYouDao: type = SSDKPlatformTypeYouDaoNote; break;
        default: type = SSDKPlatformTypeQQ; break;
    }
    BOOL isShare = YES;
    switch (type) {
        case SSDKPlatformSubTypeQQFriend:
        case SSDKPlatformSubTypeQZone:
        {
            if (![QQApiInterface isQQInstalled]) {
                isShare = NO;
                resultBlock(NO, kCQQNoInstalled);
                break;
            }
            if (![QQApiInterface isQQSupportApi]) {
                isShare = NO;
                resultBlock(NO, kCQQNoSupportApi);
                break;
            }
            break;
        }
        case SSDKPlatformSubTypeWechatSession:
        case SSDKPlatformSubTypeWechatTimeline:
        {
            if (![Utils isWXAppInstalled]) {
                isShare = NO;
                resultBlock(NO, kCWeChatNoInstalled);
                break;
            }
            if (![WXApi isWXAppSupportApi]) {
                isShare = NO;
                resultBlock(NO, kCWeChatNoSupportApi);
                break;
            }
            break;
        }
        default:break;
    }
    if (!isShare) {return;}
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imgObj
                                        url:[NSURL URLWithString:webUrl]
                                      title:title
                                       type:SSDKContentTypeAuto];
    //分享
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        GCDMainBlock(^(void){
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    GCDAfterBlock(kShareManagerGCDAfterTime, ^{
                        [ZProgressHUD showSuccess:kCShareTitleSuccess];
                    });
                    if (resultBlock) {
                        resultBlock(YES, nil);
                    }
                    break;
                }
                case SSDKResponseStateFail:
                {
                    if (resultBlock) {
                        if (error.code == 205) {
                            resultBlock(NO, kCShareTitleNoAuthorizeError);
                        } else {
                            resultBlock(NO, kCShareTitleError);
                        }
                    }
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    if (resultBlock) {
                        resultBlock(NO, nil);
                    }
                    break;
                }
                default:break;
            }
        });
    }];
}

@end
