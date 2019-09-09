//
//  GifManager.m
//  PlaneLive
//
//  Created by Daniel on 10/05/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "GifManager.h"
#import <ImageIO/ImageIO.h>
#import <SDWebImage/UIImage+GIF.h>

static NSMutableArray *arrRefreshIconGif;
static NSMutableArray *arrPlayIconGif;
static NSTimeInterval durationRefreshIconGif;
static NSTimeInterval durationPlayIconGif;
static UIImage *imagePlayIconGif;

@implementation GifManager

/// 刷新中的GIF
+ (NSArray *)getRefreshImagesGif {
    if (arrRefreshIconGif && arrRefreshIconGif.count > 0) {
        return arrRefreshIconGif;
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *name = @"refresh_header";
    if (scale == 3) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@3x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        if (data) {
            arrRefreshIconGif = [self getRefreshGifImagesWithName:data];
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
            data = [NSData dataWithContentsOfFile:path];
            if (data) {
                arrRefreshIconGif = [self getRefreshGifImagesWithName:data];
            }
        }
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            arrRefreshIconGif = [self getRefreshGifImagesWithName:data];
        }
    }
    return arrRefreshIconGif;
}
/// 播放中的GIF
+ (NSArray *)getPlayingImagesGif {
    if (arrPlayIconGif && arrPlayIconGif.count > 0) {
        return arrPlayIconGif;
    }
    /// 通过多图片获取图片集合
    arrPlayIconGif = [NSMutableArray array];
    for (int i = 1; i < 51; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ZPlaying.bundle/playing_icon_%d",i]];
        //[image changeImageColorWithColor:MAINCOLOR];
        [arrPlayIconGif addObject:image];
    }
    if (arrPlayIconGif && arrPlayIconGif.count > 0) {
        return arrPlayIconGif;
    }
    /// 通过GIF获取图片集合
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *name = @"playing_icon";
    if (scale == 3) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@3x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:retinaPath];
        if (data) {
            arrPlayIconGif = [self getPlayingGifImagesWithName:data];
        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
            data = [NSData dataWithContentsOfFile:path];
            if (data) {
                arrPlayIconGif = [self getPlayingGifImagesWithName:data];
            }
        }
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            arrPlayIconGif = [self getPlayingGifImagesWithName:data];
        }
    }
    return arrPlayIconGif;
}
/// 播放中的GIF
+ (UIImage *)getPlayingImageGif
{
    if (imagePlayIconGif) {
        return imagePlayIconGif;
    }
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"playing_icon" ofType:@"gif"];
    NSData *imgData = nil;
    if (imgPath) {
        imgData = [NSData dataWithContentsOfFile:imgPath];
    }
    if (imgData) {
        imagePlayIconGif = [UIImage sd_animatedGIFWithData:imgData];
    }
    return imagePlayIconGif;
}
/// 播放动画时间
+ (NSTimeInterval)getPlayingDuration
{
    return durationPlayIconGif;
}
/// 刷新动画时间
+ (NSTimeInterval)getRefreshDuration
{
    return durationRefreshIconGif;
}
+ (NSMutableArray *)getRefreshGifImagesWithName:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray array];
    if (count <= 1) {
        UIImage *animatedImage = [[UIImage alloc] initWithData:data];
        [images addObject:animatedImage];
    } else {
        //NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            durationRefreshIconGif += [self frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!durationRefreshIconGif) { durationRefreshIconGif = (1.0f / 10.0f) * count; }
    }
    CFRelease(source);

    return images;
}
+ (NSMutableArray *)getPlayingGifImagesWithName:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray array];
    if (count <= 1) {
        UIImage *animatedImage = [[UIImage alloc] initWithData:data];
        [images addObject:animatedImage];
    } else {
        //NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            durationPlayIconGif += [self frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!durationPlayIconGif) { durationPlayIconGif = (1.0f / 10.0f) * count; }
    }
    CFRelease(source);
    
    return images;
}
+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (void)cancelMemory {
    [arrPlayIconGif removeAllObjects];
    arrPlayIconGif = nil;
    [arrRefreshIconGif removeAllObjects];
    arrRefreshIconGif = nil;
    imagePlayIconGif = nil;
}

@end
