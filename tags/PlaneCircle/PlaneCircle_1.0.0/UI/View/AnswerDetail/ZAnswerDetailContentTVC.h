//
//  ZAnswerDetailContentTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/15/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZAnswerDetailContentTVC : ZBaseTVC

///需要刷新CELL
@property (copy, nonatomic) void(^onRefreshTVC)();

///图片点击事件
@property (copy , nonatomic) void(^onImageClick)(UIImage *image, NSURL *imgUrl, CGSize size);

///设置数据源
//-(void)setRootTableView:(UITableView *)tvMain;

///根据数据模型获取高度
-(CGFloat)getHWithModel:(ModelAnswerBase *)model;

@end
