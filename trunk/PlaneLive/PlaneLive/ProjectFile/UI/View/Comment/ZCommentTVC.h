//
//  ZCommentTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZCommentTVC : ZBaseTVC

///高度改变
@property (copy, nonatomic) void(^onRowHeightChange)(NSInteger row,BOOL isDefaultH);

///头像
@property (copy, nonatomic) void(^onImagePhotoClick)(ModelComment *model);

///设置是否默认高度
-(void)setCellIsDefaultH:(BOOL)isDF;

///根据数据模型获取CELL高度
-(CGFloat)getHWithModel:(ModelComment *)model;

@end
