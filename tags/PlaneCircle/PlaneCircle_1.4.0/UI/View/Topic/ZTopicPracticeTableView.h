//
//  ZTopicPracticeTableView.h
//  PlaneCircle
//
//  Created by Daniel on 9/19/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZBaseTableView.h"

@interface ZTopicPracticeTableView : ZBaseTableView

///实务区域点击
@property (copy, nonatomic) void(^onRowSelected)(NSArray *arrPractice, NSInteger rowIndex);

///获取实务数据集合
-(NSArray *)getPracticeArray;

@end
