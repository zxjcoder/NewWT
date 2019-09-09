//
//  ZNewSearchHistoryView.h
//  PlaneLive
//
//  Created by Daniel on 28/10/2017.
//  Copyright © 2017 WT. All rights reserved.
//

#import "ZView.h"

@interface ZNewSearchHistoryView : ZView

///偏移量改变
@property (copy, nonatomic) void(^onContentOffsetChange)(CGFloat contentOffsetY);
/// 关键字点击
@property (copy, nonatomic) void(^onKeywordClick)(NSString *keyword);
/// 删除按钮
@property (copy, nonatomic) void(^onDelegateClick)();

/// 设置热门搜索关键字
-(void)setViewHotData:(NSArray *)array;
/// 设置历史搜索关键字
-(void)setViewHistoryData:(NSArray *)array;

@end
