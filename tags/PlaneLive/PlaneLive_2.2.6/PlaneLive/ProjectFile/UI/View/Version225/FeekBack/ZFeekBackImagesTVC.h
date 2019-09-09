//
//  ZFeekBackImagesTVC.h
//  PlaneLive
//
//  Created by Daniel on 25/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZBaseTVC.h"

/// 意见反馈图片
@interface ZFeekBackImagesTVC : ZBaseTVC

///添加图片
@property (copy, nonatomic) void(^onAddImageClick)();

///移除所有的图片
-(void)removeImageArray;
///设置图片集合
-(void)setCellDataImage:(NSArray *)array;
///获取图片集合
-(NSArray *)getImagesArray;

@end
