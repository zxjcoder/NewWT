//
//  SEImageCache.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/13.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

typedef void(^SEImageDownloadCompletionBlock)(UIImage *image, NSError *error);

@interface SEImageCache : NSObject

+ (SEImageCache *)sharedInstance;

/**
 *  有默认图片->本地缓存回答
 */
- (UIImage *)imageForURL:(NSString *)imageURL completionBlock:(SEImageDownloadCompletionBlock)block;

/**
 *  有默认图片->指定本地缓存
 */
- (UIImage *)imageForURL:(NSString *)imageURL defaultImage:(UIImage *)defaultImage filePath:(NSString *)filePath completionBlock:(SEImageDownloadCompletionBlock)block;

@end
