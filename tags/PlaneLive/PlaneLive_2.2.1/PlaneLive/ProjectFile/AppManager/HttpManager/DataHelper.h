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

#define kHeaderIMeiKey @"UDID"

@interface DataHelper : NSObject

///单例模式
+ (DataHelper *)sharedSingleton;

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
-(void)postJsonWithAction:(NSString *)action
                postParam:(id)dicParam
                 postFile:(NSArray *)arrayFile
               serverType:(WTServerType)serverType
              resultBlock:(void(^)(Response *result))resultBlock;

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
-(void)postJsonWithAction:(NSString *)action
                postParam:(id)dicParam
                 postFile:(NSArray *)arrayFile
              resultBlock:(void(^)(Response *result))resultBlock;

/**
 *  异步请求SNS通用方法
 *
 *  @param url 地址
 *  @param resultBlock  返回对象
 */
-(void)getJsonWithUrl:(NSString *)url resultBlock:(void(^)(Response *result))resultBlock;

/**
 *  异步请求SNS通用方法
 *
 *  @param fileUrl          下载地址
 *  @param localPath        本地缓存地址
 *  @param completionBlock 返回数据对象
 *  @param progressBlock   进度回调
 *  @param errorBlock      错误回调
 */
-(NSURLSessionDownloadTask *)downloadFileDataWithFileUrl:(NSString *)fileUrl
                                               localPath:(NSString *)localPath
                                         completionBlock:(void(^)(NSString *filePath))completionBlock
                                           progressBlock:(void(^)(NSProgress *uploadProgress))progressBlock
                                              errorBlock:(void(^)(NSError *error))errorBlock;

@end
