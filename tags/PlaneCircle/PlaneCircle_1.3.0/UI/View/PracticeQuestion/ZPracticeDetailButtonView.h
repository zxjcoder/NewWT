//
//  ZPracticeDetailButtonView.h
//  PlaneCircle
//
//  Created by Daniel on 8/23/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZPracticeDetailButtonView : ZView

///文本
@property (copy, nonatomic) void(^onTextClick)();
///PPT
@property (copy, nonatomic) void(^onPPTClick)();
///收藏
@property (copy, nonatomic) void(^onCollectionClick)();
///点赞
@property (copy, nonatomic) void(^onPraiseClick)();

///设置是否显示分割线
-(void)setIsShowLine:(BOOL)isShow;

///设置数据模型
-(void)setViewDataWithModel:(ModelPractice *)model;

///获取高度
+(CGFloat)getViewH;

///获取高度
+(CGFloat)getViewLineH;

@end
