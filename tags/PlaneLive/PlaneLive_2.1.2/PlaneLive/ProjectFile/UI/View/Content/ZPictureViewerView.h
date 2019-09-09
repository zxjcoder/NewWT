//
//  ZPictureViewerView.h
//  PlaneCircle
//
//  Created by Daniel on 6/16/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPictureViewerView : ZView

/**
 *  设置数据源
 *  @param imageUrl         图片地址
 *  @param defaultImage     默认图片
 *  @param defaultSize      默认大小
 */
-(void)setViewPictureUrlWithImageUrl:(NSURL *)imageUrl defaultImage:(UIImage *)defaultImage defaultSize:(CGSize)defaultSize;

///显示
-(void)show;

///隐藏
-(void)dismiss;

@end
