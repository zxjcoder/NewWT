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

-(void)setPhotoURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultPhoto] completed:nil];
}

-(void)setPhotoURLStr:(NSString*)urlString completed:(void(^)(UIImage *image))completed
{
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultPhoto] completed:completed];
}

-(void)setPhotoURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage
{
    [self setImageURLStr:urlString placeImage:placeImage completed:nil];
}

-(void)setImageURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage
{
    [self setImageURLStr:urlString placeImage:placeImage completed:nil];
}

-(void)setImageURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage completed:(void(^)(UIImage *image))completed
{
    if (urlString && urlString.length == 0 && [urlString isUrl]) {
        return;
    }
    self.imageUrl = urlString;
    
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
            placeholderImage:placeImage
                     options:SDWebImageRetryFailed|SDWebImageLowPriority
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (error == nil && image != nil && completed) {
                           completed(image);
                       }
                   }];
}

-(void)setImageURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultImage]];
}

-(void)setImageURLStr:(NSString*)urlString completed:(void(^)(UIImage *image))completed
{
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultImage] completed:completed];
}

-(void)setMaxImageURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getMaxImage]];
}

-(void)dealloc
{
    
}

@end
