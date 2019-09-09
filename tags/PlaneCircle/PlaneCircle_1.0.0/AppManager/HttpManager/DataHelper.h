//
//  DataHelper.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import "ModelEntity.h"
#import "Utils.h"

#define kHeaderIMeiKey @"udid"

@interface DataHelper : NSObject

/**
 *  异步请求SNS通用方法
 *
 *  @param action 路由地址
 *  @param postParam 请求参数集合或字典
 *         集合格式  @[@[@"key",@"value"],@[@"key",@"value"]]
 *         字典格式  {@"value":@"key",@"value":@"key"}
 *  @param postFile 图片集合
 *  @param serverType 服务器地址分类
 *  @result resultBlock 返回数据对象
 */
+(void)postJsonWithAction:(NSString *)action
                postParam:(id)dicParam
                 postFile:(NSArray *)arrayFile
               serverType:(WTServerType)serverType
              resultBlock:(void(^)(Response *result))resultBlock;

/**
 *  异步请求SNS通用方法
 *
 *  @param action 路由地址
 *  @param postParam 请求参数集合或字典
 *         集合格式  @[@[@"key",@"value"],@[@"key",@"value"]]
 *         字典格式  {@"value":@"key",@"value":@"key"}
 *  @param postFile 图片集合
 *  @result resultBlock 返回数据对象
 */
+(void)postJsonWithAction:(NSString *)action
                postParam:(id)dicParam
                 postFile:(NSArray *)arrayFile
              resultBlock:(void(^)(Response *result))resultBlock;

/**
 *  异步请求SNS通用方法
 *
 *  @param fileUrl          下载地址
 *  @param localPath        本地缓存地址
 *  @result completionBlock 返回数据对象
 *  @result progressBlock   进度回调
 *  @result errorBlock      错误回调
 */
+(NSURLSessionDownloadTask *)downloadFileDataWithFileUrl:(NSString *)fileUrl
                                               localPath:(NSString *)localPath
                                         completionBlock:(void(^)(NSString *filePath, NSData *fileData))completionBlock
                                           progressBlock:(void(^)(NSProgress *uploadProgress))progressBlock
                                              errorBlock:(void(^)(NSError *error))errorBlock;

@end
