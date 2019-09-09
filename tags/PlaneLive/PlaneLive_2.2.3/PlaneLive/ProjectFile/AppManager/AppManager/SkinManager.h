//
//  SkinManager.h
//  PlaneCircle
//
//  Created by Daniel on 6/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkinManager : NSObject

/**
 *  根据对应图片名称获取对应图片对象
 */
+(UIImage*)getImageWithName:(NSString*)name;
/**
 *  Cell间隔区域图片
 */
+(UIImage*)getSpaceImage;
/**
 *  默认列表小图片
 */
+(UIImage*)getDefaultImage;
/**
 *  实务列表小图片
 */
+(UIImage*)getPracticeImage;
/**
 *  首页顶部广告
 */
+(UIImage*)getMaxImage;
/**
 *  默认显示头像
 */
+(UIImage*)getDefaultPhoto;

@end
