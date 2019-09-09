//
//  SEImageCache.h
//  SECoreTextView
//
//  Created by kishikawa katsumi on 2013/04/13.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "SECompatibility.h"

typedef void(^SEImageDownloadCompletionBlock)(NSImage *image, NSError *error);

@interface SEImageCache : NSObject

+ (SEImageCache *)sharedInstance;

/**
 *  无默认图片->本地缓存回答
 */
- (NSImage *)imageForURL:(NSString *)imageURL completionBlock:(SEImageDownloadCompletionBlock)block;
/**
 *  有默认图片->本地缓存回答
 */
- (NSImage *)imageForURL:(NSString *)imageURL defaultImage:(NSImage *)defaultImage completionBlock:(SEImageDownloadCompletionBlock)block;
/**
 *  有默认图片->指定本地缓存
 */
- (NSImage *)imageForURL:(NSString *)imageURL defaultImage:(NSImage *)defaultImage filePath:(NSString *)filePath completionBlock:(SEImageDownloadCompletionBlock)block;

@end
