//
//  PushManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushManager : NSObject

/**
 *  设置推送内容
 *  @param  接收内容
 */
+(void)setPushContentWithUserInfo:(NSDictionary*)userInfo;

/**
 *  设置推送对应模块的页面
 *  @param  URL地址
 */
+(void)setPushViewControllerWithUrl:(NSURL *)url;

/**
 *  获取上次弹出的内容
 */
+(NSDictionary *)getPushViewControllerLastUrlParam;

@end
