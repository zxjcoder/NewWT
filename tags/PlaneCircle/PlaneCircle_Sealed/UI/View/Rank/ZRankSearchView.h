//
//  ZRankSearchView.h
//  PlaneCircle
//
//  Created by Daniel on 6/18/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import "ZView.h"

@interface ZRankSearchView : ZView

///开始点击事件
@property (copy ,nonatomic) void(^onBeginEditClick)();
///取消点击事件
@property (copy ,nonatomic) void(^onClearClick)();
///搜索按钮事件
@property (copy ,nonatomic) void(^onSearchClick)(NSString *content);

///获取文本内容
-(NSString *)getSearchContent;

@end
