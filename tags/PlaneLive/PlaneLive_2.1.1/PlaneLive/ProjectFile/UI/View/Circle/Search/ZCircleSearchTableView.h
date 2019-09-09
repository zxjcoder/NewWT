//
//  ZCircleSearchTableView.h
//  PlaneCircle
//
//  Created by Daniel on 6/8/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelEntity.h"

@interface ZCircleSearchTableView : UIView

///搜索内容底部刷新
@property (copy, nonatomic) void(^onRefreshContentFooter)();
///搜索用户底部刷新
@property (copy, nonatomic) void(^onRefreshUserFooter)();

///搜索内容点击刷新
@property (copy, nonatomic) void(^onContentBackgoundClick)();
///搜索用户点击刷新
@property (copy, nonatomic) void(^onUserBackgoundClick)();

///标签选中
@property (copy, nonatomic) void(^onTagClick)(ModelTag *model);
///问题或提问选中
@property (copy, nonatomic) void(^onContentItemClick)(ModelQuestionBase *model);
///用户被选中
@property (copy, nonatomic) void(^onUserItemClick)(ModelUserBase *model);

///开始滑动
@property (copy, nonatomic) void(^onOffsetChange)(CGFloat y);

///设置搜索内容
-(void)setViewCircleContentWithDictionary:(NSDictionary *)dic;
///设置搜索用户
-(void)setViewCircleUserWithDictionary:(NSDictionary *)dic;

///关键字
-(void)setViewCircleKeyword:(NSString *)key;

@end
