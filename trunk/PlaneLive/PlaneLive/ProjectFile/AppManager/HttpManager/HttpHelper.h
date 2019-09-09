//
//  HttpHelper.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

#import "AESCrypt.h"

@interface HttpHelper : NSObject

//创建实例
+ (id)sharedWithUrl:(NSString *)url;
+ (id)sharedWithAction:(NSString *)action;
+ (id)sharedWithAction:(NSString *)action dicParameters:(id)dicParameters;

@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) NSArray *arrayFile;
@property (nonatomic, assign) NSTimeInterval timeout;

- (NSURLSessionDownloadTask *)getWithLocalPath:(NSString *)localPath
                               completionBlock:(void(^)(NSString *filePath))completionBlock
                                 progressBlock:(void(^)(NSProgress *uploadProgress))progressBlock
                                    errorBlock:(void(^)(NSError *error))errorBlock;

- (void)getWithBlock:(void(^)(Response *result))resultBlock;

- (void)postWithBlock:(void(^)(Response *result))resultBlock;

@end
