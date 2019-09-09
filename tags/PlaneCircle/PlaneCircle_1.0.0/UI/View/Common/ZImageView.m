//
//  ZImageView.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZImageView.h"
#import "Utils.h"
#import "AppSetting.h"
#import "UIImageView+WebCache.h"

@implementation ZImageView

-(id)init
{
    self = [super init];
    if (self) {
        [self innerInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self innerInit];
    }
    return self;
}

#pragma mark - Event

-(void)innerInit
{
    [self setBackgroundColor:CLEARCOLOR];
    [self setOpaque:NO];
}

-(void)setDefaultImage
{
    [self setImage:[SkinManager getDefaultImage]];
}

-(void)setMaxImage
{
    [self setImage:[SkinManager getMaxImage]];
}

-(void)setDefaultPhoto
{
    [self setImage:[SkinManager getDefaultPhoto]];
}

-(void)setImageName:(NSString*)name
{
    [self setImage:[SkinManager getImageWithName:name]];
}

-(void)setImageURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage
{
    self.imageUrl = urlString;
    
    [self sd_setImageWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:placeImage options:(SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageContinueInBackground) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

-(void)setImageURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage successBlock:(void(^)(UIImage *image))successBlock;
{
    self.imageUrl = urlString;
    [self sd_setImageWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:placeImage options:(SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageContinueInBackground) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && image != placeImage) {
            if (successBlock) {
                successBlock(image);
            }
        }
    }];
}

-(void)setImageURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultImage]];
}

-(void)setMaxImageURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getMaxImage]];
}

-(void)setPhotoURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultPhoto]];
}

@end
