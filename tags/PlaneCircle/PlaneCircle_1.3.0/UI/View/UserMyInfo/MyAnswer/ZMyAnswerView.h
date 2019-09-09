//
//  ZMyAnswerView.h
//  PlaneCircle
//
//  Created by Daniel on 7/21/16.
//  Copyright © 2016 WT. Answer rights reserved.
//

#import "ZView.h"

@interface ZMyAnswerView : ZView

///我的答案顶部刷新
@property (copy, nonatomic) void(^onRefreshAnswerHeader)();

///设置我的答案分页数量
@property (copy, nonatomic) void(^onAnswerPageNumChange)(int pageNum);

///我的答案刷新
@property (copy, nonatomic) void(^onBackgroundAnswerClick)(ZBackgroundState state);

///我的答案底部刷新
@property (copy, nonatomic) void(^onRefreshAnswerFooter)();

///我的答案选中
@property (copy, nonatomic) void(^onAnswerRowClick)(ModelQuestionMyAnswer *model);
///我的答案->问题选中
@property (copy, nonatomic) void(^onQuestionRowClick)(ModelQuestionMyAnswer *model);

///删除我的答案按钮点击
@property (copy, nonatomic) void(^onDeleteAnswerClick)(ModelQuestionMyAnswer *model);

///设置我的答案背景状态
-(void)setAnswerBackgroundViewWithState:(ZBackgroundState)backState;

///设置是否允许删除
-(void)setViewIsDelete:(BOOL)isDel;

///设置我的答案
-(void)setViewAnswerWithDictionary:(NSDictionary *)dic;

///结束我的答案顶部刷新
-(void)endRefreshAnswerHeader;
///结束我的答案底部刷新
-(void)endRefreshAnswerFooter;

@end
