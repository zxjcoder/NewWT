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

#define kMD5DataUsingKey(val) [NSString stringWithFormat:@"WUCOMTONGSX%@MOBILEAPP",val]

@implementation DataHelper

/**
 *  异步请求SNS通用方法
 *
 *  @param action 路由地址
 *  @param dicParam 请求参数集合或字典
 *         集合格式  @[@[@"key",@"value"],@[@"key",@"value"]]
 *         字典格式  {@"value":@"key",@"value":@"key"}
 *  @param arrayFile 图片集合
 *  @param serverType 服务器地址分类
 *  @param resultBlock 返回数据对象
 */
+(void)postJsonWithAction:(NSString *)action
                postParam:(id)dicParam
                 postFile:(NSArray *)arrayFile
               serverType:(WTServerType)serverType
              resultBlock:(void(^)(Response *result))resultBlock
{
    HttpHelper *http = [HttpHelper sharedWithAction:action dicParameters:dicParam];
    NSMutableDictionary *dicHeaders = [NSMutableDictionary dictionary];
    [dicHeaders setObject:[AppSetting getUserDetauleId] forKey:@"userId"];
    switch (serverType) {
        case WTServerTypeEncrypt:
        {
            ///处理参数加密的过程
            NSString *requestStr = nil;
            if (dicParam) {
                NSError *parseError = nil;
                NSData *requestData = [NSJSONSerialization dataWithJSONObject:dicParam options:NSJSONWritingPrettyPrinted error:&parseError];
                requestStr = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];;
            } else {
                requestStr = kEmpty;
            }
            NSString *encryptParams = [AESCrypt DESEncrypt:requestStr password:kDESEncryptedDataUsingKey];
            
            NSData *desEncryptedData = [encryptParams dataUsingEncoding:NSUTF8StringEncoding];
            NSString *token = [Utils stringMD5:kMD5DataUsingKey([Utils dataMD5:desEncryptedData])];
            
            [dicHeaders setObject:token forKey:@"token"];
            
            http.parameters = @{@"data":encryptParams};
            break;
        }
        case WTServerTypeNone: break;
        default: break;
    }
    http.baseUrl = kApiServerUrl;
    http.headers = [NSDictionary dictionaryWithDictionary:dicHeaders];
    
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
 *  @param dicParam 请求参数集合或字典
 *         集合格式  @[@[@"key",@"value"],@[@"key",@"value"]]
 *         字典格式  {@"value":@"key",@"value":@"key"}
 *  @param arrayFile 图片集合
 *  @param resultBlock 返回数据对象
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
 *  @param url 地址
 *  @param resultBlock  返回对象
 */
+(void)getJsonWithUrl:(NSString *)url resultBlock:(void(^)(Response *result))resultBlock
{
    HttpHelper *http = [HttpHelper sharedWithUrl:url];
   
    [http getWithBlock:^(Response *result) {
        if (resultBlock) {
            resultBlock(result);
        }
    }];
}

/**
 *  异步请求SNS通用方法
 *
 *  @param fileUrl          下载地址
 *  @param localPath        本地缓存地址
 *  @param completionBlock 返回数据对象
 *  @param progressBlock   进度回调
 *  @param errorBlock      错误回调
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
