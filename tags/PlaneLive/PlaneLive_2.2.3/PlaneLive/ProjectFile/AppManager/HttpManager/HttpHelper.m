//
//  HttpHelper.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "HttpHelper.h"
#import "Utils.h"
#import "AppSetting.h"

#import "AFNetworking.h"

#import "ModelImage.h"

#define kHttpRequestMethodPost @"POST"
#define kHttpRequestMethodGet @"GET"

@interface HttpHelper()

@end

@implementation HttpHelper

+ (id)sharedWithUrl:(NSString *)url
{
    return [[HttpHelper alloc] initWithUrl:url];
}

+ (id)sharedWithAction:(NSString *)action
{
    return [[HttpHelper alloc] initWithAction:action];
}

+ (id)sharedWithAction:(NSString *)action dicParameters:(id)dicParameters
{
    HttpHelper *http = [[HttpHelper alloc] initWithAction:action];
    if (http && dicParameters) {
        http.parameters = dicParameters;
    }
    return http;
}

+ (AFHTTPSessionManager*)defaultHttpManager
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [[[AFHTTPResponseSerializer serializer] acceptableContentTypes] setByAddingObject:@"text/html"];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    });
    return manager;
}
+ (AFURLSessionManager*)defaultUrlManager
{
    static AFURLSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    return manager;
}

#pragma mark - initWith...

- (id)initWithAction:(NSString *)action
{
    self = [super init];
    if (self) {
        self.parameters = nil;
        self.baseUrl = nil;
        self.action = action;
        self.timeout = 15;
    }
    return self;
}

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.parameters = nil;
        self.baseUrl = url;
        self.action = nil;
        self.timeout = 15;
    }
    return self;
}

#pragma mark Request-GET

- (NSURLSessionDownloadTask *)getWithLocalPath:(NSString *)localPath
                               completionBlock:(void(^)(NSString *filePath))completionBlock
                                 progressBlock:(void(^)(NSProgress *uploadProgress))progressBlock
                                    errorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *strUrl = self.action == nil
    ? self.baseUrl
    : [NSString stringWithFormat:@"%@%@", self.baseUrl, self.action];
    
    NSString *fileUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:fileUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
    AFURLSessionManager *manager = [HttpHelper defaultUrlManager];
    
    NSURLSessionDownloadTask *downloadTask = nil;
    downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:localPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (errorBlock) {
                errorBlock(error);
            }
        } else {
            if (completionBlock) {
                completionBlock(filePath.path);
            }
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

- (void)getWithBlock:(void(^)(Response *result))resultBlock
{
    NSString *strUrl = self.action == nil
    ? self.baseUrl
    : [NSString stringWithFormat:@"%@%@", self.baseUrl, self.action];
    
    NSString *fileUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:fileUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeout];
    AFURLSessionManager *manager = [HttpHelper defaultUrlManager];
    
    NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (resultBlock) {
            if (error) {
                resultBlock([Response sharedWithError:error]);
            } else {
                resultBlock([Response sharedWithJSONDictionary:responseObject]);
            }
        }
    }];
    [dataTask resume];
}

#pragma mark Request-POST

- (void)postWithBlock:(void(^)(Response *result))resultBlock
{
    NSString *strUrl = self.action == nil
    ? self.baseUrl
    : [NSString stringWithFormat:@"%@%@", self.baseUrl, self.action];
    
    AFHTTPSessionManager *manager = [HttpHelper defaultHttpManager];
    [manager.requestSerializer setTimeoutInterval:self.timeout];
    if (self.headers && self.headers.allKeys.count > 0) {
        for (int i = 0; i < self.headers.allKeys.count; i++) {
            [manager.requestSerializer setValue:[self.headers.allValues objectAtIndex:i]
                             forHTTPHeaderField:[self.headers.allKeys objectAtIndex:i]];
        }
    }
    
    NSDictionary *dicParams = self.parameters;
    if (self.arrayFile.count > 0) {
        [manager POST:strUrl parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int index = 0;
            for (id imgObj in self.arrayFile) {
                if (imgObj && [imgObj isKindOfClass:[NSString class]]) {
                    if ([[NSFileManager defaultManager] fileExistsAtPath:(NSString*)imgObj]) {
                        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:imgObj] name:@"file" fileName:kRandomImageName mimeType:@"application/x-www-form-urlencoded; charset=UTF-8"];
                    }
                } else if (imgObj && [imgObj isKindOfClass:[ModelImage class]]) {
                    UIImage *imageOjbect = [(ModelImage*)imgObj imageObject];
                    if (imageOjbect) {
                        NSString *fileName = [(ModelImage*)imgObj imageName];
                        NSString *name = [NSString stringWithFormat:@"answerImg%d",index];
                        [formData appendPartWithFileData:UIImagePNGRepresentation(imageOjbect) name:name fileName:fileName mimeType:@"application/x-www-form-urlencoded; charset=UTF-8"];
                    }
                } else if (imgObj && [imgObj isKindOfClass:[NSData class]]) {
                    [formData appendPartWithFileData:imgObj name:@"file" fileName:kRandomImageName mimeType:@"application/x-www-form-urlencoded; charset=UTF-8"];
                }
                index++;
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef DEBUG
            NSLog(@"Response: %@ ,\n RequestHeaders: %@,\n RequestParams: %@,\n ResponseObject: %@", task.response, task.currentRequest.allHTTPHeaderFields, dicParams ,responseObject);
#endif
            if (resultBlock) {
                resultBlock([Response sharedWithJSONDictionary:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
            NSLog(@"Response: %@ ,\n RequestHeaders: %@,\n RequestParams: %@,\n ResponseError: %@", task.response, task.currentRequest.allHTTPHeaderFields, dicParams ,error);
#endif
            if (resultBlock) {
                resultBlock([Response sharedWithError:error]);
            }
        }];
    } else {
        [manager POST:strUrl parameters:dicParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#ifdef DEBUG
            NSLog(@"Response: %@ ,\n RequestHeaders: %@,\n RequestParams: %@,\n ResponseObject: %@", task.response, task.currentRequest.allHTTPHeaderFields, dicParams ,responseObject);
#endif
            if (resultBlock) {
                resultBlock([Response sharedWithJSONDictionary:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
            NSLog(@"Response: %@ ,\n RequestHeaders: %@,\n RequestParams: %@,\n ResponseError: %@", task.response, task.currentRequest.allHTTPHeaderFields, dicParams ,error);
#endif
            if (resultBlock) {
                resultBlock([Response sharedWithError:error]);
            }
        }];
    }
}

@end
