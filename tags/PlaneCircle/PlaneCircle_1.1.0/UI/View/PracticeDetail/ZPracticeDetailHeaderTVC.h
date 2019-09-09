//
//  ZPracticeDetailHeaderTVC.h
//  PlaneCircle
//
//  Created by Daniel on 6/21/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTVC.h"

@interface ZPracticeDetailHeaderTVC : ZBaseTVC

///文本
@property (copy, nonatomic) void(^onTextClick)();
///收藏
@property (copy, nonatomic) void(^onCollectionClick)();
///点赞
@property (copy, nonatomic) void(^onPraiseClick)();

@end
