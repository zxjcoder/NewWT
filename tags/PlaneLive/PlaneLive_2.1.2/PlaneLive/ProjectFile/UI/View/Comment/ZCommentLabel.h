//
//  ZCommentLabel.h
//  PlaneCircle
//
//  Created by Daniel on 9/1/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZCommentLabel : UIView

///初始化对象
-(id)initWithFrame:(CGRect)frame modelReply:(ModelCommentReply *)modelReply;
///初始化对象->用来计算高度的
-(id)initWithCalculation;

///设置坐标
-(void)setLabelFrame:(CGRect)frame;
///设置数据源
-(void)setLabelData:(ModelCommentReply *)model;

///用户点击
@property (copy, nonatomic) void(^onUserClick)(ModelUserBase *model);
///区域事件
@property (copy, nonatomic) void(^onContentClick)(ModelCommentReply *model);

///获取View高度
-(CGFloat)getViewH;

@end
