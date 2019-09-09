//
//  ZImageView.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZImageView : UIImageView

@property (retain, nonatomic) NSString *imageUrl;

///设置默认图片
-(void)setDefaultImage;

///设置默认图片
-(void)setMaxImage;

///设置默认头像
-(void)setDefaultPhoto;

///设置图片
-(void)setImageName:(NSString*)name;

///下载头像原图图片,并显示默认头像
-(void)setPhotoURLStr:(NSString*)urlString;

///下载头像原图图片,并设置默认头像
-(void)setPhotoURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage;

///下载列表原图图片,并显示默认图片
-(void)setImageURLStr:(NSString*)urlString;

///下载横幅原图图片,并显示默认图片
-(void)setMaxImageURLStr:(NSString*)urlString;

///下载列表原图图片,并设置默认图片
-(void)setImageURLStr:(NSString*)urlString placeImage:(UIImage*)placeImage;

@end
