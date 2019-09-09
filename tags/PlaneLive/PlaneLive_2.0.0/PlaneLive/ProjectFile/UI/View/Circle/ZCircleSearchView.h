//
//  ZCircleSearchView.h
//  PlaneCircle
//
//  Created by Daniel on 6/7/16.
//  Copyright © 2016 WT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCircleSearchView : UIView

///开始点击事件
@property (copy ,nonatomic) void(^onBeginClick)();
///取消点击事件
@property (copy ,nonatomic) void(^onClearClick)();
///提问点击事件
@property (copy ,nonatomic) void(^onQuestionClick)();
///搜索按钮事件
@property (copy ,nonatomic) void(^onSearchClick)(NSString *content);

///获取文本内容
-(NSString *)getSearchContent;

///显示键盘
-(void)setViewShowKeyboard;

///隐藏键盘
-(void)setViewHiddenKeyboard;

@end
