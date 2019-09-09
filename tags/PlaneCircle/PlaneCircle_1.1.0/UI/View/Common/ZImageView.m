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
#import "SEImageCache.h"

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
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultPhoto] filePath:[AppSetting getHeadFilePath]];
}

-(void)setPhotoURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage
{
    [self setImageURLStr:urlString placeImage:placeImage filePath:[AppSetting getHeadFilePath]];
}

-(void)setImageURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage
{
    [self setImageURLStr:urlString placeImage:placeImage filePath:[AppSetting getRecvFilePath]];
}

-(void)setImageURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage filePath:(NSString *)filePath
{
    self.imageUrl = urlString;
    
    __weak typeof(self) ws = self;
    UIImage *img = [[SEImageCache sharedInstance] imageForURL:urlString defaultImage:placeImage filePath:filePath completionBlock:^(UIImage *image, NSError *error) {
        GCDMainBlock(^{
            if (image) {
                [ws setImage:image];
                [ws setNeedsDisplay];
            }
        });
    }];
    if (img) {
        [self setImage:img];
        [ws setNeedsDisplay];
    } else {
        [self setImage:placeImage];
        [ws setNeedsDisplay];
    }
}

-(void)setImageURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getDefaultImage]];
}

-(void)setMaxImageURLStr:(NSString*)urlString
{
    [self setImageURLStr:urlString placeImage:[SkinManager getMaxImage]];
}

@end
