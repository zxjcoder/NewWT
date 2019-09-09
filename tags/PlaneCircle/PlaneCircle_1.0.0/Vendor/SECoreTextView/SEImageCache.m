//
//  SEImageCache.m
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/13.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "SEImageCache.h"
#import "AppSetting.h"
#import "Utils.h"

@interface SEImageCache ()

@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

@implementation SEImageCache

+ (SEImageCache *)sharedInstance
{
    static SEImageCache *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SEImageCache alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (NSImage *)imageForURL:(NSURL *)imageURL completionBlock:(SEImageDownloadCompletionBlock)block
{
    return [self imageForURL:imageURL defaultImage:nil completionBlock:block];
}

- (NSImage *)imageForURL:(NSURL *)imageURL defaultImage:(NSImage *)defaultImage completionBlock:(SEImageDownloadCompletionBlock)block
{
    if (!imageURL && imageURL.absoluteString.length == 0) {
        return defaultImage;
    }
    
    NSString *key = [Utils stringMD5:imageURL.absoluteString];
//    NSImage *cachedImage = [self.cache objectForKey:key];
//    if (cachedImage) {
//        return cachedImage;
//    }
    NSString *cacheFile = [NSString stringWithFormat:@"%@/%@.jpeg",[AppSetting getAnswerFilePath],key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
        UIImage *cachedImg = [UIImage imageWithContentsOfFile:cacheFile];
        if (cachedImg) {
            return cachedImg;
        }
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:imageURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [SEImageCache sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
         if (!error) {
             NSImage *image = [[NSImage alloc] initWithData:data];
             if (image) {
//                 [self.cache setObject:image forKey:key];
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     
                     CGFloat scale = APP_FRAME_WIDTH/image.size.width;
                     CGFloat imgW = APP_FRAME_WIDTH;
                     CGFloat imgH = image.size.height * scale;
                     UIImage *newImage = [Utils resizedTransformtoSize:CGSizeMake(imgW, imgH) image:image];
                     
                     [Utils writeImage:newImage toFileAtPath:cacheFile];
                     
                     dispatch_async(dispatch_get_main_queue(), ^ {
                         if (block) {
                             block(newImage, nil);
                         }
                     });
                 });
             } else {
                 NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
                 dispatch_async(dispatch_get_main_queue(), ^ {
                     if (block) {
                         block(nil, error);
                     }
                 });
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (block) {
                     block(nil, error);
                 }
             });
         }
     }];
    
    return defaultImage;
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
    if ([[NSThread currentThread] isMainThread]) {
        [queue addOperationWithBlock:^{
            NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (handler) {
                    handler(response, data, error);
                }
            }];
            
            [dataTask resume];
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendAsynchronousRequest:request queue:queue completionHandler:handler];
        });
    }
}

@end
