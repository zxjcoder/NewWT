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
#import "DataHelper.h"

@interface SEImageCache ()

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
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)dealloc
{
    OBJC_RELEASE(_queue);
}

- (UIImage *)imageForURL:(NSString *)imageURL completionBlock:(SEImageDownloadCompletionBlock)block
{
    return [self imageForURL:imageURL defaultImage:nil filePath:[AppSetting getAnswerFilePath] imageSize:CGSizeMake(APP_FRAME_WIDTH, 0) completionBlock:block];
}

- (UIImage *)imageForURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage filePath:(NSString *)filePath completionBlock:(SEImageDownloadCompletionBlock)block
{
    return [self imageForURL:imageURL defaultImage:defaultImage filePath:filePath imageSize:CGSizeZero completionBlock:block];
}

- (UIImage *)imageForURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage filePath:(NSString *)filePath imageSize:(CGSize)imageSize completionBlock:(SEImageDownloadCompletionBlock)block
{
    if (imageURL == nil || imageURL.length == 0) {
        return defaultImage;
    }
    
    NSString *imgName = [Utils stringMD5:imageURL];
    NSString *cacheFile = [NSString stringWithFormat:@"%@/%@.%@",filePath, imgName, imageURL.pathExtension];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
        UIImage *cachedImg = [UIImage imageWithContentsOfFile:cacheFile];
        if (cachedImg) {
            return cachedImg;
        }
    }
    [DataHelper downloadFileDataWithFileUrl:imageURL localPath:cacheFile completionBlock:^(NSData *fileData) {
        UIImage *image = [[UIImage alloc] initWithData:fileData];
        if (image) {
            if (imageSize.width > 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    CGFloat scale = imageSize.width/image.size.width;
                    CGFloat imgW = imageSize.width;
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
                dispatch_async(dispatch_get_main_queue(), ^ {
                    if (block) {
                        block(image, nil);
                    }
                });
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^ {
                if (block) {
                    block(nil, error);
                }
            });
        }
    } progressBlock:^(NSProgress *uploadProgress) {
        
    } errorBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(nil, error);
            }
        });
    }];
    return defaultImage;
}

@end
