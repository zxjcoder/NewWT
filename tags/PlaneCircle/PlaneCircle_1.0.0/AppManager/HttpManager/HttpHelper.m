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
                               completionBlock:(void(^)(NSString *filePath, NSData *fileData))completionBlock
                                 progressBlock:(void(^)(NSProgress *progress))progressBlock
                                    errorBlock:(void(^)(NSError *error))errorBlock
{
    NSString *strUrl = self.action == nil
    ? self.baseUrl
    : [NSString stringWithFormat:@"%@%@", self.baseUrl, self.action];
    
    NSString *fileUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //TODO:ZWW备注-证书设置
    // 是否信任无效的SSL证书, YES表示如果此处允许使用自建证书,服务器自己弄的CA证书,非官方
//    manager.securityPolicy.allowInvalidCertificates = YES;
    // 是否验证主机名
    // 你想验证自建证书的domain是否有效。那么你必须使用pinnedCertificates（就是在客户端保存服务器端颁发的证书拷贝）才可以。但是你的SSLPinningMode为AFSSLPinningModeNone，表示你不使用SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。所以当然你的客户端上没有你导入的pinnedCertificates，同样表示你无法验证该自建证书。所以都返回NO。最终结论就是要使用服务器端自建证书，那么就得将对应的证书拷贝到iOS客户端，并使用AFSSLPinningMode或AFSSLPinningModePublicKey
//    manager.securityPolicy.validatesDomainName = NO;
    
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
                completionBlock(localPath, [NSData dataWithContentsOfURL:filePath]);
            }
        }
        GBLog(@"completionHandler response: %@  \n localPath: %@ \n Error: %@", response, localPath, error);
    }];
    [downloadTask resume];
    return downloadTask;
}

#pragma mark Request-POST

- (void)postWithBlock:(void(^)(Response *result))resultBlock
{
    NSString *strUrl = self.action == nil
    ? self.baseUrl
    : [NSString stringWithFormat:@"%@%@", self.baseUrl, self.action];
    
    if (self.arrayFile.count > 0) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        // 设置超时时间
        manager.requestSerializer.timeoutInterval = self.timeout;
        //TODO:ZWW备注-证书设置
        // 是否信任无效的SSL证书, YES表示如果此处允许使用自建证书,服务器自己弄的CA证书,非官方
//        manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否验证主机名
        // 你想验证自建证书的domain是否有效。那么你必须使用pinnedCertificates（就是在客户端保存服务器端颁发的证书拷贝）才可以。但是你的SSLPinningMode为AFSSLPinningModeNone，表示你不使用SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。所以当然你的客户端上没有你导入的pinnedCertificates，同样表示你无法验证该自建证书。所以都返回NO。最终结论就是要使用服务器端自建证书，那么就得将对应的证书拷贝到iOS客户端，并使用AFSSLPinningMode或AFSSLPinningModePublicKey
//        manager.securityPolicy.validatesDomainName = NO;
        // 设置接收类型
        manager.responseSerializer.acceptableContentTypes = [[[AFHTTPResponseSerializer serializer] acceptableContentTypes] setByAddingObject:@"text/html"];
        
        [manager POST:strUrl parameters:self.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int index = 0;
            for (id imgObj in self.arrayFile) {
                if (imgObj && [imgObj isKindOfClass:[NSString class]]) {
                    if ([[NSFileManager defaultManager] fileExistsAtPath:(NSString*)imgObj]) {
                        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:imgObj] name:@"file" fileName:kRandomImageName mimeType:@"application/x-www-form-urlencoded; charset=UTF-8"];
                    }
                } else if (imgObj && [imgObj isKindOfClass:[ModelImage class]]) {
                    NSString *filePath = [(ModelImage*)imgObj imagePath];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                        NSString *fileName = [(ModelImage*)imgObj imageName];
                        NSString *name = [NSString stringWithFormat:@"answerImg%d",index];
                        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:filePath] name:name fileName:fileName mimeType:@"application/x-www-form-urlencoded; charset=UTF-8"];
                    }
                } else if (imgObj && [imgObj isKindOfClass:[NSData class]]) {
                    [formData appendPartWithFileData:imgObj name:@"file" fileName:kRandomImageName mimeType:@"application/x-www-form-urlencoded; charset=UTF-8"];
                }
                index++;
            }
        } progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (resultBlock) {
                resultBlock([Response sharedWithJSONDictionary:responseObject]);
            }
#ifdef DEBUG  // 调试状态
            GBLog(@"RequestBase: %@ \n RequestParams: %@ \n RequestFiles: %@ \n ResponseData: %@", strUrl, self.parameters, self.arrayFile, responseObject);
#endif
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (resultBlock) {
                resultBlock([Response sharedWithError:error]);
            }
            GBLog(@"Error: %@", error);
        }];
    } else {
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:kHttpRequestMethodPost URLString:strUrl parameters:self.parameters error:nil];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        // 设置超时时间
        manager.requestSerializer.timeoutInterval = self.timeout;
        //TODO:ZWW备注-证书设置
        // 是否信任无效的SSL证书, YES表示如果此处允许使用自建证书,服务器自己弄的CA证书,非官方
//        manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否验证主机名
        // 你想验证自建证书的domain是否有效。那么你必须使用pinnedCertificates（就是在客户端保存服务器端颁发的证书拷贝）才可以。但是你的SSLPinningMode为AFSSLPinningModeNone，表示你不使用SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。所以当然你的客户端上没有你导入的pinnedCertificates，同样表示你无法验证该自建证书。所以都返回NO。最终结论就是要使用服务器端自建证书，那么就得将对应的证书拷贝到iOS客户端，并使用AFSSLPinningMode或AFSSLPinningModePublicKey
//        manager.securityPolicy.validatesDomainName = NO;
        
        NSURLSessionDataTask *dataTask = nil;
        dataTask = [manager dataTaskWithRequest:request
                                 uploadProgress:^(NSProgress * _Nonnull uploadProgress) {}
                               downloadProgress:^(NSProgress * _Nonnull downloadProgress) {}
                              completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                  if (error) {
                                      if (resultBlock) {
                                          resultBlock([Response sharedWithError:error]);
                                      }
                                      GBLog(@"Error: %@", error);
                                  } else {
                                      if (resultBlock) {
                                          resultBlock([Response sharedWithJSONDictionary:responseObject]);
                                      }
#ifdef DEBUG  // 调试状态
                                      NSLog(@"RequestBase: %@ \n RequestParams: %@ \n RequestFiles: %@ \n ResponseData: %@", response, self.parameters, self.arrayFile, responseObject);
#endif
                                  }
                              }];
        [dataTask resume];
    }
}

@end
