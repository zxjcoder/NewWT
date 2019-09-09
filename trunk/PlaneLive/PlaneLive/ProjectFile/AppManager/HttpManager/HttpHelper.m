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
        
        [manager setSecurityPolicy:[HttpHelper customSecurityPolicy]];
    });
    return manager;
}
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // 导入证书 仅支持cer 格式 需要将crt格式转换下  //转换格式 openssl x509 -in 你的证书.crt -out 你的证书.cer -outform der
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"dis" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    // AFSSLPinningModeNone 这个模式表示不做SSL pinning，只跟浏览器一样在系统的信任机构列表里验证服务端返回的证书。若证书是信任机构签发的就会通过，若是自己服务器生成的证书就不会通过。
    // AFSSLPinningModeCertificate 这个模式表示用证书绑定方式验证证书，需要客户端保存有服务端的证书拷贝，这里验证分两步，第一步验证证书的域名有效期等信息，第二步是对比服务端返回的证书跟客户端返回的是否一致。
    // AFSSLPinningModePublicKey 这个模式同样是用证书绑定方式验证，客户端要有服务端的证书拷贝，只是验证时只验证证书里的公钥，不验证证书的有效期等信息。只要公钥是正确的，就能保证通信不会被窃听，因为中间人没有私钥，无法解开通过公钥加密的数据。
    NSSet *setData = [NSSet setWithObjects:cerData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone withPinnedCertificates:setData];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //是否需要验证域名，默认为YES
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    //validatesCertificateChain 是否验证整个证书链，默认为YES 2.6.0版本以前
    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
    //GeoTrust Global CA
    //    Google Internet Authority G2
    //        *.google.com
    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证，因为整个证书链一一比对是完全没有必要（请查看源代码）；
    //securityPolicy.validatesCertificateChain = NO;
    // 设置证书数据
    //[securityPolicy setPinnedCertificates:@[cerData]];
    return securityPolicy;
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
                        NSString *serverName = [(ModelImage*)imgObj fileName];
                        NSString *name = @"file";
                        if (serverName.length > 0) {
                            name = [NSString stringWithFormat:@"%@%d",serverName,index];
                        }
                        NSData *imageData = UIImageJPEGRepresentation(imageOjbect, 0.3);
                        [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"application/x-www-form-urlencoded; charset=UTF-8"];
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
