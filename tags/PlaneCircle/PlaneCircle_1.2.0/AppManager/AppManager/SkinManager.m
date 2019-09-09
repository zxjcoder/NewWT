//
//  SkinManager.m
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "SkinManager.h"

@implementation SkinManager

+(UIImage*)getImageWithName:(NSString*)name
{
    //     NSString *strSkin = [AppSetting getUserSkin];
    //下载的自定义皮肤
    //    if (![strSkin isEqualToString:@"Default"]) {
    //        NSString *skinPath = [[AppSetting getSkinFilePath] stringByAppendingPathComponent:strSkin];
    //        NSString *imgPath = [[skinPath stringByAppendingPathComponent:name] stringByAppendingPathComponent:strSkin];
    //        if (IsIPhoneDevice) {
    //            if (IsIPhone6Plus) {
    //                imgPath = [imgPath stringByAppendingPathComponent:@"@3x.png"];
    //            } else {
    //                imgPath = [imgPath stringByAppendingPathComponent:@"@2x.png"];
    //            }
    //        } else {
    //            imgPath = [imgPath stringByAppendingPathComponent:@"@2x.png"];
    //        }
    //        if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
    //            return [UIImage imageWithContentsOfFile:imgPath];
    //        }
    //    }
    //设置应用默认皮肤
    return [UIImage imageNamed:name];
}

+(UIImage*)getSpaceImage
{
    return [UIImage imageNamed:@"new_home_space"];
}

+(UIImage*)getDefaultImage
{
    return [UIImage imageNamed:@"new_image_default"];
}

+(UIImage*)getMaxImage
{
    return [UIImage imageNamed:@"new_home_banner_default"];
}

+(UIImage*)getDefaultPhoto
{
    return [UIImage imageNamed:@"new_user_photo"];
}

@end
