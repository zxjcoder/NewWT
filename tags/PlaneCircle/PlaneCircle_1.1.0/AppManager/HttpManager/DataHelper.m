//
//  DataHelper.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "DataHelper.h"
#import "AppSetting.h"
#import "Utils.h"
#import "HttpHelper.h"
#import "RequestManager.h"

@implementation DataHelper

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
              resultBlock:(void(^)(Response *result))resultBlock
{
    HttpHelper *http = [HttpHelper sharedWithAction:action dicParameters:dicParam];
    switch (serverType) {
        case WTServerTypeNone:
        case WTServerTypeLogin:
        default: http.baseUrl = kApiServerUrl; break;
    }
    
    if (arrayFile) [http setArrayFile:[NSArray arrayWithArray:arrayFile]];
    
    [http postWithBlock:^(Response *result) {
        if (resultBlock) {
            resultBlock(result);
        }
    }];
}

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
              resultBlock:(void(^)(Response *result))resultBlock
{
    [self postJsonWithAction:action postParam:dicParam postFile:arrayFile serverType:(WTServerTypeNone) resultBlock:^(Response *resultObj) {
        if (resultBlock) {
            resultBlock(resultObj);
        }
    }];
}

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
                                         completionBlock:(void(^)(NSData *fileData))completionBlock
                                           progressBlock:(void(^)(NSProgress *progress))progressBlock
                                              errorBlock:(void(^)(NSError *error))errorBlock
{
    HttpHelper *http = [HttpHelper sharedWithUrl:fileUrl];
    
    NSURLSessionDownloadTask *downloadTask = [http getWithLocalPath:localPath
                                                    completionBlock:^(NSData *fileData) {
                                                        if (completionBlock) {
                                                            completionBlock(fileData);
                                                        }
                                                    } progressBlock:^(NSProgress *progress) {
                                                        if (progressBlock) {
                                                            progressBlock(progress);
                                                        }
                                                    } errorBlock:^(NSError *error) {
                                                        if (errorBlock) {
                                                            errorBlock(error);
                                                        }
                                                    }];
    
    return downloadTask;
}

@end
