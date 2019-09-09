//
//  ZPracticeDetailTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZPracticeDetailTableView : ZBaseTableView

///文本
@property (copy, nonatomic) void(^onTextClick)();
///收藏
@property (copy, nonatomic) void(^onCollectionClick)();
///点赞
@property (copy, nonatomic) void(^onPraiseClick)();
///头像->评论
@property (copy, nonatomic) void(^onCommentPhotoClick)(ModelComment *model);
///偏移量
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

///设置数据源
-(void)setViewDataWithModel:(ModelPractice *)model;

@end
