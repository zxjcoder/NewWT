//
//  ZPracticeTypeTableView.h
//  PlaneLive
//
//  Created by Daniel on 02/10/2016.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZPracticeTypeTableView : ZBaseTableView

///查看全部点击事件
@property (copy, nonatomic) void(^onPracticeAllClick)(ModelPracticeType *model);
///选中行事件
@property (copy, nonatomic) void(^onPracticeClick)(NSArray *array, NSInteger row);
///搜索内容改变
@property (copy, nonatomic) void(^onSearchContentChange)(NSString *content);
///排序点击事件
@property (copy, nonatomic) void(^onSortClick)(BOOL isAscending);
@property (copy, nonatomic) void(^onSearchClick)();
@property (copy, nonatomic) void(^onCancelClick)();

-(void)setViewTypeDataWithArray:(NSArray *)arrResult;

-(void)setViewPracticeDataWithArray:(NSArray *)arrResult isHeader:(BOOL)isHeader;

@end
